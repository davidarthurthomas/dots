# Source material: the Next.js App Router documentation

From the official docs at nextjs.org/docs/app: the "Server and Client Components," "Fetching Data," "Caching," "Mutating Data," "Layouts and Pages," "Error Handling," and "Loading UI and Streaming" pages, plus the "Server Actions" and caching guides. Quotes are verbatim. Next.js ships two overlapping caching APIs across recent major versions (a `fetch`-options model and a newer `use cache` / Cache Components model); the quotes below are chosen for the durable ideas they express, not the specific API surface, which churns.

## Server Components are the default

Rendering happens on the server unless something opts a subtree out.

> By default, layouts and pages are Server Components, which lets you fetch data and render parts of your UI on the server, optionally cache the result, and stream it to the client. When you need interactivity or browser APIs, you can use Client Components to layer in functionality.

> Since Server Components are rendered on the server, credentials and query logic will not be included in the client bundle so you can safely make database queries using an ORM or database client.

The docs frame the choice as capability-driven, not default:

> Use Server Components when you need: Fetch data from databases or APIs close to the source. Use API keys, tokens, and other secrets without exposing them to the client. Reduce the amount of JavaScript sent to the browser.

## The "use client" boundary

The directive marks a boundary in the module graph, and everything below it ships to the client.

> `"use client"` is used to declare a boundary between the Server and Client module graphs (trees).

> Once a file is marked with `"use client"`, all of its imports and the components it directly renders are included in the client bundle. This means you don't need to add the directive to every component that is intended for the client.

Server Components passed *through* a Client Component as props are the exception, because they never enter its module graph:

> This behavior applies to components that are part of the Client Component's module graph, which includes the modules it imports and the components it renders directly. It does not apply to Server Components passed as children or other props. Those components are not imported into the Client Component's module graph. They are rendered on the server and passed to the Client Component as rendered output.

What crosses the boundary as props must be serializable:

> Good to know: Props passed to Client Components need to be serializable by React.

## Composition across the boundary

Pass server-rendered UI into a client component through props or `children` to keep it on the server.

> You can pass Server Components as a prop to a Client Component. This allows you to visually nest server-rendered UI within Client components.

> A common pattern is to use `children` to create a slot in a `<ClientComponent>`. For example, a `<Cart>` component that fetches data on the server, inside a `<Modal>` component that uses client state to toggle visibility.

> In this pattern, Server Components are rendered on the server ahead of time, even when passed as props to Client Components. The React Server Component Payload contains the rendered result of those Server Components, plus placeholders for where Client Components should be rendered and references to their JavaScript files.

## Fetching data on the server, colocated

Turn the component async and fetch where the data is used; identical requests are deduplicated so colocation isn't refetching.

> To fetch data with the `fetch` API, turn your component into an asynchronous function, and await the `fetch` call.

> Identical `fetch` requests in a React component tree are memoized by default, so you can fetch data in the component that needs it instead of drilling props.

For non-`fetch` data access, wrap in React's `cache` to get the same request-scoped dedup:

> If you are not using `fetch` (which is automatically memoized), and instead using an ORM or database directly, you can wrap your data access with the React `cache` function to deduplicate requests within a single render pass.

> `React.cache` is scoped to the current request only. Each request gets its own memoization scope with no sharing between requests.

## Parallel versus sequential fetching

Segments fetch in parallel by default; `await`s stacked inside one component serialize into a waterfall.

> Parallel data fetching happens when data requests in a route are eagerly initiated and start at the same time.

> Sequential data fetching happens when one request depends on data from another.

> By default, layouts and pages are rendered in parallel. So each segment starts fetching data as soon as possible.

> However, within any component, multiple `async`/`await` requests can still be sequential if placed after the other.

The fix is to start requests before awaiting them:

> Start multiple requests by calling `fetch`, then await them with `Promise.all`. Requests begin as soon as `fetch` is called.

## Streaming with Suspense

A slow request blocks the whole route; streaming breaks the page into chunks the server sends as they finish.

> When you fetch data in Server Components, the data is fetched and rendered on the server for each request. If you have any slow data requests, the whole route will be blocked from rendering until all the data is fetched.

