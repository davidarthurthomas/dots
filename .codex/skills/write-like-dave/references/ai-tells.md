# AI Writing Tells

Patterns that mark prose as AI-generated. If even one appears, the reader's trust is broken. The goal is not merely to avoid detection but to write with the specificity, unevenness, and lived texture that AI cannot produce.

## Why AI writing is recognizable

AI prose is **semantically uniform** — every sentence carries equal weight, every paragraph is self-contained, every detail exists at the same level of importance. Human writing is semantically turbulent: some sentences carry heavy freight, others breathe, and meaning accumulates across sentences in ways that depend on context. AI writing can be replaced by its prompt with no loss. If you can guess the prompt and predict the output, no information was added.

AI **overfits on quality markers** found in its training data. Em dashes appear in well-edited prose, so AI drenches everything in em dashes. Good writing is subtle, so AI screams about subtlety — everything becomes a whisper, a shadow, quiet. Good writing uses metaphor, so AI piles concepts until they collapse ("turpentine and dreams"). The result is recognizable on sight even when no single tell is present.

## Fatal pattern: negation-reframing

**The single most disqualifying construction.** Delete the negation; state the positive claim.

All of these fail on contact:

- "This isn't X. This is Y."
- "Not X. Y."
- "Forget X. This is Y."
- "Less X, more Y."
- "It's not about X, it's about Y."
- "Not just X, but Y" / "more than just X"
- "Not only...but also"

Any sentence that negates one framing then asserts a corrected one. The pattern exists because AI has learned that reframing signals insight. It doesn't.

> Before: "This isn't a linter. It's a way to enforce team standards."
> After: "It enforces team standards."

> Before: "It's not about speed, it's about correctness."
> After: "Correctness matters more than speed."

## Constructions

### Copula avoidance

"Serves as", "stands as", "functions as", "acts as" instead of "is".

> Before: "This module serves as the entry point for the application."
> After: "This module is the entry point."

### False ranges

"From X to Y" where X and Y aren't on a meaningful scale.

> Before: "From initial prototyping to production deployment, the framework handles it all."
> After: "The framework works for prototyping and production."

### Superficial -ing phrases

Participial phrases tacked on for fake depth: "highlighting", "underscoring", "emphasizing", "ensuring", "reflecting", "showcasing", "fostering", "contributing to".

> Before: "The refactor simplifies the data layer, ensuring better maintainability and showcasing the team's commitment to code quality."
> After: "The refactor simplifies the data layer."

### Throat-clearing openers

- "In today's [anything]..."
- "In the age of [anything]..."
- "To put this in perspective..."
- "What makes this particularly interesting is..."
- "The implications here are..."

Delete. Start with the actual content.

### Manufactured stakes

- "Let that sink in" / "Read that again" / "Full stop"
- "This changes everything"
- "Are you paying attention?"
- "You're not ready for this"

The writer asserting significance proves the writing failed to create it.

### Insider posturing

- "Here's the part nobody's talking about"
- "What nobody tells you"
- Any construction with "nobody" or "most people don't realize"

These claim insider knowledge without demonstrating it. State the insight directly.

## Vocabulary

### Dead AI language

Never use these words. They have been statistically drained of meaning:

"delve", "dive into", "unpack", "leverage", "harness", "utilize", "ensure", "robust", "seamless", "comprehensive", "streamline", "foster", "empower", "bolster", "facilitate", "spearhead", "supercharge", "unlock", "future-proof"

Also: "straightforward", "I'd be happy to help", "10x"

### Inflated significance

"testament", "pivotal", "crucial", "vital", "key" (adj.), "cornerstone", "paradigm shift", "groundbreaking", "game-changing", "cutting-edge", "transformative", "indelible mark", "deeply rooted"

State the fact.

### Abstract place-words

"landscape" (abstract), "realm", "tapestry" (abstract), "woven" (figurative), "journey" (figurative). AI uses these because it can't experience the world and falls back on spatial metaphors for everything.

### Ghost vocabulary

