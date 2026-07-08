# Source material: Sam Selikoff and Ryan Toronto (Build UI)

From the buildui.com course lesson "Building a users table" (in "Data fetching with React Server Components") and the post "React Cache" by Ryan Toronto. Quotes are verbatim. Build UI's fullest RSC mental-model material is in a podcast episode with no published transcript, so this dossier draws on their written lessons; the "two worlds" framing is covered more fully by the `comeau` and `abramov` sources.

## Server Components only ever run on the server

Unlike SSR, which runs ordinary components on the server *and* the client, Server Components execute in one place only.

> This is distinct from the concept of server-side rendering (SSR) which applies to the typical React components you're probably familiar with.

> Server Components, in contrast, never execute on the client.

> Second, Server Components only ever run on the server.

That single guarantee is what lets them touch server-only resources directly:

> Because Server Components are guaranteed to only ever run on the server, they allow us to write React components that directly access secure data from databases.

> First, Server Components can be `async` functions that use the `await` keyword. This allows them to directly use libraries that use promises for async work (like Prisma), without any additional wrapping code.

## The output crosses the wire, not the code

The browser receives the rendered result, never the component's source or its dependencies.

> They only execute on the server at the time of the request, and then send their output (called the RSC Payload) up to the browser to be rendered by your app.

> The payload only contains the output, so the browser never needs to execute or even see the code inside your Server Component.

## Colocating fetch-and-render can block

Awaiting data inside a component is convenient, but it stalls that component until the data arrives.

> One of the problems with co-locating data fetching and rendering in async components is that these components are now blocked while they're fetching data.

> It's worth noting that while our Server Component is awaiting a response from Prisma, our page is blocked from rendering.

## Request-scoped memoization stands in for shared fetch state

On the server there's no context or module store to dedupe fetches, so `cache()` gives you a per-request place to stash results.

> In client React we have context and module-scoped external stores to manage loading states and shared fetches, but in RSC we don't have access to those tools.

> React's `cache()` memoizes your function calls when rendering server components.

> This short-lived cache is useful when you are fetching data in multiple places, for example a layout and a page that both fetch the current user.

> After one component fetches the top article, all other components that need the article will re-use the result of the first fetch.
