# Source material: Arlo Belshee, naming as a process

From the "Naming as a Process" series on digdeeproots.com, Belshee's rewrite of his original arlobelshee.com series "Good naming is a process, not a single step". Quotes are verbatim from the articles.

## The core claim

Good names are the output of accumulated understanding, so a name at any moment should encode exactly how much you currently understand, including explicit markers of ignorance. You improve names one small, committed step at a time; each rename records an insight, and each honest-but-ugly name is a to-do list that drives the next refactoring.

> Naming is design.

> Names are the place we communicate our insights and intentions to other humans.

> Mistakes happen when our mental model doesn't match the reality of the code.

## The progression

Each stage has one move that gets you to the next. Never try to jump straight to a great name; take one insight per iteration, rename with a refactoring tool, and commit each rename.

1. **Missing.** A concept exists (a paragraph of statements, a gnarly expression, a cluster of parameters) but has no name. Move on: extract it and name it deliberate nonsense.
2. **Obvious nonsense.** `Applesauce` is better than a misleading name because nobody will trust it. Misleading names (type echoes, lifecycle names, `-er` and `-Utils` suffixes, methods hiding side effects) get renamed to nonsense too. Move on: read the body, find one true thing it does, state it.
3. **Honest.** The name truthfully states one thing the code does, with uncertainty marked: `probably_updateInventoryCounts_AndStuff()`. Move on: expand the known and narrow the unknown until nothing is missing.
4. **Honest and complete.** The name states everything the code does, however ugly. The ugliness is diagnostic: it exposes too many responsibilities. Move on: change the code, one extracted responsibility at a time, until the complete name is short.
5. **Does the right thing.** The honest, complete name is now short because the code has one responsibility. Move on: read the call sites to learn why callers use it.

   > If we don't like the name then we have to change what the thing does.

6. **Intent.** The name says why callers care, what the mechanical description obscured.

   > The name describes the thing. It doesn't tell us why we care.

   > Keep any parts of the Complete and Honest name that make it more obvious when you want to use this thing. Drop the rest.

7. **Domain abstraction.** After several naming iterations in one area, clusters of intent-named things reveal a shared concept. Hunt primitive obsession (a string named for a domain concept, an int carrying units) and extract the concept into its own type.

   > A domain abstraction is just a shared context for some set of code.

## Working rules

- Never guess a name. A wrong-but-trusted name causes bugs; nonsense at least tells the truth about your ignorance.

  > Good is too expensive; all I want is better (quickly).

- A name should be exactly as good as your understanding, no better. Encode uncertainty explicitly.
- Be specific over polite: a name that transmits your actual judgment beats a diplomatic vagueness.
- A horrifyingly long honest name is a signal to refactor the code; shortening the name just hides the problem.
- Improve names when reading, not only when writing. Each reader takes the minimum steps for the current story and leaves the name for the next person to extend:

  > You quickly assess the current state of a name. You take the minimum steps to get the name to meet your need for the current story. You leave the name in an incomplete state that will be extended by the next person.
