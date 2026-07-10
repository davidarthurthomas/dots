# Source material: Constantine & Yourdon, Structured Design (cohesion and coupling)

Distilled from the structured-design treatment of module cohesion and coupling, as it has come down through the literature. The scale names are the standard terms; the prose is paraphrase.

## Two measures of a boundary

Structured design gave the field two ways to judge a module division: **cohesion**, how well the things inside one module belong together, and **coupling**, how much two modules must know about each other. The goal is high cohesion within a module and low coupling between modules. They tend to move together (raising cohesion usually lowers coupling) because both are asking the same question from two sides: is the line in the right place?

## The cohesion scale (worst to best)

A module's cohesion is *why* its parts are in the same module:

- **Coincidental**: no meaningful relationship; the parts landed together by accident (the `utils` grab-bag). Worst.
- **Logical**: parts do the same *category* of thing, selected by a flag ("all the I/O", "all the validation"), though the specific things are unrelated.
- **Temporal**: parts are grouped because they happen at the same time (an `init` module that does ten unrelated setup steps).
- **Procedural / Communicational**: parts follow a shared sequence of control, or operate on the same data.
- **Sequential**: the output of one part is the input of the next.
- **Functional**: every part contributes to one single, well-defined task, and nothing else does. Best.

The useful lesson for file structure: the low end of this scale is exactly the set of *tempting* groupings: same category, same phase, same time. They feel organized but bind unrelated code. Aim for functional cohesion: one file, one job.

## The coupling scale (worst to best)

Coupling is *how* two modules are joined:

- **Content**: one module reaches inside another and manipulates its internals. Worst.
- **Common**: modules share global mutable state.
- **Control**: one passes a flag that tells the other which branch to take, so the caller knows the callee's internal logic.
- **Stamp**: modules share a composite data structure but each uses only part of it.
- **Data**: modules communicate only through simple parameters, each exactly what is needed. Best.

Lower coupling means a module can be understood, changed, and tested with less knowledge of its neighbors. A file you cannot read without opening three others is too tightly coupled; the fix is usually a narrower interface passing plain data.

## Why it matters for where code lives

Cohesion and coupling turn "where should this go?" into two checkable questions. **Does this belong here?** is cohesion: everything in the file should share the module's one reason to exist. **What will this drag in?** is coupling: prefer the placement that leaves the fewest, thinnest connections to the rest of the tree. A file with weak cohesion or heavy coupling is misplaced, and the measure names the fix.
