# React clients (Apollo & urql)

Sources: Apollo Client React docs (apollographql.com/docs/react: hooks, `useFragment`,
Suspense), urql docs (urql.dev: Provider, exchanges, Graphcache), graphql-codegen
client-preset (the-guild.dev), Relay docs ("Thinking in Relay", "Rendering Fragments")
for the fragment-reference architecture, React.dev for Suspense and error boundaries.

The consumption principles live in [client.md](client.md): codegen, fragment
colocation, cache-as-source-of-truth, mutation cache updates, pagination, error
handling. This file is the React binding for both libraries and does not re-explain
them. For the underlying React principles (colocation, "prop drilling is explicit",
"server state is borrowed"), see the `react` skill.

## Client setup

Apollo's `InMemoryCache` is normalized by default:

```typescript
const client = new ApolloClient({
  link: httpLink,
  cache: new InMemoryCache(),
});

<ApolloProvider client={client}>{children}</ApolloProvider>;
```

urql's default `cacheExchange` is a *document cache*: it keys whole responses by
operation and never splits them into entities. That means a mutation returning an
updated entity does **not** update other queries holding the same entity: the
cache-as-source-of-truth model in `client.md` does not hold under the default. Swap in
Graphcache to get normalization:

```typescript
import { cacheExchange } from "@urql/exchange-graphcache";

const client = createClient({
  url: "/graphql",
  exchanges: [cacheExchange({ keys: {}, updates: {}, optimistic: {} }), fetchExchange],
});

<Provider value={client}>{children}</Provider>;
```

Reach for Graphcache whenever the app has more than one screen reading the same
entity. The document cache is only enough for read-mostly, non-overlapping pages.

## Reading data

One data hook per operation. Handle the three states in order: loading, error, then
render from `data` only once it is present.

Apollo returns an object:

```typescript
const { data, loading, error } = useQuery(ReviewListDocument, {
  variables: { first: 20 },
});
if (loading) return <Spinner />;
if (error) return <ErrorNotice error={error} />;
return <ReviewList reviews={data.reviews} />;
```

urql returns a tuple, and the in-flight flag is `fetching`, not `loading`:

```typescript
const [{ data, fetching, error }] = useQuery({
  query: ReviewListDocument,
  variables: { first: 20 },
});
if (fetching) return <Spinner />;
if (error) return <ErrorNotice error={error} />;
return <ReviewList reviews={data.reviews} />;
```

Suspense is available in both (Apollo `useSuspenseQuery`, urql `useQuery` with
`suspense: true` on the client) for teams already rendering inside error boundaries:
loading moves to a `<Suspense fallback>` and errors to the boundary. Use it when the
boundaries already exist; otherwise the explicit three-state hook above is the default.

## Where to query vs. what to pass down

The architectural decision that shapes a GraphQL React app. The rule, from Relay:
**query at route or container boundaries; below that boundary a component declares a
fragment and receives a fragment reference, never the parent's scalar fields.** Three
shapes:

- **A query in every leaf component.** Each leaf hits the network, so a child's fetch
  can't begin until its parent has rendered: a request waterfall, N loading states,
  and refetch storms on every re-render. Wrong anywhere below the route level.
- **One top query that enumerates every descendant's fields, prop-drilled down.** One
  request, but the parent's query now spells out every field its children render, so it
  is coupled to all of them: adding one field to a leaf means editing the leaf *and*
  every query above it, and the child can read fields it never declared. The coupling
  is what hurts here. Passing a fragment **reference** down through props is ordinary,
  explicit prop-passing, as the `react` skill notes.
- **Colocated fragments, one query per screen, fragment refs read with `useFragment`.**
  Each component owns a fragment; the route query spreads them and fires one request;
  the ref flows down and each component reads only its own slice. A field change touches
  exactly one fragment. This is the recommended default.

Open a *new* query deliberately, only for data that is genuinely independent or
on-demand: a lazily mounted modal, a tab not yet visited, a section you want behind its
own loading boundary, or a pagination continuation (see [client.md](client.md)).

Attribution: this is **Relay's** model, and Relay *enforces* the masking: a component
physically cannot read a field its fragment did not declare. **Apollo** endorses the
same pattern through its `useFragment` hook but leaves masking to convention. **urql**
has no native `useFragment`; it reaches the same place through the graphql-codegen
client-preset's `useFragment` / `FragmentType` helpers.

## Reading fragment data

A child reads its masked slice from the fragment reference its parent passed, rather
than receiving unpacked scalars. Apollo ships a native hook:

```typescript
function ReviewCard({ review }: { review: FragmentType<typeof ReviewCardFragment> }) {
  const data = useFragment({ fragment: ReviewCardFragment, from: review });
  return <Card title={data.title} rating={data.rating} />;
}
```

urql uses the codegen client-preset's `useFragment` helper for the identical effect:
same fragment definition, same masking, different import. See the fragment colocation
section in [client.md](client.md) for why colocation pays off.

## Mutations in a component

Apollo's `useMutation` returns the mutate function directly:

```typescript
const [approveReview, { loading }] = useMutation(ApproveReviewDocument);
await approveReview({ variables: { input: { reviewId } } });
```

urql's returns a `[result, execute]` tuple; you call `execute` to run it:

```typescript
const [result, approveReview] = useMutation(ApproveReviewDocument);
await approveReview({ input: { reviewId } });
```

The cache-update *strategy* (free updates from the returned entity, `update` for list
membership, `optimisticResponse`, `refetchQueries` as the justified exception) lives in
[client.md](client.md). Where that logic goes differs by library: Apollo takes `update`
and `optimisticResponse` at the call site; urql keeps the equivalent list-membership and
optimistic logic in Graphcache's `updates` and `optimistic` config, not at the call site.

## Apollo ↔ urql

| Concern | Apollo | urql |
| --- | --- | --- |
| Provider | `ApolloProvider` | `Provider` |
| Read hook | `useQuery` → object | `useQuery` → `[result]` tuple |
| In-flight flag | `loading` | `fetching` |
| Mutation trigger | `[mutate]`, call directly | `[result, execute]`, call `execute` |
| Normalized cache | `InMemoryCache`, built in | Graphcache (`@urql/exchange-graphcache`) add-on |
| Fragment read | native `useFragment` | codegen client-preset `useFragment` |
| Connection pagination | `relayStylePagination()` | Graphcache `relayPagination()` |
| Optimistic / list updates | call-site `update` + `optimisticResponse` | Graphcache `updates` + `optimistic` config |
