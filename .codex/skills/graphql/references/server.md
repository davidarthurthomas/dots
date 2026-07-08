# Server implementation

Sources: DataLoader README (github.com/graphql/dataloader), Apollo GraphOS schema-design
guides ("Handling the N+1 Problem", demand control), NestJS docs (graphql/complexity,
fundamentals/injection-scopes), Marc-André Giroux, productionreadygraphql.com/blog.
Code examples use NestJS code-first (@nestjs/graphql + Apollo); the principles are
framework-agnostic.

## Resolver structure

Resolvers are a thin mapping layer: parse the GraphQL shape, delegate to a service, map the
result back. Business logic lives in services where it can be tested without a GraphQL
harness and reused by non-GraphQL callers (jobs, webhooks, other transports). A resolver
long enough to need its own tests is holding logic that belongs one layer down.

## N+1 and DataLoader

A field resolver runs once per parent. This per-parent service call is the N+1 anti-pattern:

```typescript
@ResolveField(() => Customer)
customer(@Parent() review: Review) {
  // 50 reviews in the list = 50 queries
  return this.customers.findById(review.customerId);
}
```

Any field resolver that fetches by parent key goes through a DataLoader instead. Loaders
batch all `.load(key)` calls in one tick into a single backend call, and deduplicate repeated
keys within the request.

The two contracts that make loaders correct:

- **Per-request instances.** A loader memoizes per instance. Shared across requests it serves
  stale data and leaks one user's authorized results to another. Create the loader bag when a
  request begins.
- **Batch alignment.** The batch function returns results in the same length and order as its
  keys, with `null` or an `Error` at each missing/failed index: the backend's return order
  never matches by accident, so re-align by key:

```typescript
export interface Loaders {
  customerById: DataLoader<string, Customer | null>;
  responsesByReviewId: DataLoader<string, ReviewResponse[]>;
}

export function createLoaders(customers: CustomersService, responses: ResponsesService): Loaders {
  return {
    customerById: new DataLoader(async (ids: readonly string[]) => {
      const rows = await customers.findByIds([...ids]);
      const byId = new Map(rows.map((c) => [c.id, c]));
      return ids.map((id) => byId.get(id) ?? null);
    }),
    responsesByReviewId: new DataLoader(async (reviewIds: readonly string[]) => {
      const rows = await responses.findByReviewIds([...reviewIds]);
      const grouped = Map.groupBy(rows, (r) => r.reviewId);
      return reviewIds.map((id) => grouped.get(id) ?? []);
    }),
  };
}
```

In NestJS, build the loader bag in the GraphQL context factory (it already runs once per
request) and keep every service a singleton:

```typescript
GraphQLModule.forRootAsync<ApolloDriverConfig>({
  driver: ApolloDriver,
  imports: [CustomersModule, ResponsesModule],
  inject: [CustomersService, ResponsesService],
  useFactory: (customers: CustomersService, responses: ResponsesService) => ({
    autoSchemaFile: 'schema.graphql',
    context: ({ req }) => ({ req, loaders: createLoaders(customers, responses) }),
  }),
}),
```

```typescript
@ResolveField(() => Customer, { nullable: true })
customer(@Parent() review: Review, @Context('loaders') loaders: Loaders) {
  return loaders.customerById.load(review.customerId);
}
```

Avoid `Scope.REQUEST` providers for this: request scope bubbles up the injection chain,
silently making every dependent provider request-scoped and re-instantiated per request.

When the viewer must scope the loader's queries, pass the request's user into
`createLoaders` and thread it to the service calls. When a list query already fetched
entities a child loader would re-load, `loader.prime(key, value)` skips the redundant fetch.

## Error contract

Two channels, by intent:

- **Expected failures** (validation, state conflicts, not-found-for-you) return as
  `userErrors` on the mutation payload (see schema-design.md, Mutations). The resolver
  catches the domain outcome and maps it to typed errors; it does not throw.
- **Exceptional failures** (bugs, infrastructure, auth) throw. They surface as top-level
  GraphQL errors. Give them stable machine-readable codes in `extensions.code`
  (`UNAUTHENTICATED`, `FORBIDDEN`, `INTERNAL_SERVER_ERROR`), because the message is for
  humans and will change.
- Mask internal errors at the boundary: log the real error with a correlation id, report to
  the error tracker, and return a generic message to the client. Stack traces and database
  errors in a GraphQL response are an information leak.
- The test for which channel: could a well-behaved client cause this by sending semantically
  valid input at the wrong time? Then it's a userError. Could only a bug or an outage cause
  it? Then throw.

## Authorization

- Decide at the boundary, declaratively: role/permission metadata on the field
  (`@Roles`/`@Permissions` decorators or schema directives), enforced by shared middleware.
  A reader auditing the schema should be able to see what every field requires.
- Authorization *logic* belongs in one layer. Scattering `hasPermission` calls through
  resolver bodies and services means three places to audit and three places to miss.
- Shaping data by permission (a field silently returning less for some viewers) is a last
  resort. It's invisible in the schema, so when unavoidable, say so in the field's
  description. Prefer modeling the difference explicitly: a `viewerCanModerate` field, or a
  separate type for the privileged view.
- Never leak existence through errors: "not found" and "not yours" should be
  indistinguishable to the client unless the resource's existence is public.

## Demand control

An unbounded query is a denial-of-service invitation: nested connections multiply. Enforce
a complexity budget before execution:

- Every list field takes a capped `first`/`last` (reject over-cap and negative values). The
  cap is what makes cost computable.
- Score queries: fields cost ~1 by default, expensive fields declare more, list fields
  multiply child cost by their pagination argument. Reject over-budget operations before
  resolving. In NestJS this is an Apollo plugin with `graphql-query-complexity`
  (docs.nestjs.com/graphql/complexity); federated setups get it in the router via
  `@cost`/`@listSize`.
- Add structural backstops: max depth, max aliases.
- No generic filter/order query language "for flexibility." Every filter you expose is an
  index you must maintain and a query plan you must defend; add filters for concrete use
  cases, not speculatively.

## Subscriptions

- A subscription is a query that keeps answering: its payload reuses the same object types
  (and therefore client fragments) as the equivalent query, so cache updates work the same
  way.
- Publish on `topic:entityId` channels so subscribers receive only their entity's events;
  a global topic filtered in application code fans every event out to every subscriber.
- Authorize at subscribe time *and* remember the connection outlives the check: bound the
  subscription's lifetime to the credential's (e.g. close the socket when the token expires
  and let the client resubscribe).
- Prefer subscriptions for small incremental deltas; for "something changed, refetch" cases,
  send a lightweight signal and let the client re-run its query.
