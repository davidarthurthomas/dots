# Source material: Boswell and Foucher, The Art of Readable Code, ch. 2 and 3

Two chapters on names: packing information in, and keeping misinterpretation out. Distilled from the book; paraphrase throughout, no verbatim quotes.

## Pack information into names (ch. 2)

- **Choose specific words.** `get` is nearly empty: `getPage` says nothing about where the page comes from, while `fetchPage` or `downloadPage` does. `size` on a tree could mean height, node count, or memory; `height`, `numNodes`, `memoryBytes` each say one thing. For every bland verb there is a more specific candidate: send might be `deliver`, `dispatch`, `route`; find might be `search`, `extract`, `locate`.
- **Avoid generic names, or know why you're using one.** `tmp`, `retval`, `foo` say only "I couldn't think of a name." `tmp` is honest for a value that genuinely lives only a few lines with no other role (a swap variable); `retval` never is, because it describes the variable's position, never its content.
- **Concrete over abstract.** Name the observable behavior, never the idea behind it: a check that the server can bind its port is `canListenOnPort`, which is testable and precise, where `serverCanStart` is mush.
- **Attach important details.** If a value has a unit or a caveat the reader must not miss, put it in the name: `delaySecs`, `sizeMb`, `maxKbps`; `untrustedUrl`, `plaintextPassword`, `unescapedComment`. The qualifier is cheap insurance against the bug where two callers assume different units.
- **Length scales with scope.** Short names for short scopes; identifiers visible across a file or module need enough words to be understood cold.

## Names that can't be misconstrued (ch. 3)

The key habit: interrogate your own name by asking what else it could mean.

- `filter(year >= 2011)`: does it select the matches or exclude them? `select` or `exclude` would each be unambiguous.
- `clip(text, length)`: cut from the end or truncate to the length? And is length in bytes, characters, or words? `truncateToMaxChars` answers both readings.
- **Limits.** Prefix inclusive limits with `max` and `min` (`maxItemsInCart`), rather than `limit`, which doesn't say whether the boundary value is allowed.
- **Ranges.** `first` and `last` for inclusive ranges; `begin` and `end` for inclusive-exclusive ranges, matching the convention readers already carry.
- **Booleans.** Lead with `is`, `has`, `can`, `should` so the name reads as a question, and avoid negations: `useSsl`, never `disableSsl = false`, which forces the reader through a double negative.
- **Match expectations.** Readers assume `get` methods and `size` are cheap accessors. If the operation walks a tree or hits the network, name the cost: `computeSize`, `countAllRecords`, `fetchProfile`.
