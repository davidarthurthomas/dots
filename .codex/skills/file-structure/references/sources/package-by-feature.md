# Source material: "Package by feature, not by layer" (folder-structure practice)

Distilled from the widely-repeated argument for feature-based source layout (Robert C. Martin's "Screaming Architecture", the "Package by Feature" essays in the Java and JavaScript communities, and the colocation practice popularized by front-end frameworks). Paraphrase throughout.

## The two ways to slice a tree

Every source tree of any size chooses, implicitly, between two top-level cuts:

- **By layer (by kind):** `controllers/`, `services/`, `models/`, `views/`, `utils/`. Files are grouped by their technical role.
- **By feature (by domain):** `orders/`, `billing/`, `search/`, each holding the controller, service, model, and view for that slice of the product.

## Why by-feature usually wins

- **Changes are local.** A feature request ("change how billing works") touches one directory, not one file in each of five layer folders. The layout matches the shape of the work, which is the Common Closure Principle applied to folders: put together what changes together.
- **Coupling is visible.** When a feature is one folder, its dependencies on other features are imports that cross folder lines, easy to see and to police. In a by-layer tree the same dependencies hide inside `services/`, and the true structure is invisible.
- **The tree documents the product.** A newcomer reading `orders/ billing/ shipping/` learns what the system does. Reading `controllers/ models/ views/` they learn only what framework it uses.
- **It scales by growing outward, not fatter.** A new feature is a new folder. A by-layer tree grows by making every layer folder larger, so each one becomes a junk drawer nobody can hold in their head.

## When by-layer is fine

At small scale, or inside a single feature folder, splitting by kind is reasonable: a feature may have its own `components/`, `hooks/`, `api/`. Layering is a fine *secondary* cut, within a feature; it is a poor *primary* cut, at the root. The rule of thumb: the highest levels of the tree should be domain, the lower levels may be technical.

## Colocation

Keep a thing near the thing it serves. A test next to the code it tests, a stylesheet next to the component it styles, a helper next to its single caller, a type next to the function that returns it. The default distance between two files should be proportional to how likely you are to open them together. Something used by exactly one feature lives inside that feature; only things used by many earn a place in a shared or common directory, and a shared directory that keeps growing is a signal that a concept wants to become a feature of its own.

## Depth

Prefer a flat-enough tree that a reader can navigate by name. Deep nesting (`src/main/app/modules/core/impl/...`) hides code and makes imports brittle; a very flat tree with hundreds of siblings is just as hard to scan. Add a directory level when a group of files has a name (a real concept the level stands for), not merely to reduce the count of siblings. Every folder should justify itself with a word from the domain.
