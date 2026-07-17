---
name: nextjs
description: >
  Write and review Next.js App Router code: Server and Client Components, the "use client"
  boundary, server-side data fetching, caching and revalidation, Server Actions, routing and
  layouts, streaming. Use when adding a route or layout, deciding server vs client for a component,
  fetching data in the App Router, chasing a waterfall or a stale cache, writing a Server Action or
  mutation, placing a Suspense boundary, or reviewing App Router code in a diff. Triggers on
  "App Router", "Server Component", "use client", "Server Action", "revalidate", "loading.tsx",
  "Next.js".
global_category: Engineering
---

# Next.js

Next.js App Router principles, grounded in the modern canon:

- [The Next.js App Router documentation](references/sources/next-docs.md)
- [The react.dev Server Components reference](references/sources/react-dev.md)
- [Dan Abramov, overreacted.io essays on React Server Components](references/sources/abramov.md)
- [Josh Comeau, _Making Sense of React Server Components_](references/sources/comeau.md)
- [Sam Selikoff and Ryan Toronto, Build UI](references/sources/buildui.md)
- [Lee Robinson, App Router talks and essays](references/sources/robinson.md)

For base component, hook, and state principles, see the `react` skill; for data-layer design, the
`graphql` skill; for test discipline, `testing`.

## The server/client boundary

**An App Router app is one program split across two computers.** Abramov's frame is that "the backend and a frontend are a single program split across two computers"; the `"use client"` and `"use server"` directives "express the client/server boundary within the module system" so you can move the line without rewriting the code. Hold both environments in view at once rather than treating the server as a remote API the client calls.

**Server Components are the default; the client is the opt-in.** Comeau's rule is that "all components are assumed to be Server Components by default. We have to 'opt in' for Client Components." The reason to opt in is real interactivity, not habit: state, effects, event handlers, and browser APIs are what force a component to the client. Everything else stays on the server, out of the bundle and close to the data.

**`"use client"` marks a boundary, not a file.** The directive "defines the boundary between server and client code on the module dependency tree, not the render tree": once a file has it, "all of its imports and the components it directly renders are included in the client bundle", and "Client Components can only import other Client Components". Comeau's insight is that the boundary follows the import graph, not the visual tree ("the parent/child relationship doesn't matter"), so put the directive on the smallest interactive leaf, not near the root where it drags half the app across with it.

**Only serializable values cross the boundary.** Props "passed to Client Components need to be serializable by React"; an argument to a server function travels as "a serialized copy". Functions, class instances, and closures don't cross as data — the one thing that does cross as a callable is a Server Function, which travels as a reference the client invokes over the network.

**Pass server-rendered UI through the client as `children`.** A Server Component handed to a Client Component as a prop is the exception to the bundle rule: "it does not apply to Server Components passed as children or other props ... They are rendered on the server and passed to the Client Component as rendered output." This is how an interactive shell (a modal, a provider, a toggle) wraps server-rendered content without pulling that content onto the client. Reach for it before you consider making the content itself a Client Component.

**Data flows one way, server to client.** "The backend passes data to the frontend ... The backend is the source of truth for the data—so it must be the frontend's parent." Server Components "run once on the server to generate the UI", and that output is "locked in place" — immutable from the client's view. Design the tree so data originates on the server and descends, never so the client fetches back up to fill a hole the server could have filled.

## Fetching data on the server

**Fetch on the server, colocated with the component that renders it.** "Both Route Handlers and Server Components run securely on the server. You don't need the additional network hop" — so keep "the data close to where the UI is actually being rendered". This is the App Router's answer to the waterfall the `react` skill warns about under "fetch at route boundaries": the segment that owns the URL is itself an async Server Component that awaits its data directly, no separate fetch-initiation layer required.

**Colocating isn't refetching, because requests dedupe.** "Identical `fetch` requests in a React component tree are memoized by default, so you can fetch data in the component that needs it instead of drilling props." For an ORM or database call, wrap the access in React's `cache` to get the same request-scoped dedup — on the server "we don't have access to" context or module stores, so this memo is what a layout and a page share when both read the current user.

**Start independent requests in parallel; sequential `await`s are a waterfall.** Segments "are rendered in parallel", but "within any component, multiple `async`/`await` requests can still be sequential if placed after the other". When two fetches don't depend on each other, kick them both off and await together with `Promise.all` — "requests begin as soon as `fetch` is called". A stacked pair of awaits is the default way to accidentally serialize them.

**Stream slow data instead of blocking the whole route.** "If you have any slow data requests, the whole route will be blocked from rendering until all the data is fetched"; the fix is to "break the page into smaller chunks and progressively send those chunks". `loading.js` is a Suspense boundary declared by file convention, and any `<Suspense>` "needs to be placed higher than the async component doing the data fetching" — the boundary wraps the awaiting component, it isn't the awaiting component.

