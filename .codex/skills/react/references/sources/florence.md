# Source material: Ryan Florence on React

From the Remix "Technical Explanation" and Philosophy docs (carried forward into the React Router docs as the "Progressive Enhancement," "Form vs. fetcher," and "Network Concurrency Management" explanation pages), the remix.run blog post "Remixing React Router," the Syntax.fm "Supper Club" interview transcript, and the Chats with Kent Dodds podcast transcript. Quotes from docs, the blog, and interview transcripts are verbatim. The Reactathon talk "When To Fetch: Remixing React Router" is summarized from secondhand writeups only (no transcript was found), so its material is paraphrased and attributed rather than quoted.

## The URL is the state

Remix and React Router treat the URL itself as the state container for anything that should be shareable, bookmarkable, or survive a refresh, rather than syncing it into a separate React state variable. The docs frame the choice between a `<Form>` navigation and a `useFetcher` call as one question:

> The primary criterion when choosing among these tools is whether you want the URL to change or not

The URL should change when an action moves the user to a new context: creating a record and sending them to its page, or deleting one and returning them to the list. It shouldn't change for small, in-place edits:

> Updating a Single Field: Maybe a user wants to change the name of an item in a list or update a specific property of a record. This action is minor and doesn't necessitate a new page or URL.

## Forms and mutations are the unit of interaction

Remix models every write as an HTML form submission, not a function call from a component. Florence, in the Syntax.fm interview, starts from what a plain form already means before any framework gets involved:

> What do forms do? What does HTTP post mean? What happens before JavaScript shows up and you submit a form? Well, you change some data. Maybe you redirect.

The framework's job is to keep the rest of the page honest after that mutation runs, automatically, without the developer wiring up cache invalidation:

> When the action completes, we go and revalidate any data that you fetched on the page previously so that the UI and your data on the back end stay in sync automatically.

The React Router docs state the same mechanism plainly:

> Data mutations are done through Route actions. When the action completes, all loader data on the page is revalidated to keep your UI in sync with the data without writing any code to do it.

This is the alternative to hand-rolled client state management for server data: the form submits, the action runs, the loaders rerun, the UI reflects the new truth. No store, no manual refetch, no cache key to invalidate by hand.

## Progressive enhancement, not two apps

Florence's recurring argument is that a form should work before JavaScript exists on the page, and that JavaScript should only ever enhance that baseline, never replace it:

> React Router embraces progressive enhancement by building on top of HTML, allowing you to build your app in a way that works without JavaScript, and then layer on JavaScript to enhance the experience.

> Whether JavaScript has loaded or not doesn't matter, this button will add the product to the cart.

The docs justify this on more than resilience grounds; performance and plain simplicity are the other two legs:

> While it's easy to think that only 5% of your users have slow connections, the reality is that 100% of your users have slow connections 5% of the time.

> Everybody has JavaScript disabled until it's loaded.

> Building your apps in a progressively enhanced way with React Router is actually simpler than building a traditional SPA.

Critically, this isn't building the feature twice:

> It's not about building it two different ways–once for JavaScript and once without–it's about building it in iterations... Not only will the user get a progressively enhanced experience, but the app developer gets to "progressively enhance" the UI without changing the fundamental design of the feature.

Remix's own docs call this out by name as a deliberate, old idea reapplied:

> We borrowed an old term and called this Progressive Enhancement in Remix. Start small with a plain HTML form (Remix scales down) and then scale the UI up when you have the time and ambition.

## Fetch at route boundaries, not in components

Florence's core complaint about component-level data fetching is that it is slow by construction: a component has to render before it can know what to fetch, so children wait on parents and the whole tree waterfalls.

> We've learned that fetching in components is the quickest way to the slowest UX (not to mention all the content layout shift that usually follows).

> Component fetching like this makes your app ridiculously slower than it could be.

His fix, carried from React Router into Remix's loaders, is to separate deciding what to fetch from rendering what was fetched, and to make that decision at the route level where every segment of the URL is already known up front:

> The solution is to decouple _initiating fetches_ from _reading results_.

> By initiating your fetches at nested route boundaries the request waterfall chain is flattened and 3x faster.

The same logic extends to interruption and concurrency: because the router, not a component, owns the fetch, it can also own cancellation when the user navigates again before a request resolves.

> When a link is clicked within a React Router application, it initiates fetch requests for each loader tied to the target URL. If another navigation interrupts the initial navigation, React Router cancels the previous fetch requests, ensuring that only the latest requests proceed.

In the Reactathon talk (paraphrased, no transcript available), Florence describes this as reducing a component's job from initiator, reader, and fallback all at once down to just reading and falling back: because the server already knows the URL before the component ever renders, it can start the fetch there instead of waiting on the client.

## Use the platform

Underneath all of the above is a bet that browsers and HTTP are the right foundation to build on, rather than a network layer invented on top of them. Florence, on the Chats with Kent Dodds podcast:

> We can use the webs. And by the webs, I mean browsers. And we think it's been a really good bet.

> We're really going all in on the web platform, particularly for servers, but anything you build for a server can run pretty much in the browser or in a service worker.

> Our goal is not to go and beat everything that's out there. It's just we want to make a bet on the web platform.

He makes the same point about protocols, not just runtimes, in the Syntax.fm interview:

> We can actually just use these standard web APIs for our network interface, and if we build Remix to strictly operate on those, nothing from Node...then we can deploy this everywhere.

And the payoff isn't novelty; it's an old, well-understood model with a modern implementation:

> It gave this really old school PHP development workflow, but with a modern implementation where it was just all fetches in the background, you're not redownloading assets.
