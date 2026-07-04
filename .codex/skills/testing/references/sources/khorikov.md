# Source material: Vladimir Khorikov, Unit Testing Principles, Practices, and Patterns

Manning, 2020, plus his blog at enterprisecraftsmanship.com. Six blog posts fetched; quotes from them are verbatim. Book-only lines rest on secondary sources and are marked as such; everything else is paraphrase of the book.

## The goal

The goal of unit testing is sustainable growth of the project, never coverage or one-test-per-class (paraphrase, ch. 1). Tests are code, and code "is not an asset, it's a liability" (secondary): a bad test costs maintenance without buying confidence, and confidence is the point:

> the single most important benefit of unit testing is confidence

## The four pillars

A good test scores on four attributes (paraphrase, ch. 4):

1. **Protection against regressions**: how likely the test is to catch a real bug. Grows with the amount, complexity, and domain significance of the code exercised; trivial code earns little.
2. **Resistance to refactoring**: how likely the test is to survive a refactoring without a false alarm. Determined entirely by coupling to implementation details.
3. **Fast feedback**: slow tests get run less, and bugs found later cost more.
4. **Maintainability**: how hard the test is to read and to run.

The test's value is the product of the four scores, not the sum, so a zero on any pillar zeroes the test (paraphrase of the book's scoring model). And one pillar is special:

> The reason resistance to refactoring is non-negotiable is that whether a test possesses this attribute is mostly a binary choice: the test either has resistance to refactoring or it doesn't.

(secondary). Protection against regressions and fast feedback are dials you trade against each other; resistance to refactoring is a switch. Max it first, then pick your position on the regressions-versus-speed dial.

## False positives

A false positive is a test failing while the code is fine; a false negative is a bug the suite misses. Resistance to refactoring minimizes false positives, protection against regressions minimizes false negatives (paraphrase, ch. 4). False positives come from coupling to implementation details, and once developers get used to tests going red on every refactoring, they stop paying attention to red and legitimate failures drown in the noise (paraphrase of the value-proposition post). The cure:

> As long as the output stays the same, we shouldn't worry about how exactly that output was generated. These implementation details are simply irrelevant.

Verify the end result, never the steps. A test coupled to structure cannot distinguish a bug from a legitimate refactoring, which is the resistance-to-refactoring pillar failing. Two related smells, both verbatim:

> Try to avoid white-box testing completely as it encourages coupling unit tests to the SUT's implementation details.

> Extracting an interface out of a domain entity in order to "enable unit testing" is a design smell.

## When to mock: managed vs unmanaged dependencies

> Managed dependencies — out-of-process dependencies you have full control over.
> Unmanaged dependencies — out-of-process dependencies you don't have full control over.

> Communications with managed dependencies are implementation details; communications with unmanaged dependencies are part of your system's observable behavior.

> Only unmanaged dependencies should be replaced with mocks. Use real instances of managed dependencies in tests.

The reasoning: your own application database has no other observers, so you are free to change how you talk to it, and a mock would pin tests to a communication pattern you should be free to refactor; use the real database and treat it as part of the system. An SMTP server, message bus, or third-party API has other observers, so the communication pattern is a contract that must stay backward compatible, and a mock rightly pins that contract. In-process collaborators are never mocked, against both classical habit (avoiding mocks even at real edges) and London habit (mocking every mutable collaborator). Practical corollary (paraphrase, ch. 8): mock your own gateway type at the boundary, never a third-party library's internals.

## Styles: output-based over state-based over communication-based

Three styles (verbatim definitions from the styles post): **output-based**, "you feed an input to the system under test (SUT) and check what output it produces", which requires side-effect-free code; **state-based**, verify the state of the system or its collaborators afterward; **communication-based**, use mocks to verify interactions.

> Functional style is the best one in terms of its value proposition as it has the lowest chance of producing false positives.

Inputs and outputs change less often under refactoring than collaboration patterns do, so communication-based tests produce the most false positives; they are legitimate only where the communication is itself observable behavior, meaning unmanaged dependencies (paraphrase).

## Functional architecture

The architecture that enables output-based testing:

> In the vast majority of cases, you have an immutable core which accepts an input and which contains all the logic for processing that input.

> the mutable shell should be made as dumb as possible. Ideally, try to bring it to the cyclomatic complexity of 1.

The immutable core returns decisions as values; the shell gathers inputs, calls the core, and applies the outputs to the world. Structurally this is Bernhardt's functional core, imperative shell, though the fetched post does not credit him and his own terms are "immutable core" and "mutable shell" (confirmed absence; treat any book attribution as unverified). In DDD terms, the core is the domain model and the shell is the application services layer (paraphrase).

## Coverage

> Coverage metrics are a good negative indicator but a bad positive one.

(secondary). Low coverage reliably signals too little testing; high coverage guarantees nothing, since coverage measures code executed, not outcomes verified. Aim effort at the domain model, and practice "investing only in the tests that yield the biggest return on your effort" (verbatim, pragmatic-unit-testing post).
