# Source material: Kent C. Dodds on React

From "Application State Management with React," "State Colocation will make your React app faster," "Colocation," "Prop Drilling," "When to break up a component into multiple components," "Compound Components with React Hooks," "Inversion of Control," "Testing Implementation Details," "Write tests. Not too many. Mostly integration," and the Testing Library "Guiding Principles." Quotes are verbatim.

## Colocation

The general rule underneath everything else Dodds writes about structuring a codebase:

> Place code as close to where it's relevant as possible

He credits the sharper version to Dan Abramov:

> Things that change together should be located as close as reasonable.

Colocation isn't only about state — it applies to comments next to the code they explain, styles next to the markup they style, tests next to the code they exercise, and utility functions next to their one caller. Keeping related things adjacent means they're less likely to go stale, more visible when something nearby changes, and cheaper to work with because there's no context-switching to find the rest of the picture.

## State colocation

Applied to React state specifically (*State Colocation will make your React app faster*, *Application State Management with React*):

> Keep state as close to where it's needed as possible.

Not everything belongs in one big state object or one global store — state should live at the level of the component that actually needs it, not be hoisted preemptively. When state that changes often is lifted too high, every update forces React to check every component below it, and the usual fixes — `React.memo`, manual debouncing — add complexity without addressing the real cause. Moving fast-changing state back down to the component that owns it means React only has to reconcile a smaller subtree; the article's `dog`/`DogName` example shows an unrelated `SlowComponent` no longer re-rendering once the state moves down.

This produces a simple decision order: use `useState` for state only one component needs; lift it to the closest shared parent when siblings need it; reach for Context only to avoid drilling it through many layers, and still keep the provider near where it's used. Global stores like Redux are for state that is genuinely global — server data is its own category and belongs in a cache (react-query), not in application state, since it's "state that's actually stored on the server and we store in the client for quick-access."

## Lifting state and prop drilling

Prop drilling is passing a value through components that don't use it themselves so a descendant can. Dodds' central claim is that this is not automatically a problem:

> Prop drilling at its most basic level is simply explicitly passing values throughout the view of your application.

The explicitness is the point: a reader can trace a value's origin statically, without running the code — a real improvement over implicit global variables or scope inheritance that hides where data comes from. The fix for painful prop drilling is usually component composition (passing already-rendered children or elements as props) before reaching for Context, and Context itself should be introduced to avoid deep threading, not to avoid drilling per se — it trades one kind of indirection for another and should still be colocated near where it's consumed.

On not restructuring components just to dodge a prop:

> There's no reason to break things out prematurely. Wait until you really need to reuse a block before breaking it out.

## Breaking up components

From *When to break up a component into multiple components*: split a component when you hit a concrete problem, not in anticipation of one.

> When you experience one of the problems above, that's when you break your component into multiple smaller components. NOT BEFORE.

The problems worth watching for: the whole app re-renders on a state change that should be local; a chunk of markup and logic needs reuse elsewhere; it's hard to tell which state and handlers belong to which JSX; the component is only testable in large, slow integration tests; the file causes constant merge conflicts; a third-party library or HOC can't compose with it; or imperative APIs (refs, lifecycle escape hatches) are tangled through it. None of these is inherent to a large component — they're the actual costs a split should be paying down. Splitting is itself an abstraction, and Dodds invokes Sandi Metz's line to justify waiting:

> Duplication is far cheaper than the wrong abstraction.

## Compound components and inversion of control

*Compound Components with React Hooks* names the pattern: components that "work together to accomplish a useful task," modeled on `<select>` and `<option>` — a parent holds shared state and children read it implicitly instead of the parent passing every value down as a prop.

> The `<select>` element implicitly stores state about the selected option and shares that with its children.

> The compound components API gives you a nice way to express relationships between components.

*Inversion of Control* generalizes why this pattern (and the state reducer pattern) works: a reusable abstraction stays maintainable by doing less itself and handing decisions back to the caller.

> Make your abstraction do less stuff, and make your users do that instead.

Dodds' worked example is a `filter` function: rather than growing flags (`filterNull`, `filterUndefined`, `filterZero`, ...) to cover every case an author anticipates, invert control and take a predicate — `filter(array, (el) => el !== null && el !== undefined)` — so the caller decides. Compound components apply the same move to rendering (the parent no longer decides what to render, only what state to share) and the state reducer pattern applies it to state transitions (the caller can intercept and modify a change before it's applied). He pairs this with a caution against reaching for it before a second use case exists — the same premature-abstraction warning as breaking up components.

## Testing behavior, not implementation

*Testing Implementation Details* defines the target to avoid:

> Implementation details are things which users of your code will not typically use, see, or even know about.

Tests that reach into implementation details fail in both directions: they go red on a refactor that changed nothing a user could observe (false negative for confidence), and they can stay green while real user-facing behavior is broken (false positive). The fix is to treat the test as a stand-in for an actual user of the code — an end user interacting with rendered output, or a developer using a component's props — never as a user of internal state or private methods. The same sentence anchors both this post and the Testing Library docs:

> The more your tests resemble the way your software is used, the more confidence they can give you.

Testing Library's *Guiding Principles* build the library around that sentence directly: tests should find and interact with DOM nodes the way a user would rather than reach into component instances, and the API stays deliberately simple so it doesn't invite implementation-detail testing.

*Write tests. Not too many. Mostly integration.* (crediting Guillermo Rauch for the line) sets the shape of a whole suite, not just one test. Write tests because they catch bugs locally and buy confidence that TypeScript and lint can't; don't chase 100% coverage, since value drops off past roughly 70% and the rest is often implementation detail that breaks on refactors; and weight the suite toward integration tests — the Testing Trophy over the traditional pyramid — because they buy the most confidence per unit of speed and maintenance cost. The practical corollary is to stop over-mocking: shallow rendering and heavy mocking hide exactly the component interactions integration tests exist to check.
