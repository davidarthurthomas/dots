# Source material: Lea Verou on CSS

From "Custom properties with defaults: 3+1 strategies," "Eigensolutions: composability as the antidote to overfit," and "On compliance vs readability: Generating text colors with CSS," all published on lea.verou.me. Quotes are verbatim.

## Custom properties are an API, not just storage

Exposing a property as a styling parameter turns a component into something callers can configure.

> When developing customizable components, one often wants to expose various parameters of the styling as custom properties, and form a sort of *CSS API*.

> My preferred solution is what I call *pseudo-private custom properties*. You use a different property internally than the one you expose, which is set to the one you expose plus the fallback.

Getting the exposure wrong quietly removes the inheritance that makes custom properties worth using.

> It means that people cannot take advantage of inheritance to set `--color` on an ancestor.

## Compose general features instead of overfitting to use cases

A solution built for too few cases can't stretch even to obviously related ones.

> Overfitting happens when the driving use cases behind a solution are insufficiently diverse, so the solution ends up being so specific it cannot even generalize to use cases that are clearly related.

> Overfitting is one of the worst things that can happen during the design process. It is a hallmark of poor design that leads to feature creep and poor user experiences.

> Rather than designing a solution to address only our driving use cases, step back and ask yourself: can we design a solution as a composition of smaller, more general features, that could be used together to address a broader set of use cases?

> The eigensolution is a solution that addresses several key use cases, that previously appeared unrelated.

## Reduce couplings even when you own every line

Modularity pays off in a single-author codebase, not only across teams.

> Even in a codebase where every line of CSS code is controlled by a single author, reducing couplings can improve modularity and facilitate code reuse.
