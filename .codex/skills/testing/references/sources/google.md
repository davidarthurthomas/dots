# Source material: Software Engineering at Google, chs. 11-12

Winters, Manshreck & Wright (2020), "Testing Overview" and "Unit Testing", plus the Testing on the Toilet post on change-detector tests. All fetched; quotes are verbatim against the raw HTML unless marked as paraphrase.

## Why tests exist

> An equally important reason why you want to test your software is to support the ability to change. ... If you have a robust testing practice, you needn't fear change—you can embrace it as an essential quality of developing software.

The Beyoncé Rule decides what needs a test: "If you liked it, then you shoulda put a test on it." There is no blessed list of test types; anything you don't want broken gets a test in CI (paraphrase of the surrounding section).

## Unchanging tests

> the ideal test is unchanging: after it's written, it never needs to change unless the requirements of the system under test change.

Four kinds of change to production code, and whether tests should change:

1. **Pure refactorings**: "the system's tests shouldn't need to change." A test that breaks means the change wasn't pure, or "the tests were not written at an appropriate level of abstraction."
2. **New features**: new tests for the new behaviors; existing tests untouched.
3. **Bug fixes**: "the presence of the bug suggests that a case was missing from the initial test suite, and the bug fix should include that missing test case."
4. **Behavior changes**: "the one case when we expect to have to make updates to the system's existing tests."

A **brittle test** "fails in the face of an unrelated change to production code that does not introduce any real bugs." The two defenses:

> write tests that invoke the system being tested in the same way its users would; that is, make calls against its public API rather than its implementation details. If tests work the same way as the system's users, by definition, change that breaks a test might also break a user.

> Interaction tests tend to be more brittle than state tests for the same reason that it's more brittle to test a private method than to test a public method: interaction tests check how a system arrived at its result, whereas usually you should care only what the result is.

And on doubles: "we tend to prefer the use of real objects in favor of mocked objects, as long as the real objects are fast and deterministic."

## Change-detector tests

From Testing on the Toilet (Alex Eagle, 2015): a change-detector test "is a transformation of the same information in the code under test—and it breaks in response to any change to the production code, without verifying correct behavior of either the original or modified production code."

> Change detectors provide negative value, since the tests do not catch any defects, and the added maintenance cost slows down development. These tests should be re-written or deleted.

> A correct or incorrect program is equally likely to pass a test that is a derivative of the code under test.

## Test behaviors, not methods

> rather than writing a test for each method, write a test for each behavior.

> A behavior is any guarantee that a system makes about how it will respond to a series of inputs while in a particular state. Behaviors can often be expressed using the words "given," "when," and "then": "Given that a bank account is empty, when attempting to withdraw money from it, then the transaction is rejected."

Each test covers one behavior, almost always one "when" and one "then". Name the test after the behavior so the name reads as a sentence; a name that needs the word "and" is probably testing multiple behaviors and should be split (paraphrase of confirmed fragments).

## Clear tests

> Clear tests are trivially correct upon inspection; that is, it is obvious that a test is doing the correct thing just from glancing at it.

Logic (operators, loops, conditionals) is the usual source of unclarity; in the book's worked example a single string concatenation hides a bug, and removing it makes the bug obvious. Stick to straight-line code over clever logic (confirmed fragment). Failure messages carry the same duty:

> In an ideal world, an engineer could diagnose a problem just from reading its failure message in a log or report without ever having to look at the test itself.

## Complete and concise; DAMP, not DRY

> A test is complete when its body contains all of the information a reader needs in order to understand how it arrives at its result. A test is concise when it contains no other distracting or irrelevant information.

> Instead of being completely DRY, test code should often strive to be DAMP—that is, to promote "Descriptive And Meaningful Phrases." A little bit of duplication is OK in tests so long as that duplication makes the test simpler and clearer.

The reason tests get this exemption:

> production code has the benefit of a test suite to ensure that it keeps working as it becomes complex, whereas tests must stand by themselves

DAMP complements DRY rather than replacing it; helpers still earn their place for repetitive setup whose details don't matter to the behavior under test (paraphrase).

## Sizes, hermeticity, flakiness, and the mix

Tests are classified by resources, not just scope: small tests run in a single process and "aren't allowed to sleep, perform I/O operations, or make any other blocking calls"; medium tests get one machine and localhost; large tests get everything. The constraints are a sandbox against slowness and nondeterminism (paraphrase). All sizes:

> All tests should strive to be hermetic: a test should contain all of the information necessary to set up, execute, and tear down its environment.

On flakiness: "as you approach 1% flakiness, the tests begin to lose value" (Google holds around 0.15%), and "If test flakiness continues to grow, you will experience something much worse than lost productivity: a loss of confidence in the tests."

The mix: around 80% narrow unit tests, 15% integration, 5% end-to-end. The anti-patterns are the ice-cream cone (mostly end-to-end: "Such suites tend to be slow, unreliable, and difficult to work with") and the hourglass (many unit and end-to-end tests, few integration).

## Coverage

> code coverage only measures that a line was invoked, not what happened as a result.

Making the number a goal inverts it: teams given an 80% bar treat it "like a ceiling" rather than a floor. The better question is which behaviors are tested and whether you have confidence that changes won't break the product (paraphrase of confirmed fragments).
