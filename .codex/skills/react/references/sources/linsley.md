# Source material: Tanner Linsley on server state

From the TanStack Query docs — the "Overview" (Motivation), "Does TanStack Query replace client state managers?", and "Important Defaults" pages — and the React Summit talk "It's Time to Break Up with Global State." Doc quotes are verbatim. No transcript of the talk was found; its quotes below are drawn from a fetched third-party summary that presented them as direct excerpts, so treat them as close paraphrase rather than a certified verbatim record.

## Server state is not client state

The docs open by naming the gap: general-purpose state managers were built for state a component fully owns, and that's not what most app state actually is.

> Most core web frameworks do not come with an opinionated way of fetching or updating data in a holistic way.

> While most traditional state management libraries are great for working with client state, they are not so great at working with async or server state.

TanStack Query exists specifically to fill that gap:

> [TanStack Query] makes fetching, caching, synchronizing and updating server state in your web applications a breeze.

The docs define server state by four properties that client state doesn't share:

- **Remotely owned.** "Is persisted remotely in a location you may not control or own"
- **Asynchronous by nature.** "Requires asynchronous APIs for fetching and updating"
- **Shared.** "Implies shared ownership and can be changed by other people without your knowledge"
- **Perishable.** "Can potentially become 'out of date' in your applications if you're not careful"

In the talk, Linsley draws the same line more bluntly, contrasting the two categories directly rather than listing properties of one:

> Client state is relatively simple...It's temporary and local, and it's generally not persisted between sessions.

> Server state, however, is pretty different. Server state is persisted remotely, so the location source of truth for our server state is potentially unknown.

## Most "global state" is server state in disguise

Linsley's argument in the talk is that reaching for a global store the moment data needs to be shared across components is a category error — the data isn't state you own, it's a cache of something else's data, and calling it "global state" hides that.

> I think we've made a really big mistake by placing it there. We've tricked ourselves and our code into thinking that all state is created equal.

He grants why the mistake is tempting — global stores solve a real, immediate pain:

> Global state is super convenient. It helps us avoid prop drilling, and it lets us access data across our application without copying or duplicating it.

But convenience for sharing isn't the same as correctness for managing something asynchronous, remotely owned, and subject to going stale behind your back. The docs make the same distinction as a matter of tooling, not just terminology: general client-state libraries can technically hold server data, but at a cost.

> Redux, MobX, Zustand, etc. are client-state libraries that can be used to store asynchronous data, albeit inefficiently when compared to a tool like TanStack Query.

## What's actually left as client state

Once server data moves into a query cache, the docs describe what typically remains in a global client store as small enough to barely need one:

> the truly globally accessible client state that is left over...is usually very tiny

The docs' own example of what's left is UI preference state — `themeMode`, `sidebarStatus` — not domain data. This isn't an argument to delete client-state libraries; it's an argument that their job shrinks once server data has somewhere better to live:

> TanStack Query is not a replacement for local/client state management

> you can use TanStack Query alongside most client state managers with zero issues

## Defaults exist because server state goes stale

Because server state can change out from under the client at any time, TanStack Query treats freshness, not request-minimization, as the thing to default toward. The moment a query resolves, its data is already considered stale unless told otherwise:

> Query instances via `useQuery` or `useInfiniteQuery` by default consider cached data as stale.

Staleness triggers automatic background refetches at the points a user is most likely to be looking at outdated data:

> Stale queries are refetched automatically in the background when: The window is refocused

Data that's no longer in use doesn't linger indefinitely either — it's garbage collected on a timer rather than kept forever on the assumption it might still be right:

> By default, 'inactive' queries are garbage collected after 5 minutes.

The docs call this combination "aggressive but sane" — a direct expression of Linsley's premise that server state's defining risk is going quietly out of date, so the defaults should err toward rechecking rather than trusting a stale cache.

## The tool follows from the category, not the reverse

In the talk, Linsley frames the library itself as scoped narrowly on purpose — solving asynchronous server state, and nothing more general:

> React Query is an NPM library comprised of a couple hooks and utilities that aim to solve asynchronous server state. It's a small API, it's simple, and it's designed to help both novice and advanced React developers.

> React query automatically handles caching and background refetching right out of the box. And when things are cached, they can be rendered immediately next time.

The closing claim is about how this reframes state management generally, not just data fetching:

> I believe that tools like React Query are the future for handling our asynchronous data...it also helps us model and think about our global state with a new perspective.
