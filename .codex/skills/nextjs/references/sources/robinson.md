# Source material: Lee Robinson on the App Router

From the Vercel blog post "Common mistakes with the Next.js App Router and how to fix them" (solo-authored) and the conference talk "The New Next.js App Router" (transcript on gitnation.com). The two blog-post quotes below were confirmed verbatim against the live page. The talk quotes are transcribed speech and are marked as such: their wording is consistent across independent fetches but transcripts are prone to drift, so treat them as closely paraphrased rather than forensically exact.

## Fetch on the server to skip the network hop

Server Components and Route Handlers already run on the server, so fetching from the client to reach them is a wasted round trip.

> Both Route Handlers and Server Components run securely on the server. You don't need the additional network hop.

## Colocate data fetching with the UI

The App Router lets a component fetch the data it renders, keeping the two together. (Talk transcript.)

> It would be great if we could co-locate our data fetching with our components.

> Because the app router is built on react server components, we could now co-locate data with UI.

> So you keep the data close to where the UI is actually being rendered. That's a big improvement.

## Top-down loading is all-or-nothing; stream instead

Blocking the whole page on its data means the user sees nothing until everything is ready; streaming lets slow data arrive out of order. (Talk transcript.)

> Now when you're doing this top down data loading you have all or nothing data fetching for your page. Either you have all of your data or you have none of it.

> We instantly see the UI, the data that's slow gets to stream in out of order, and it gets to be co-located with the component.

## Put the Suspense boundary above the async component

Streaming works only when the boundary wraps the component that awaits data, not the component itself.

> The Suspense boundary needs to be placed higher than the async component doing the data fetching.

## The App Router's stated goals

From the Next.js 13 announcement, which Robinson co-authored with the Next.js team (multi-author byline, not attributable to him alone), the framing the App Router was built around:

> Server Components: Making server-first the default for the most dynamic applications.

> The ability to colocate data fetching inside components and ship less JavaScript to the client were two important pieces of community feedback we are excited to include with the `app/` directory.
