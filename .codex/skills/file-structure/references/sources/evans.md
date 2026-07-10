# Source material: Eric Evans, Domain-Driven Design (modules, bounded contexts)

Distilled from the chapters on modules and on strategic design. Paraphrase throughout.

## Modules tell a story about the domain

Evans treats a module (package, namespace, directory) as a modeling decision, not a filing decision. A module should carry a name and a boundary drawn from the domain, so that the package structure reads as a map of the business, and understanding one module means understanding one coherent piece of the domain. Choose modules to tell the story of the system and contain a cohesive set of concepts; the goal is low coupling between modules and high cohesion within.

The failure mode he names: modules drawn to reflect the *technical* structure (a package of all the interfaces, a package of all the data objects) rather than the conceptual one. Those cut across concepts, so following a single domain idea means hopping between packages, and the structure teaches nothing about the domain. Let the boundaries fall where the concepts do.

## The name is part of the model

When you refine the model, refine the module structure and names to match; a package whose name no longer fits the concepts inside it misleads every reader. Module boundaries and the ubiquitous language move together; renaming and re-grouping as understanding grows is part of modeling, not overhead.

## Bounded contexts: the largest boundary

At the largest scale, a **bounded context** is the boundary within which one model applies and one team's terms mean one thing. The same word ("account", "policy", "order") means different things in different contexts, and the mistake is to force one shared model across the whole system. Draw an explicit boundary; inside it the model is unified and consistent, and across it you translate. In a repository this is the top-level split: the seams between contexts are the seams between the biggest directories or the separate services, and getting these lines right matters far more than any file placement inside them.

## Keep related concepts together, unrelated ones apart

The everyday rule that follows: things that are used and reasoned about together belong in the same module, and a dependency that forces a reader to chase a concept across many packages is a sign the boundary is wrong. Structure so that a developer can hold one module in mind at a time.