AI fiction is obsessed with the spectral. "Whisper", "shadow", "echo", "ghost", "quiet", "softly humming", "liminal". These appear regardless of context because AI has learned they signal literary quality.

### Promotional language

"vibrant", "rich" (figurative), "profound", "nestled", "in the heart of", "breathtaking", "stunning", "renowned", "must-visit", "boasts"

## Dead transitions

Never use these connectives. They are scaffolding that hides weak connections between sentences:

- "Furthermore" / "Additionally" / "Moreover"
- "Moving forward"
- "At the end of the day"
- "In other words..."
- "It goes without saying..."
- "It is important to note that..." / "It's worth noting..."
- "It should be noted that..."

If the connection between sentences needs a transition word to work, the sentences are in the wrong order or one of them shouldn't exist.

## Punctuation and formatting

### Em dashes

LLMs overuse em dashes as all-purpose connectors — a statistical overfitting on "quality" prose in training data. The em dash is now so AI-coded that even legitimate human use reads as generated. Use commas, periods, colons, semicolons, or parentheses.

### Curly quotes

ChatGPT produces curly quotes ("\u201c...\u201d") instead of straight quotes ("..."). Use straight quotes.

### Emoji decoration

Emojis before headings or bullet points signal generated text.

### Boldface overuse

Mechanically bolding terms on first mention or bolding headers within list items.

### Inline-header lists

The bold-word-colon-description pattern:

> Before:
> - **Speed:** Faster iteration cycles
> - **Quality:** Better test coverage
> - **Adoption:** Growing usage

> After: Faster iterations, better test coverage, growing usage.

### Title case in headings

AI defaults to title case. Use sentence case.

## Tone

### Sycophantic language

"Great question!", "You're absolutely right!", "That's an excellent point!", "I hope this helps!", "Let me know if you'd like me to expand on any section.", "I'd be happy to help." Cut entirely.

### Generic positive conclusions

"The future looks bright", "Exciting times lie ahead", "This represents a major step in the right direction." Replace with specific facts or cut entirely.

### Hedging stacks

Multiple qualifiers in one sentence: "It could potentially possibly be argued that this might have some effect." Collapse to the actual claim.

### Knowledge-cutoff disclaimers

"As of [date]", "While specific details are limited", "based on available information." State what you know or say nothing.

## Structure

### Semantic uniformity

The deepest tell. Human writing varies in density — some sentences carry heavy freight, others breathe, and meaning accumulates non-linearly across the piece. AI treats every sentence as independently evaluated, self-contained, comprehensible without surrounding context. This produces the "nutrition paste" quality recognizable on sight even without specific vocabulary tells.

To counter: let some sentences depend on others. Let some carry less. Vary density deliberately.

### Rhythmic triplets

LLMs force ideas into groups of three. Two items or a full list. Three adjectives in a row is a tell.

> Before: "Fast, flexible, and reliable."
> After: "Fast and flexible."

### Elegant variation

Cycling through synonyms to avoid repetition. "The protagonist", "the main character", "the central figure", "the hero." Repeat the word.

### Shallow complexity

AI output looks detailed but contains no information beyond the prompt. Close examination of "details" reveals they're interchangeable — none help you predict or understand the rest. Real writing rewards close reading; AI writing exhausts its content at a glance.

### Mechanical perfection

AI prose is uniformly polished — every sentence at the same level of finish, no rough edges, no idiosyncratic constructions. The solution is not to inject errors. It is to write with voice: syntactic choices that reflect a particular mind, not a statistical average. Contractions, sentence fragments, interrupted rhythms, a willingness to let a sentence be plain when plainness serves — these are markers of a human sensibility, not of carelessness.

### Filler phrases

| Before | After |
|--------|-------|
| In order to | To |
| Due to the fact that | Because |
| At this point in time | Now |
| In the event that | If |
| Has the ability to | Can |
| In order to ensure | To |
| At the end of the day | *(delete)* |

### "Challenges and future prospects" formula

"Despite its [strengths], [subject] faces challenges typical of [category]. Despite these challenges, [optimistic conclusion]." Cut entirely or replace with specifics.
