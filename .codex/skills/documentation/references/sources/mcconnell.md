# Source material: Steve McConnell, Code Complete, ch. 32 "Self-Documenting Code"

The survey treatment of commenting, and the origin of much conventional wisdom about it. Distilled from the book; paraphrase throughout, no verbatim quotes.

## The hierarchy

Documentation quality is decided mostly below the comment level: good program structure, clear names, well-factored routines, and straightforward control flow document a program better than any commentary laid over bad code. Comments are the icing; the code is the cake. His running question for any would-be comment: could this information be moved into the code itself (a name, a constant, an extracted routine)? Only what can't move earns a comment.

## The six kinds of comments

His taxonomy, ordered from worthless to valuable:

1. **Repeat of the code.** Says in different words what the statement already says. Delete.
2. **Explanation of the code.** Explains confusing code. Usually the code should be fixed instead; confusing code is the bug, the comment is a bandage.
3. **Marker.** A note to self (TODO-style) not intended to stay. Fine while working; standardize the marker so it can be found, and don't ship them casually.
4. **Summary of the code.** Distills several lines into one sentence, so a reader can scan the summary instead of the statements. Valuable, especially for readers navigating quickly.
5. **Description of the code's intent.** Explains the purpose at the problem level (what this section is for) rather than the solution level (what these statements do). The most valuable routine-level comment.
6. **Information that cannot possibly be expressed by the code.** Copyright, references to the requirement or algorithm source, units, ranges, and other external context.

Good commenting practice lives almost entirely in the last three.

## Working rules

- **Comment at the level of intent.** Describe what the block is for, in problem-domain terms; a reader should be able to follow the routine by reading only its comments.
- **Comment as you go, not after.** Comments deferred to a documentation pass at the end mostly never happen, and cost more when they do. If commenting feels expensive in the moment, the usual cause is code that's hard to describe, which is a design signal.
- **Don't comment tricky code; rewrite it.** Code so complicated it needs line-by-line narration needs simplification more than narration.
- **Endline comments only for data.** A comment squeezed to the right of a statement can't say anything useful about the statement; but on a data declaration ("in milliseconds", "range 0-100") it's exactly right.
- **Keep maintenance in mind while writing.** Style choices that make comments expensive to maintain (aligned asterisk boxes, decorated banners) get abandoned under deadline, and then the decoration outlives the accuracy. Plain comments that are easy to edit stay true.
- **Document surprises and violations of expectations.** If the code does something a reasonable reader wouldn't expect (a performance workaround, an order dependency, an odd constant), that's precisely what must be written down.
