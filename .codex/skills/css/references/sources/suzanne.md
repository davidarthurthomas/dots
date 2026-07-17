# Source material: Miriam Suzanne on CSS

From the "Cascade Layers Guide" (css-tricks.com) and the "Container queries explainer & proposal" (miriamsuzanne.com). Quotes are verbatim.

## Cascade layers make the cascade intentional

Layers give explicit control over priority, so specificity hacks and `!important` stop being the tools of last resort.

> Cascade layers give CSS authors more direct control over the cascade so we can build more intentionally cascading systems without relying as much on heuristic assumptions that are tied to selection.

> This is your complete guide to CSS cascade layers, a CSS feature that allows us to define explicit contained layers of specificity, so that we have full control over which styles take priority in a project without relying on specificity hacks or !important.

> Specificity is still applied to conflicts within each layer, but conflicts between layers are always resolved by using the higher-priority layer styles.

> These layers are ordered and grouped so that they don't escalate in the same way that specificity and importance can. Cascade layers aren't cumulative like selectors. Adding more layers doesn't make something more important.

Methodologies that route around the cascade solve a different problem than layers do.

> These rules are usually more about avoiding the cascade, rather than putting it to use.

## Container queries respond to context, not the viewport

A component should style itself from the space it occupies, so the same component works anywhere you drop it.

> Media-queries allow an author to make style changes based on the overall viewport dimensions – but in many cases, authors would prefer styling modular components based on their context within a layout.

> The .media class above is now responsive to any container it is in. Each instance of the .media class will query its nearest container.

> That means we can have one .media element that moves around, responding to the context we put it in
