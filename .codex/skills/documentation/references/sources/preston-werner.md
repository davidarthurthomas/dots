# Source material: Tom Preston-Werner, "Readme Driven Development"

From tom.preston-werner.com (2010). Quotes are verbatim.

## The rule

> Write your Readme first. First. As in, before you write any code or tests or behaviors or stories or ANYTHING.

## The argument

**Implementation quality can't rescue a wrong interface.**

> A perfect implementation of the wrong specification is worthless.

And the corollary: "a beautifully crafted library with no documentation is also damn near worthless." Code that nobody can figure out how to use might as well not exist.

**Prose is the cheapest place to design.** Writing the README gives you "a chance to think through the project without the overhead of having to change code every time you change your mind." The public interface gets designed, revised, and discarded in a medium where revision costs nothing, before any of it hardens into code.

**Docs written after shipping go stale or never get written.** Writing documentation up front captures the initial knowledge and enthusiasm; retrofitting it onto finished code is a drag, so it gets skipped, or written thin, or goes stale immediately.

**The README is the project's public contract.** It's the first thing a user sees, so writing it first means the project is specified from the user's side of the interface inward.

**A written interface unblocks everyone else.** Teammates can build against the documented interface before the implementation exists, and "it's a lot simpler to have a discussion based on something written down."

## Placement in the workflow

RDD sits before TDD: one abstraction level up, designing the interface the tests will then pin down. He frames writing the README as the true act of creation; tests and code follow from it.
