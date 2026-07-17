# Source material: Ahmad Shadeed on CSS

From "Defensive CSS," "An Interactive Guide to CSS Container Queries," and "Intrinsic Sizing In CSS," all published on ishadeed.com. Quotes are verbatim.

## Defensive CSS anticipates content that changes

Content is dynamic, so write the layout to survive variation instead of assuming the happy path.

> Content is dynamic, and things can change on a web page, thus increasing the possibility of a CSS issue or a weird behavior.

> We developers need to account for different content lengths.

> One of the common things that break a layout is using a fixed width or height with an element that has content in different lengths.

> For me, this is a defensive CSS approach. It's nice to get to fix the 'problem' before it actually happens.

## Size to content when content should decide

Extrinsic sizing can't express "as big as the content needs"; the intrinsic keywords can.

> Sometimes, we want to size elements based on its content, and in that case, using extrinsic sizing doesn't help.

> However, everything is cool until the image width is larger than the viewport. In that case, the width of the figure will be as large as the image, which will cause horizontal scrolling.

## Container queries make a component truly fluid

A component tuned to its container adapts wherever it lands.

> While building layouts in CSS, we always wanted a way to change a specific UI based on the width of its container, not the viewport.

> When using a container query, we can fine-tune such details and give the components the ability to expand based on their container width, not the viewport.

> CSS container queries help us to write a truly fluid components that change based on their container size.