> To improve the initial load time and user experience, you can break the page into smaller chunks and progressively send those chunks from the server to the client. This is called streaming.

`loading.js` is a Suspense boundary declared by file convention:

> The special file `loading.js` helps you create meaningful Loading UI with React Suspense. With this convention, you can show an instant loading state from the server while the content of a route segment streams in. The new content is automatically swapped in once complete.

> In the same folder, `loading.js` will be nested inside `layout.js`. It will automatically wrap the `page.js` file and any children below in a `<Suspense>` boundary.

## Static and dynamic rendering

Reading request-time data is what turns a route dynamic.

> Using `searchParams` opts your page into dynamic rendering because it requires an incoming request to read the search parameters from.

> Runtime APIs require information that is only available when a user makes a request. These include: `cookies` - User's cookie data, `headers` - Request headers, `searchParams` - URL query parameters, `params` - Dynamic route parameters.

## Caching and revalidation

Caching stores a result so the work isn't repeated; revalidation is how a mutation tells the cache what changed.

> Caching is a technique for storing the result of data fetching and other computations so that future requests for the same data can be served faster, without doing the work again.

> To revalidate cached data after an event, use `revalidateTag` or `revalidatePath` in a Server Action or Route Handler.

> Invalidate cached data by tag using `revalidateTag`.

> Invalidate all cached data for a specific route path using `revalidatePath`.

Time-based revalidation covers data that goes stale on a schedule:

> Use the `next.revalidate` option on `fetch` to revalidate data after a specified number of seconds.

## Mutations with Server Actions

A Server Action is a server function callable from the client; after a write, revalidate what the page reads.

> A Server Function is an asynchronous function that runs on the server. You can call them from the client through a network request, which is why they must be asynchronous. In an `action` or mutation context, they are also called Server Actions.

> When an action is invoked, Next.js can return both the updated UI and new data in a single server roundtrip. Behind the scenes, actions use the `POST` method, and only this HTTP method can invoke them.

> After performing a mutation, you can revalidate the Next.js cache and show the updated data by calling `revalidatePath` or `revalidateTag` within the Server Function.

Forms that call actions work before hydration:

> Good to know: Server Components support progressive enhancement by default, meaning forms that call Server Actions will be submitted even if JavaScript hasn't loaded yet or is disabled.

An action is a public endpoint; render-time gating is not a security boundary:

> Server Functions are reachable via direct POST requests, not just through your application's UI. Always verify authentication and authorization inside every Server Function.

> Render-time gating (only rendering a form on an authenticated page) is not a security boundary, because requests can be sent without going through the UI.

> Constrain return values. Action returns are serialized to the client. Shape them to what the UI renders, not raw database records.

## Routing is file structure

Folders are the route tree; layouts nest and persist across navigation.

> Next.js uses file-system based routing, meaning you can use folders and files to define routes.

> Folders are used to define the route segments that map to URL segments. Files (like `page` and `layout`) are used to create UI that is shown for a segment.

> A layout is UI that is shared between multiple pages. On navigation, layouts preserve state, remain interactive, and do not rerender.

> By default, layouts in the folder hierarchy are also nested, which means they wrap child layouts via their `children` prop.

Error boundaries are declared the same way, and errors bubble to the nearest one:

> Next.js uses error boundaries to handle uncaught exceptions. Error boundaries catch errors in their child components and display a fallback UI instead of the component tree that crashed.

> Errors will bubble up to the nearest parent error boundary. This allows for granular error handling by placing `error.tsx` files at different levels in the route hierarchy.

## Partial Prerendering

The durable shape is a static shell sent instantly with dynamic holes streamed in. (The name and the enabling config flag are version-specific; the idea is not.)

> This generates a static shell consisting of HTML for initial page loads and a serialized RSC Payload for client-side navigation, ensuring the browser receives fully rendered content instantly whether users navigate directly to the URL or transition from another page.

The pitfall is deferring the whole route with one badly placed boundary:

> Placing a `<Suspense>` boundary with an empty fallback above the document body in your Root Layout causes the entire app to defer to request time. Because the fallback is empty, there is no static shell to send immediately, so every request blocks until the page is fully rendered.
