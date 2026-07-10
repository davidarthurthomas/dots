# Source material: Robert C. Martin, Clean Architecture and Clean Code (component and SRP chapters)

Distilled from the component-cohesion, component-coupling, SRP, and "Screaming Architecture" chapters. The principle names are Martin's; the prose is paraphrase.

## The Single Responsibility Principle, restated

Martin's mature phrasing: a module should have one, and only one, reason to change, meaning it should be responsible to one actor. Two responsibilities that serve different actors will change at different times for different people, and if they share a file, each change risks breaking the other's actor. Gather what changes for the same reason; separate what changes for different reasons. This is the file-level echo of Parnas: the "reason to change" is the hidden decision.

## Component cohesion: what goes in a package

Three principles, in tension, decide which classes belong together:

- **REP, the Reuse/Release Equivalence Principle.** The granule of reuse is the granule of release. Group things that are released together and used together as a unit; a package should be a coherent thing a consumer can adopt whole.
- **CCP, the Common Closure Principle.** Gather into one component the classes that change for the same reasons and at the same times; separate those that change at different times for different reasons. This is the SRP for components, and the day-to-day workhorse: **put together what changes together.** A change that should touch one component and touches five means the boundary is wrong.
- **CRP, the Common Reuse Principle.** Don't force users of a component to depend on things they don't need. Classes that are always used together belong together; a class that is dragged in but never used is a sign it belongs elsewhere.

These three pull against each other (CCP and CRP especially), so a boundary is always a balance, and it shifts as the system matures; early on, ease of change (CCP) usually wins over reusability (REP).

## Component coupling: which way the arrows point

- **The Acyclic Dependencies Principle.** Allow no cycles in the dependency graph between components. A cycle turns the tangle into one big component that must be understood and released together. Break cycles with dependency inversion or by extracting a new component the two can both depend on.
- **The Stable Dependencies Principle.** Depend in the direction of stability. A component that is hard to change should not depend on one that is easy to change, or the easy change is no longer easy. Volatile things sit at the leaves; stable things sit where many depend on them.
- **The Stable Abstractions Principle.** A stable component should be abstract, so that its stability does not prevent it from being extended. High-level policy belongs in stable, abstract components; low-level detail in volatile, concrete ones.

## Point dependencies at policy, not detail

The high-level policy of a system (the rules that make it what it is) should not depend on low-level details like the database, the framework, or the delivery mechanism. Details depend on policy, never the reverse. Where the natural flow of control runs the wrong way, invert it with an interface so the source-code dependency points inward toward the policy.

## Screaming architecture: organize by domain, not by framework

The top level of a source tree should announce what the system *does*, not what it is *built with*. A directory of `controllers/`, `models/`, `views/` screams "Rails"; a directory of `orders/`, `billing/`, `shipping/` screams what the application is for. Organize the tree around the domain so the structure documents the system's purpose, and so a framework decision stays a detail you could reverse. The framework is a tool the system uses, not the architecture the system is.
