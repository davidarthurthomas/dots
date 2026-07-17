# Source material: Andy Bell on CSS

From "Be the Browser's Mentor, not its Micromanager" (buildexcellentwebsit.es), the CUBE CSS methodology (cube.fyi), "A (more) Modern CSS Reset" (piccalil.li), and "Fluid scale and tokens: a match made in heaven." Quotes are verbatim.

## Be the browser's mentor, not its micromanager

Set rules and hints, then let the browser resolve them against a context you can't see from your desk.

> Give the browser some solid rules and hints, then let it make the right decisions for the people that visit it, based on their device, connection quality and capabilities.

> A better way to approach this is to be the browser's mentor by setting some base rules and hints, then getting out of its way to let it make decisions based on the challenges it will undoubtedly face.

> It makes sense to lose a bit of perceived control and instead, get even greater control by being the browser's mentor and not its micromanger, right?

> Building up with the lowest possible technological solution and enhancing it where device capability, connection speeds and context conditions allow, helps you build for everyone.

## CUBE CSS extends the cascade rather than fighting it

CUBE stands for Composition, Utility, Block, Exception, and it leans on inheritance instead of routing around it.

> It's designed to work with the medium that you're working in—often the browser—rather than against it.

> The name of this methodology gives the game away straight away; it's an extension of CSS rather than a reinvention of CSS.

> The cascade and inheritance are embraced, not avoided, so by the time you get down to blocks in CUBE, they become much more insignificant.

## The reset defines flow and space at a macro level

Strip user-agent margins and reintroduce spacing as a system, not per element.

> Resets are one of those things that people get worked up about, but really, with browsers being so bloody good now, you probably don't even need one in the first place.

> Now we're focussing more on letting the browser do more work with flexible layouts with fluid type and space, this rule isn't as useful as it once was.

> I'll always favour stripping out user agent styles for margin in favour of defining flow and space at a more macro level.

## Fluid type scales instead of stepping at breakpoints

Design a system in which type and space scale proportionally, so fewer breakpoints are needed.

> Instead of designing for x number of arbitrary breakpoints, we can design a system within which elements scale proportionally and fluidly

> This cuts down on generated classes, and importantly, media-queries, while simplifying the process of implementing a type scale.
