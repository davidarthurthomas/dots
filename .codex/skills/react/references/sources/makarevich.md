# Source material: Nadia Makarevich on React re-renders

From "React re-renders guide: everything, all at once" (its "why components re-render" and "preventing unnecessary re-renders" installments), "The mystery of React Element, children, parents and re-renders," and "How to write performant React code: rules, patterns, do's and don'ts," all published on developerway.com. Quotes are verbatim.

## What actually triggers a re-render

Four reasons cover every re-render: state, parent, context, hooks.

> When a component's state changes, it will re-render itself.

> A component will re-render itself if its parent re-renders.

> When the value in Context Provider changes, **all** components that use this Context will re-render.

> state change inside the hook will trigger an **unpreventable** re-rerender of the "host" component

## The props myth

Props changing is not itself a trigger; it only matters once memoization is in play.

> It doesn't matter whether the component's props change or not when talking about re-renders of not memoized components.

> In order for props to change, they need to be updated by the parent component. This means the parent would have to re-render, which will trigger re-render of the child component regardless of its props.

> Only when memoization techniques are used (`React.memo`, `useMemo`), then props change becomes important.

## React Elements are objects, not renders

Confusion about why `children` or other component props don't re-render dissolves once you see JSX as producing a plain description object, not performing a render.

> This is nothing more than syntax sugar again for a function React.createElement that returns an object.

> this object is just a description of the things you want to see on the screen when this element actually ends up in the render tree. Not sooner.

The element for `children` (or any component passed as a prop) is created wherever that JSX is written, not by the component re-rendering in between.

> "children" is a `<ChildComponent />` element that is created in `SomeOutsideComponent`. When `MovingComponent` re-renders because of its state change, its props stay the same. Therefore any `Element` (i.e. definition object) that comes from props won't be re-created, and therefore re-renders of those components won't happen.

> Only when I actually include it in the return result ... and only after `Parent` component renders itself, will the actual render of `Child` component be triggered.

## Composition as the built-in optimization: moving state down

Isolating state to the smallest component that needs it keeps the rest of the tree from re-rendering on its account.

> This pattern can be beneficial when a heavy component manages state, and this state is only used on a small isolated portion of the render tree.

## Composition as the built-in optimization: children as props

Passing an already-created element as `children` shields it from a parent's state churn, for the same reason as the Element mystery above.

> This pattern is similar to "moving state down": it encapsulates state changes in a smaller component.

> state management and components that use that state can be extracted into a smaller component, and the slow component can be passed to it as `children`.

> From the smaller component perspective `children` are just prop, so they will not be affected by the state change and therefore won't re-render.

## React.memo mechanics

`React.memo` only blocks the downstream cascade, and only if every non-primitive prop is memoized too.

> Wrapping a component in `React.memo` will stop the downstream chain of re-renders that is triggered somewhere up the render tree, unless this component's props have changed.

> All props that are not primitive values have to be memoized for React.memo to work.

## Rules for performant code

Numbered rules from "How to write performant React code":

> Rule #1. If the only reason you want to extract your inline functions in props into useCallback is to avoid re-renders of children components: don't. It doesn't work.

> Rule #2. If your component manages state, find parts of the render tree that don't depend on the changed state and memoise them to minimize their re-renders.

> Rule #3. Never create new components inside the render function of another component.

> Rule #4: When using context, make sure that value property is always memoised if it's not a number, string or boolean.

Creating components inline is singled out as especially costly:

> Creating components inside render function of another component is an anti-pattern that can be the biggest performance killer.
