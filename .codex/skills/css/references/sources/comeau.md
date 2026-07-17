# Source material: Josh Comeau on CSS

From "The Rules of Margin Collapse," "An Interactive Guide to Flexbox," "An Interactive Guide to CSS Grid," "Full-Bleed Layout Using CSS Grid," "Understanding Layout Algorithms," "What The Heck, z-index??," "The Height Enigma," "A Friendly Introduction to Container Queries," and "A Modern CSS Reset," all published on joshwcomeau.com. Quotes are verbatim.

## CSS is layout algorithms, not a bag of properties

A property means nothing on its own; the active layout algorithm decides what it does.

> CSS is so much more than a collection of properties. It's a constellation of inter-connected layout algorithms.

> The properties we write are inputs, like arguments being passed to a function. It's up to the layout algorithm to choose what to do with those inputs.

> This is the critical mental-model shift. CSS properties on their own are meaningless. It's up to the layout algorithm to define what they do, how they're used in the calculations.

Flow is the default algorithm, older than the layout tools most developers reach for first.

> Flow is the "OG" layout algorithm of the web. It was created in an era when the web was primarily seen as a giant hyperlinked set of documents, like the world's largest archive.

## Width and height are calculated in opposite directions

They look like a symmetric pair and behave nothing alike.

> In CSS, width and height are fundamentally different. By default, they're calculated in totally opposite ways.

> Block-level elements like `<div>` will expand to take up all available width, but they don't do that for height. Instead, they shrinkwrap around their children.

> When calculating an element's default width, the browser looks up the tree, to the element's parent. But when calculating an element's default height, well, that depends on the element's children.

This is why percentage heights so often do nothing.

> In order for something like `height: 50%` to work, the parent's height can't depend on the child's height.

## Margin collapse

Vertical margins between siblings merge; the rules are specific and worth memorizing.

> Only vertical margins collapse.

> The bigger margin wins.

> Margin is meant to increase the distance between siblings. It is not meant to increase the gap between a child and its parent's bounding box; that's what padding is for.

> Margin will always try and increase distance between siblings, even if it means transferring margin to the parent element!

## Flexbox is about the primary axis

Flexbox distributes a group along one axis and aligns across the other.

> Flexbox is all about arranging a group of items in a row or column, and giving us a ridiculous amount of control over the distribution and alignment of those items.

> In Flexbox, everything is based on the primary axis.

> When it comes to the primary axis, we don't generally think in terms of aligning a single child. ... In the primary axis, though, we can only think about how to distribute the group.

> This means that only one of these properties can be active at once.

## Grid is indexed by lines, and `fr` distributes free space

Grid children anchor to lines, not cells, which is the source of most off-by-one confusion.

> CSS Grid is the latest and greatest layout algorithm. It's incredibly powerful: we can use it to build complex layouts that fluidly adapt based on a number of constraints.

> Confusingly, a 4-column grid actually has 5 column lines. When we assign a child to our grid, we anchor them using these lines.

> In fact, grid columns are indexed by the lines, not the cells.

> The fr unit is a flexible unit that fills available space. It's similar in principle to flex-grow; it's a ratio of how much of the free space the column should consume.

Grid placement moves the paint order, not the tab order.

> There's a big gotcha when it comes to grid assignments: tab order will still be based on DOM position, not grid position.

## z-index is local to a stacking context

A `z-index` competes only within its own stacking context, never globally.

> When we give an element a z-index, that value is only compared against other elements in the same context. z-index values are not global.

> When we apply this declaration to an element, it does precisely 1 thing: it creates a new stacking context.

> More and more, I'm starting to believe that z-index is an escape hatch, similar to !important.

## Container queries measure something they can't change

A component queries the size of its container, and the thing being measured stays outside the component's own influence.

> The golden rule with container queries is that we can't change what we measure.

> When it comes to height, elements tend to shrinkwrap around their children.

## The reset addresses root causes

Each rule in the reset removes a default that causes a category of downstream bugs.

> In my opinion, margin is a design concern, and not something that should be applied by default.

> By setting display: block on all images by default, we sidestep a whole category of funky issues.

> Let's address the root cause instead: form inputs shouldn't have their own typographical styles!

> This is beneficial since it allows us to guarantee that certain high-priority elements (modals, dropdowns, tooltips) will always show up above the other elements in our application. No weird stacking context bugs, no z-index arms race.
