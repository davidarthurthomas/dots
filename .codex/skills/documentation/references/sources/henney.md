# Source material: Kevlin Henney, "Comment Only What the Code Cannot Say"

Chapter 17 of _97 Things Every Programmer Should Know_ (Henney edited the book and wrote this entry). Quotes are verbatim.

## The argument

Commenting is taught as unconditionally good practice, and in theory it sounds worthy: offer the reader detail. Practice reveals the failure modes.

**Wrong comments are worse than none.** He cites Kernighan and Plauger:

> A comment is of zero (or negative) value if it is wrong.

No compiler catches a wrong comment and no test fails because of one; it persists silently as a source of distraction and misinformation. Worse, unreliable comments train readers to distrust and skip all comments, which destroys the value of the good ones too.

**Correct but redundant comments are noise.**

> Comments that parrot the code offer nothing extra to the reader: stating something once in code and again in natural language does not make it any truer.

Commented-out code falls under the same verdict: clutter, and a version-control job.

**A comment describing what the code does is a confession.** The code is the primary expression; a comment that merely restates it means the code failed to express itself.

> A comment explaining what a piece of code should already say is an invitation to change code structure or coding conventions so the code speaks for itself.

The prescribed responses: "Instead of compensating for poor method or class names, rename them. Instead of commenting sections in long functions, extract smaller functions whose names capture the former sections' intent."

## The rule

> Comment what the code cannot say, not simply what it does not say.

Reserve comments for what code structurally cannot convey: intent, rationale, constraints. A comment is a last resort for meaning, never the default channel.
