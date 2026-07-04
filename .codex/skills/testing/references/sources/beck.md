# Source material: Kent Beck, "Test Desiderata"

From the 2019 Medium article and its companion site, testdesiderata.com. Both fetched; quotes are verbatim unless marked as paraphrase.

## The thesis

> Tests should be coupled to the behavior of code and decoupled from the structure of code.

Behavioral and structure-insensitive are two sides of that one goal: a test should notice every behavior change and shrug at every rewrite that preserves behavior.

## The twelve properties

Each with Beck's gloss, verbatim:

1. **Isolated** — "tests should return the same results regardless of the order in which they are run."
2. **Composable** — "I should be able to test different dimensions of variability separately and combine the results." (companion-site wording; the article elaborates that isolated tests compose: run 1 or 1,000,000 and get the same results)
3. **Fast** — "tests should run quickly."
4. **Inspiring** — "passing the tests should inspire confidence"
5. **Writable** — "tests should be cheap to write relative to the cost of the code being tested."
6. **Readable** — "tests should be comprehensible for reader, invoking the motivation for writing this particular test."
7. **Behavioral** — "tests should be sensitive to changes in the behavior of the code under test."
8. **Structure-insensitive** — "tests should not change their result if the structure of the code changes."
9. **Automated** — "tests should run without human intervention."
10. **Specific** — "if a test fails, the cause of the failure should be obvious."
11. **Deterministic** — "if nothing changes, the test result shouldn't change."
12. **Predictive** — "if the tests all pass, then the code under test should be suitable for production."

Isolated and deterministic are distinct: isolated is order-independence between tests; deterministic is the same test giving the same result when nothing changed.

## The tradeoffs

The properties are desiderata, wishes rather than requirements, and they pull against each other:

> Not all tests need to exhibit all properties. However, no property should be given up without receiving a property of greater value in return.

Different kinds of tests deliberately choose different subsets (paraphrase): unit tests trade predictiveness for writability, speed, isolation, and specificity; acceptance tests trade speed and specificity for readability and predictiveness; production monitoring trades determinism and isolation for maximum predictiveness. Composability relaxes the apparent fast-versus-predictive conflict: test each dimension of variability separately and combine the results, rather than testing every combination end to end.

## How to use the list

As a reflective checklist, never a mandate:

> Look at the last test you wrote. Which properties does it have? Which does it lack? Is that the tradeoff you want to make?
