# Source material: Peter Hilton on naming

From the talk "How to name things: the hardest problem in programming", the paper "Naming guidelines for professional programmers", and the naming posts on hilton.org.uk. Quotes are verbatim.

> The surprising thing about naming things well in code is not that it's hard, but how easy it is to accept bad names.

> Rename is the safest but most effective refactoring. Use it.

## The smell catalog

Ordered roughly from annoying to dangerous:

- **Meaningless names.** `foo`, `bar`, and their kin, excused by "the code won't last long." His ranking of the worst names: `data`, then `data2`, then `data_2`.
- **Abstract names.** `data`, `object`, `value`: they state the obvious and add nothing. "'data' doesn't add any meaning - you already know that a variable is data." Type echoes (`customer = new Customer`) are redundant with the type. The one exception is generic library code, where specificity is impossible; in a domain model, never.
- **Numeric suffixes.** `employee2` hides the actual distinction; rename both to communicate it (`manager` and `recentHire`).
- **Abbreviations.** Ambiguous because several words share one abbreviation: does `auth` mean authentication or authorization?
- **Single letters.** "Meta-ambiguous because they're ambiguous about which kind of ambiguity you're dealing with."
- **Vague words.** `-Manager` says nothing about responsibility; prefer a word that does (`bucket`, `supervisor`, `planner`, `builder`). The `get` prefix on non-accessors is a JavaBeans habit; use `calculate`, `estimate`, `fetch`.
- **Vestigial Hungarian.** Type prefixes are redundant: `victory` over `isVictory`, `created` over `dateCreated`. Domain terms like `birthDate` are fine.
- **Pidgin compounds.** Concatenations form "a pidgin language of simple words"; the domain usually has the real word: `calendar` over `appointment_list`, `employee` over `company_person`, `edit` over `text_correction_by_editor`.
- **Wrong names.** The name refers to the wrong concept entirely, and only domain knowledge exposes it. The worst kind, and the most valuable rename.

## Guidelines

- Start with what you want the code to say; use words with precise meanings; prefer fewer words; never abbreviate (except `id`).
- Keep names under about 20 characters and at most four words; only correctly spelled dictionary words. Research backs the full words: full-word identifiers lead to the best comprehension (Lawrie et al., 2006).
- Use a large vocabulary: one rich word beats a compound.
- Use problem-domain terms, backed by a living glossary. "Using domain jargon only helps if everyone knows what it means."
- Names in the same scope must differ in actual meaning, by more than a letter or two, by more than word order, and phonetically (code gets discussed aloud). No synonym pairs like `input` and `inputValue`.
- Singular for values, plural for collections, and prefer collective nouns: `calendar`, not `appointments`.
- Booleans imply true or false (`done`, `found`) and stay positive (never `notSuccessful`).
- Use standard opposite pairs consistently: add/remove, begin/end, open/close.
- Classes are noun phrases valid for every possible state and value; methods are verb phrases. Reserve `get`, `is`, `has`, `set` for true accessors with matching semantics; side-effecting methods get real verbs.
- Name constants for meaning (`boilingPoint`, not the number); qualify with suffixes (`Count`, `Minimum`) so related names sort together.

## Process

- Renaming is refactoring; practice it constantly. Five fears block it: change itself, breaking things, discussion overhead, time cost, and admitting your domain understanding was wrong.
- Iterate socially: challenge names in review and pairing (roughly a quarter of code reviews mention naming), and read code aloud to check it sounds right.
- Build the skill deliberately: learn the smells, expand your vocabulary, keep a thesaurus nearby, study the domain, practice prose.
- Why it matters: identifiers are about a third of tokens and nearly three quarters of characters in a large codebase, and naming flaws correlate with static-analysis warnings.
