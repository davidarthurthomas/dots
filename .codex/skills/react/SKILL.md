---
name: react
description: >
  Write and review React code: components, hooks, state, effects, data fetching, re-renders,
  component APIs. Use when writing or refactoring components or hooks, deciding where state lives,
  adding a useEffect, fetching or caching server data, chasing re-render or performance problems,
  designing a component's props, or reviewing React in a diff. Triggers on "component", "hook",
  "useEffect", "re-render", "state management", "React".
global_category: Engineering
---

# React

React principles, grounded in the modern canon:

- [Kent C. Dodds, essays on colocation, composition, and testing](references/sources/dodds.md)
- [Ryan Florence, Remix and React Router philosophy](references/sources/florence.md)
- [Dan Abramov, overreacted.io essays](references/sources/abramov.md)
- [The react.dev Learn docs](references/sources/react-dev.md)
- [Dominik Dorfmeister (TkDodo), tkdodo.eu essays](references/sources/tkdodo.md)
- [Tanner Linsley, TanStack Query docs and _It's Time to Break Up with Global State_](references/sources/linsley.md)
- [Mark Erikson, _A (Mostly) Complete Guide to React Rendering Behavior_](references/sources/erikson.md)
- [Nadia Makarevich, developerway.com re-render guides](references/sources/makarevich.md)
- [Josh Comeau, _Why React Re-Renders_](references/sources/comeau.md)

For test discipline in general, see the `testing` skill; for names, the `naming` skill.

## Thinking in components

**Render is a pure calculation.** A component takes props and state and returns JSX, and nothing else: "Components should only return their JSX, and not change any objects or variables that existed before rendering." Same inputs, same output; mutating is fine only for objects created during this render. A component must also survive rendering at any frequency — StrictMode calls it twice precisely to catch violations — and Abramov's bar is strict: "If removing an optimization breaks a component, it was too fragile to begin with."

**Build the static version first.** Render the full UI from a hard-coded data model before adding any state: "Building a static version requires a lot of typing and no thinking, but adding interactivity requires a lot of thinking and not a lot of typing." Getting the component tree and one-way data flow right first means the later question is only where state lives, not what the components are.

**Split a component when it hurts, not before.** A long component is not itself a problem; split when you hit a real cost — local state re-rendering unrelated UI, a block needed elsewhere, JSX whose state and handlers can't be told apart, untestability. Dodds' rule is to wait for the problem, "NOT BEFORE," and his justification is Sandi Metz's: "Duplication is far cheaper than the wrong abstraction."

**Never define a component inside another component.** A function defined during render is a new type identity every render, so React remounts the subtree instead of updating it, destroying its state and DOM. Makarevich calls it "an anti-pattern that can be the biggest performance killer."

**Colocate.** "Place code as close to where it's relevant as possible": state in the component that uses it, styles next to the markup, tests next to the code, a single-caller helper next to its caller. Distance is what lets related things drift apart.

## State

**Find state by elimination.** "Does it **remain unchanged** over time? If so, it isn't state. Is it **passed in from a parent** via props? If so, it isn't state. **Can you compute it** based on existing state or props in your component? If so, it *definitely* isn't state!" State is the minimal set of changing data; everything else is computed during render.

**Derive, don't sync.** A value computable from existing props or state is a plain expression in the render body, never a second `useState` kept in step by an effect. TkDodo's test catches the disease at the setter: "Whenever a state setter function is only used synchronously in an effect, get rid of the state!"

**Make contradictions impossible.** Booleans that can be simultaneously true when they logically can't be — `isSending` and `isSent` — leave "room for mistakes"; replace them with one `status` variable whose values are exactly the valid states. Store the `selectedId`, not a `selectedItem` copy that can drift from the list it came from.

**Colocate state; lift only when two components need it.** "Keep state as close to where it's needed as possible." When siblings must change together, move the state to their closest common parent — for each piece of state exactly one component owns it, a "single source of truth". Abramov's test for what stays local: "If this component was rendered twice, should this interaction reflect in the other copy? Whenever the answer is 'no', you found some local state."

**Prop drilling is explicit, not a smell.** Passing a value down through a few layers lets a reader trace its origin statically — an improvement over anything implicit. When drilling gets genuinely painful, reach for composition (pass rendered elements down) before Context, and keep any provider near its consumers.

**Don't copy props into state.** "By copying a prop into state you're ignoring all updates to it" — the `useState` initializer is read once, at mount, and every later prop change is silently dropped. To reset on a change, give the component a `key`; to keep it live, drop the local state and let the parent own it.

**Replace, never mutate.** "React relies on a state variable's identity to tell when the state has changed" — pushing into an array or assigning into an object leaves the reference unchanged and the update invisible. Setters hand React a new value, and they schedule a render rather than reassigning a variable.

## Server state and the URL

**Server state is borrowed, not owned.** Fetched data "can be changed by other people without your knowledge" and goes stale from the moment it arrives: "we have just borrowed it to display that snapshot." It belongs in a cache that assumes staleness and revalidates — not in `useState`, not in a store. Treat every parameter the fetch reads as part of its cache key, the same discipline as an effect's dependency array, and err toward refetching too often rather than trusting a stale copy.

**Most "global state" is a mislabeled server cache.** Linsley: "We've tricked ourselves and our code into thinking that all state is created equal." Reaching for a global store because fetched data needs sharing solves the sharing and ignores the staleness. Once server data lives in a cache, "the truly globally accessible client state that is left over ... is usually very tiny" — theme, sidebar, preferences, not domain data.

**Never copy server data into another container.** Putting query results into local or store state means "you implicitly opt out of all background updates ... because the state 'copy' will not update with it." One source of truth: read from the cache everywhere.

**Shareable state lives in the URL.** If a value should survive a refresh or a shared link — the selected tab, the filter, the open record — it belongs in the URL, not a state variable synced to it. The router is a state manager whose store is the address bar.

**Mutate through actions, then revalidate.** Model a write the way a form models it — submit, change data, maybe redirect — and let completion trigger revalidation of what the page reads: "When the action completes, all loader data on the page is revalidated to keep your UI in sync with the data without writing any code to do it." Hand-wired invalidation after each write is the code smell this replaces.

**Fetch at route boundaries, not in components.** A component can't know what to fetch until it renders, so component fetching waterfalls by construction: "fetching in components is the quickest way to the slowest UX." Decouple initiating fetches from reading results, and initiate where the URL is already known.

## Effects

**An effect synchronizes with an external system; anything else isn't an effect.** "Effects are an escape hatch from the React paradigm" for the DOM, the network, a subscription, a non-React widget. "If your Effect only adjusts some state based on other state, you might not need an Effect" — deriving in an effect buys an extra render pass and a window where the UI shows the stale value.

**Ask why the code runs, not when.** Code that runs because the user did something belongs in that event handler, which knows exactly what happened; an effect only knows the component was displayed. "Use Effects only for code that should run *because* the component was displayed to the user."

**Never lie to the dependency array.** Each render's effect is closed over that render's own props and state — "all values from inside your component that are used by the effect *must* be there." The array is a truthful declaration of what the effect reads, not a dial for tuning when it fires; omitting a value to skip runs trades an honest bug for a stale one.

## Rendering and performance

**Every re-render starts at a state change and sweeps downward.** "Every re-render in React starts with a state change. It's the only 'trigger'" — and once a component renders, "React will recursively render all child components inside of it," props or no props. Changing props can't cause a re-render the parent didn't already cause; props only start to matter once memoization is in play.

**Composition is the built-in optimization.** Move state down into the smallest component that needs it, and lift expensive content up past the state as `children`: an element created outside the re-rendering component is the same reference as last time, so React skips its subtree. These are structural fixes — they also flatten prop plumbing — and they come before any `memo`.

**Memoization comes last, and it's fragile.** `React.memo` shallow-compares props with `Object.is`, so a single inline object, array, or function silently defeats it: "All props that are not primitive values have to be memoized for React.memo to work," and `useCallback` on its own "doesn't work." Whoever adds a prop later won't know the component was memoized, which is why TkDodo calls it "an uphill battle that's hardly winnable." Restructure first, then profile, and only then, in Abramov's words, "sprinkle those memo's."

**A context change re-renders every consumer.** "Every nested component that consumes that context will be forced to re-render," with no way to subscribe to part of the value. Memoize the provider's value if it isn't a primitive, keep providers narrow, and split contexts that change at different rates.

## Component APIs

**Compound components over configuration props.** When a parent and its children form one widget, share state implicitly the way `<select>` shares with `<option>` rather than threading a growing bag of props: "The compound components API gives you a nice way to express relationships between components."

**Invert control instead of adding flags.** When an abstraction keeps sprouting options for cases its author didn't anticipate, "make your abstraction do less stuff, and make your users do that instead": take a predicate instead of `filterNull`/`filterZero` flags, a render function instead of display options, a reducer instead of behavior switches. Wait for the second real use case before building any of it.

**Decide what's controlled.** Local state makes a component easy to drop in; props make it coordinable from outside. "When writing a component, consider which information in it should be controlled (via props), and which information should be uncontrolled (via state)" — the choice is per piece of information, made deliberately, not inherited from whichever mode the first draft happened to use.

## Testing React

**Test what a user can observe.** "The more your tests resemble the way your software is used, the more confidence they can give you." Query the DOM the way a user finds things and drive components through their props and events, never through internals — a test coupled to implementation details fails on refactors that change nothing and passes while real behavior breaks. Weight the suite toward integration tests over isolated units, and skip the mocking that hides exactly the component interactions integration exists to check. The general discipline lives in the `testing` skill.
