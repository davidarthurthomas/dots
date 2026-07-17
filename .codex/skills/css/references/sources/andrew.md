# Source material: Rachel Andrew on CSS

From "Should I use Grid or Flexbox?" and "CSS Grid. One layout method not the only layout method" (rachelandrew.co.uk), "How Big Is That Box? Understanding Sizing In CSS Layout" (Smashing Magazine), and "Flexible Sized Grids with auto-fill and minmax" (rachelandrew.co.uk / gridbyexample.com). Quotes are verbatim.

## Flexbox is one dimension, Grid is two

Choose the method by the shape of the problem, not by which is newer.

> Flexbox is essentially for laying out items in a single dimension – in a row OR a column. Grid is for layout of items in two dimensions – rows AND columns.

> Do you want to let your content control the way it is displayed, on a row by row or column by column basis? That's flexbox.

> Grid is for the creation of two dimensional grids. So you use Grid when your layout needs a two dimensional grid. ... If you can't draw a set of boxes and put the bits of your design neatly into them, it probably isn't the method you are looking for.

> Grid is only a replacement for flexbox if you have been trying to make flexbox into a two-dimensional grid. If you want to take a bunch of items and space them out evenly in a single row, use flexbox.

## Boxes already have a size

Content gives an element a size before you assign one, and the modern layout methods want you to lean on that.

> boxes on your webpage have a size — even if you haven't given them one.

> Instead of constraining the box using a length or by way of it hitting the edges of the containing block, you might want to allow the content to dictate the size. This is where these new content-based sizing keywords come in.

> Working in percentages gives us some degree of control, control that we need to start to give up in order to fully utilize the power of Grid and Flexbox!

> You will find you need fewer Media Queries and can rely on the inherent flexibleness of the layout methods.

## Flexible grids with minmax() and auto-fill / auto-fit

Ask for as many tracks as will fit rather than declaring a fixed count.

> To achieve a truly flexible grid – flexible both in size of tracks and number – we need an additional piece of the puzzle – minmax().

> The result as many equal width, flexible sized columns as can fit inside the container.

> If you use the auto-fill keyword empty tracks will remain as part of the grid. If you were to use the alternate auto-fit keyword, this would behave in the same way as described above but once all grid items have been placed any completely empty tracks will be dropped.
