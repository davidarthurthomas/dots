# Source material: Every Layout (Heydon Pickering & Andy Bell)

From every-layout.dev: the homepage, the "Axioms" rudiment, and the freely readable layout primitives (the Stack, the Sidebar, the Switcher). The Box, Center, and Cluster pages are behind the paid tier and are not quoted here. Quotes are verbatim.

## Algorithmic layout removes breakpoints and magic numbers

Compose small, context-independent layouts and let the browser's own algorithms do the arranging.

> Employing algorithmic layout design means doing away with @media breakpoints, 'magic numbers', and other hacks, to create context-independent layout components.

> Through a series of simple, composable layouts, Every Layout will teach you how to better harness the built-in algorithms that power browsers and CSS.

> If you find yourself wrestling with CSS layout, it's likely you're making decisions for browsers they should be making themselves.

> Your future design systems will be more consistent, terser in code, and more malleable in the hands of your users and their devices.

## Axioms are rules that generate artefacts, not the artefacts themselves

You define the governing rules and the browser produces the layouts they imply.

> Think of yourself as the browser's mentor, rather than its micro-manager.

> Unless your design is founded on axioms, your output will be inconsistent and malformed.

> Axioms do not directly create visual artefacts, only the characteristics of artefacts that might emerge.

> Think of it as writing programs for generating visual artefacts. Axioms are the rules that influence how those artefacts are created by the browser.

## Style the context, not the element (the Stack)

Spacing between flow elements belongs to their common parent, not to each element in turn.

> Flow elements require space (sometimes referred to as white space) to physically and conceptually separate them from the elements that come before and after them.

> The trick is to style the context, not the individual element(s). The Stack layout primitive injects margin between elements via their common parent.

## A component handles its own layout intrinsically (the Sidebar)

When the medium is indeterminate, a component should adapt to the space it's given rather than to the viewport.

> When the dimensions and settings of the medium for your visual design are indeterminate, even something simple like putting things next to other things is a quandary.

> A component might appear within a 300px wide container, or it might appear within a more generous 500px wide container. But the width of the viewport is the same in either case, so there's nothing to 'respond' to.

> Your component handles its own layout, intrinsically, and without the need for manual intervention.

## Suggest an arrangement instead of dictating several (the Switcher)

One layout that exists in multiple states at once beats many layouts pinned to breakpoints.

> An overuse of @media breakpoints can easily come about when we try to fix designs to different contexts and devices.

> By only suggesting to the browser how it should arrange our layout boxes, we move from creating multiple layouts to single quantum layouts existing simultaneously in different states.
