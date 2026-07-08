# Schema design

Sources: Relay GraphQL Cursor Connections Specification (relay.dev/graphql/connections.htm),
Shopify graphql-design-tutorial (github.com/Shopify/graphql-design-tutorial), GitHub GraphQL
API docs (docs.github.com/en/graphql), Marc-André Giroux, *Production Ready GraphQL* and
productionreadygraphql.com/blog, graphql.org/learn (pagination, schema design, global object
identification).

## Naming

- Types PascalCase, fields and enum *field names* camelCase, enum *values* SCREAMING_SNAKE.
- Mutations verb-first (`approveReview`, `createRefund`), one per business action. (Shopify
  uses noun-first (`reviewApprove`) for alphabetical grouping; a valid alternative for very
  large schemas, but pick one and hold it.)
- Queries noun-first (`review`, `reviews`, `customerSearch`). Booleans read as claims:
  `isApproved`, `hasResponse`.
- Be specific over generic: `ReviewComment`, not `Comment`, unless it truly is the one comment
  concept in the domain. Generic names squat namespace you will want later.
- Don't share types because their shapes coincide today. A `User` returned as the viewer, a
  public profile, and a team member are three types with three authorization stories; sharing
  one forces fields nullable with prose explaining when they're visible. Identical shape ≠
  same type. New types are cheaper than they feel.
- Use object references, not ID fields: `customer: Customer`, never `customerId: ID`. The
  client can always select `customer { id }`; an ID field forces a second round trip for
  anything more.

## Descriptions

Write every description as the API speaking to its consumer: a client developer reading
introspection docs, for whom the implementation does not exist. The consumer is the audience,
never the subject. Say what the field or mutation means in the domain and when to use it.

- Never reveal or rely on the implementation: resolver logic, database columns and joins,
  service or class names, caching, "calls the X service." A description that leans on the code
  under the hood leaks the coupling the schema exists to hide, and it goes stale silently when
  the code moves.
- Write from the API's perspective, speaking to the consumer. `responseTemplate: "The
  template string the client has configured for review replies."` reads as internal notes
  about the reader; spoken *to* them it's simply `responseTemplate: "A template string for
  review replies."` When a description must name the consumer, use their domain role rather
  than "the user" or "the client": `label: "A display name chosen by the merchant for this
  review form."`
- Document the contract a consumer would otherwise have to discover by testing: units,
  timezone, ordering, valid ranges, when a nullable field is null, what happens when an
  optional argument is omitted.
- Don't restate the name or type. `createdAt: "When the object was created."` adds nothing;
  `createdAt: "When the reviewer submitted the review, in UTC."` names the event and pins the
  timezone. If the only description you can write in consumer terms is a restatement, either
  the name already says it all (fine: skip the description) or the concept is fuzzy (design
  feedback: fix the field, not the prose).

## Nullability

Decide per field; it is a semantic claim and a failure-isolation boundary, not a style.

- **Non-null**: arguments and input fields the operation genuinely requires; `id`; fields of
  narrow, context-specific types where the type itself guarantees presence; values computed
  without I/O from data you already have.
- **Nullable**: anything backed by an association, network call, or other fallible work. Under
  partial failure the null-propagation rule destroys the enclosing selection: a non-null
  field that errors nulls its parent, and if everything up the chain is non-null, the whole
  response. `[T!]!` means one failed element nulls the entire list; use it only for lists
  whose elements you fully control.
- Evolution is asymmetric: nullable → non-null is safe, non-null → nullable breaks every
  client that trusted the guarantee. When unsure, start nullable.
- When *adding* an argument or input field to an existing operation, it must be nullable (or
  defaulted): required additions break existing callers.
- A nullable `Boolean` is a design smell: it's a tri-state. Model the third state explicitly
  or make it non-null. `null` means "not applicable"; `""` means "applicable and empty":
  don't conflate them.

## IDs and object identity

- Every entity type gets `id: ID!`, unique at least per type, stable for the object's life.
  If two selections return the same `id` for a type, they must describe the same object:
  client caches key on `__typename:id`, and a violated invariant corrupts every consumer.
- If a type's field *values* vary by context (the same profile looks different per
  tenant/viewer scope), the model is wrong: make the context an explicit field argument or a
  distinct type. Context-dependent identity pushed into client cache configuration is a
  symptom, not a solution.
- The Relay `Node` interface + `node(id: ID!)` root field is opt-in. Adopt it when clients do
  normalized caching generically or need refetch-by-id; it requires *globally* unique, opaque
  ids that alone suffice to refetch the object. Skip it otherwise, but keep the per-type
  uniqueness invariant regardless.

## Pagination

Paginate any list field that can grow. An unpaginated list over a growing table is a breaking
change on a timer: one day it times out and the fix (adding pagination) breaks every client.

Use spec Relay connections: standard tooling (Apollo `relayStylePagination()`, codegen,
Relay itself) works against this exact shape and fights anything else:

```graphql
type Query {
  reviews(first: Int, after: String, last: Int, before: String): ReviewConnection!
}

type ReviewConnection {
  edges: [ReviewEdge!]!
  pageInfo: PageInfo!
  # extra connection fields are spec-legal
  totalCount: Int!
}

type ReviewEdge {
  node: Review!
  cursor: String!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  # nullable: the spec says these "can be null if there are no results"
  startCursor: String
  endCursor: String
}
```

What the spec requires vs what is house choice:

- Required: `edges` (list of edge types with `node` + `cursor`), `pageInfo: PageInfo!`,
  `hasNextPage`/`hasPreviousPage` as `Boolean!`, `startCursor`/`endCursor` nullable, at least
  one of the `first`/`after` or `last`/`before` argument pairs. The `Connection` suffix is
  reserved: a type named `XConnection` must follow these rules.
