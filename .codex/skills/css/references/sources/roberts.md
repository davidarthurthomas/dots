# Source material: Harry Roberts on CSS

From "The Specificity Graph," "Hacks for dealing with specificity," "Code smells in CSS," "CSS and Network Performance," and "Critical CSS? Not So Fast!," all published on csswizardry.com, plus the "Managing CSS Projects with ITCSS" talk. Quotes are verbatim; ITCSS slide lines are transcribed from the deck and marked below.

## Keep specificity low and flat

Specificity is the fastest way to lose control of a growing stylesheet, so avoid it wherever you can.

> Specificity is a trait best avoided, which is why we don't use IDs in CSS, and we don't nest selectors unless absolutely necessary.

> specificity is one of the quickest ways to get yourself in a tangle when trying to scale a CSS project

> Specificity is how projects start to spiral so it is vital to keep it low.

> Never use IDs in CSS, ever. They have no advantage over classes

> An ID is 255 times more specific than one class… infinitely more specific than a class.

> never use a selector more specific than the one you need.

> Make heavy use of classes because they are the ideal selector: low specificity

## Write CSS in specificity order

Source order carries the cascade; a stylesheet that climbs steadily in specificity stays maintainable.

> Specificity throws a real curve-ball at a language which is entirely dependent upon source order.

> An upward trending Specificity Graph represents CSS that is, essentially, written in specificity order.

> A spiky graph is a bad graph.

> No more bolting things on to the end of a stylesheet!

> Ordering CSS based on its specificity leads to much simpler and hassle-free maintenance, as well as offering improved scalability due to more evenly distributed complexity and a more sane working environment.

The following are transcribed from the ITCSS talk slides (verify against the primary deck if exactness is critical):

> Start with generic and end with explicit.

> All rulesets should only ever add to and inherit from previous ones.

## Only add, never undo

Rules should accumulate down the stylesheet; code that unsets earlier work is a warning sign.

> The very nature of CSS is that things will, well, cascade and inherit from things defined previously.

> As you go down a stylesheet you should only ever be adding styles, not taking away.

> Any CSS that unsets styles (apart from in a reset) should start ringing alarm bells right away.

> If you find you are having to undo styling as you go down your document the chances are you jumped the gun and started adding too much too soon.

## CSS is on the critical path

Stylesheets block rendering, so their delivery is a performance concern, not just an architecture one.

> CSS is critical to rendering a page—a browser will not begin rendering until all CSS has been found, downloaded, and parsed—so it is imperative that we get it onto a user's device as fast as we possibly can.

> your page will only render as quickly as your slowest stylesheet

> Any delays on the Critical Path affect our Start Render and leave users looking at a blank screen.

> Critical CSS only helps if CSS is your biggest render-blocking bottleneck, and quite often, it isn't.
