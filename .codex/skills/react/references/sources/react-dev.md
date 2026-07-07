# Source material: The react.dev docs

From the Learn section pages "Thinking in React," "You Might Not Need an Effect," "Keeping Components Pure," "Choosing the State Structure," "Sharing State Between Components," and "Synchronizing with Effects." Quotes are verbatim.

## Thinking in React: five steps

Components come from the UI, and state has to be found before it can be placed.

> When you build a user interface with React, you will first break it apart into pieces called *components*.

> If your JSON is well-structured, you'll often find that it naturally maps to the component structure of your UI.

Build the non-interactive render before wiring up any state:

> The most straightforward approach is to build a version that renders the UI from your data model without adding any interactivity... yet!

> Building a static version requires a lot of typing and no thinking, but adding interactivity requires a lot of thinking and not a lot of typing.

State is defined by what it excludes, not what it includes — three questions filter a candidate value out of state entirely:

> Think of state as the minimal set of changing data that your app needs to remember.

> The most important principle for structuring state is to keep it DRY (Don't Repeat Yourself).

> Figure out the absolute minimal representation of the state your application needs and compute everything else on-demand.

> Does it **remain unchanged** over time? If so, it isn't state. Is it **passed in from a parent** via props? If so, it isn't state. **Can you compute it** based on existing state or props in your component? If so, it *definitely* isn't state!

Once state is minimal, its home follows the one-way data flow down to the closest shared ancestor:

> Remember: React uses one-way data flow, passing data down the component hierarchy from parent to child component.

> Find their closest common parent component — a component above them all in the hierarchy.

## Effects are an escape hatch, not a reaction primitive

The framing that governs everything else: an Effect is for stepping outside React to touch something React doesn't own.

> Effects are an escape hatch from the React paradigm. They let you "step outside" of React and synchronize your components with some external system like a non-React widget, network, or the browser DOM.

> *Effects* let you specify side effects that are caused by rendering itself, rather than by a particular event.

> Effects run at the end of a commit after the screen updates. This is a good time to synchronize the React components with some external system (like network or a third-party library).

> Don't rush to add Effects to your components. Keep in mind that Effects are typically used to "step out" of your React code and synchronize with some *external* system.

> This includes browser APIs, third-party widgets, network, and so on. If your Effect only adjusts some state based on other state, you might not need an Effect.

Rendering itself must stay pure — an Effect exists precisely because DOM mutation can't happen during render:

> The reason this code isn't correct is that it tries to do something with the DOM node during rendering. In React, rendering should be a pure calculation of JSX and should not contain side effects like modifying the DOM.

> Unlike events, Effects are caused by rendering itself rather than a particular interaction.

## You might not need an Effect

The negative space of the rule above, spelled out by case:

> If there is no external system involved (for example, if you want to update a component's state when some props or state change), you shouldn't need an Effect.

> Removing unnecessary Effects will make your code easier to follow, faster to run, and less error-prone.

Deriving data in an effect creates a second, wasted render pass; deriving it at the top level doesn't:

> You don't need Effects to transform data for rendering.

> When you update the state, React will first call your component functions to calculate what should be on the screen. Then React will "commit" these changes to the DOM, updating the screen. Then React will run your Effects. If your Effect *also* immediately updates the state, this restarts the whole process from scratch!

> To avoid the unnecessary render passes, transform all the data at the top level of your components. That code will automatically re-run whenever your props or state change.

An Effect can't tell you *why* it's running; an event handler always knows.

> You don't need Effects to handle user events.

> In the Buy button click event handler, you know exactly what happened. By the time an Effect runs, you don't know *what* the user did (for example, which button was clicked). This is why you'll usually handle user events in the corresponding event handlers.

`key` resets a subtree's identity instead of an Effect manually resetting each field:

> By passing `userId` as a `key` to the `Profile` component, you're asking React to treat two `Profile` components with different `userId` as two different components that should not share any state.

The test for whether logic belongs in an Effect or an event handler is *why*, not *when*:

> When you're not sure whether some code should be in an Effect or in an event handler, ask yourself *why* this code needs to run. Use Effects only for code that should run *because* the component was displayed to the user.

> In this example, the notification should appear because the user *pressed the button*, not because the page was displayed!

Effects are still the right tool once an actual external system is involved:

> You *do* need Effects to synchronize with external systems.

## Keeping components pure

Purity is the contract React's whole model rests on: same input, same JSX, no reaching outside.

> Pure functions only perform a calculation and nothing more.

> A pure function is a function with the following characteristics: It minds its own business. It does not change any objects or variables that existed before it was called.

> Same inputs, same output. Given the same inputs, a pure function should always return the same result.

> React assumes that every component you write is a pure function.

> React components you write must always return the same JSX given the same inputs.

Components don't coordinate with each other during render — each one is self-contained.

> React's rendering process must always be pure. Components should only return their JSX, and not change any objects or variables that existed before rendering — that would make them impure!

> Each component should only "think for itself", and not attempt to coordinate with or depend upon others during rendering.

StrictMode's double-render is a purity linter: if calling twice changes behavior, the component was impure.

> By calling the component functions twice, Strict Mode helps find components that break these rules.

Mutation isn't banned outright — only mutation of things you didn't just create.

> It's completely fine to change variables and objects that you've just created while rendering.

> If the `cups` variable or the `[]` array were created outside the `TeaGathering` function, this would be a huge problem!

> However, it's fine because you've created them during the same render, inside `TeaGathering`... This is called "local mutation" — it's like your component's little secret.

## Choosing the state structure: derive, don't duplicate

Two variables that always move together should be one variable — separating them is where a state variable's value can quietly fall out of sync with reality.

> If you always update two or more state variables at the same time, consider merging them into a single state variable.

Booleans that can be simultaneously true when they logically shouldn't be are a design smell:

> When the state is structured in a way that several pieces of state may contradict and "disagree" with each other, you leave room for mistakes.

> Since `isSending` and `isSent` should never be `true` at the same time, it is better to replace them with one `status` state variable that may take one of *three* valid states.

Anything computable from existing state or props isn't state — it's a derived value masquerading as one.

> If you can calculate some information from the component's props or its existing state variables during rendering, you **should not** put that information into that component's state.

> "Mirroring" props into state only makes sense when you *want* to ignore all updates for a specific prop.

Storing the same fact in two places (an object and its ID both held independently) is how they drift apart.

> The contents of the `selectedItem` is the same object as one of the items inside the `items` list. This means that the information about the item itself is duplicated in two places.

> Instead of a `selectedItem` object (which creates a duplication with objects inside `items`), you hold the `selectedId` in state, and *then* get the `selectedItem` by searching the `items` array for an item with that ID.

Nested trees are expensive to update immutably; flatten into an id-keyed map instead.

> Deeply hierarchical state is not very convenient to update.

> When possible, prefer to structure state in a flat way.

> Instead of a tree-like structure where each `place` has an array of *its child places*, you can have each place hold an array of *its child place IDs*, and then store a mapping from each place ID to the corresponding place.

> The goal behind these principles is to *make state easy to update without introducing mistakes*.

> **"Make your state as simple as it can be — but no simpler."**

## Sharing state: lift up to a single source of truth

When two components need to change together, state doesn't get synced between them — it moves to whichever component contains both.

> Sometimes, you want the state of two components to always change together. To do it, remove state from both of them, move it to their closest common parent, and then pass it down to them via props.

> This is known as *lifting state up*, and it's one of the most common things you will do writing React code.

Ownership, not location, is the invariant — each piece of state has exactly one component responsible for it.

> **For each unique piece of state, you will choose the component that "owns" it.** This principle is also known as having a "single source of truth".

> It doesn't mean that all state lives in one place — but that for *each* piece of state, there is a *specific* component that holds that piece of information.

Controlled and uncontrolled describe a spectrum, not a binary, and it's a live design choice per component:

> It is common to call a component with some local state "uncontrolled"... In contrast, you might say a component is "controlled" when the important information in it is driven by props rather than its own local state.

> Uncontrolled components are easier to use within their parents because they require less configuration. But they're less flexible when you want to coordinate them together.

> When writing a component, consider which information in it should be controlled (via props), and which information should be uncontrolled (via state).
