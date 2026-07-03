# Source material: Eric Evans, Domain-Driven Design

The ubiquitous language, the book's central naming idea, plus the intention-revealing interfaces pattern. Distilled from the book; paraphrase throughout, no verbatim quotes.

## Ubiquitous language

A project needs one language shared by developers and domain experts, used everywhere: in conversation, in diagrams, in documents, and above all in the code. Class names, method names, and module names come from the domain model, so that saying something about the domain and saying something about the code are the same act. When the developers translate between a customer vocabulary and a code vocabulary, information is lost in every translation, and the two models drift.

Consequences for naming:

- **A rename is a model change.** When the team finds a better word for a concept, the code changes to match, at once. Letting the code keep the old word forks the language.
- **Experiment with phrasings.** Evans has teams talk through scenarios out loud using the model's terms; awkward sentences expose awkward concepts. If a sentence built from your class and method names sounds wrong to a domain expert, the model (and its names) needs work.
- **Missing words are missing concepts.** When the team keeps reaching for a word that isn't in the model, that word is a candidate object, service, or event. The vocabulary drives the design as much as it labels it.
- **One term per concept, one concept per term.** Two names for the same idea invite divergence; one name for two ideas invites the bug where they're conflated. The language is only ubiquitous if it's also consistent.

## Intention-revealing interfaces

From the later design chapters: name classes and operations to describe their effect and purpose, without reference to the means by which they do what they promise. A client developer should be able to use an interface from its names alone, thinking in the model's terms, never needing to read the implementation to learn what it does. If understanding a method requires opening it, its name has failed, and so, in Evans's terms, has the abstraction.
