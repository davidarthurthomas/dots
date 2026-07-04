# Source material: Daniele Procida, Diátaxis

From diataxis.fr, the standard framework for documentation structure. Quotes are verbatim.

## The model

Two axes describe what a documentation user needs at a given moment: whether they are acting or thinking (action vs cognition), and whether they are studying or working (acquisition vs application of skill).

> There are only two dimensions, and they don't just cover the entire territory, they define it. This is why there are necessarily four quarters to it, and there could not be three, or five.

| Mode | Serves | The user's question |
|---|---|---|
| Tutorial | acquisition + action | "Can you teach me to...?" |
| How-to guide | application + action | "How do I...?" |
| Reference | application + cognition | "What is...?" |
| Explanation | acquisition + cognition | "Why...?" |

His culinary analogy: teaching a child to cook, a recipe, the information on the back of a food packet, an article on culinary history. Nobody confuses those four; documentation confuses their equivalents constantly.

## The four modes

**Tutorial.** A lesson: "a tutorial is a lesson, that takes a student by the hand through a learning experience." The deliverable is the learner's competence, never the artifact built. Responsibility for success lies with the teacher. One narrow, perfectly reliable path; no choices, no alternatives; visible results at every step ("The output should look something like..."); flag likely failure points and surprises; concrete before abstract, always.

> The first rule of teaching is simply: don't try to teach.

> The user will learn through what they do - not because someone has tried to teach them.

> A tutorial is not the place for explanation.

**How-to guide.** Directions for a real task from real life, for "the already-competent user, whom you can assume to know what they want to do." Conditional imperatives ("If you want x, do y"), titles that name the task ("How to..."), sequence matched to how the user works. No teaching, no background, no completeness for its own sake: practical usability beats completeness. The failure to avoid is documenting tool operations ("turn the tap clockwise") instead of the user's actual goal.

**Reference.** Technical description of the machinery, consulted for truth and certainty while working.

> Reference material is neutral. It is not concerned with what the user is doing.

Austere, consistent, wholly authoritative, deliberately boring; its structure mirrors the structure of the code or product so the two can be navigated in parallel. Describe, never instruct or explain; examples illustrate, never teach. Auto-generated API docs passed off as the whole documentation is the characteristic failure.

**Explanation.** Understanding-oriented reading you can do away from the keyboard: "explanation deepens and broadens the reader's understanding of a subject. It brings clarity, light and context." The one mode where rationale, history, tradeoffs, alternatives, and opinion belong. Title pattern: "About X." Because it has no natural boundary (a tutorial ends with the lesson, a how-to with the task, reference with the machinery), scope it with an implied why-question.

## Mode-mixing is the characteristic failure

> Crossing or blurring the boundaries described in the map is at the heart of a vast number of problems in documentation.

Each mixture fails a specific reader. A tutorial that explains strands the learner (explanation "breaks the magic spell of learning"); a how-to that teaches buries the task for the practitioner who came to get something done; reference that instructs or explains gets "interrupted and obscured by digressions" while the explanation never develops; the tutorial/how-to conflation, the most common, serves neither the student nor the worker, and complexity is not the line between them; study vs work is.

## The compass

Two questions place any piece of writing, from a whole document down to a sentence:

1. Does it inform action, or cognition?
2. Does it serve the acquisition of skill, or its application?

Action + acquisition is a tutorial; action + application a how-to; cognition + application reference; cognition + acquisition explanation. Use it whenever you suspect a piece of writing is doing one thing while claiming another.

## Working iteratively

Diátaxis restructures documentation from the inside, one page at a time; top-down reorganization is explicitly warned against.

> Don't create empty structures for tutorials/howto guides/reference/explanation with nothing in them. Don't do that. It's horrible.

The loop: choose something small (a page, a paragraph); assess what user need it serves and how well; ask "what single next action will produce an immediate improvement here"; do that completely; repeat. Documentation grows like an organism, complete at every stage and finished at none.
