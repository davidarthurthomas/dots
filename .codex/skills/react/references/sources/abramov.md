# Source material: Dan Abramov on React

From the essays "A Complete Guide to useEffect," "Writing Resilient Components" (with Brian Vaughn), "Before You memo()," and "React as a UI Runtime," all published on overreacted.io. Quotes are verbatim.

## Effects belong to the render that created them

Each render has its own props, state, and event handlers, and its own effect, closed over that render's values. Nothing is watching or mutating a shared variable across renders.

> In this example, `count` is just a number. It's not a magic "data binding", a "watcher", a "proxy", or anything else.

> Inside any particular render, props and state forever stay the same.

> Each version "sees" the `count` value from the render that it "belongs" to

> It's not the `count` variable that somehow changes inside an "unchanging" effect. It's the *effect function itself* that's different on every render.

The dependency array is not a knob for tuning when an effect fires; it's a truthful declaration of what the effect reads.

> **_all_ values from inside your component that are used by the effect _must_ be there**

## Synchronization, not lifecycle

`useEffect` doesn't map to `componentDidMount`/`componentDidUpdate`. Thinking in lifecycle names pulls you back toward the class model that hooks replaced.

> **`useEffect` lets you _synchronize_ things outside of the React tree according to our props and state.**

> It's all about the destination, not the journey.

> Side effects become a part of the React data flow.

Functions are not exempt from this. Wrapped correctly (`useCallback`), they participate in the same data flow as any other value an effect depends on.

> **With `useCallback`, functions can fully participate in the data flow.**

## Resilient components: don't stop the data flow

Copying a prop into state freezes a snapshot and silently drops future updates.

> By copying a prop into state you're ignoring all updates to it.

> Props and state are a part of the React data flow. Both rendering and side effects should reflect changes in that data flow, not ignore them!

> Don't stop the data flow! Whenever you use props and state, consider what should happen if they change.

## Resilient components: always be ready to render

A component that only works because it renders a particular number of times, in a particular order, relative to its parent, is fragile by construction.

> Your component should be ready to re-render at any time.

> Components should be resilient to rendering less or more often because otherwise they're too coupled to their particular parents.

> If removing an optimization breaks a component, it was too fragile to begin with.

## Resilient components: no singletons, isolate local state

> Showing or hiding a tree shouldn't break components outside of that tree.

A rendering-twice thought experiment surfaces state that's accidentally global:

> If this component was rendered twice, should this interaction reflect in the other copy? Whenever the answer is "no", you found some local state.

> Avoid making truly local state global. There's fewer surprising synchronization happening between components.

> These principles help you write components that are optimized for change.

## Memoization comes last

Before reaching for `memo`/`useMemo`, restructure the tree so the parts that change are separated from the parts that don't: move state down, and lift content up as `children`.

> Before you apply optimizations like `memo` or `useMemo`, it might make sense to look if you can split the parts that change from the parts that don't change.

Passing JSX as `children` means a parent re-render doesn't force the subtree to re-render, because the element reference is unchanged:

> When the `color` changes, `ColorPicker` re-renders. But it still has the same `children` prop it got from the `App` last time, so React doesn't visit that subtree.

These aren't just performance tricks:

> Using the `children` prop to split up components usually makes the data flow of your application easier to follow and reduces the number of props plumbed down through the tree.

Structural fixes come first; measurement decides what's left.

> These techniques are complementary to what you already know! They don't replace `memo` or `useMemo`, but they're often good to try first.

> Then, where it's not enough, use the Profiler and sprinkle those memo's.

## React's model: elements, components, and the host tree

An element is inert data describing what should be on screen; it has no identity of its own.

> A React element is a plain JavaScript object. It can *describe* a host instance.

> React elements don't have their own persistent identity. They're meant to be re-created and thrown away all the time.

React's job is to reconcile that description against the real ("host") tree, reusing instances when the element type at a given position matches between renders.

> React's job is to *make the host tree match the provided React element tree*.

> If an element type in the same place in the tree "matches up" between renders, React reuses the host instance.

Render must be pure with respect to props, but React leans on a weaker guarantee than mathematical purity: calling a component function twice for the same input must be safe.

> React components are assumed to be pure with respect to their props.

> *Idempotence* is more important to React than purity.

Local state is a feature of the position in the tree, not of the component definition, which is why hooks must be called unconditionally in the same order.

> Local state tied to the position in the tree is one of these features.

> React state is local to the *component* and its identity in the tree.
