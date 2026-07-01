---
name: pr
description: >
  Use when opening or updating a GitHub PR—`gh pr create`/`gh pr edit`, drafting title/body, choosing
  base branch, or refreshing description after new pushes. Triggers on "create PR", "PR description",
  "update the PR". Requires `gh`.
compatibility: Requires GitHub CLI (gh).
global_category: Git
---

# PR

## Context

- Branch: !`git branch --show-current 2>/dev/null`
- Status: !`git status --short 2>/dev/null`
- Existing PR: !`gh pr view --json number,baseRefName,title,url 2>/dev/null || echo "none"`
- Recent commits (for style): !`git log --oneline -10 2>/dev/null`

## Procedure

1. Determine the base branch (see [Base branch](#base-branch)) — do this first, a wrong base makes the diff meaningless.
2. Review the full diff: `gh pr diff` for existing PRs, or `git fetch origin <base>` then `git diff origin/<base>...HEAD`. Never diff against a local branch, which may be stale.
3. Check commit style with `git log`, then run pre-submission checks (types, lint, format, tests).
4. Stage, commit with a concise message, and push with `-u`.
5. Draft the title and description per the rules below, then create the PR with `gh pr create --draft`.

Use a HEREDOC for the body to preserve formatting:

```bash
gh pr create --draft --title "Restore focus after closing dialogs" --body "$(cat <<'EOF'
PR body here...
EOF
)"
```

**Updating an existing PR:** After pushing new commits, proactively check that the title and description still describe the PR *as a whole* — don't wait to be asked. Read the current state with `gh pr view`, compare against the full diff (not just the new commits), and update with `gh pr edit` if the scope has shifted.

## Base branch

Determine the base before anything else:

1. **Conductor workspace:** use the target branch from the system instruction if present (see `/conductor`).
2. **Existing PR:** `gh pr view --json baseRefName -q .baseRefName` — the PR already knows.
3. **Convention:** `dev` for most feature work; `main`/`master` for hotfixes or repos without a dev branch; a feature branch for sub-features of a larger effort.
4. **Ask** if still ambiguous.

Always `git fetch origin <base>` and diff against `origin/<base>`, never a local branch.

**Changes to include:** confirm whether the PR covers all uncommitted changes, staged only (`git diff --cached`), or specific files.

**Branch naming:** if the user mentions a ticket (e.g. `PROJ-1234`), put it in the branch name from the start (`<handle>/proj-1234`) so tracker auto-linking works and you avoid renaming later.

Ask before proceeding if any of these are unclear.

## PR title

- Plain language in sentence case — no commit-style prefixes (`feat:`, `fix:`).
- Describe what changed, not the ticket number. Concise but specific.

## PR description

Draft the title and body prose with `/write-like-dave` for sentence-level craft — plain, direct, and free of AI tells. The structure, scope, and voice rules in this section are PR-specific and take precedence where they differ.

Never use `##` headers. Open with a paragraph on the problem, context, or motivation — why the PR exists — then bullets on *what* changed and *why*. Keep bullet runs to 3–4; break longer lists into conceptual groups, each introduced by a sentence or two of prose, so readers can scan at both paragraph and bullet level.

**Voice:**

- Present tense — "Adds validation for empty inputs", not "Added". Applies to the opening paragraph and bullets alike.
- Drop subject pronouns. "We" for team-level decisions, "I" only for genuinely first-person observations.
- Problem or motivation before solution.
- Direct — every sentence adds information. No preamble, hedging, or filler.
- Mention edge cases as asides or parentheticals, not dedicated sections.
- Group small related changes at the end under "Also:" or "A couple other semi-related changes:".
- Reference tickets, Slack threads, Figma files, and related PRs inline.

**Scale to size:**

- **Small:** one or two sentences.
- **Medium:** intro paragraph + bullets + related links.
- **Large:** same flat structure, no headers — group related bullets under short prose paragraphs for scannable sections.

**Dependent and cross-repo PRs:** a change spanning two repos gets one PR per repo, each on a branch named for the shared ticket. Cross-link them in both descriptions with full URLs, stating what each side provides and depends on, and name non-obvious causes a reviewer can't infer from the diff (a transitive dependency bump, an API contract the other side must ship first). When ship order matters, block the downstream PR loudly so it can't merge early: set it to CHANGES_REQUESTED and add an all-caps `DO NOT MERGE UNTIL <linked PR> IS DEPLOYED TO PRODUCTION`, removing the block once the dependency lands. Cross-repo edits belong in dedicated worktrees, not a shared local branch — see `/git-workflows`.

**Considered alternatives:** when an approach was explored and intentionally rejected, add a brief note (inline or a short `## Considered but not done` section) — useful when a reviewer might naturally suggest it. Infer from commit history or conversation.

**Testing / validation:** include only when testing is non-obvious (complex interactions, specific repro steps, multi-step verification). Use a bulleted list for independent checks or an ordered list for sequential steps — never checkboxes. Say what page to visit, what data must exist, what to look for.

**Ticket references:** put `Fixes <ticket>` or `Closes <ticket>` on its own line near the top or bottom. Use inline links for related-but-not-closed tickets.

## What to avoid

- File-by-file listings or mechanical inventories (unless the refactor is the point).
- Counts, magnitudes, or diff stats ("~75 instances", "+200 lines") — GitHub shows these.
- Restating the diff ("migrates all shorthand usages to longhand") — give the what and why, not the mechanical operation.
- Status information ("all tests pass", "ran typecheck") — CI is assumed.
- AI vocabulary ("defense-in-depth", "leveraging", "ensuring robustness").
- Decision narration ("Rather than X, I extracted Y") — state facts; use "Considered alternatives" when rejection context is genuinely useful.
- Numbered behavioral flows, unless explaining a race condition or sequence-dependent bug.
- `Fixes #123` as the entire body — always explain why.
- `## Summary` / `## Test plan` scaffolding, or any `##` headers.
- Checkboxes — use plain bullets or ordered lists.
- The phrase "smoke test".
- "Generated with Claude Code" or any AI footer / co-authorship.

## PR comments and interactions

Posting a comment, reply, or review is a publish action. Do it when the user asks — including replying to their inline feedback on a first-pass PR — but never unprompted. When asked only to "get" or "check" comments, present them in the conversation; don't reply on GitHub.

Because the agent posts through the user's own account, attribution has to live in the body. Lead every agent-authored comment with an italicized provider-model-and-effort line, followed by a blockquote:

```
*Claude Opus 4.8 (Max)*:

> <comment body>
```

Keeping the whole voice inside one blockquote makes it read as a single offset unit, never confusable with the user's plain-text comments. This covers every agent-authored GitHub comment — inline replies, review summaries, conversation comments, including those via `/code-review --comment`. It does not apply to PR titles or descriptions, which are in the user's voice and carry no footer.
