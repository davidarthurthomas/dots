# Source material: Google on comments and technical writing

From three Google sources: the developer documentation style guide (developers.google.com/style), the technical writing courses (developers.google.com/tech-writing), and the comments section of the C++ style guide (google.github.io/styleguide). Quotes are verbatim.

## Comments (from the style guide for code)

The philosophy:

> While comments are very important, the best code is self-documenting. Giving sensible names to types and variables is much better than using obscure names that you must then explain through comments.

The audience:

> Write for your audience: the next contributor who will need to understand your code. Be generous - the next one may be you!

The rules worth carrying anywhere:

- **Declaration comments describe use; definition comments explain why.** A comment on a function's declaration tells a caller what it does and how to call it (start with a verb phrase: "Opens the file"); a comment inside the definition explains "why you chose to implement the function in the way you did rather than using a viable alternative" (why a lock covers the first half of the function but not the second).
- **Document the contract's edges.** Inputs and outputs, behavior on null, ownership of pointers and resources, synchronization assumptions, performance implications; for a class, enough to know how and when to use it, ideally with a small usage example.
- **Comment only the non-obvious.** "Do not be unnecessarily verbose or state the completely obvious." A destructor commented "destroys this object" is the canonical failure. Implementation comments belong only in tricky, non-obvious, or important parts.
- **Prefer a code change to a comment.** A magic literal becomes a named constant; a bare boolean argument becomes an enum or named parameter; an inscrutable expression becomes a named variable. Comment only what no such change can express.
- **Variables:** the name carries the meaning; comment only invariants and sentinel values ("-1 means the table size is unknown").

## Documentation (from the tech-writing courses and style guide)

- **Define the audience before writing.** Identify the reader's role, then their proximity to the knowledge; role alone isn't enough, because an engineer new to this project and an engineer who built it need different documents. Then state what the reader will be able to do afterward, as concrete objectives.
- **Beware the curse of knowledge.** Experts' understanding of a topic ruins their explanations of it; they make passing reference to subtleties a newcomer can't follow. State prerequisites explicitly rather than assuming them, avoid idioms, and "prefer simple words over complex words."
- **Second person, active voice, present tense.** Address the reader as "you"; make clear who performs each action; describe general behavior in the present tense (future tense only for genuinely future events, and never the hypothetical "would").
- **Conditions before instructions.** The reader must know the condition before acting: "If you want to delete the file, click Delete", never the reverse.
- Mechanics that generalize: descriptive link text, sentence-case headings, numbered lists only for actual sequences, code in code font.
