---
name: documentation
description: >
  Decide what to document and write it well: comments, docstrings and doc blocks, READMEs, docs
  pages, API reference. Use when writing or reviewing comments, deciding whether a comment is
  warranted, documenting a function, module, or feature, writing or restructuring a README or docs
  site, or choosing where a piece of documentation belongs. Triggers on "comment", "docstring",
  "document this", "README", "docs".
global_category: Engineering
---

# Documentation

Documentation principles, grounded in the canon:

- [Ousterhout, _A Philosophy of Software Design_, chs. 12, 13, 15, 16](references/sources/ousterhout.md)
- [antirez, _Writing system software: code comments_](references/sources/antirez.md)
- [Henney, _Comment Only What the Code Cannot Say_](references/sources/henney.md)
- [McConnell, _Code Complete_, ch. 32](references/sources/mcconnell.md)
- [Procida, _Diátaxis_](references/sources/diataxis.md)
- [Preston-Werner, _Readme Driven Development_](references/sources/preston-werner.md)
- [Google, style guides and technical writing courses](references/sources/google.md)

Prose craft for any of this (sentences, registers, AI tells) is the `write-like-dave` skill; the boundary between a comment and a better name is the `naming` skill.

## Language

Each rule below names one way of writing a phrase that sounds precise while stating no fact about the system. When you cannot write the replacement, you do not know the fact yet: read the code, or say what you do know.

**Name the operation.** "Carries", "holds", "takes", "handles", "deals with", "works with", and "involves" are verbs of possession and generic activity. Write the operation: not "the request carries a user ID" but "encodes the ID in the `X-User-Id` header"; not "the cache holds a token" but "stores the token under a key until the TTL expires"; not "takes a callback" (the signature already says so) but "invokes the callback once per row".

**Name the mechanism, not a figure of speech for it.** Machines do not want, try, decide, panic, or get unhappy, and idiom from speech ("kick the tires", "the long pole") does not survive dialect or translation. Write the behavior and its trigger: not "the worker gives up when the queue gets unhappy" but "the worker stops retrying after the fifth consecutive timeout". Metaphors with exact technical definitions (handshake, deadlock, starvation, heartbeat, garbage collection) are the right words.

**Name the object, not the product.** "Postgres" names a program; the system has a client library, a connection pool, a server process, a cluster node, and each fails differently. "A" before a product name, or a plural, is the tell. "Spin up a Postgres" is "start a Postgres server container".

**Give the state as an observation.** Not "a saturated Postgres", "a dirty cache", "a bad connection": say what a reader could measure to find the same state, e.g. "a pooled connection whose server did not answer within the 2s socket timeout". A state nobody can check is a guess written as a fact.

**When a term has more than one technical meaning, say the operation in ordinary words.** "Round trip" is network latency in protocol work and serialize-then-deserialize-and-compare in serialization work; "commit", "buffer", "stream", "handle", "block" each have several meanings. In code that makes network calls, a bare "round trip" could mean either, so write the operation: "serializes to JSON and parses back unchanged". If no technical field uses the term the way you are using it, you are guessing at its meaning: ordinary words again.

## Comments

**Comment what the code cannot say.** Code is mostly self-documenting. Use clear names and small, well-factored functions and you won't need comments. Do not write comments that restate what the code already says. Reserve comments for the *why* the code cannot express: non-obvious constraints, tradeoffs, or context. A comment that parrots the code is noise; a comment explaining what the code should say is an invitation to rename or extract until the code says it. Wrong comments are worse than none: nothing catches them, and they teach readers to skip all comments.

**Self-documenting code still can't say everything.** Mostly is not entirely: Ousterhout calls "good code is self-documenting" a delicious myth, because rationale, side effects, units, boundary conditions, ownership, and usage constraints have no expression in code. "If users must read the code of a method in order to use it, then there is no abstraction." Lower-level comments add precision (units, inclusive or exclusive bounds, what null means, invariants); higher-level comments add intuition (what this block is trying to do, and why).

**The comments worth writing.** antirez's taxonomy from the Redis source. Function comments let the reader skip the body entirely and double as API reference that changes in the same edit as the code. Design comments at the top of a file give the algorithm and its rationale. Why comments "explain the reason why the code is doing something, even if what the code is doing is crystal clear," especially why it avoids the more natural-looking alternative. Teacher comments teach the domain (the math, the protocol) so readers outside it can follow. Checklist comments say what else must change when this changes. The three to avoid: trivial comments (cost more to read than the code they annotate), debt comments (a bare `TODO` where a reason should be), and backup comments ("source code is not for making backups").

**Interface comments define the abstraction.** A caller must be able to use a thing from its comment alone. Keep implementation out of interface comments: documentation that can only describe behavior by describing implementation marks a shallow abstraction. Inside a method, comment what a block is doing and why, never how; the code is the how.

**Avoid comments that will quickly drift out of date.** Before writing a comment, ask whether it can become wrong without the line next to it changing. If it can, don't write it. This rules out counts ("the three callers of this function"), lists of usage sites, descriptions of code that lives elsewhere, and anything comparing to "the old way" or "the new way": all of these go stale silently, and a stale comment is worse than none.

**No breadcrumbs.** Write comments about the code as it is now. When you remove code, do not leave a comment explaining why. When you edit code, do not leave a comment referencing a previous implementation. Never leave a comment explaining where a field or function is used.

