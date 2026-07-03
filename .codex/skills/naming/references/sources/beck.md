# Source material: Kent Beck, Smalltalk Best Practice Patterns

The origin of 'intention-revealing' naming, which most later books repeat. The patterns are Smalltalk-flavored but the reasoning is language-independent. Distilled from the book; paraphrase throughout, no verbatim quotes.

## Intention-revealing selector

Name a method after what it accomplishes for the caller, never after how it works. His example: a method that highlights an area of the screen by inverting it. Named for the mechanism (`reverse`), the name goes wrong the moment the implementation changes and tells callers nothing about when to use it. Named for the intent (`highlight`), it stays true across implementations and reads correctly at every call site.

The test he proposes: imagine a second implementation with a completely different mechanism. Would the name still fit? If yes, the name expresses intent. Naming by intent is also what makes the call site read as the caller's own level of abstraction; the reader of the calling code cares what happens, and only the reader of the implementation cares how.

The same pattern covers the classic small case: `isEmpty` over comparing a size to zero at every call site. Wrap the mechanism in a name that states the question being asked.

## Names by role in the communication

- **Role-suggesting instance variable.** Name a field for the part it plays in the object's life, since its type is either declared or obvious from initialization.
- **Type-suggesting parameter name.** For a parameter, the caller mostly needs to know what to pass, so the expected kind of thing can lead (`aString`, `aCollection` in Smalltalk fashion); when several parameters share a kind, distinguish them by role.
- **Simple superclass name.** The roots of an abstraction hierarchy get a few carefully chosen words that stake out the concept (`Number`, `Collection`). These names become the vocabulary of the system, so they deserve the most care.
- **Qualified subclass name.** Subclasses get the superclass name qualified by what makes them different (`OrderedCollection`, `SortedCollection`), so the hierarchy reads as a taxonomy.

## The underlying stance

Beck frames all of it as communication: code is written once and read many times, and names are the main channel through which one programmer's intentions reach another. Every naming pattern in the book asks the same question, namely what the reader needs to know at this point, and puts exactly that in the name.
