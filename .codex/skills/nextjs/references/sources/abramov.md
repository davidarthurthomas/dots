# Source material: Dan Abramov on React Server Components

From the overreacted.io essays "React for Two Computers," "Impossible Components," "What Does 'use client' Do?," and "JSX Over The Wire." Quotes are verbatim (modulo curly-quote and em-dash normalization). This dossier covers Abramov's RSC writing specifically; his older essays on effects and memoization are cited by the sibling `react` skill.

## A single program across two computers

RSC models a client/server application as one program spanning two machines, with the network gap made explicit rather than hidden.

> Some programs are distributed computations across multiple machines. In particular, some programs can be represented as functions spanning across two machines (although in principle there could be more).

> But if you adopt the view that the backend and a frontend are a single program split across two computers, you can't really "unsee" it.

> Together, these directives let you express the client/server boundary within the module system. They let you model a client/server application as a single program spanning the two machines without losing sight of the reality of the network and serialization gap. That, in turn, allows seamless composition across the network.

## Two isolated environments

The two sides share no runtime; they can't reach into each other, which is why the directives, not convention, connect them.

> It's tempting to see the client and the server as two separate programs that communicate with each other. But now you know that it's a single function that closes over the network by sending the rest of itself forward in time and space.

> Although they are a part of a single conceptual program, they are separate runtime environments. They can't coordinate with each other at runtime because they're separated by time and space. Their module systems are completely isolated from each other, they each have their own globals, and even may be running on different JavaScript engines.

> These directives express the network gap within your module system. They let you describe a client/server application as a single program spanning two environments. They acknowledge and fully embrace the fact that these environments don't share any execution context—this is why neither import executes any code.

## Data flows one way, backend to frontend

The backend is the parent in React's top-down flow; the frontend receives data already resolved.

> The data flows strictly in a one direction—from the first to the second computer. The second part can see the values from the first part (as long as they can be turned into text). But the first part doesn't know anything about the second part.

> Notice that the backend runs first. Our mental model here isn't "frontend loads data from the backend". Rather, it's "the backend passes data to the frontend". This is React's top-down data flow, but including the backend into the flow. The backend is the source of truth for the data—so it must be the frontend's parent.

> And because the backend parts always run first, when you load this page, from the frontend's perspective, the data is "already there". There are no flashes of "loading data from the backend"—the backend has already passed the data to the frontend.

The inversion this creates: the server hands the client components, not raw data to go fetch.

> Your components don't call your API. Instead, your API returns your components.

> A navigation to a new screen should be possible to complete in one client/server roundtrip. Even if you have hundreds of components that each want to load some data, from the client's perspective, a screen should arrive as a single response.

## The boundary is a door, and it should move freely

Each directive opens a door in one direction between the two worlds, making the seam syntactic instead of conventional.

> Like 'use server' before it, 'use client' makes the connection between the server and the client syntactic. Whereas 'use server' opens a door from the client to the server, 'use client' opens a door from the server to the client. It's like two worlds with two doors between them.

The physical split is real, but you shouldn't have to rewrite to move the line:

> The division between the frontend and the backend is physical. We can't escape from the fact that we're writing client/server applications. Some logic is naturally more suited to either side. But one side should not dominate the other. And we shouldn't have to change the approach whenever we need to move the boundary.

> What we need are the tools that let us compose across the stack. Then we can create self-contained LEGO blocks that run where appropriate—and snap them together.
