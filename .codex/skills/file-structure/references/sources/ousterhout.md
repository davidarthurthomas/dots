# Source material: John Ousterhout, A Philosophy of Software Design (modules chapters)

Distilled from chapters 4–9. The "deep module" framing and the red-flag names are close to verbatim; the rest is paraphrase.

## Modules should be deep

A module has two parts: an interface (what a caller must know to use it) and an implementation (everything else). The best modules are deep: a simple interface over a substantial implementation. The interface is the cost the module imposes on the rest of the system; the implementation is the benefit it provides. A deep module hides a lot of complexity behind a little interface, so it pays for itself many times over.

A shallow module is the opposite: its interface is nearly as complex as its implementation, so it hides almost nothing. A method that just forwards to another, a class that wraps one field, a pass-through layer: these add interface without hiding complexity, and each one is a net cost. Ousterhout's provocation: **classitis**, the belief that more, smaller classes are automatically better, produces a swarm of shallow modules and more total complexity, not less. Judge a module by depth, not by line count.

## Information hiding and leakage

The single most important technique for making modules deep is information hiding: each module encapsulates a piece of design knowledge (a data structure, a file format, an algorithm) that callers never see. Its opposite, **information leakage**, is the red flag: a design decision shows up in more than one module, so the two are coupled and must change together. Leakage is worse than duplication, because the two sites do not even look alike; they are bound by a shared assumption no reader can see.

The most common leak is a **temporal decomposition**: structure that mirrors the order operations happen in rather than the knowledge they share. You read a file, process it, write it, so you make three modules, and now the file format is known to all three. Execution order is a bad basis for module boundaries; shared knowledge is the right one. When you catch yourself splitting by "first this, then that," check whether both halves touch the same secret.

## Where a decision lives

A design decision should be encapsulated in one place if possible. When it must be reflected in several places (a network protocol known to sender and receiver), keep those places consistent, and centralize whatever you can so the rest derives from one source. Prefer designs where each piece of knowledge has a single home.

## Define errors (and special cases) out of existence

The best way to handle an edge case is to design an interface where the case does not arise. Fewer special cases means a simpler interface and fewer branches for callers to handle. This is a structural tool: reshape the module so the exception is folded into the normal path, rather than exposing it and pushing the handling onto every caller.

## Design it twice

Do not settle for the first structure that comes to mind. Sketch two or three genuinely different decompositions, list the interface each forces on callers, and pick the one whose interfaces are simplest. The extra hour up front is cheap against the cost of living with the wrong boundary.

## Comments and interfaces

If the interface of a module cannot be described simply, the module is probably not deep. A boundary you can't summarize in a sentence is a boundary in the wrong place. The obligation to write the interface comment first is a design check, not a documentation chore.
