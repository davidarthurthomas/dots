# Client consumption

Sources: Apollo Client docs (caching, mutations, fragments, cursor-based pagination),
graphql-codegen client-preset docs (the-guild.dev/graphql/codegen). Examples use Apollo
Client + graphql-codegen; the principles apply to any normalized-cache client (urql with
Graphcache, Relay). For the React binding (Provider setup, query hooks, where to query
vs. pass fragment refs, Apollo vs urql), see [react.md](react.md).

## Typed operations

All operations go through codegen: hand-written response types drift from the schema
silently. With the client preset, write documents via the generated `graphql()` tag and let
types flow; regenerate on every schema or operation change (wire it into the dev loop so it
can't be forgotten). One generated target; a second parallel setup "for compatibility" means
every type exists twice and half the imports are stale.

## Fragment colocation

Each component declares its own data needs as a fragment in its own file; parents spread
child fragments into their query instead of copy-pasting selections:

```typescript
// ReviewCard.tsx
export const ReviewCardFragment = graphql(`
  fragment ReviewCard on Review {
    id
    rating
    title
    isApproved
  }
`);

// ReviewList.tsx composes it without knowing its fields
const ReviewListQuery = graphql(`
  query ReviewList($first: Int!, $after: String) {
    reviews(first: $first, after: $after) {
      edges { node { id ...ReviewCard } }
      pageInfo { hasNextPage endCursor }
    }
  }
`);
```

Why: when `ReviewCard` needs a new field, one fragment changes and every query that renders a
review card picks it up. Copy-pasted selections mean N places to update and N chances for a
missing-field runtime surprise. Keep the client preset's fragment masking on: a component
can only read fields its own fragment declared, so deleting a fragment field is safe exactly
when the component compiles.

One data hook per operation. A component juggling three ad-hoc queries usually wants one
query with three fragments.

## The cache is the source of truth

Server data lives in the normalized cache and is read from it (queries, `useFragment`).
Never mirror query results into a second store (Redux, Zustand, module state): the mirror
bypasses normalization, so mutation responses and subscription events update the cache while
the copy drifts, and now the app has two versions of the truth and a sync layer to debug.
Client-only state lives beside server data (local-only fields) or in any local store, as
long as server entities aren't duplicated into it.

Identity: the default cache key is `__typename:id`, which works when the schema keeps ids
unique per type. `keyFields` is for types whose identity genuinely spans fields;
`keyFields: false` embeds identity-less value objects (a `Money`, a `DateRange`) in their
parent. Needing a compound key for an *entity* usually means the schema's identity model is
wrong. Raise it as a schema problem, don't just configure around it.

## Mutations and cache updates

Order of preference:

1. **Free.** A mutation payload returning the changed entity with `id` + `__typename`
   updates every cached copy automatically. No code. This is why payloads carry the entity.
2. **`update` for list membership.** Normalization can't infer that a new entity belongs in
   a cached list (or that a deleted one leaves). Write the membership change directly:

```typescript
const [approveReview] = useMutation(ApproveReviewDocument, {
  optimisticResponse: {
    approveReview: {
      __typename: "ApproveReviewPayload",
      review: { __typename: "Review", id: review.id, isApproved: true },
      userErrors: [],
    },
  },
  update(cache, { data }) {
    const review = data?.approveReview.review;
    if (!review) return;
    cache.modify({
      fields: {
        pendingReviews(existing, { readField }) {
          return {
            ...existing,
            edges: existing.edges.filter(
              (edge) => readField("id", edge.node) !== review.id,
            ),
          };
        },
      },
    });
  },
});
```

3. **`refetchQueries` as the justified exception.** Legitimate when the client can't compute
   the post-mutation state: server-derived aggregates, complex filtered lists. It costs a
   round trip per query and re-renders everything downstream, so when you use it, say why in
   a comment.

Pair `update` with `optimisticResponse` for perceived-instant UI; the optimistic layer is
rolled back and replaced by the real response, flowing through the same `update` path, so
it must include `__typename` and `id`.

In urql the same strategy applies, but the list-membership and optimistic logic lives in
Graphcache's `updates` and `optimistic` config rather than at the call site. See
[react.md](react.md).

## Pagination

For connection fields, use `relayStylePagination()` as the field policy: it merges pages
into the cache and makes `fetchMore` append:

```typescript
new InMemoryCache({
  typePolicies: {
    Query: {
      fields: {
        // keyArgs: pages of the same filter merge; different filters cache separately
        reviews: relayStylePagination(["filter"]),
      },
    },
  },
});
```

Then `fetchMore({ variables: { after: pageInfo.endCursor } })` and render from the merged
result. urql's Graphcache exposes the same merge as `relayPagination()`. The merge lives in
the field policy, in one place. Do not also merge pages by hand
in `updateQuery` or in a component; multiple merge layers for the same field is how lists
duplicate and drop entries. If the server's connection shape diverges from spec Relay,
`relayStylePagination` won't fit and you'll be maintaining a patched copy: that's a schema
problem worth raising, not a client problem to absorb.

## Error handling

Two channels arrive at the client; handle both, differently:

- **`userErrors` on mutation payloads**: expected, actionable. Render them in the UI at the
  point of action: field-level messages next to inputs (via the `field` path), general ones
  inline. Branch on `code`, not on message text.
- **Top-level GraphQL / network errors**: exceptional. Surface generically (toast, error
  boundary) and report to the error tracker. The user can't fix these; don't ask them to.

Every mutation call site checks `userErrors`: a payload with errors and HTTP 200 is a
*failed* action, and ignoring it means the UI claims success on failure. Wire the generic
channel once (an error link that reports and notifies), not per call site.

Suppressing an error is sometimes right (a background prefetch, a fire-and-forget ping) but
never silently: an ignored error carries a comment saying why ignoring is safe.
