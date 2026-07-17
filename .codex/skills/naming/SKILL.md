---
name: naming
description: >
  Choose, review, and improve names in code: variables, functions, classes, modules, packages,
  APIs, schemas, events, flags. Use when naming anything new, renaming, extracting a function or
  type, designing an API or schema, or reviewing the names in a diff. Triggers on "what should I
  call this", "name this", "rename", "better name", "naming".
global_category: Engineering
---

# Naming

Naming principles, grounded in the canon:

- [Ousterhout, _A Philosophy of Software Design_, ch. 14](references/sources/ousterhout.md)
- [McConnell, _Code Complete_, ch. 11](references/sources/mcconnell.md)
- [Beck, _Smalltalk Best Practice Patterns_](references/sources/beck.md)
- [Swift API design guidelines](references/sources/swift-api.md)
- [Boswell & Foucher, _The Art of Readable Code_](references/sources/readable-code.md)
- [Evans, _Domain-Driven Design_](references/sources/evans.md)
- [Belshee, _Naming as a Process_](references/sources/belshee.md)
- [Hilton, _How to name things_](references/sources/hilton.md)
- [Henney, _Giving Code a Good Name_](references/sources/henney.md)
- [Martin, _Clean Code_, ch. 2](references/sources/martin.md)

## Judging a name

**Judge the name at the call site.** A name is declared once and read at every use, so "clarity at the point of use is your most important goal": write out a realistic use and read it as a sentence. `employees.remove(at: x)` and `employees.remove(x)` differ by one word, and that word decides whether a reader thinks `x` is a position or a victim.

**The image test.** Shown the name in isolation, with no declaration, documentation, or surrounding code, how closely can a reader guess what it refers to, and what it is not? A name that fails cold will mislead warm.

**Every word earns its place.** Include all the words needed to keep a reader from guessing wrong; omit every word the reader already has from context or type. `views.remove(cancelButton)`, not `views.removeElement(cancelButton)`: 'element' repeats what the receiver already says. `truncateToMaxChars(text, limit)`, not `clip(text, limit)`: 'clip' leaves both the direction and the unit open.

## What to name for

**Intent over mechanism.** Name a function for what it accomplishes for the caller, never for how. Beck's test: would the name survive a completely different implementation? A routine that highlights by inverting pixels is `highlight`, never `reverse`; the mechanism name goes stale on the first rewrite and tells callers nothing about when to use it.

**Role over type.** `supplier`, never `widgetFactory`; `greeting`, never `string`. A type name repeats what the reader already knows, and the weaker the type (string, int, dict), the harder the name must work: a bare string parameter needs a role noun (`unescapedComment`, `keyPath`) where a strongly typed one mostly names itself.

**The domain's word.** Draw names from the vocabulary the domain experts use, one term per concept and one concept per term, so saying something about the code and saying something about the domain are the same act. The domain usually has one rich word where the code has a pidgin compound: `calendar`, never `appointmentList`; `employee`, never `companyPerson`. A word the team keeps reaching for that isn't in the code yet is a missing abstraction.

## Precision

**Vague names are the cardinal smell.** A name broad enough to mean many things conveys nothing and invites misuse: `data`, `info`, `result`, `status`, `item`, `value`, `process`, `handle`. The cautionary tale is Ousterhout's Sprite bug: a variable named `block` sometimes held a logical and sometimes a physical block number, one site mixed them up, and the corruption took months to find because every reader assumed `block` held the right kind. As `fileBlock` and `diskBlock` the bug cannot hide.

**No homeopathic suffixes.** Appending `Manager`, `Helper`, `Util`, `Factory`, `Processor`, `Object`, `Service` dilutes a name; it never strengthens one. A `util` bucket is a confession that the concept was never identified. The same goes for category suffixes the syntax already announces: spend the characters on the problem (`InvalidNumberFormat`), never on the category (`NumberFormatException`).

**Attach the details a reader must not miss.** Units and caveats go in the name: `delaySecs`, `sizeMb`, `untrustedUrl`, `plaintextPassword`. Prefix inclusive limits with `max` or `min`; use `first`/`last` for inclusive ranges and `begin`/`end` for inclusive-exclusive ones.

**Never disinform.** A vague name wastes time; a false one plants a bug. `accountList` that isn't a list, an `add` that appends in one class and sums in another, a `getSize` that walks the tree. Readers assume `get` and `size` are cheap; if it computes, fetches, or counts, say so.

## Form

**Length scales with scope.** The greater the distance between a name's declaration and its uses, the longer the name should be. `i` is fine when the whole scope is three lines; a module-level name earns 10 to 16 characters (the range McConnell cites) and at most four words. Extra words that add no information are clutter at any length: `file`, never `fileObject`.

**Grammar carries semantics.** A reader should tell from grammar alone whether calling something changes anything: side effects take an imperative verb phrase (`x.sort()`, `deletePage()`), pure operations a noun phrase or participle (`x.sorted()`, `distance(to:)`). Classes are noun phrases valid for every state the object can hold. Booleans lead with `is`, `has`, `can`, `should`, read as positive assertions (`isEmpty`, `cursorVisible`), and never negate (`useSsl`, not `disableSsl`).

**Dictionary words, spelled out.** Abbreviations are private terms of art; use one only if a web search resolves it (`id`, `max`, `html`). Names must be pronounceable (code is discussed aloud) and searchable (a name you can't grep for might as well be anonymous). Use standard opposite pairs consistently: add/remove, begin/end, open/close.

## Consistency

**Same name, same thing, everywhere.** Use the common name for a given purpose every time, use it for nothing else, and keep the purpose narrow enough that everything wearing the name behaves alike. Pick one of `fetch`, `retrieve`, `get` and use it project-wide; a reader who meets two assumes a difference that isn't there. Names in one scope must differ in meaning, never only in a letter or a word order.

**Follow precedent.** When a term of art is the precise word, use it with its established meaning; don't surprise an expert or send a beginner's web search to the wrong place. `sin(x)` beats any self-explaining phrase, and the community's word for a structure beats your improvement on it.

## Naming as a process

**A name should be exactly as good as your understanding.** Never guess: a plausible wrong name is trusted and causes bugs, where obvious nonsense (`applesauce`) at least tells the truth about your ignorance. Mark uncertainty explicitly (`probably_`, `_andStuff`) and burn it down as you learn. Good naming is iterative: nonsense, then honest, then complete, then intent, one committed rename per insight.

**Hard to name is design feedback.** When no simple, precise name fits, the underlying thing lacks a clean design: it has too many responsibilities or the abstraction boundary is wrong. An honestly ugly complete name (`parseConfigAndConnectAndLogFailures`) is a to-do list; fix the code and the short name appears. Wordsmithing harder just hides the signal.

**Rename freely.** Rename is the safest refactoring, and the most valuable renames correct a wrong concept rather than swap synonyms. A better word for a domain concept is a model change: propagate it to the code at once, and improve names when reading, not only when writing.

## Choosing a name

1. What to name for.
2. Judge the name at the call site.
3. Every word earns its place.
4. The image test.
5. The domain's word; follow precedent.
6. Hard to name is design feedback.
