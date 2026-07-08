# Source material: the react.dev Server Components reference

From the React documentation at react.dev/reference/rsc: the "Server Components," "use client," "use server," and "Server Functions" reference pages. Quotes are verbatim.

## What a Server Component is

A Server Component renders ahead of the bundle, in an environment separate from the client and the SSR server.

> Server Components are a new type of Component that renders ahead of time, before bundling, in an environment separate from your client app or SSR server.

> This separate environment is the "server" in React Server Components. Server Components can run once at build time on your CI server, or they can be run for each request using a web server.

Because they run on the server, they reach the data layer directly and can be async:

> Server Components can also run on a web server during a request for a page, letting you access your data layer without having to build an API. They are rendered before your application is bundled, and can pass data and JSX as props to Client Components.

> Async Components are a new feature of Server Components that allow you to `await` in render.

> When you `await` in an async component, React will suspend and wait for the promise to resolve before resuming rendering.

Server Components can't hold interactivity, which is what forces the composition with Client Components:

> Server Components are not sent to the browser, so they cannot use interactive APIs like `useState`. To add interactivity to Server Components, you can compose them with Client Component using the `"use client"` directive.

There is no directive for Server Components; the common belief that `"use server"` marks them is wrong:

> A common misunderstanding is that Server Components are denoted by `"use server"`, but there is no directive for Server Components. The `"use server"` directive is used for Server Functions.

## The "use client" directive

The directive marks a boundary in the module dependency tree, not the render tree.

> `'use client'` lets you mark what code runs on the client.

> When a file marked with `'use client'` is imported from a Server Component, compatible bundlers will treat the module import as a boundary between server-run and client-run code.

> `'use client'` defines the boundary between server and client code on the module dependency tree, not the render tree.

Everything in the client sub-tree ships to the client, components or not:

> Code that is marked for client evaluation is not limited to components. All code that is a part of the Client module sub-tree is sent to and run by the client.

The same module can run in either place depending on who imports it:

> Note that a single module may be evaluated on the server when imported from server code and on the client when imported from client code.

## The "use server" directive and Server Functions

The directive marks a server function callable from the client; React handles the network call.

> `'use server'` marks server-side functions that can be called from client-side code.

> Server Functions allow Client Components to call async functions executed on the server.

> When a Server Function is defined with the `"use server"` directive, your framework will automatically create a reference to the Server Function, and pass that reference to the Client Component. When that function is called on the client, React will send a request to the server to execute the function, and return the result.

Its purpose is mutation, not fetching, and every argument is untrusted:

> Server Functions are designed for mutations that update server-side state; they are not recommended for data fetching.

> Always treat arguments to Server Functions as untrusted input and authorize any mutations.

## Serialization across the boundary

Arguments and return values cross the network as serialized copies.

> When calling a Server Function on the client, it will make a network request to the server that includes a serialized copy of any arguments passed. If the Server Function returns a value, that value will be serialized and returned to the client.

## Composition across the boundary

A Server Component's output is passed to a Client Component as already-rendered props.

> This works by first rendering `Notes` as a Server Component, and then instructing the bundler to create a bundle for the Client Component `Expandable`. In the browser, the Client Components will see output of the Server Components passed as props.
