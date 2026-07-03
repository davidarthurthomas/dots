## Environment

macOS with Homebrew. 

Dotfiles managed via a bare git repo. See /Users/davidthomas/README.md. 

Node managed with [mise](https://mise.jdx.dev/).

## Git Workflow

I care about clean, readable history. Each commit should tell a story.

**Keep a clean history.** Commit as you go - each commit should be atomic and the code should pass project diagnostics at every point. You should rebase, squash, and reorder commits to keep a clean, readable history.

**What you must never do:** Push, force push, reset, delete branches, or discard changes. These are destructive or affect the remote.

**Write commit messages in present-tense imperative mood.** "Add login form".

**The `gh` CLI is available.** Use it to create and edit PRs, and always assign PRs to me.

**PR titles.** Use present-tense imperative, no prefixes, and no trailing period. Keep it under ~60 characters and describe the primary change. Only include a Linear issue ID in the title if the branch name does not already include that ID.

**PR descriptions.** If the PR is small enough, a description is not necessary. Otherwise, write 2 sentences max explaining what changed and why, then list major decisions as bullets ordered by importance and risk. Do not include minor implementation details or a testing section.

Good example:
```
Reduce database round-trips by batching user lookups.
This keeps the endpoint fast under load without changing behavior.

- Batch by account_id to match the most common access pattern.
- Keep the existing query shape to avoid widening the API response.
```

## Communication

Be direct. Tell me what you did, what you found, or what you need. Skip pleasantries and filler.

**No time estimates or project predictions.** Don't estimate how long something will take, how many PRs it will require, or how significant a change is. Just do the work.

**Don't negotiate scope down.** If I ask for something, build it. Don't suggest cutting features, deferring parts to "follow-up PRs," or simplifying the ask because it seems like a lot of work. If something is blocked or ambiguous, say so - but "this would take a while" is not a reason to push back.

**One session, one PR.** Unless I say otherwise, assume everything I ask for in a session belongs in a single PR.

Flag breaking changes before making them. Don't ship breaking changes without explicit approval.

### Before You Hand Off

When you finish a task:

1. Run the project's diagnostics (typecheck, lint, tests - depends on the project) to make sure the code passes
2. Summarize what changed and reference the files
3. Call out any TODOs or follow-up work I should know about

## Approach

**Keep it simple.** Favor plain, readable code that says exactly what it does — `if (shouldDoSomething) doSomething();`. Prefer the most direct solution that solves the problem in front of you, and don't build for requirements that don't exist yet.

**Separation of concerns.** Keep distinct responsibilities in distinct units.

**Avoid hasty abstractions.** Prefer duplication on the first pass. Wait until a pattern has repeated enough that its shape is obvious before extracting it.

**Functional core, imperative shell.** Keep decision-making logic pure and free of side effects. Push I/O, mutation, and other effects out to a thin shell that wraps the core.

**Values at boundaries.** Have components communicate through plain data and value objects rather than sharing mutable state.

**Leave the code better than you found it.** Your code will be copied and imitated by other engineers and AI agents, so set the standard you want repeated.

**Fight entropy debt.** Refactor surrounding code so the whole reads as if written with your change in mind — rename what's now misleading, move logic that now lives in the wrong place. Don't just graft new behavior onto a system built for outdated requirements.

## Documentation

Code is mostly self-documenting, and we should always strive to write code that is self-documenting. Use clear names and small, well-factored functions and you won't need comments. Do not write comments that restate what the code already says. Reserve comments for the *why* the code cannot express: non-obvious constraints, tradeoffs, or context.

**Avoid comments that will quickly drift out of date.** Before writing a comment, ask whether it can become wrong without the line next to it changing. If it can, don't write it. This rules out counts ("the three callers of this function"), lists of usage sites, descriptions of code that lives elsewhere, and anything comparing to "the old way" or "the new way" — all of these go stale silently, and a stale comment is worse than none.

**No breadcrumbs.** Write comments about the code as it is now. When you remove code, do not leave a comment explaining why. When you edit code, do not leave a comment referencing a previous implementation. Never leave a comment explaining where a field or function is used.

**No comments about future work.** Comments describe the code as it is, not what it will become. Do not write comments that anticipate planned changes, unbuilt features, or work happening elsewhere — e.g. "this will also handle the cancelled state once that flow exists." A reader cannot tell whether such a comment is stale, and it ages into a lie the moment the plan shifts. 

The one exception is a concrete, actionable task on the current code: mark it with a `TODO:` comment. A `TODO:` is appropriate only when all of these hold: it names a specific change to *this* code, it is something a reader could act on now, and the code is correct as written without it. It is not a place to narrate roadmap, speculate about future design, or excuse a half-built abstraction.

**No banner comments.** Don't decorate code with block comments that draw section dividers or ASCII rules, like:

```
// ---------------------------------------------------------------------------
// Notes
// ---------------------------------------------------------------------------
```

If a file needs that kind of signposting to be navigable, split it into multiple files.

**Pick one of two registers for a comment.** Either a terse fragment labeling one value or line ("5 minutes" on a millisecond literal, "exclude events before the cutoff") or a plain-English explanation in simple, full sentences. Nothing in between. Never use jargon or AI-isms like em dashes.

**Document as close to the code as possible.** When a comment is warranted, put it next to the line it explains, not in a summary somewhere above. Do not describe a method's full behavior in its JSDoc/docstring and then leave the implementation uncommented — that splits the explanation from the code and lets the two drift apart. Use the doc block for the contract callers need (purpose, params, returns, invariants); explain the *why* of a specific step with an inline comment on that step.

**Show a concrete example when the shape of a value is not obvious from the code.** When you build a string with interpolation, add an inline comment showing a sample of the result, so a reader sees the final shape without running it in their head. The same applies to anything where the literal output matters more than the expression that produces it:

- **String interpolation / formatting.** `` `${user.id}-${slug}` `` → `// "4821-acme-co"`
- **Regular expressions.** Show one string that matches and, if the boundary is subtle, one that doesn't.
- **Date, time, and number format strings.** Show what the format renders, e.g. `"yyyy-MM-dd"` → `// 2026-06-30`.
- **Parsers and non-trivial transforms.** Show a small input and its corresponding output, so the mapping is legible at a glance.
- **Encoded or packed values.** Bitfields, base64, URL params, and similar — show a decoded example.

Keep the example terse and real (a value the code would actually produce), and put it on the line it illustrates.

## Style

**Use consistent terminology.** Pick one term for each concept and use it everywhere — in names, comments, documentation, and conversation. Do not reach for synonyms or close approximations; varied wording for the same thing makes a reader wonder whether you mean something different.

## Naming

Names do most of the documenting in a codebase, so choose them deliberately. The full treatment, with sources, lives in the `naming` skill; these rules carry the most weight:

**Judge the name at the call site.** A name is declared once and read at every call site, so write out a realistic use and read it as a sentence. Every word must tell the reader something that site doesn't already; drop words that repeat type information (`views.remove(cancelButton)`, not `views.removeElement(cancelButton)`).

**Name the role and the intent.** Name a parameter for its part in this function (`supplier` over `widgetFactory`); name a method for why callers care (`beginTrackingOrder()` over `saveOrderAndRefreshScreen()`). The weaker the type (string, int, dict), the harder its name must work.

**Be precise.** `data`, `info`, `result`, `item`, `process`, `handle`, and the `-Manager`/`-Helper`/`-Util` suffixes admit the concept was never identified. Draw names from the domain's vocabulary, one term per concept (see Style), and prefer one rich word to a compound: `calendar`, not `appointmentList`.

**Length scales with scope.** The farther a name's uses sit from its declaration, the longer it should be: `i` is fine in a three-line loop, and a module-level name earns more words. Spell words out; abbreviate only what a web search would resolve (`id`, `max`).

**Grammar carries semantics.** A function with side effects is an imperative verb phrase (`x.sort()`); a pure one is a noun phrase or participle (`x.sorted()`). A boolean reads as a positive assertion: `isEmpty`, `cursorVisible`, never `notSuccessful`.

**Hard to name is design feedback.** When no precise name fits, the code has too many responsibilities or the abstraction is wrong; fix the design and the name follows. Until understanding arrives, an honest awkward name beats a plausible false one, and every new insight is a rename.

## Testing

Tests are how you change code without holding your breath. So don't ask whether a test passes. Ask whether it's a good test, and keep a list of what you want from one. Hold each test up to these. If it misses one, that's the thing to fix.

**Structure-insensitive.** A good test doesn't care how you wrote the code, only what the code does. You should be able to tear out the insides of a function, put them back a different way, and if the behavior is the same, the test stays green. If you rename a private helper and a test breaks, that test was watching your typing, not your behavior. Test what a caller can see: what goes in, what comes out, what changes in the world.

**Behavioral and specific.** Two things. If the behavior changes, some test should go red, or the test isn't earning its keep. And when it goes red, you want to know what broke without opening the file. The name should tell you. `returns the cached value on the second call` tells you. `test cache 2` tells you nothing. Keep each test to one claim, so a failure means one thing.

**Fast and deterministic.** If the suite is slow, you stop running it, and a test you don't run is worthless. If a test fails at random, you learn to shrug at red, and now green means nothing either. Both are worse than no test, because they cost you trust. Same inputs, same answer, whatever order you run things in. How fast and how steady a test is comes down to how much it touches.

**Rooted in the functional core.** Split a program in two. In the middle is the logic that makes decisions: pure calculation, no talking to the outside world. Around it is a thin layer that talks to the database, the network, the screen. Gary Bernhardt calls it a functional core in an imperative shell. The core is a joy to test. Hand it values, check the values it hands back, cover every edge and every failure. It needs nothing else to run, so the tests are fast. Keep the shell thin and a few end-to-end tests will cover it. Don't write a pile of little tests for plumbing just to move a number.

**Sparing with mocks.** Reach for real objects first. Most of the time, once you've split the core from the shell, you don't need a mock at all, because the core is just values in and values out. When you do need one, put it at an edge you own: the clock, the network, the disk. Don't mock someone else's library from the inside. You don't really know how it behaves, so a mock of it is just your guess wearing a costume. And if a test is mostly mocks, you're testing your guesses, not your code. Some people use mocks the other way, to drive the design. That works for them. It's not how you do it here, and know that's a choice, not a law.

**Readable as a bug report.** When a test fails, it should read like a bug report: here's what you expected, here's what you got. Set things up, do the thing, check the result, in that order, with the check at the end where you can see it. No logic in the test. If there's a loop or an `if` deciding what to check, now you have to debug the test, and you didn't sign up for that.

**Triggered by a behavior, not a class.** Write a test when there's a new behavior to pin down or a bug to reproduce, not one per class out of habit. A failing test before a fix does two jobs: it shows you the bug is real, and it tells you the moment it's gone. A test next to new code writes down the promise that code is making. Tests added later just to raise the coverage number tend to freeze the code the way it is, bugs and all.

## Reminders

IMPORTANT: Most codebases have existed for a long time with many contributors. Because of this, they are often full of many styles, riddled with debt, and inconsistent from one corner to the next. It may seem tempting to just blindly copy the existing patterns you find, but don't. My explicit instructions, these instructions, my skills, the project's instructions, and the project's skills are your primary directive. Follow them over whatever the surrounding code happens to do.
