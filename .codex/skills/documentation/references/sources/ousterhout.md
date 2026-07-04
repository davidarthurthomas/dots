# Source material: John Ousterhout, A Philosophy of Software Design, chs. 12, 13, 15, 16

Four chapters on comments: why to write them, what belongs in them, when to write them, and how to keep them alive. Quotes marked as red flags or attributed are verbatim; the rest is close paraphrase cross-checked against his Stanford CS190 lecture notes and multiple independent reading notes.

## The four excuses (ch. 12)

His framing: comments capture design information that exists only in the designer's mind. Without them there is no way to hide complexity, because a caller who must read a method's body to use it has gained nothing from the abstraction.

> If users must read the code of a method in order to use it, then there is no abstraction.

1. **"Good code is self-documenting."** He calls this "a delicious myth". Names and structure carry a lot, and still cannot express rationale, side effects, usage constraints, units, or the informal parts of an interface.
2. **"I don't have time."** Comments cost roughly a tenth of development time and repay it many times over in maintainability.
3. **"Comments get out of date and become misleading."** Keeping them current is cheap if they sit near the code, avoid duplication, and get checked in review. Large comment rewrites accompany only large code changes.
4. **"All the comments I've seen are worthless."** The one excuse with merit: most comments are bad. The answer is learning to write good ones.

## What belongs in a comment (ch. 13)

The governing principle: comments should describe things that are not obvious from the code.

> Comment Repeats Code: If the information in a comment is already obvious from the code next to the comment, then the comment isn't helpful.

The test: could someone who has never seen the code write the comment just by looking at the code next to it? If yes, delete it. Corollary: use different words in the comment than in the name of the thing it describes.

Two categories, plus one:

- **Interface comments** precede a declaration and give a caller everything needed to use the thing. The interface comment is the abstraction: code cannot describe abstractions, so if you want one, write it down.
- **Implementation comments** live inside a method and explain what a block is doing and why, never how; the code shows the how. One comment before each major phase; explain loops by what an iteration accomplishes.
- **Cross-module comments** document design decisions that span modules, in one central, discoverable place.

Two directions of value:

- **Lower-level comments add precision.** Units, inclusive or exclusive boundaries, whether null is allowed and what it means, ownership of resources, invariants. Precision fills in what the code understates.
- **Higher-level comments add intuition.** What is this code trying to do, what is the most important thing about it. Intuition survives implementation changes.

> Implementation Documentation Contaminates Interface: This red flag occurs when interface documentation, such as that for a method, describes implementation details that aren't needed in order to use the thing being documented.

An interface comment that can only describe behavior by describing implementation marks a shallow abstraction.

## Write the comments first (ch. 15)

Comments are part of the design process, written while designing rather than after. His procedure: write the class interface comment first, then interface comments and signatures for the important methods with empty bodies, iterate until the structure feels right, then comment the key instance variables, and fill in bodies last. Delayed comments mostly never get written, and by then the rationale has evaporated.

The payoff is design feedback. Comments are the canary in the coal mine of complexity:

> Hard to Describe: The comment that describes a method or variable should be simple and yet complete. If you find it difficult to write such a comment, that's an indicator that there might be a problem with the design of the thing you are describing.

A long or complicated interface comment means a complicated abstraction; fix the design, never the comment.

## Keeping comments alive (ch. 16)

- **Keep comments near the code they describe.** Distance breeds drift. For a multi-phase method, comment each phase inline rather than one block in the header. Interface comments stay abstract precisely so implementation edits don't invalidate them.
- **Update comments as part of the change.** Check the diff before committing to confirm the documentation moved with the code; review is the enforcement point.
- **"Comments belong in the code, not the commit log."** A future reader of the code will never think to excavate the commit history; anything they need lives in the source.
- **Document each decision exactly once**, in the most obvious place. If no single obvious place exists, add a central design-notes file and reference it from the code. If it's already documented elsewhere, reference it; duplicated documentation drifts.