**No comments about future work.** Comments describe the code as it is, not what it will become. Do not write comments that anticipate planned changes, unbuilt features, or work happening elsewhere, e.g. "this will also handle the cancelled state once that flow exists." A reader cannot tell whether such a comment is stale, and it ages into a lie the moment the plan shifts.

The one exception is a concrete, actionable task on the current code: mark it with a `TODO:` comment. A `TODO:` is appropriate only when all of these hold: it names a specific change to *this* code, it is something a reader could act on now, and the code is correct as written without it. It is not a place to narrate roadmap, speculate about future design, or excuse a half-built abstraction.

**No banner comments.** Don't decorate code with block comments that draw section dividers or ASCII rules, like:

```
// ---------------------------------------------------------------------------
// Notes
// ---------------------------------------------------------------------------
```

If a file needs that kind of signposting to be navigable, split it into multiple files.

**Pick one of two registers for a comment.** Either a terse fragment labeling one value or line ("5 minutes" on a millisecond literal, "exclude events before the cutoff") or a plain-English explanation in simple, full sentences. Nothing in between. Never use jargon or AI-isms like em dashes.

**Document as close to the code as possible.** When a comment is warranted, put it next to the line it explains, not in a summary somewhere above. Do not describe a method's full behavior in its doc block and then leave the implementation uncommented: that splits the explanation from the code and lets the two drift apart. Use the doc block for the contract callers need (purpose, params, returns, invariants); explain the *why* of a specific step with an inline comment on that step.

**Comments belong in the code, not the commit log.** A future reader of the code will never excavate the commit history for the explanation. Update comments as part of the change, and check the diff before committing to confirm the documentation moved with the code. Document each design decision exactly once, in the most obvious place; if it's already documented somewhere, reference it rather than restating it.

**Show a concrete example when the shape of a value is not obvious from the code.** When you build a string with interpolation, add an inline comment showing a sample of the result, so a reader sees the final shape without running it in their head. The same applies to anything where the literal output matters more than the expression that produces it:

- **String interpolation / formatting.** `` `${user.id}-${slug}` `` → `// "4821-acme-co"`
- **Regular expressions.** Show one string that matches and, if the boundary is subtle, one that doesn't.
- **Date, time, and number format strings.** Show what the format renders, e.g. `"yyyy-MM-dd"` → `// 2026-06-30`.
- **Parsers and non-trivial transforms.** Show a small input and its corresponding output, so the mapping is legible at a glance.
- **Encoded or packed values.** Bitfields, base64, URL params, and similar: show a decoded example.

Keep the example terse and real (a value the code would actually produce), and put it on the line it illustrates.

**Write the comment first.** Comments are a design tool, written while designing rather than after; delayed comments mostly never get written, and by then the rationale has evaporated. Write the interface comment before the body, and let it test the design: "if you find it difficult to write such a comment, that's an indicator that there might be a problem with the design of the thing you are describing" (Ousterhout's Hard to Describe red flag, the comment counterpart of a hard-to-pick name). antirez: "comments are rubber duck debugging on steroids", addressed to a future reader who will judge whether what you're stating is acceptable.

## Documentation

**Write docs in one mode at a time.** Diátaxis: a document teaches (tutorial), directs a real task (how-to), describes the machinery (reference), or deepens understanding (explanation). "Crossing or blurring the boundaries described in the map is at the heart of a vast number of problems in documentation": a tutorial that explains strands the learner, a how-to that teaches buries the task, reference that instructs stops being trustworthy description. Two compass questions place any piece of writing: does it inform action or cognition, and does it serve the acquisition of skill or its application?

**Per-mode rules.**

- *Tutorial*: a lesson whose deliverable is the learner's competence. One narrow, perfectly reliable path; visible results at every step; concrete before abstract; no choices, no alternatives, and no explanation ("the first rule of teaching is simply: don't try to teach").
- *How-to*: directions for a real task from real life, serving "the already-competent user." Conditional imperatives ("If you want x, do y"), a title that names the task. Usability beats completeness; no teaching, no background.
- *Reference*: neutral description of the machinery, structured to mirror the code so both can be navigated in parallel. Austere, consistent, authoritative, deliberately boring. Describe, never instruct; examples illustrate, never teach.
- *Explanation*: the one place for rationale, history, tradeoffs, alternatives, and opinion. "About X" framing, scoped by an implied why-question. No steps, no close-up detail.

**Improve docs one page at a time.** Never build empty tutorial/how-to/reference/explanation scaffolding and hope it fills in. Pick one page or paragraph, ask what user need it serves and how well, make the single next improvement completely, repeat. Documentation stays complete at every stage and finished at none.

**Write the README first.** Before the code: "a perfect implementation of the wrong specification is worthless." The README designs the public interface in prose, where changing your mind is free; it captures the knowledge while the enthusiasm exists (docs written after shipping go stale or never get written); and a written interface lets others build against it and gives design discussion something concrete to grip.

**Define the audience before writing.** Identify the reader's role and their proximity to this knowledge, then state what they'll be able to do after reading. The curse of knowledge is the default failure: experts make passing reference to subtleties newcomers can't follow, so state prerequisites explicitly. Address the reader as "you", use active voice and present tense, and put conditions before instructions ("If you want to delete the file, click Delete").
