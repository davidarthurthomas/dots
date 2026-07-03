# Source material: Robert Martin, Clean Code, ch. 2 "Meaningful Names"

The most-cited chapter on naming. The book as a whole is contested; the chapter's specific rules hold up and are mined here selectively. Distilled from the book; paraphrase throughout, no verbatim quotes.

## Rules worth keeping

- **Intention-revealing names.** The name should answer why the thing exists, what it does, and how it's used. `elapsedTimeInDays` over `d`; if a name requires a comment to explain it, the name failed.
- **Avoid disinformation.** Never let a name imply something false: `accountList` for something that isn't a list, a name that shadows a platform term, `l` and `O` where they read as `1` and `0`. A vague name wastes the reader's time; a wrong one plants a bug.
- **Make meaningful distinctions.** If two names differ, the things must differ, and the name should say how. Noise words fail this: `ProductInfo` versus `ProductData` distinguishes nothing, and `a1`, `a2` distinguish only position. This is also the case against number-series names.
- **Pronounceable and searchable.** Code is discussed aloud and grepped constantly. `generationTimestamp` can be said in a meeting and found in a search; `genymdhms` can do neither. The searchability rule also argues for named constants over magic numbers, since you can search for `MAX_CLASSES_PER_STUDENT` and can't usefully search for `7`.
- **Classes are nouns, methods are verbs.** A class name is a noun phrase (`Customer`, `AddressParser`), never a verb and never a catch-all (`Processor`, `Data`, `Info`). Method names are verb phrases (`postPayment`, `deletePage`).
- **One word per concept.** Choose one of `fetch`, `retrieve`, `get` and use it everywhere; a reader who meets two of them assumes a difference that isn't there.
- **Don't pun.** The inverse rule: never use one word for two ideas. If `add` means arithmetic in one class and appending in another, one of them needs a different word.
- **Solution domain and problem domain.** Programmer terms are fine where they're the precise word (`visitor`, `queue`, `factory` in its pattern sense); everywhere else, use the domain's word, which also means the reader can ask a domain expert what it means.
- **Context, exactly enough.** Add context that meaning requires (`addrState` in a grouping of address fields, or better, an `Address` type), and none that it doesn't: prefixing every name in an application with the application's initials gives every search a thousand hits and every name a dead syllable.
