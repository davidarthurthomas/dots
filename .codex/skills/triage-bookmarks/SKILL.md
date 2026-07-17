---
name: triage-bookmarks
description: Review the user's Shiori bookmarks for missing or wrong tags. Use when the user asks to "go through bookmarks", "triage", "tag bookmarks", "clean up bookmarks", or audit their bookmark collection.
---

# triage-bookmarks

Find untagged or under-tagged bookmarks and apply existing tags. Create new tags when real clusters don't fit anywhere. Act, then report — no need to ask permission for tag application, creation, or cleanup operations.

## Two purposes of tags

Tags serve two distinct goals. A healthy schema has both, and many bookmarks should carry one of each.

1. **Filtered inboxes (type tags).** When the user is in a mood — "I want to read essays", "give me videos to watch" — they want a clean stack of one content type. Type tags like `read`, `watch`, `book` answer "what mood am I in?" Keep these strict; don't pollute (e.g., a short product-announcement tweet doesn't belong under `read`).
2. **Search / retrieval (topic tags).** When the user needs to find something specific — "I need a bottle of wine", "that AI framework I saved" — they want everything on a topic regardless of format. Topic tags like `wine`, `ai`, `cocktails` answer "what is this about?"

The power move is double-tagging across the two axes. An essay about AI gets `read` + `ai`. A YouTube talk about AI gets `watch` + `ai`. Now "AI stuff" works across content types, and the reading inbox stays clean.

## Workflow

1. **Load tools.** `tool_search(query="shiori bookmarks tags")` for the full Shiori toolset.
2. **Map the schema.** `Shiori:list_tags` first. Existing slugs are what to reach for; respect the user's taxonomy.
3. **Find untagged items.** `Shiori:list_links` does *not* return per-link tags. To know what's already tagged, call `Shiori:list_links` once per tag (with the `tag` param) and build the set of tagged IDs. Anything in the full list but not in that set is a candidate.
4. **Apply.** `Shiori:set_link_tags(link_id, tag_ids)` *replaces* all tags on the link — for items that already have tags, pass the merged set.

## Creating new tags

When a real cluster (≥3 items) doesn't fit any existing tag, create one and apply it.

Before creating:
- See if an existing tag would stretch — better to expand than fragment.
- Decide whether it's a type tag or topic tag (see "Two purposes" above). A schema heavy on one axis is missing capability on the other.
- Names cap at 16 chars and auto-slugify.

`Shiori:create_tag(name)`, then apply.

## Other operations

- **Archive**: `Shiori:update_link(id, read: true)` — keeps the bookmark, removes from active feed. Good for stale RSS-style releases of the same project.
- **Trash**: `Shiori:delete_link(id)` — soft delete junk that pollutes search results.
- **Rename a tag**: `Shiori:update_tag(id, name)` — affects all linked items.

## Reporting

After acting, give a short summary: what got tagged, what new tags were created, what was archived/trashed, and any borderline judgment calls the user might want to revisit, with the reasoning behind each decision.

## Notes

- Batch related tag operations: many bookmarks share the same tag set.
- Match the user's existing taxonomy — don't impose a tidier one.
