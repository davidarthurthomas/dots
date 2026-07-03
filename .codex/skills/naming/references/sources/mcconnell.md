# Source material: Steve McConnell, Code Complete, ch. 11 "The Power of Variable Names"

The most thorough single treatment of naming, and one of the few grounded in research. Distilled from the book; paraphrase throughout, no verbatim quotes.

## The fundamental rule

A good name fully and accurately describes the entity it represents. The most effective technique is to state in words what the variable represents and use that statement as the name: the number of people on the US Olympic team is `numberOfPeopleOnTheUsOlympicTeam`; trim from there. Accuracy matters more than cleverness: a name that describes the thing wrongly is worse than one that describes it vaguely.

## Problem orientation

Name things after the problem, not the solution: what, not how. `employeeData`, not `inputRec`; `printerReady`, not `bitFlag`. A name drawn from the problem domain survives changes to the implementation; a name drawn from the mechanism goes stale the first time the mechanism changes.

## Optimal length

He cites a study (Gorla, Benander, and Benander) finding that debugging effort was minimized when variable names averaged roughly 10 to 16 characters. The point is the shape of the curve, both tails cost you: cryptically short names force decoding, and very long names bury the differences between related names. Scope moderates the rule; short names suit short scopes, longer names suit wider ones.

## Conventions worth stealing

- **Computed-value qualifiers go at the end, consistently.** `revenueTotal`, `revenueAverage`, `revenueMax`: the modified thing first, the qualifier last, and the same order everywhere so related names sort and scan together. Avoid `num` as a qualifier; it's ambiguous between a count and an index (`customerCount` and `customerIndex` are each precise).
- **Booleans.** Use names that imply true or false (`done`, `error`, `found`, `success`), give them positive forms (`found`, never `notFound`), and prefer the specific claim over the general one when there is one.
- **Loop indexes.** `i`, `j`, `k` are fine for tight loops; the moment the index outlives the loop or the loops nest meaningfully, it earns a real name (`teamIndex`, `eventIndex`).
- **Named constants.** Name the meaning, never the value: a constant named after its value has nothing left to say when the value changes.
- **Abbreviations.** If you must abbreviate, do it consistently (one abbreviation per word, project-wide), keep results pronounceable, and document the scheme. Never abbreviate one occurrence and spell out another.

## Names to avoid

Names that differ only in capitalization or in easily confused characters; names with numerals where the numeral hides a real distinction; misspelled names (the reader can't guess which misspelling you chose); names with ambiguous or multiple common meanings; names that differ from each other by one or two letters or that sound alike when read aloud.
