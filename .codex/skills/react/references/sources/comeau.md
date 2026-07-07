# Source material: Josh Comeau on React

From "Why React Re-Renders" and "Common Beginner Mistakes with React," both published on joshwcomeau.com. Quotes are verbatim.

## State is the only trigger

Every re-render traces back to a state change; there's no other entry point.

> Every re-render in React starts with a state change. It's the only "trigger" in React for a component to re-render.

## It's not about the props

A re-rendering component sweeps its whole subtree along with it, whether or not a given descendant's props reference the changed state.

> When a component re-renders, it tries to re-render all descendants, regardless of whether they're being passed a particular state variable through props or not.

React is deliberately biased toward re-rendering too much rather than too little, because staying in sync with state is the priority.

> React's #1 goal is to make sure that the UI that the user sees is kept "in sync" with the application state. And so, React will err on the side of too many renders.

## Render as a snapshot

Each render is a self-contained picture of what the UI should look like for that state, not a mutation of the previous one.

> Each render is a snapshot, like a photo taken by a camera, that shows what the UI should look like, based on the current application state.

> React's "main job" is to keep the application UI in sync with the React state. The point of a re-render is to figure out what needs to change.

## Diagnosing re-renders

The Profiler tab in devtools answers "why did this render" directly, instead of guessing from the code.

> By clicking through to the component you're interested in, you can see exactly why a particular component re-rendered.

## State identity, not content, is what React checks

React compares a state variable's own identity between renders, so mutating in place produces no change React can detect.

> React relies on a state variable's identity to tell when the state has changed. When we push an item into an array, we aren't changing that array's identity, and so React can't tell that the value has changed.

The fix is to hand React a new value rather than change the old one:

> Instead of modifying an existing array, I'm creating a new one from scratch.

## Keys and reconciliation

A `key` is how React tells one list item from another across renders; generating it from render-time data undermines the point.

> Whenever we render an array of elements, we need to provide a bit of extra context to React, so that it can identify each item.

> Generating it in the JSX like this will cause the key to change on every render. Whenever the key changes, React will destroy and re-create these elements.

## State updates are scheduled, not synchronous

Calling a setter doesn't mutate a variable in place; it queues an update for a future render, so reading the "same" variable right after won't reflect it yet.

> When we call `setCount`, we aren't re-assigning a variable. We're scheduling an update.
