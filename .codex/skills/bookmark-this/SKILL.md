---
name: bookmark-this
description: Save URLs to the user's Shiori bookmark service, with optional tags. Use whenever the user wants to bookmark, save, or stash a link or set of links — including triggers like "bookmark this", "save this to Shiori", "/bookmark-this", "save these links", or "add to my reading list". Also use when the user references items by name (e.g. "save those wineries") and expects them to land in their bookmarks.
---

# bookmark-this

Save one or more URLs to Shiori, optionally tagged.

## Workflow

1. **Resolve URLs.** If the user gave a URL, use it. If they referenced things by name (e.g. "save those wineries"), look each one up with `web_search` first — don't guess URLs, broken bookmarks are worse than a few extra search calls. Prefer the brand's own homepage over aggregator listings.
2. **Load Shiori tools** if not already loaded: `tool_search(query="save link bookmark")`.
3. **Save each link** with `Shiori:save_link`. It returns a `linkId`.
4. **Tag if asked.** Call `Shiori:set_link_tags` with the `linkId` and an array of tag names. Important: this *replaces* all tags on the link, so it's safe for new saves but destructive on existing ones — for an existing link, list its current tags first and pass the merged set.
5. **Confirm briefly.** List what was saved and the tags applied. No long postamble.

## Notes

- If a target has no real public site (allocation-only producers, private services, etc.), say so and skip rather than saving a junk URL.
- Default to the homepage unless the user wants a specific article or subpage.
