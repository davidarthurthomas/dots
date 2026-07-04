# Source material: Gary Bernhardt, "Boundaries" and "Functional Core, Imperative Shell"

From the Boundaries talk (SCNA 2012 / PyCon 2013), the Functional Core, Imperative Shell screencast (2012), and the essay "Test Isolation Is About Avoiding Mocks" (2014). Talk and screencast pages and the full essay fetched; no public transcript of the talk itself exists, so talk-body material is close paraphrase from multiple sets of notes. Quotes are verbatim unless marked.

## The split

Divide a program in two (paraphrase of the talk's separation criterion):

- The **functional core** owns the decisions: branching, business rules, edge cases, written as pure functions over immutable values. Many paths, no dependencies.
- The **imperative shell** owns the dependencies: stdin, stdout, database, network. It gathers inputs for the core and enacts the values the core returns. Many dependencies, almost no paths; ideally so few conditionals it barely branches.

The way to find the split: do as much as you can without mutation, then encapsulate the mutation separately (paraphrase of the talk's closing).

## The testing consequence

From the screencast description:

> This design has many nice side effects. For example, testing the functional pieces is very easy, and it often naturally allows isolated testing with no test doubles. It also leads to an imperative shell with few conditionals, making reasoning about the program's state over time much easier.

The rule of thumb from the talk's close (secondhand, treat as paraphrase): many fast unit tests for the functional core; a few integration tests for the imperative shell.

## Values as the boundary

From the talk description:

> This talk is about using simple values (as opposed to complex objects) not just for holding data, but also as the boundaries between components and subsystems.

And the PyCon abstract names the move that eliminates test doubles:

> transforming interface dependencies into data dependencies

When a component depends on another component's interface, a test must double that interface. When it depends only on data, a test simply constructs the data. Isolation is a property you want; mocks are one mechanism for it, and FCIS gets it structurally instead: a pure function over values is inherently isolated, with nothing to stub because there are no collaborators to fake.

## Mock pain is design feedback

From the 2014 essay, all verbatim:

> Avoiding numerous or deeply nested mocks is the principal design activity of isolated TDD.

> Deeply nested mocks tell us little about mocks, just as deeply nested conditionals tell us little about structured programming. Proficient users of structured programming rarely write deeply nested conditionals; proficient users of mocks rarely write deeply nested mocks.

> Design isn't just reflected in isolated test setup; it's magnified. Isolated tests are a microscope for object interaction.

> Today, I'd extract a functional core wherever it was natural, testing the core in isolation with no test doubles at all.

The argument (paraphrase): nested stubs are a symptom that the code under test reaches deep into its collaborators. The pain of writing the mocks is the pressure that forces decomposition; once the design improves and the decision moves into the core, the mocks disappear on their own. Two limits he concedes: test-setup pain measures coupling only ("Mock setup exposes coupling, remember; not cohesion or other design properties"), and shell code gets a pass. His `ChargePurchase` shell class has nine collaborators and heavy stubbing, tolerated because centralizing the whole charging process in one linear place is worth more than clean test setup.

## Vocabulary

- **Boundaries**: the seams between components and subsystems; make them out of values.
- **FauxO** (paraphrase): his name for immutable, pure-method objects, OO packaging with functional semantics; the core is built of these. FauxO can't do I/O, which is what forces the shell into existence.
- **Paradigms in miniature** (wording unconfirmed, widely cited from the slides): rather than choosing OO or FP for a whole system, each piece is one paradigm in miniature, small functional programs embedded in a small imperative one.
- The concurrency payoff (paraphrase): immutable values crossing every seam eliminate shared mutable state, and the shape maps directly onto the actor model.