- Choices: `[ReviewEdge!]!` strictness, non-null `node`/`cursor`, `totalCount`, offering both
  directions. Forward-only (`first`/`after`) is fully conforming; add `last`/`before` only
  when a real consumer paginates backward.
- Cursors are opaque strings that round-trip: whatever `cursor` returns, `after`/`before`
  accept. Base64-encode to discourage clients from parsing them. Ordering must be stable
  across pages, which means the sort key must be unique (tiebreak on `id`).
- Cap `first`/`last` server-side and reject negatives. The cap is what makes query cost
  computable (see server.md, demand control).

For genuinely small, bounded lists (a review's photos), a plain list field is fine: that's
the escape hatch, not offset arguments. If a UI truly needs jump-to-page, encode the offset
*inside* the opaque cursor rather than exposing `offset`/`skip` args, so the shape survives a
backend change.

## Mutations

One mutation per logical business action. A generic `updateReview(input)` with all-optional
fields defers every rule to runtime and tells the client nothing about what actions exist;
`approveReview`, `rejectReview`, and `respondToReview` each carry their own required fields,
their own error space, and their own domain event.

Shape:

```graphql
type Mutation {
  approveReview(input: ApproveReviewInput!): ApproveReviewPayload!
}

input ApproveReviewInput {
  reviewId: ID!
  note: String
}

type ApproveReviewPayload {
  # nullable: null when userErrors is non-empty
  review: Review
  userErrors: [ApproveReviewError!]!
}

type ApproveReviewError {
  # path to the offending input field, e.g. ["input", "note"]
  field: [String!]
  message: String!
  code: ApproveReviewErrorCode
}

enum ApproveReviewErrorCode {
  REVIEW_ALREADY_MODERATED
  REVIEW_NOT_FOUND
  NOTE_TOO_LONG
}
```

- Single required input object named `<MutationName>Input`; payload named
  `<MutationName>Payload`. One input per mutation evolves cleanly: new optional fields never
  change the signature.
- The payload carries the changed entity so clients update caches without a refetch. Nullable,
  because on failure there may be nothing to return.
- `userErrors` is the contract for **expected** failures: validation, state conflicts,
  not-found-for-you. `field` is a nullable path array; `code` is a nullable per-mutation enum
  so clients can branch without string-matching messages. Top-level GraphQL errors are
  reserved for the exceptional: bugs, auth failure, infrastructure. User data is data, not an
  Error.
- A shared `UserError` interface (`field`, `message`) across payloads keeps client handling
  generic; per-mutation error types add the codes. For public APIs needing richer errors, the
  upgrade path is a union of error types all implementing the interface: clients that select
  only the interface never miss a new error.
- Inputs: only mark fields required that are semantically required for the action. Prefer
  strong scalar types (`DateTime` over `String`) when the format is unambiguous; prefer a
  weak type when validation is complex and belongs in `userErrors` rather than a type-level
  parse failure.
- Batch mutations take plural arguments (`reviewIds: [ID!]!`), never ask the client to build
  repeated fields dynamically. A client should never have to construct query strings at
  runtime.

## Enums, scalars, and the JSON escape hatch

- Any field with a fixed value set is an enum, never a `String`. Stringly-typed status fields
  hide the state machine and can't be deprecated value-by-value.
- SCREAMING_SNAKE values, consistently. A schema with `Open`, `pending_payment`, and `SHIPPED`
  in one enum makes every consumer guess.
- Adding an enum value is a *dangerous* change, not a safe one: clients receive values they've
  never seen. Server-side, treat it as additive; client-side, always handle the unknown case.
- Semantic scalars (`DateTime`, `URL`, `Money`) beat primitives when they carry real meaning
  and validation.
- `JSON` scalars are for genuinely schemaless data only: third-party webhook payloads,
  user-defined config. If you can name the fields, type them: a `JSON` field loses
  introspection, typing, and field-level deprecation, and its consumers can't be found by
  schema usage tracking. Prefer object types over positional arrays (`TimeRange` with
  `start`/`end`, not `[DateTime!]!`).

## Polymorphism

- Interfaces describe shared *behavior*, not shared fields. `Reviewable` (things that accept
  reviews) is an interface; `ItemFields` (types that happen to share columns) is a smell:
  don't DRY types together by shape.
- Prefer interfaces over unions when members share behavior; prefer small, focused interfaces
  over one generic one.
- Unions fit disjoint alternatives with no shared contract. Adding a union member is
  quasi-breaking (client `switch` statements go silently incomplete), so for evolving sets,
  make union members implement a common interface clients can fall back on.
- Complex divergent behavior inside one entity: push the polymorphism down into a field-level
  union rather than splitting the parent type.

## Evolution and deprecation

- Additive changes are almost always safe and must be the first resort. Design so additions
  stay possible: single input objects, nullable-by-default outputs, connections from day one.
- Retire fields with `@deprecated(reason:)` where the reason names the replacement and,
  ideally, a removal date: `@deprecated(reason: "Use responseText. Removal on 2027-01-01.")`.
- Deprecation is a last resort, not a workflow. It still ends in a breaking change; the
  discipline that makes it work is field-level usage tracking (GraphQL has no `SELECT *`:
  you can know every consumer), building new features only on the replacement path, and
  contacting laggards before removal.
- Never break a schema a client is currently depending on without an explicit escape hatch
  they opted into: dated API versions or scheduled removal windows with months of notice.
