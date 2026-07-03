# Source material: Kevlin Henney on naming

From the talk "Giving Code a Good Name" (also delivered as "What's in a Name?"), the essay "Exceptional Naming", and "Seven Ineffective Coding Habits of Many Programmers". Quotes are verbatim.

## Naming versus labelling

Code is made of names, spacing, and punctuation; with those three tools the programmer must communicate intent, not merely instruct. Sticking a syntactically valid tag on a construct is labelling. Naming builds an intention-revealing vocabulary.

> This is not naming, it is labelling.

> A name is not simply a label: it informs and guides the reader's mental model.

> A good name should change the way the reader thinks.

## Homeopathic naming

His coinage for making names longer with generic words in the hope of adding meaning, diluting it with every `Factory`, `Manager`, `Object`, `Controller`, `Value`, `Service` appended:

> Diluting things dilutes them; it does not make them more potent.

Affixing Lego-brick parts to an identifier "does not amplify or enhance its meaning, and often serves to highlight there may have been little meaning there in the first place."

Related smells:

- **Lego naming.** Gluing stock words together (`create`, `process`, `validate`, `factory`, `manager`, `helper`) until you reach a `controllerFactoryFactory`. Adding words does not add meaning and usually subtracts it.
- **Util buckets.** A package or class named `util`, `utils`, or `utility` is a confession that you couldn't name the concept.
- **Redundant category suffixes.** His worked example is exceptions: they appear only in throw and catch positions, so the compiler and the reader both already know. Spend the characters on the actual problem: `InvalidNumberFormat`, not `NumberFormatException`; `UnexpectedNullReference`, not `NullPointerException`. The same logic applies to any suffix the surrounding syntax makes obvious.
- **Conventions propping up weak names.** "A naming convention should not be used to prop up weak names. If a name doesn't communicate well, we need to see that clearly so we can address it."
- **Consistent noise.** "A common vocabulary in code is useful, but concepts named should qualify as useful information; consistent noise is just noise."

## Underabstraction

Missing concepts show up as long parameter lists and as raw types (string, list) doing domain work. His tag-cloud test: generate a word-frequency cloud of the code. Well-abstracted code surfaces domain concepts; underabstracted code surfaces `string`, `list`, `get`, `set`. The vague agent nouns (`Manager`, `Helper`, `Processor`) usually mark the spot where a real concept was never identified.

## Positive advice

- Spend a name's bandwidth on signal: tell the reader something they don't already know from context, type, or syntax.
- Name roles and relationships. Objects collaborate, so a class name should reflect the role it plays for its collaborators.
- Draw names from the logic of the domain, whose meaning you control, rather than from external accidents (company mergers, product rebrands).
- Name interfaces with extra care; they are the stable, published part of the design.
- On `get`: in English, 'get' implies effortful fetching, nearly the opposite of what a cheap accessor promises.
