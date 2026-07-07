# Source material: Dominik Dorfmeister (TkDodo) on React

From the blog posts "Practical React Query," "Thinking in React Query," "React Query as a State Manager," "Don't over useState," "Putting props to useState," "Things to know about useState," and "The Uphill Battle of Memoization," all published on tkdodo.eu/blog. Quotes are verbatim.

## Server state is borrowed, not owned

Data fetched from a server isn't state the frontend owns; it's a snapshot of someone else's data.

> Because React Query manages async state (or, in terms of data fetching: server state), it assumes that the frontend application doesn't "own" the data.

> "server state", we only see a snapshot in time of when we fetched it. It can get out of date, because we are not the only owner of that state. The backend, probably our database owns it. We have just borrowed it to display that snapshot.

Which is why it's framed as a state manager, not a fetching library; once that's the frame, questions like "how do I set a `baseURL`" dissolve:

> React Query is an async state manager. It can manage any form of asynchronous state - it is happy as long as it gets a Promise.

> React Query doesn't care! Just somehow return a Promise, please.

## Erring toward freshness over minimizing requests

Because the frontend doesn't own the data, defaults favor updating too often over too rarely, and `staleTime` (not `gcTime`) is the knob that matters day to day.

> React Query provides the means to synchronize our view with the actual data owner - the backend. And by doing so, it errs on the side of updating often rather than not updating often enough.

> Yep, zero as in zero milliseconds, so React Query marks everything as stale instantly. That's certainly aggressive... but instead of erroring on the side of minimizing network requests, React Query errors on the side of keeping things up-to-date.

> Most of the time, if you want to change one of these settings, it's the `staleTime` that needs adjusting. I have rarely ever needed to tamper with the `gcTime`.

## Query keys as dependency array, and not syncing state elsewhere

Parameters used inside `queryFn` belong in the query key, the same discipline `useEffect` applies to its dependency array; this is what caches entries separately and drives automatic refetches.

> We should treat parameters as dependencies... put them into the `queryKey`. This ensures... entries are cached separately depending on their input... It also enables automatic refetches when [the key changes].

Copying query data into local or other-state-manager state opts you out of that machinery entirely:

> If you get data from `useQuery`, try not to put that data into local state... you implicitly opt out of all background updates that React Query does for you, because the state "copy" will not update with it.

> All of these are forms of state syncing that take away the single source of truth, and are unnecessary because React Query is already a state manager, so we don't need to put that state into another one.

## What actually counts as state

Most of the "over-useState" problem is derived values masquerading as state.

> Is it passed in from a parent via props? If so, it probably isn't state. Does it remain unchanged over time? If so, it probably isn't state. Can you compute it based on any other state or props in your component? If so, it isn't state.

> a value that can be computed from a state value is _not_ its own state.

## useEffect syncs with the outside world, not with other state

`useEffect` exists to synchronize React with something external (the DOM, a subscription, a server), not to keep one piece of React state in lockstep with another.

> It should be used to sync your state _with something outside of React_. Utilizing useEffect to sync _two react states_ is rarely right.

> Whenever a state setter function is only used synchronously in an effect, get rid of the state!

## Props into useState only take effect on mount

Seeding `useState` with a prop value is a trap: the initial value is read once, at mount, and every later prop change is silently ignored.

> The initial value of a useState hook is always _discarded_ on re-renders - it only has an effect when the component _mounts_.

The fix is either to force a remount with an explicit `key`, or to remove the local state and let the parent own it fully:

> you can also just put a key attribute on any component to tell React: "Please mount this whenever the key changes."

> take the draft state and move it further up the tree, thus making our DetailView a fully controlled component

## Lesser-known useState mechanics

Lazy initialization defers an expensive computation by passing a function instead of a value, invoked only on mount:

> React will only invoke this function when it really needs the result (= when the component mounts)

The functional updater reads the previous value instead of closing over a stale one, and React bails out of re-rendering entirely when a new value equals the old one:

> Instead of passing a new value to the setter that we get from useState, we can also pass a function to it... React will call that function and gives us the previousValue, so that we can calculate a new result depending on it.

> React will not always re-render your component. It will bail out of rendering if you try to update to the same value that your state is currently holding... React uses Object.is to determine if the values are different.

## Memoization is an uphill battle

`memo` compares each prop with `Object.is`, brittle against any prop that isn't a primitive. A single inline object, array, or function prop silently defeats it, and the break is invisible to whoever adds that prop later.

> When a component is memoized, React will compare each prop with Object.is. If they haven't changed, re-rending can be skipped.

> we've inadvertently ruined the memoization, because the `style` prop will be a new object on every render.

> This is usually how components evolve over time - props get added... consumers of the `ExpensiveTree` component don't necessarily know that it is memoized... we're fighting an uphill battle that's hardly winnable.

> Memoizing in general makes our code harder to read, and it's easy to get wrong, which makes it the worst option for me.
