---
name: css
description: >
  Write and review CSS: layout, the cascade, specificity, sizing, responsive design, custom
  properties, architecture. Use when building a layout with flexbox or grid, debugging specificity
  or the cascade, sizing elements, making something responsive, deciding between media and container
  queries, setting up custom properties, or reviewing CSS in a diff. Triggers on "flexbox", "grid",
  "cascade", "specificity", "z-index", "media query", "container query", "responsive", "CSS".
global_category: Engineering
---

# CSS

CSS principles, grounded in the modern canon:

- [Josh Comeau, the interactive CSS guides on joshwcomeau.com](references/sources/comeau.md)
- [Andy Bell, _Be the Browser's Mentor_, CUBE CSS, and the modern reset](references/sources/bell.md)
- [Heydon Pickering & Andy Bell, _Every Layout_](references/sources/every-layout.md)
- [Kevin Powell, on the "webiness" of CSS](references/sources/powell.md)
- [Harry Roberts, csswizardry.com on specificity, ITCSS, and performance](references/sources/roberts.md)
- [Rachel Andrew, on Grid, Flexbox, and intrinsic sizing](references/sources/andrew.md)
- [Miriam Suzanne, on cascade layers and container queries](references/sources/suzanne.md)
- [Lea Verou, on custom properties and composability](references/sources/verou.md)
- [Ahmad Shadeed, ishadeed.com on defensive and intrinsic CSS](references/sources/shadeed.md)

For names, see the `naming` skill; for components that carry CSS, the `react` skill.

## Working with the browser

**You share control of the output with the browser and the user, so hand it decisions rather than overriding them.** The developer who finds CSS a fight is usually fighting the parts built to keep content reachable. Bell's frame is the one to hold: "be the browser's mentor by setting some base rules and hints, then getting out of its way to let it make decisions based on the challenges it will undoubtedly face." You trade a little perceived control for far more real control.

**A property is an input to a layout algorithm, not an instruction on its own.** Comeau's mental-model shift: "CSS properties on their own are meaningless. It's up to the layout algorithm to define what they do." The same `width` or `margin` resolves differently under Flow, Flexbox, and Grid, so the first question about any declaration is which algorithm is reading it. Learn what each algorithm does with your inputs before you reach for a value.

**CSS forgives instead of failing, which is what makes progressive enhancement safe.** "If the browser doesn't understand a line of code, it just skips it and keeps on going." An unsupported declaration is dropped and the rest of the rule still applies, so you can layer a modern property over a working baseline and trust old browsers to ignore what they can't use.

## The cascade

**Keep specificity low and flat; it is the fastest way to lose a stylesheet.** Roberts is blunt: "never use a selector more specific than the one you need." Skip IDs entirely (an ID is 255 times more specific than one class), and don't nest or qualify selectors without a reason, because each step up in specificity is a debt the next author pays.

**Write rules in specificity order and only ever add, never undo.** Roberts' alarm: "Any CSS that unsets styles (apart from in a reset) should start ringing alarm bells right away."

**Reach for cascade layers before specificity hacks or `!important`.** Layers "define explicit contained layers of specificity ... without relying on specificity hacks or !important," Suzanne writes. Put resets and third-party styles in low layers and your components above them, and a plain class beats a heavy selector from a layer below it.

**Embrace inheritance instead of routing around it.** Bell designed CUBE CSS so "the cascade and inheritance are embraced, not avoided", which is why its blocks stay small: set typography, color, and spacing high in the tree and let them flow down.

## Sizing and the box model

**Width and height are computed in opposite directions, so stop treating them as a pair.** Comeau: "In CSS, width and height are fundamentally different. By default, they're calculated in totally opposite ways." A block element fills its parent's width but shrinkwraps its children's height. This is why `height: 50%` so often does nothing.

**Let content size the box; it already has a size before you assign one.** Andrew: "boxes on your webpage have a size — even if you haven't given them one," and when you want the content to decide, the content-based keywords (`min-content`, `max-content`, `fit-content`) express it directly. Fixed dimensions are where layouts break. Giving up some control here is the price of Grid and Flexbox.

**Margin spaces siblings, not a child from its parent.** Comeau's rule for margin collapse: "Margin is meant to increase the distance between siblings. It is not meant to increase the gap between a child and its parent's bounding box; that's what padding is for." Only vertical margins collapse, and the bigger one wins. When a child's top margin mysteriously pushes the parent down, that is the rule at work, and the fix is padding or a formatting boundary.

## Layout: flexbox and grid

**Flexbox is one dimension, Grid is two; pick by the shape of the problem.** Andrew: "Flexbox is essentially for laying out items in a single dimension – in a row OR a column. Grid is for layout of items in two dimensions – rows AND columns." Her test for Grid is literal: if you can't draw a set of boxes and put the bits of your design neatly into them, it probably isn't the method you are looking for. Grid replaces Flexbox only when you were bending Flexbox into a two-dimensional grid.

**In Flexbox, think about the group along the primary axis and the single item across it.** The two axes ask different questions: "In the primary axis ... we can only think about how to distribute the group," Comeau writes, while the cross axis aligns each item. `flex-grow` and `flex-shrink` are the primary-axis controls, depending on whether there's free space to give or overflow to take.

**Grid is indexed by lines, and `fr` shares out the free space.** The recurring confusion: "a 4-column grid actually has 5 column lines", because children are indexed by the lines, not the cells. The `fr` unit is similar in principle to flex-grow; it's a ratio of how much of the free space the column should consume. One caveat that trips up accessibility: placing items visually doesn't move them in the tab order, which will still be based on DOM position, not grid position.

**Ask for as many tracks as will fit instead of hard-coding a column count.** Andrew's flexible grid pairs `repeat(auto-fit, ...)` with `minmax()`: "To achieve a truly flexible grid ... we need an additional piece of the puzzle – minmax()." Use `auto-fill` to keep empty tracks in the grid and `auto-fit` to collapse them, and a responsive card grid needs no media queries at all.

## Intrinsic, algorithmic layout

**Compose small layout primitives and let the browser arrange them.** Every Layout's thesis: "Employing algorithmic layout design means doing away with @media breakpoints, 'magic numbers', and other hacks, to create context-independent layout components." When layout fights back, it's likely you're making decisions for browsers they should be making themselves. You write the governing rules, and the arrangements follow.

**Style the context, not each element.** Spacing between flow elements belongs to their shared parent. Every Layout's Stack "injects margin between elements via their common parent" rather than hanging a margin on every item, so adding or removing children just works. Bell applies the same instinct to resets: strip user-agent margins and reintroduce spacing as a system.

**Suggest one adaptive layout instead of pinning several to breakpoints.** The alternative is "single quantum layouts existing simultaneously in different states." Scale type and space fluidly so the design flexes between sizes rather than stepping at them. Every breakpoint you don't write is a device class you didn't have to anticipate.

## Responsive by component

**A component should respond to its container, not the viewport.** A card in a 300px sidebar and the same card in a 500px main column see the same viewport, so, as Every Layout puts it, "there's nothing to 'respond' to." Container queries fix this: the component handles its own layout, intrinsically, and works wherever you drop it.

**With container queries, you can't style based on what you're measuring.** Comeau's golden rule: "we can't change what we measure." A query on a container's inline size may restyle the container's descendants, never the container's own size, which is what keeps the measurement from feeding back on itself. Establish a containment context on the wrapper, then size the children against it.

## Custom properties

**Treat exposed custom properties as a component's API.** Verou: authors "expose various parameters of the styling as custom properties, and form a sort of *CSS API*." A property set on an ancestor cascades into every instance below it, so a themeable component is often just a handful of well-named variables with sensible fallbacks. Provide a default inline (`var(--gap, 1rem)`) so the component works before anyone sets it, and reach for pseudo-private properties when you need an internal value that callers shouldn't override.

**Reduce coupling even in code you fully own.** The payoff isn't only cross-team: "Even in a codebase where every line of CSS code is controlled by a single author, reducing couplings can improve modularity and facilitate code reuse." Name a value once as a custom property and read it everywhere, and prefer composing small general features over a rule tuned to today's exact case, which Verou calls overfitting.

## Defensive CSS

**Write for content that varies, because it will.** Shadeed: "Content is dynamic, and things can change on a web page, thus increasing the possibility of a CSS issue." Design for the long label, the missing image, the empty list, and the item count you didn't expect. The recurring failure is a fixed dimension meeting variable content, so prefer intrinsic sizing, set `min-width: 0` on flex children that must be allowed to shrink, and decide up front how text overflows. Fixing the problem is cheaper than the bug report.

## Stacking and z-index

**`z-index` is local to a stacking context, so a bigger number is not a bigger hammer.** "z-index values are not global," Comeau writes. An element that won't rise above another usually sits in a different stacking context that was created upstream by a transform, opacity, or filter, and no `z-index` on the child can escape it. Reach for `isolation: isolate` to create a context deliberately without side effects, and treat `z-index` itself as an escape hatch, similar to !important.
