# Source material: Mark Erikson on React rendering

From "A (Mostly) Complete Guide to React Rendering Behavior," published on blog.isquaredsoftware.com. Quotes are verbatim.

## What rendering means

Rendering is not the same as producing visible output — it's the process of asking components what they want the UI to look like right now.

> Rendering is the process of React asking your components to describe what they want their section of the UI to look like, now, based on the current combination of props and state.

## Render phase versus commit phase

React splits its work into calculating what changed, then applying it.

> The "Render phase" contains all the work of rendering components and calculating changes

> The "Commit phase" is the process of applying those changes to the DOM

A component can render without anything visible happening as a result — rendering and updating the DOM are different events.

> rendering is not the same thing as updating the DOM, and a component may be rendered without any visible changes happening as a result.

## Default render behavior: children render unconditionally

React's default behavior renders every descendant of a rendered component, whether or not that descendant's props changed.

> React's default behavior is that when a parent component renders, React will recursively render all child components inside of it!

> In normal rendering, React does not care whether "props changed" - it will render child components unconditionally just because the parent rendered!

## What triggers a re-render

After the first render, only a small, fixed set of actions queues another one.

> After the initial render has completed, there are a few different ways to tell React to queue a re-render: Function components: `useState` setters, `useReducer` dispatches; Class components: `this.setState()`, `this.forceUpdate()`; Other: Calling ReactDOM top-level `render(<App>)` method again

## Optimizing with React.memo

`React.memo()` is the built-in escape hatch from the default "render everything" behavior.

> The primary method is `React.memo()`, a built-in "higher order component"

> The wrapper component's default behavior is to check to see if any of the props have changed, and if not, prevent a re-render.

That comparison is deliberately cheap, not deep.

> All of these approaches use a comparison technique called "shallow equality".

## Context forces every consumer to re-render

A changed context value re-renders every consumer beneath the provider, with no way to subscribe to only part of it.

> React checks to see if a context provider has been given a new value when the surrounding component renders the provider. If the provider's value is a new reference, then React knows the value has changed, and that the components consuming that context need to be updated.

> When a context provider has a new value, every nested component that consumes that context will be forced to re-render

> there is no way for a component that consumes a context to skip updates caused by new context values, even if it only cares about part of a new value.

## Batching

Multiple state updates queued in the same tick collapse into a single render pass.

> Render batching is when multiple calls to setState() result in a single render pass being queued and executed, usually on a slight delay

## Reconciliation

The diffing step that decides what the commit phase needs to apply has its own name.

> The diffing and calculation process is known as "reconciliation".

> React then applies all the calculated changes to the DOM in one synchronous sequence.

## State is a snapshot, closed over per render

Event handlers only see the values that existed when they were defined — state variables aren't live references, they're frozen per render.

> The `handleClick` function is a "closure" - it can only see the values of variables as they existed when the function was defined

> these state variables are a snapshot in time
