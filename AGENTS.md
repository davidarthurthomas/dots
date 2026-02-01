# Agent Guide

This document explains how I like to work and how agents can be most effective in my repos. Read this when starting a task and refer back before major decisions.

## Before You Write Code

**Do your research.** Read the official documentation for any libraries or APIs you'll be working with. Search the web for current best practices. Explore the existing codebase to understand the architecture and patterns already in use. Back up your decisions with reputable sources. A few minutes of research prevents hours of rework.

**Ask clarifying questions when it matters.** If the task involves multiple files, architectural decisions, or has unclear scope, ask before you build. Quick questions like "Should this handle X?" or "I see two approaches - A or B?" are cheap compared to building the wrong thing. For small, obvious tasks, just proceed.

**Propose a plan for non-trivial work.** Before diving into larger changes, outline your approach: "I'll do X by changing Y and Z." This gives me a chance to course-correct early.

When you understand the problem well enough to explain it back to me, you're ready to start.

## How I Think About Code

**Do what's asked, nothing more.** If I ask for a bug fix, fix the bug. Don't refactor surrounding code, add features, or "improve" things that weren't mentioned. Over-engineering wastes time and introduces risk.

**Fix root causes.** When something breaks, understand why before fixing it. Bandaid fixes create tech debt. If you're not sure what's causing a problem, say so - we can investigate together.

**Leave no breadcrumbs.** When you delete or move code, delete it cleanly. No "moved to X" comments, no commented-out blocks "just in case." Git tracks history; the code doesn't need to.

**Code should explain itself.** If you need a comment to explain what code does, the code is probably too clever. Refactor for clarity instead of adding comments. Save comments for explaining *why* something unusual is necessary.

## Git Workflow

I care about clean, readable history. Each commit should tell a story.

**Commits should be atomic.** One logical change per commit. The code should compile and pass tests at every commit. If you're making multiple changes, commit them separately so I can review, reorder, or revert them independently.

**Write commit messages in present-tense imperative mood.** "Add login form" not "Added login form." This matches Git's built-in style (e.g., "Merge branch...").

**I curate history myself.** I regularly rebase, squash, and reorder commits before merging. Don't rebase, amend, or otherwise rewrite history - that's my job.

**Keep PRs small.** Before starting work, think about how the changes could be broken into small, focused PRs. Each PR should do one thing well. This makes review easier and reduces risk. When describing a PR, write 2 sentences max explaining the change, then list major decisions in order of importance and risk.

**I prefer worktrees to checking out branches.** Worktrees let me keep multiple branches open in separate directories without stashing or losing context. My shell has helper functions:

- `wta <branch>` - Create new worktree with new branch
- `wtc <branch>` - Check out existing branch as worktree
- `wtl` - List worktrees
- `wts` - Switch worktree (interactive with fzf)
- `wtd <branch>` - Delete worktree and branch
- `wtp` - Prune stale worktrees

Worktrees are created as sibling directories named `<repo>--<branch>`.

**What you can do:** Read-only commands (`status`, `log`, `diff`, `show`), stage files, and commit.

**What you must never do:** Push, force push, rebase, amend, reset, delete branches, or discard changes. These are destructive or affect the remote - I handle them myself.

**No attribution.** Don't add "Co-Authored-By" or similar attribution lines to commits.

## TypeScript

I work primarily in TypeScript. These rules aren't negotiable:

**Never use `any`.** If you don't know the type, figure it out. Use `unknown` if you truly need an escape hatch, then narrow it properly.

**Avoid `as` type assertions.** Assertions lie to the compiler. If you need to assert, it usually means the types don't model the real shape of the data. Fix the types instead.

**Use named exports.** Default exports make refactoring harder and autocomplete worse. Always use named exports.

**Use async/await.** No callback pyramids, no `.then()` chains when async/await is cleaner.

**No magic values.** Strings and numbers that appear in code should be named constants. This makes code searchable and intent clear.

**Target modern browsers.** Don't add polyfills or workarounds for old browsers unless the project specifically requires it.

## Adding Dependencies

Always ask me before adding a new dependency. Even small packages add maintenance burden, security surface, and bundle size.

When you propose a dependency, come prepared: explain why it's needed, what alternatives exist, and why this one is the best choice. Prefer well-maintained packages with active communities.

## Tooling

Each project has its own setup. Check `package.json` scripts to see what's available. Use whatever package manager, linter, and formatter the project has configured - don't assume.

## Communication

Be direct. Tell me what you did, what you found, or what you need. Skip pleasantries and filler.

No emojis in code or communication. No forced humor.

## Environment

macOS with Homebrew. Dotfiles managed via a bare git repo in `~/.cfg` with a `config` alias that works like git.

**Editor:** Zed

**Shell:** zsh with modern CLI replacements:
- `eza` for `ls` (aliased)
- `zoxide` for `cd` (aliased as `z`)
- `ripgrep` for `grep` (aliased)
- `fzf` for fuzzy finding

**Node:** Managed with `fnm` (fast node manager). It auto-switches versions based on `.node-version` or `.nvmrc` files.

**Package managers:** Projects may use npm, pnpm, or bun. Check the lockfile to see which one a project uses.

## Before You Hand Off

When you finish a task:

1. Run the project's diagnostics (typecheck, lint, tests - depends on the project) to make sure the code passes
2. Summarize what changed and reference the files
3. Call out any TODOs or follow-up work I should know about
