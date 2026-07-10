# Source material: David Parnas, "On the Criteria To Be Used in Decomposing Systems into Modules" (1972)

Distilled from the paper. The proposed-criterion sentence and the definition of a module's secret are close to verbatim; the rest is paraphrase.

## The question

Given a system to build, on what basis do you draw the lines between modules? Parnas takes one small system (a KWIC index) and decomposes it two ways to show the criterion matters more than anyone assumed.

## The conventional criterion, and why it fails

The obvious decomposition follows the flowchart: make each major step of the processing its own module (read input, build the index, sort it, print it). Parnas calls this decomposition by processing steps and shows it is almost always wrong. Every module in it shares knowledge of how the data is represented, so a change to that representation forces edits across all of them. The modules are not independent; they are chapters in one story that must be read together.

## The criterion he proposes

> We propose instead that one begins with a list of difficult design decisions or design decisions which are likely to change. Each module is then designed to hide such a decision from the others.

Decompose by decision, not by step. A module owns one design decision (a data representation, an algorithm, an input format, a hardware dependency) and hides it behind an interface. The decision is the module's secret. Callers see the interface and never the secret, so the secret can change without touching them.

## Information hiding

The interface of a module should reveal as little as possible about its inner workings. What is likely to change is precisely what must be hidden. Two modules should share only what neither is likely to change; everything volatile belongs inside one module, behind its interface, invisible to the rest.

This inverts the naive instinct. You do not group code because it runs at the same time or in the same phase; you group it because it would change for the same reason, and you split it from code that would change for a different reason.

## What follows

- **Changeability.** A change confined to one secret touches one module. This is the whole payoff: the decomposition is good to the extent that likely changes are local.
- **Independent development.** Once interfaces are fixed, teams can work on modules without knowing each other's secrets.
- **Comprehensibility.** A reader can understand one module without holding the others in their head, because the interface is the whole contract.

## Hierarchical structure is a separate property

Parnas warns not to conflate two ideas. "Clean, hierarchical structure" (a tree of uses with no cycles) and "good modularization" (decomposition by hidden decision) are different properties; a system can have one without the other. Pursue both, but do not assume drawing a neat layer diagram has hidden any decisions.

## Efficiency

The information-hiding decomposition can cost run-time efficiency, because crossing a clean interface is not free. Parnas's stance: design the modularization for changeability first, and recover efficiency later where measurement shows it is needed, rather than sacrificing the structure up front to a performance fear that may never materialize.