## Caching and revalidation

**Static by default; reading request data makes a route dynamic.** Runtime APIs — `cookies`, `headers`, `searchParams`, `params` — "require information that is only available when a user makes a request", and touching one opts the route into dynamic rendering. Let a route stay static unless it genuinely needs request-time data; don't reach for dynamic reflexively.

**Server data is borrowed, so revalidate rather than hoard it.** The `react` skill's "server state is borrowed, not owned" applies here at the framework level.

**Revalidate by time, tag, or path — the write names what changed.** Data that goes stale on a schedule uses time-based revalidation; data invalidated by an event uses "`revalidateTag` or `revalidatePath` in a Server Action". The mutation declares what's now stale and the cache re-derives it, which replaces the hand-wired invalidation-after-every-write that the `react` skill flags as a smell.

**The cache is the source of truth; don't copy server data into a client store.** As in the `react` skill's "never copy server data into another container", read from the server on each request and revalidate; keep the client store for the genuinely client-owned state (open/closed, theme) that the server never had.

## Mutations with Server Actions

**A mutation is a server function, colocated with the UI that triggers it.** `"use server"` "marks server-side functions that can be called from client-side code", and they're "designed for mutations that update server-side state; they are not recommended for data fetching". When invoked, an action "can return both the updated UI and new data in a single server roundtrip" — the write and the refresh are one trip, not a mutation followed by a manual refetch.

**Write, then revalidate what the page reads.** "After performing a mutation, you can revalidate the Next.js cache and show the updated data by calling `revalidatePath` or `revalidateTag`." This is the `react` skill's "mutate through actions, then revalidate" made first-class: name the tags or paths the write touched rather than orchestrating refetches by hand.

**Model writes as forms for progressive enhancement.** "Forms that call Server Actions will be submitted even if JavaScript hasn't loaded yet or is disabled." Passing the action to a `<form>`'s `action` prop, rather than wiring an `onClick` handler, means the mutation works before hydration and degrades gracefully — the same submit-change-revalidate shape the `react` skill draws from Remix.

**An action is a public endpoint; authorize and validate inside it.** Actions are "reachable via direct POST requests, not just through your application's UI", so "always verify authentication and authorization inside every Server Function" and "treat arguments to Server Functions as untrusted input". Render-time gating "is not a security boundary, because requests can be sent without going through the UI"; and since returns are serialized to the client, "shape them to what the UI renders, not raw database records".

## Routing is architecture

**The file tree is the route tree.** "Folders are used to define the route segments that map to URL segments," and files like `page`, `layout`, `loading`, and `error` "create UI that is shown for a segment". These conventions are structure, not boilerplate: the shape of the directory is the shape of the app's navigation.

**Layouts nest and persist; put the shared shell there.** "On navigation, layouts preserve state, remain interactive, and do not rerender," and nested layouts "wrap child layouts via their `children` prop". Shared chrome, providers, and anything that should survive a navigation belongs in a layout, not repeated in every page underneath it.

**`loading.tsx` and `error.tsx` are boundaries you declare by convention.** `loading.js` "will automatically wrap the `page.js` file and any children below in a `<Suspense>` boundary"; error boundaries "catch errors in their child components and display a fallback UI", and errors "bubble up to the nearest parent error boundary". You get a Suspense boundary and an error boundary by placing a file at the segment that should own the fallback.

**Colocate route-specific code inside its segment.** Extending the `react` skill's colocation rule to the file system: a route's components, helpers, and data access live in its folder, close to the `page` that uses them. When regions of a screen load and update independently, reach for parallel or intercepting routes rather than hoisting their state into a shared parent.

## Rendering and streaming

**Where a component renders and when it renders are separate axes.** Server versus client is about environment — which machine holds the code and the secrets; static versus dynamic is about timing — build time or request time. A Server Component can be either static or dynamic, and conflating the two axes ("it's dynamic, so it must be a Client Component") is how rendering decisions go wrong.

**Stream the static shell first and suspend the dynamic holes.** The durable shape behind Partial Prerendering is a shell "consisting of HTML for initial page loads" sent instantly, with dynamic content streamed in behind Suspense. One slow fetch shouldn't block the page. The pitfall is a boundary placed too high: a `<Suspense>` with an empty fallback above the document body means "there is no static shell to send immediately, so every request blocks until the page is fully rendered".

**Push both boundaries as deep as the design allows.** Keep the client boundary and the dynamic boundary far down the tree, so most of the app is server-rendered and static and only the genuinely interactive or request-time leaves are isolated.
