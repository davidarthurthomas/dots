---
name: testing
description: >
  Judge and write good tests: what to test, when a test is worth keeping, test doubles and
  mocking decisions, flaky or slow suites, coverage. Use when writing or reviewing tests,
  deciding whether to test something and at what level, choosing between a real object and a
  mock, or diagnosing a brittle, flaky, or slow suite. Triggers on "test", "mock", "stub",
  "flaky", "coverage".
global_category: Engineering
---

# Testing

Testing principles, grounded in the canon:

- [Beck, _Test Desiderata_](references/sources/beck.md)
- [Bernhardt, _Boundaries_ / _Functional Core, Imperative Shell_](references/sources/bernhardt.md)
- [Fowler, _Mocks Aren't Stubs_](references/sources/fowler.md)
- [Winters, Manshreck & Wright, _Software Engineering at Google_, chs. 11-12](references/sources/google.md)
- [Khorikov, _Unit Testing Principles, Practices, and Patterns_](references/sources/khorikov.md)

The core-and-shell split itself is the Approach section's "Functional core, imperative shell" rule; test names are names, so the `naming` skill applies to them too.

## What tests are for

Don't ask whether a test passes. Ask whether it's a good test, and keep a list of what you want from one. Hold each test up to these. If it misses one, that's the thing to fix.

The list below is a working subset of Beck's Test Desiderata, twelve properties a test can have, offered as wishes rather than requirements: "Not all tests need to exhibit all properties. However, no property should be given up without receiving a property of greater value in return." Khorikov sharpens the stakes: a test's value is the product of its qualities, not the sum, so a test that fully fails one of these is worth nothing no matter how well it does on the rest.

## The properties

**Structure-insensitive.** A good test doesn't care how you wrote the code, only what the code does. You should be able to tear out the insides of a function, put them back a different way, and if the behavior is the same, the test stays green. If you rename a private helper and a test breaks, that test was watching your typing, not your behavior. Test what a caller can see: what goes in, what comes out, what changes in the world.

This is Beck's central thesis: "Tests should be coupled to the behavior of code and decoupled from the structure of code." Google states the ideal as the unchanging test: "after it's written, it never needs to change unless the requirements of the system under test change." Of the four kinds of change to production code (refactorings, new features, bug fixes, behavior changes), only behavior changes should touch existing tests; a pure refactoring that breaks tests means "the tests were not written at an appropriate level of abstraction." The two defenses: test via public APIs, because "change that breaks a test might also break a user", and test state, not interactions, because "interaction tests check how a system arrived at its result, whereas usually you should care only what the result is." The degenerate case is the change-detector test, a test that is just "a transformation of the same information in the code under test": it provides negative value and should be rewritten or deleted. Khorikov calls the property resistance to refactoring and argues it is binary and non-negotiable: every false alarm teaches you to shrug at red, and a test that can't tell a bug from a refactoring is worth zero.

**Behavioral and specific.** If the behavior changes, some test should go red, or the test isn't earning its keep. And when it goes red, you want to know what broke without opening the file. The name should tell you. `returns the cached value on the second call` tells you. `test cache 2` tells you nothing. Keep each test to one claim, so a failure means one thing.

Google's framing: write a test for each behavior, not each method, where "A behavior is any guarantee that a system makes about how it will respond to a series of inputs while in a particular state." Behaviors read as given/when/then, and "the vast majority of unit tests require only one 'when' and one 'then' block"; a name that needs the word "and" is testing two behaviors and should be split. The failure message carries the same duty as the name: an engineer should be able to diagnose the problem from the message alone, so it states the desired outcome, the actual outcome, and the relevant parameters. Beck's specific gloss: "if a test fails, the cause of the failure should be obvious."

**Fast and deterministic.** If the suite is slow, you stop running it, and a test you don't run is worthless. If a test fails at random, you learn to shrug at red, and now green means nothing either. Both are worse than no test, because they cost you trust. Same inputs, same answer, whatever order you run things in. How fast and how steady a test is comes down to how much it touches.

Beck separates two properties here: deterministic ("if nothing changes, the test result shouldn't change") and isolated ("tests should return the same results regardless of the order in which they are run"). A suite needs both. Google enforces "how much it touches" by size: a small test runs in a single process and may not sleep, perform I/O, or make any other blocking call, which removes slowness and nondeterminism at the source; every test strives to be hermetic, assuming nothing about the environment or the order tests run in. Their experience with the trust cost: "as you approach 1% flakiness, the tests begin to lose value", and past that comes "a loss of confidence in the tests."

**Rooted in the functional core.** Split a program in two. In the middle is the logic that makes decisions: pure calculation, no talking to the outside world. Around it is a thin layer that talks to the database, the network, the screen. Gary Bernhardt calls it a functional core in an imperative shell. The core is a joy to test. Hand it values, check the values it hands back, cover every edge and every failure. It needs nothing else to run, so the tests are fast. Keep the shell thin and a few end-to-end tests will cover it. Don't write a pile of little tests for plumbing just to move a number.

Bernhardt's separation criterion: the core has many paths and no dependencies; the shell has many dependencies and almost no paths. Values are the boundary between them, which is what makes the core's tests isolated without doubles: "transforming interface dependencies into data dependencies" means the seam you test at is a value you construct, and there are no collaborators to fake. Google's working mix is the same shape at suite scale: around 80% narrow unit tests, 15% integration, 5% end-to-end.

**Sparing with mocks.** Reach for real objects first. Most of the time, once you've split the core from the shell, you don't need a mock at all, because the core is just values in and values out. When you do need one, put it at an edge you own: the clock, the network, the disk. Don't mock someone else's library from the inside. You don't really know how it behaves, so a mock of it is just your guess wearing a costume. And if a test is mostly mocks, you're testing your guesses, not your code. Some people use mocks the other way, to drive the design. That works for them. It's not how we do it here; that's a choice, not a law.

Fowler's classicist rule: "use real objects if possible and a double if it's awkward to use the real thing", where awkward means the real thing is slow or nondeterministic, or a pain to set up. Khorikov gives "an edge you own" a precise form: mock only unmanaged dependencies, the out-of-process systems with other observers (an SMTP server, a message bus, a third-party API), where the communication pattern is a contract a mock rightly pins; use real instances of managed dependencies like your own database, where the communication is an implementation detail you should stay free to refactor.

**Readable as a bug report.** When a test fails, it should read like a bug report: here's what you expected, here's what you got. Set things up, do the thing, check the result, in that order, with the check at the end where you can see it. No logic in the test. If there's a loop or an `if` deciding what to check, now you have to debug the test, and you didn't sign up for that.

Google's standard: "Clear tests are trivially correct upon inspection", correct at a glance with no mental computation. Logic is the usual spoiler; in their worked example a single string concatenation in a test hides a bug, and removing it makes the bug obvious. Straight-line code over clever logic, and a failure message good enough that the problem can be diagnosed without opening the test file.

**Self-contained.** Production code has a test suite to keep it honest as it grows complex; a test has nothing watching it, so it must be obvious at a glance. Everything a reader needs to understand the result belongs in the test's body, and a little duplication that keeps it there beats a clever helper (Google calls this DAMP, not DRY). Helpers are for setup the reader doesn't need to see.

Google's terms: a test is complete when its body contains everything a reader needs to understand how it arrives at its result, and concise when it contains nothing else. The exemption from DRY exists because "production code has the benefit of a test suite to ensure that it keeps working as it becomes complex, whereas tests must stand by themselves." DAMP complements DRY rather than replacing it: factor out repetitive setup whose details don't matter to the behavior under test, and keep everything that does matter in the body. Khorikov files this under maintainability, one of his four pillars: tests are code, and code is a liability, so a test also pays rent by being cheap to read and run.

**Triggered by a behavior, not a class.** Write a test when there's a new behavior to pin down or a bug to reproduce, not one per class out of habit. A failing test before a fix does two jobs: it shows you the bug is real, and it tells you the moment it's gone. A test next to new code writes down the promise that code is making. Tests added later just to raise the coverage number tend to freeze the code the way it is, bugs and all.

Google's trigger for what deserves a test is the Beyoncé Rule: "If you liked it, then you shoulda put a test on it." Anything you don't want broken gets a test; and a bug means "a case was missing from the initial test suite, and the bug fix should include that missing test case." On coverage, Khorikov: "Coverage metrics are a good negative indicator but a bad positive one." Low coverage reliably signals too little testing; a high number guarantees nothing, because "code coverage only measures that a line was invoked, not what happened as a result" (Google), and a coverage bar inverts itself in practice: teams given 80% treat it as a ceiling instead of a floor. Ask which behaviors are tested, never what the number is.
