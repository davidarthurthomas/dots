---
name: rewrite-history
description: Rewrite the current branch's git history with clean, narrative-quality commits while preserving the exact same final diff. Use when the user wants to clean up messy commit history, squash and reorganize commits, rewrite history for review, restructure commits into a logical story, or prepare a branch for force-push with better commits. Triggers on "rewrite history", "clean up commits", "rewrite commits", "reorganize history", "restructure commits", "redo the history", "make the commits cleaner", "narrative commits".
argument-hint: [base-branch]
allowed-tools: Bash(git:*), Read, Glob, Grep, Edit, Write
model: opus
---

## Context

- Current branch: !`git branch --show-current`
- Git status: !`git status --short`
- Commits on branch: !`git log --oneline HEAD ^$(git rev-parse --abbrev-ref HEAD@{upstream} 2>/dev/null | sed 's|origin/||' | xargs -I{} git merge-base HEAD origin/{} 2>/dev/null || git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD origin/dev 2>/dev/null || echo HEAD~10)`
- Diff stat: !`git diff $(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD origin/dev 2>/dev/null || echo HEAD~10)...HEAD --stat`

## Task

Rewrite the current branch's commit history with clean, narrative-quality commits. The final tree must be byte-for-byte identical to the current state — only the commits change, not the code.

This is a destructive rewrite of the current branch. The user will force-push the result over the existing remote history when ready.

### Steps

1. **Determine the base branch**
   - If `$ARGUMENTS` is provided, use it as the base branch.
   - Otherwise, detect it: check for an open PR with `gh pr view --json baseRefName` first. If no PR exists, look at the remote tracking branch or fall back to whichever of `dev` or `main` exists on the remote.
   - Confirm the base branch with the user before proceeding.

2. **Validate preconditions**
   - Ensure no uncommitted changes (`git status --porcelain` must be empty)
   - Record the current tree SHA for later verification: `git rev-parse HEAD^{tree}`
   - Record the current branch name

3. **Analyze the full diff**
   - Study all changes between the current branch and the base branch
   - Understand the final intended state as a whole — files added, modified, deleted, and how they relate
   - Read changed files to understand the purpose and structure of the work
   - Review the existing commit history to understand what was done, but don't feel bound by it — the whole point is to tell a cleaner story

4. **Plan the commit storyline**
   - Break the implementation into self-contained logical steps — typically fewer commits than the original history
   - Each commit should represent a coherent, functional stage of development. A reviewer reading the PR commit-by-commit should see a clear progression where each step builds naturally on the last.
   - Strip out any dead ends, reverts, fixups, or back-and-forth from the original history. The rewritten history should read as if the implementation went smoothly from start to finish.
   - Aim for the smallest number of commits that are each independently valid but maximally separable — each commit should compile and work on its own, but no commit should mix unrelated concerns. New infrastructure before migration, migration before removal. Never delete code that is still referenced in a later commit.
   - Consider: what would a reviewer want to see first? What context do they need before the next piece makes sense?

5. **Rewrite the history**
   - Create a temporary branch from the base: `git checkout -b _rewrite-temp <base>`
   - Recreate changes commit by commit following the planned storyline
   - Each commit must:
     - Introduce a single coherent idea
     - Leave the codebase in a functional state — each commit should stand on its own as a reasonable checkpoint
     - Have a clear commit message (short summary line + description body when warranted)
   - Use `git commit --no-verify` for intermediate commits. Pre-commit hooks may check things like tests or type coverage that depend on the full implementation being present. Each commit should still be *intended* to be functional — `--no-verify` is a pragmatic escape hatch, not a license to commit broken states.

6. **Verify byte-for-byte equivalence**
   - After the final commit, compare the tree SHA against the one recorded in step 2:
     ```
     [ "$(git rev-parse HEAD^{tree})" = "<saved-tree-sha>" ] && echo "MATCH" || echo "MISMATCH"
     ```
   - If they differ, diff the two trees to find the discrepancy and fix it before proceeding.
   - Run the final commit **without** `--no-verify` to ensure all checks pass on the complete state.

7. **Move the branch**
   - Point the original branch at the rewritten history:
     ```
     git checkout <original-branch>
     git reset --hard _rewrite-temp
     git branch -d _rewrite-temp
     ```

8. **Report**
   - Show the new commit log: `git log <base>..HEAD --oneline`
   - Remind the user that force-push is needed to update the remote:
     ```
     git push --force-with-lease
     ```
   - Do **not** push automatically — the user decides when.

### Rules

- Never add yourself as an author or contributor
- Never include "Generated with Claude Code" or "Co-Authored-By" lines in commits
- Do not open a pull request — that is a separate workflow
