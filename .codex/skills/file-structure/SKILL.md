---
name: file-structure
description: >
  Decide where code lives and where boundaries fall: which file or module something belongs in, when
  to split or merge a file, how to shape a directory tree, which way dependencies should point. Use when
  placing new code, splitting a growing file, extracting a module or package, organizing a source tree,
  or reviewing structure in a diff. Triggers on "where should this go", "how should I structure",
  "split this file", "folder structure", "module boundaries", "package layout", "organize".
global_category: Engineering
---

# File Structure

Where code lives and where the lines between modules fall, grounded in the canon:

- [Parnas, _On the Criteria To Be Used in Decomposing Systems into Modules_](references/sources/parnas.md)
- [Ousterhout, _A Philosophy of Software Design_](references/sources/ousterhout.md)
- [Martin, _Clean Architecture_ & _Clean Code_](references/sources/martin.md)
- [Constantine & Yourdon, _Structured Design_](references/sources/constantine-yourdon.md)
- [Evans, _Domain-Driven Design_](references/sources/evans.md)
- [Package by feature, not by layer](references/sources/package-by-feature.md)

This is a sibling of the `naming` skill. A hard-to-name thing and a hard-to-place thing are usually the same design smell seen from two angles; when placement won't settle, name the thing, and the file it wants to live in often becomes obvious.

## The one criterion

**Group by what changes together, split by what changes apart.** This is the whole discipline, stated by Parnas in 1972 and restated by everyone since: decompose a system by the decisions it hides, not the steps it performs. A module owns one design decision (a data representation, a format, an algorithm, a policy) and hides it behind an interface, so that decision can change and touch one place. Martin's name for it at the file level is the Single Responsibility Principle: **a module should have one reason to change.** Ask of any file, "what change would force me to edit this?" Two answers means two files.

**Reason-to-change, not category, not phase, not time.** The tempting groupings are the bad ones. Constantine's cohesion scale ranks them at the bottom: code bundled because it's the same *kind* of thing (a `utils` drawer), because it runs in the same *phase* (an `init` that does ten unrelated setups), or because it fires at the same *time*. These feel tidy and bind unrelated code. Ousterhout's sharpest warning is the **temporal decomposition**: structure that mirrors execution order ("read, then process, then write") leaks the one secret all three steps share. Order of operations is never a boundary; shared knowledge is.

## Cohesion: does this belong here?

**One file, one job.** Aim for functional cohesion: every part of a file contributes to one well-defined purpose, and that purpose lives nowhere else. A file you can summarize in a single phrase without "and" is cohesive. One whose honest summary is "parses config *and* opens the connection *and* logs failures" is a list of files waiting to be split, and that forced "and" is the signal `naming` reads as a hard-to-name function.

**Colocate what serves one thing.** Keep a file near the file it serves: a test beside the code it tests, a helper beside its only caller, a type beside the function that returns it, a stylesheet beside its component. The default distance between two files should track how often you open them together. Something used by exactly one feature belongs *inside* that feature; only what's used by many earns a shared directory.

**A shared bucket is a confession.** `utils`, `helpers`, `common`, `misc`, `shared`: the same homeopathic suffixes `naming` bans on a symbol, now on a directory. Each is an admission the concept was never identified. When a `shared/` folder keeps growing, a real concept is hiding in it that wants a module and a domain name of its own.

## Coupling: what does this drag in?

**Prefer the placement with the fewest, thinnest ties.** Coupling is how much two modules must know about each other. Between "correct" homes for a file, pick the one that leaves the narrowest connection to the rest of the tree: communication through plain data and a small interface, not through shared mutable state or a flag that reveals the callee's branches. A file you can't read without opening three others is telling you it's coupled to them, and often that it belongs with them.

**Point dependencies toward stability, and toward policy.** Volatile, concrete details (the database, the framework, the delivery mechanism) depend on stable, abstract policy (the domain rules), never the reverse. Where control naturally flows the wrong way, invert it with an interface so the source-code dependency still points inward. High-level policy that imports a low-level detail has the arrow backwards.

**No cycles.** If two modules import each other, they are one module wearing two names, and neither can be understood, changed, or moved alone. Break the cycle by inverting one dependency or by extracting the shared thing both can depend on. An acyclic tree of dependencies is a property to design for on purpose. It is also, Parnas cautions, a separate property from good modularization: a neat layer diagram can still have hidden no decisions.

## Depth: is this boundary paying for itself?

**Favor deep modules.** Ousterhout's central measure: a good module is a simple interface over a substantial implementation. The interface is the cost it imposes on everyone else; the implementation is the benefit. A file that hides a lot behind a little is worth its boundary many times over. A **shallow** one (a wrapper that forwards, a pass-through layer, a class around a single field) adds interface without hiding much, and is a net loss.

**More files is not more modular.** The instinct that smaller and more numerous is automatically cleaner (Ousterhout's **classitis**) manufactures shallow modules and raises total complexity. Split a file when it holds two reasons to change, not when it crosses a line count. Sometimes the right move is to *merge* two shallow files whose interfaces are more complex than the code they hide.

**Information leakage is worse than duplication.** When one design decision shows up in two files, they're secretly bound and must change together, and unlike honest duplication, the two sites don't even look alike, so no reader sees the tie. If a change ripples across several files that don't reference each other, the boundary is in the wrong place; a leaked secret wants to be pulled into one module.

## The tree: slice by domain first

**The top level is the domain; the technical split goes underneath.** A source tree cut into `controllers/ models/ views/` screams what framework it's built with; one cut into `orders/ billing/ shipping/` screams what the product does. Cut the highest levels by feature so a newcomer reads the tree as a map of the business and a feature change lands in one folder. Layering (`components/`, `hooks/`, `api/`) is a fine *secondary* cut inside a feature and a poor *primary* cut at the root. This is the Common Closure Principle on folders: put together what changes together.

**Draw the biggest lines at the concept boundaries.** Evans's bounded context is the largest and most important seam: the boundary within which one model holds and a word means one thing. Getting the top-level splits right (the seams between contexts, the biggest directories or separate services) matters far more than any file placement inside them.

**Add a directory only for a concept that has a name.** A level of nesting must stand for a real thing a reader can name from the domain, not merely thin out a crowded folder. Deep nesting hides code and makes imports brittle; a flat sea of hundreds of siblings is just as unscannable. Every folder should justify itself with a word from the domain, the same bar `naming` sets for a symbol.

## Placing or splitting code

1. Say in one phrase what the file is responsible for. If the honest phrase needs "and", that's two files.
2. Ask what change would force you to edit it. Group it with what changes for that same reason; separate it from what changes for a different one.
3. Reject the tempting groupings: same category, same phase, same execution order. Group by shared secret, not shared kind or shared timing.
4. Among the homes that fit, choose the one that drags in the least: fewest imports, thinnest interface, no new cycle.
5. Check the tree: does a feature (or the domain) already have a folder for this? Put it there. Reach for `shared/` only when many features truly use it.
6. If nothing fits (the file has two jobs, the folder has no name, the dependency points backward), treat it as design feedback and reshape the thing; don't just pick the least-bad drawer.
