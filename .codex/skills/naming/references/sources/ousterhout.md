# Source material: John Ousterhout, A Philosophy of Software Design, ch. 14 "Choosing Names"

Distilled from the chapter. The two red-flag definitions and the Gerrand rule are verbatim; the rest is close paraphrase.

## Names are a form of abstraction

A name provides a simplified way of thinking about a more complex underlying entity. Good names are a form of documentation: they make code easier to understand, reduce the need for other documentation, and make errors easier to detect.

## The image test

The goal when naming is to create an image in the reader's mind of what the thing is, and as important, what it is not. The test: if someone sees the name in isolation, without the declaration, its documentation, or the surrounding code, how closely can they guess what it refers to? Is there another name that paints a clearer picture?

## Precision

Good names have two properties, precision and consistency, and most bad names fail on precision.

> Vague Name: If a variable or method name is broad enough to refer to many different things, then it doesn't convey much information to the developer and the underlying entity is more likely to be misused.

His usual suspects: `count`, `status`, `result`, `data`, bare `x` and `y` for things that aren't coordinates. Booleans should read as predicates (`cursorVisible`). Two qualifications: very short names are fine when the entire scope is a few lines (`i` in a small loop), and a name can also be too specific, misrepresenting a general-purpose entity.

The cautionary tale: in the Sprite operating system's file system, a variable named `block` sometimes held a logical block number and sometimes a physical one. One assignment site mixed them up and corrupted data on disk; the bug took about six months to find, partly because every reader saw `block` and assumed it held the right kind. As `fileBlock` and `diskBlock`, the bug is impossible to miss.

## Hard to name is design feedback

> Hard to Pick Name: If it's hard to find a simple name for a variable or method that creates a clear image of the underlying object, that's a hint that the underlying object may not have a clean design.

Naming difficulty is not a wordsmithing problem. The fix is usually to refactor the entity, not to brainstorm harder.

## Consistency

Consistent naming lets a reader learn a name once and reuse the knowledge everywhere. Three requirements: always use the common name for the given purpose; never use it for anything else; keep the purpose narrow enough that everything wearing the name behaves the same. Same thing, same name everywhere; different things, different names (the `block` bug is the violation case).

## Name length

He rejects brevity-first naming (the Go tradition of `i`, `b`, `ch` everywhere): single characters force readers to deduce meaning, and keystrokes are cheaper than reader effort. But names should also carry no words that add nothing (`file`, not `fileObject`). He endorses Andrew Gerrand's rule as the compromise:

> The greater the distance between a name's declaration and its uses, the longer the name should be.
