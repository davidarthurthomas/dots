# Source material: Martin Fowler, "Mocks Aren't Stubs"

From the article (final revision 2007) plus the TestDouble and UnitTest bliki entries, all fetched. Quotes are verbatim unless marked as paraphrase.

## The test-double taxonomy

Fowler adopts Gerard Meszaros's (xUnit Test Patterns) vocabulary: "Test Double as the generic term for any kind of pretend object used in place of a real object for testing purposes." The five kinds:

> **Dummy** objects are passed around but never actually used. Usually they are just used to fill parameter lists.

> **Fake** objects actually have working implementations, but usually take some shortcut which makes them not suitable for production.

> **Stubs** provide canned answers to calls made during the test, usually not responding at all to anything outside what's programmed in for the test.

> **Spies** are stubs that also record some information based on how they were called.

> **Mocks** are what we are talking about here: objects pre-programmed with expectations which form a specification of the calls they are expected to receive.

The article's title point: "mock" is not a synonym for every double. Mocks are the one kind defined by expectations, and

> Of these kinds of doubles, only mocks insist upon behavior verification.

State verification examines the state of the system and its collaborators after the exercised method runs; behavior verification checks that the system made the correct calls on its collaborators.

## Classical vs mockist TDD

How each school decides when to use a double:

> The classical TDD style is to use real objects if possible and a double if it's awkward to use the real thing.

> A mockist TDD practitioner, however, will always use a mock for any object with interesting behavior.

The classicist's trigger is awkwardness (slow, nondeterministic, hard to set up: databases, networks, email); the mockist's trigger is design. Mockist testing is tied to need-driven, outside-in development: expectations on mocked collaborators drive out the design of interfaces from the caller's side, layer by layer. Fowler treats it as a genuine methodological fork with working practitioners on both sides: "I know many good developers who are very happy and convinced mockists."

The UnitTest bliki adds Jay Fields's terms: **solitary** tests double all collaborators; **sociable** tests use real ones. "Indeed when xunit testing began in the 90's we made no attempt to go solitary unless communicating with the collaborators was awkward."

## The coupling argument

> Mockist tests are thus more coupled to the implementation of a method.

> Coupling to the implementation also interferes with refactoring, since implementation changes are much more likely to break tests than with classic testing.

The honest flip side (paraphrase): mockist tests localize defects (only tests whose subject contains the bug fail, where classic tests of client objects fail too) and need less fixture work (only the subject and its immediate neighbors get created). The trade is defect localization and cheap fixtures against surviving refactoring and verifying real integration.

## Fowler's position

> I don't see any compelling benefits for mockist TDD, and am concerned about the consequences of coupling tests to implementation.

> A mockist is constantly thinking about how the SUT is going to be implemented in order to write the expectations. This feels really unnatural to me.

He stays classicist, recommends trying the mockist style before judging it, and frames the whole question as a choice between two working schools rather than a right answer.

## Attribution: "only mock types you own"

The maxim is not in this article and is not Fowler's. It originates with the jMock team ("Mock Roles, not Objects", OOPSLA 2004) and is canonical in Freeman & Pryce, Growing Object-Oriented Software, Guided by Tests (2009), ch. 8: from the mockist school. Their reasoning (paraphrase): a mock encodes your assumptions about how a library behaves, and you can't verify assumptions about code you don't own. Wrap the third-party API in an interface you do own, mock that role, and cover the real adapter with integration tests.
