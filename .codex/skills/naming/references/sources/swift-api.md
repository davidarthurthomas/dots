# Source material: Swift API design guidelines

From swift.org/documentation/api-design-guidelines, widely considered the best official style-guide treatment of naming. The Swift-specific argument-label mechanics are omitted; everything here generalizes. Quotes are verbatim.

## Clarity at the point of use

> Clarity at the point of use is your most important goal. Entities such as methods and properties are declared only once but used repeatedly.

> When evaluating a design, reading a declaration is seldom sufficient; always examine a use case to make sure it looks clear in context.

The reviewing move: write out realistic call sites and read them as sentences. A name that looks fine in isolation can be redundant or ambiguous in context, and the unit of clarity is the whole expression at the use site, not the identifier alone.

## The two rules in tension

> Clarity is more important than brevity.

Brevity should fall out of removing redundancy, never out of compression. Two rules pull against each other, and the same test resolves both: does this word carry information the reader at the use site doesn't already have?

**Include all the words needed to avoid ambiguity.** `employees.remove(at: x)` versus `employees.remove(x)`: without 'at', a reader guesses the method searches for and removes an element equal to `x` rather than using `x` as a position. A word earns its place if dropping it changes what a reader would guess the code does.

**Omit needless words.**

> Every word in a name should convey salient information at the use site.

> Omit words that merely repeat type information.

`allViews.removeElement(cancelButton)` becomes `allViews.remove(cancelButton)`; 'element' adds nothing at the call site.

## Role over type

> Name variables, parameters, and associated types according to their roles, rather than their type constraints.

`var greeting = "Hello"`, not `var string = "Hello"`; `restock(from supplier: WidgetFactory)`, not `restock(from widgetFactory: WidgetFactory)`. A type name restates what the reader already knows; a role name adds meaning.

**Compensate for weak type information.** When a parameter's type says little (string, int, dictionary, any), precede it with a noun describing its role. The weaker the type, the more the name must carry; a strongly typed `Supplier` parameter mostly names itself.

## Grammar carries semantics

> Name functions and methods according to their side-effects.

- No side effects: noun phrase. `x.distance(to: y)`, `i.successor()`.
- Side effects: imperative verb phrase. `print(x)`, `x.sort()`, `x.append(y)`.
- Mutating and non-mutating pairs: bare imperative for the mutation, participle for the copy. `x.sort()` and `x.sorted()`; `x.append(y)` and `x.appending(y)`.

A reader should be able to tell from grammar alone whether calling it changes anything.

> Uses of Boolean methods and properties should read as assertions about the receiver.

`x.isEmpty`, `line1.intersects(line2)`: a boolean name is a true-or-false sentence about its subject, so conditions read as plain claims.

Read the invocation aloud; if it doesn't form a grammatical phrase, rename.

## Terms of art and abbreviations

> Avoid obscure terms if a more common word conveys meaning just as well. Don't say 'epidermis' if 'skin' will serve your purpose.

When a term of art is the precise word, stick to its established meaning:

> Don't surprise an expert ... Don't confuse a beginner.

> Avoid abbreviations. Abbreviations, especially non-standard ones, are effectively terms-of-art.

The test: "The intended meaning for any abbreviation you use should be easily found by a web search."

**Embrace precedent.** Established culture beats beginner-friendliness: `sin(x)` over a self-explaining phrase, the community's word for a data structure over your improvement on it.
