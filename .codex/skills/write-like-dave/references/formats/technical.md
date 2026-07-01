# Technical

Technical writing that explains concepts, walks through decisions, or teaches something. This is where Mitchell Hashimoto's influence is strongest - narrating the reasoning, showing tradeoffs, personal framing.

## Characteristics

- Walk through reasoning and tradeoffs. Don't just state the answer - show how you got there.
- Personal experience when relevant. "Every table I've inherited" carries more weight than "tables often have."
- Real examples from real systems. Named tools, actual projects, specific situations.
- Acknowledge where your approach might not apply. "This may not work for you" is honest, not weak.
- Plain language for complex topics. Strip the jargon without losing the substance.

## Techniques

These patterns come from David's own technical writing and are the target to aim for:

**Plain language first, formalism second.** Explain the concept in plain language before (or alongside) any formal notation. "Imagine a dial for 'John likes camping.' Each hit nudges the needle." is Bayesian inference without the word "Bayesian." The metaphor carries the concept; the math confirms it. A reader should be able to understand the system without reading a single formula.

**Concrete examples as anchors.** Every abstraction gets a concrete instance immediately. Not "entity A has attribute B" but "John likes camping," "XL Tent," "Pearl Izumi's website." The reader always has something to hold onto. When introducing a parameter, show what it means with a real value: "A purchase is much more substantial compared to a page visit."

**Sequential building.** Introduce each concept exactly when it's needed. Build from simple to complex so the reader never has to take something on faith. By the time they see a formula, they already understand what it means from the prose.

**Think out loud mid-document.** Pause to ask the question the reader is already thinking. "So now we've added up all hits to one push, but where do we push from?" This is the PG move in technical context - the writer and reader reasoning together.

**Name your abstractions.** Give tangible names to abstract concepts. Four parameters become "knobs on a reason." This makes them memorable, implies they're tunable, and gives the reader a mental model to hold.

**Include open questions.** Don't pretend to have everything figured out. "How do we properly calibrate this algorithm?" and "What's our cold start solution?" build trust. You're sharing a system in progress, not delivering a finished product from above.

**Short, tight definitions.** When introducing domain objects, one sentence each: "A person or device identity we hope to know things about." These do real work without ceremony.

**Callouts for subtle distinctions.** Use blockquotes or asides for nuances that would break the flow but are too important to skip: "These are from the reason type, not the hit, which allows us to turn these knobs without touching the database."

## Structure

Technical writing adapts to its purpose:

**Explaining a concept:**
- Start with what it is, in one plain sentence.
- Show why it matters with a concrete example.
- Walk through how it works, adding nuance incrementally.
- Acknowledge edge cases and limitations.

**Walking through a decision:**
- State the problem or constraint.
- Show the options you considered and why.
- Walk through the tradeoffs of each.
- Explain what you chose and why - not as the "right" answer, but as the best fit for the constraints.

**Designing a system:**
- Start with what the system does, in plain language.
- Define the core objects. Keep definitions tight.
- Walk through the conceptual model with a concrete example before any formalism.
- Introduce formal notation incrementally, always preceded by intuition.
- Surface open questions and cold-start problems honestly.

**Teaching a technique:**
- Start with the problem the technique solves.
- Show the technique with a real example, not a contrived one.
- Walk through what's happening and why.
- Note where it breaks down or doesn't apply.

## Process adjustments for technical writing

- **Research** - verify your technical claims. Check documentation, not just memory. If you're citing a tool or technique, make sure it works the way you say it does.
- **Challenge** - technical writing has a higher bar for accuracy. "Is this actually true?" matters more here than anywhere else.
- **Draft** - use code examples and formulas sparingly and only when they clarify. Don't include them just because you can. A well-written sentence often explains better than a code block. When you do use formulas, the prose should be able to stand on its own.

## What to avoid in technical writing

- Tutorial voice. "First, open your terminal. Now, type..." This is condescending unless the audience is genuinely beginner.
- Jargon without purpose. Use technical terms when they're the right word, not when they're the impressive word.
- Contrived examples. `foo`, `bar`, `UserService` - use something from a real codebase or at least something realistic enough to have texture.
- Authority without attribution. If you learned a technique from someone, say so. "I picked this up from Aaron Francis" is better than presenting it as your own discovery.
- Formalism as explanation. Formulas don't explain - they formalize. The explanation is in the prose.
- Hiding uncertainty. If you don't know the answer to something, say so. Open questions sections are better than hand-waving.

## Strongest influences for technical writing

- Hashimoto's narration mode (walk through reasoning, show tradeoffs)
- PG's directness and thinking out loud (say the thing, reason with the reader)
