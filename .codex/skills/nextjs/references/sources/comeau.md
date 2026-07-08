# Source material: Josh Comeau on React Server Components

From "Making Sense of React Server Components," published on joshwcomeau.com. Quotes are verbatim.

## Server Components run once and never re-render

The defining constraint: a Server Component produces UI on the server and is then frozen.

> For the first time ever, React components can run exclusively on the server.

> The key thing to understand is this: Server Components never re-render. They run once on the server to generate the UI. The rendered value is sent to the client and locked in place. As far as React is concerned, this output is immutable, and will never change.

This is why the interactive half of React's API is unavailable to them:

> This means that a big chunk of React's API is incompatible with Server Components. For example, we can't use state, because state can change, but Server Components can't re-render. And we can't use effects because effects only run after the render, on the client, and Server Components never make it to the client.

## Server by default, client by opt-in

The names invert the old intuition: the components you knew are now the special case.

> In this new "React Server Components" paradigm, all components are assumed to be Server Components by default. We have to "opt in" for Client Components.

> This new paradigm introduces a new type of component, Server Components. These new components render exclusively on the server. Their code isn't included in the JS bundle, and so they never hydrate or re-render.

"Client Component" does not mean client-only, which is the name's central trap:

> The name "Client Component" implies that these components only render on the client, but that's not actually true. Client Components render on both the client and the server.

## The client boundary follows imports, not the tree

Adding `'use client'` creates a boundary; everything it imports is pulled to the client with it.

> One of the biggest "ah-ha" moments I had with React Server Components was the realization that this new paradigm is all about creating client boundaries.

> When we add the 'use client' directive to the `Article` component, we create a "client boundary". All of the components within this boundary are implicitly converted to Client Components.

> In order to prevent this impossible situation, the React team added a rule: Client Components can only import other Client Components.

The escape hatch is `children`: a Server Component's output can be handed to a Client Component as a prop, staying server-rendered.

> This is what allows that `ColorProvider` example above to work. The output from `Header` and `MainContent` is passed into the `ColorProvider` component through the `children` prop. `ColorProvider` can re-render as much as it wants, but this data is static, locked in by the server.

> When it comes to client boundaries, though, the parent/child relationship doesn't matter. `Homepage` is the one importing and rendering `Header` and `MainContent`.

## RSC is not SSR

The two are complementary, not successive versions of the same idea.

> Let's clear up another common bit of confusion: React Server Components is not a replacement for Server Side Rendering. You shouldn't think of React Server Components as "SSR version 2.0".

> Instead, I like to think of it as two separate puzzle pieces that snap together perfectly, two flavors that complement each other.

What is genuinely new is running server-only code inside a component:

> The big difference is that we've never before had a way to run server-exclusive code inside our components.
