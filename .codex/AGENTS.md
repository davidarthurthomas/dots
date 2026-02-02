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

**KISS first.** Prefer the simplest explicit code that solves the problem. Clarity beats cleverness.

**Avoid premature abstraction and optimization.** Don't build frameworks or tune performance without evidence; measure and refactor when a real need appears.

**DRY, but only after patterns emerge.** It's fine to repeat yourself while a solution is evolving. Actively watch for repetition, and extract only when a stable, shared shape is obvious.

**Code should explain itself.** If you need a comment to explain what code does, the code is probably too clever. Refactor for clarity instead of adding comments. Save comments for explaining *why* something unusual is necessary.

**Leave no breadcrumbs.** When you delete or move code, delete it cleanly. No "moved to X" comments, no commented-out blocks "just in case." Git tracks history; the code doesn't need to.

## TypeScript

I work primarily in TypeScript. These rules aren't negotiable:

**Never use `any`.** If you don't know the type, figure it out. Use `unknown` if you truly need an escape hatch, then narrow it properly.

**Avoid `as` type assertions.** Assertions lie to the compiler. If you need to assert, it usually means the types don't model the real shape of the data. Fix the types instead.

**Validate runtime boundaries with Zod.** Parse external inputs (HTTP payloads, env vars, webhooks, JSON) with schemas. Use `.parse` for fail-fast flows and `.safeParse` for recoverable flows.

**Use `interface` for object shapes; `type` for unions and advanced types.** Prefer `interface` for public object contracts. Use `type` for unions, primitives, tuples, mapped/conditional types, or when you want a closed type.

**Derive types from values; validate with `satisfies`.** Prefer deriving types from real data and use `satisfies` to enforce shape without losing literal types.

Example:
```ts
const statusLabels = {
  open: "Open",
  closed: "Closed",
} satisfies Record<"open" | "closed", string>;
```

**Treat `Object.keys` as `string[]`.** Narrow keys before indexing (helper or type predicate) instead of assuming `keyof`.

**Let return types be inferred by default.** Only annotate return types for multi-branch functions, library/public APIs, or when addressing known TypeScript performance issues.

**Co-locate types, then lift when shared.** Define types next to the code that uses them, and only move to shared modules when multiple files need them. Use `export type` for type-only exports.

**Keep a consistent class member order.** `static` fields -> `static` methods -> instance fields -> constructor -> public methods -> protected methods -> private methods. Keep getters/setters with their visibility group.

**Use named exports.** Default exports make refactoring harder and autocomplete worse. Always use named exports.

**Use async/await.** No callback pyramids, no `.then()` chains when async/await is cleaner.

**No magic values.** Strings and numbers that appear in code should be named constants. This makes code searchable and intent clear.

**Target modern browsers.** Don't add polyfills or workarounds for old browsers unless the project specifically requires it.

Primary resource on TypeScript: Matt Pocock. If you're uncertain, look for his advice first.

## Web Development

Kent C. Dodds-inspired, framework-agnostic principles:

**Start with the web platform.** Use HTTP, URLs, links, forms, and semantic HTML as the primary building blocks; frameworks should be thin layers on top of the platform.

**Use JavaScript to enhance, not enable.** The core experience should work without JavaScript; add interactivity as progressive enhancement.

**Treat URLs as first-class state.** Make key views and filters linkable, shareable, and navigable.

**Prefer native navigation and forms.** Understand default browser behavior before preventing it; leverage built-in semantics.

**Load data efficiently and cache with HTTP.** Use standard caching directives and prefetching to improve performance.

Primary resource on web development: Kent C. Dodds. If you're uncertain, look for his advice first.

## React

**Prefer composition over configuration.** Use `children`, slots, and compound components for flexible UI; reserve prop-based APIs for simple, data-driven cases.

Example:
```tsx
// Prefer composition
<Card>
  <CardHeader>Profile</CardHeader>
  <CardBody><UserForm /></CardBody>
</Card>

// Over-configured
<Card title="Profile" body={<UserForm />} />
```

**Avoid prop drilling with composition before context.** Structure layout components to accept elements so state stays close to where it's used; reach for context only when composition isn't enough.

**Keep layout components thin.** Layout components should place content; the composing parent owns state and logic.

**Own your components.** Treat UI components as app code you control. Copy and customize instead of wrapping opaque libraries.

**Build on primitives.** Prefer accessible primitives (e.g., Radix) and utility-first styling (e.g., Tailwind) when available.

Primary resources on React componentry: Kent C. Dodds and shadcn. If you're uncertain, look for their advice first.

## Database Development

**Protect data first.** Migrations must be reversible or have a rollback plan; never assume a data change is safe to redo.

**Use constraints for integrity.** Prefer NOT NULL, UNIQUE, CHECK, and FK constraints to enforce invariants at the database layer.

**Think in transactions.** Group related writes and keep transactions short to avoid locks and contention.

**Design for query patterns.** Model tables around the reads/writes you actually need, not just the domain.

**Avoid N+1.** Batch queries and prefetch related data when iterating.

**Prefer keyset pagination.** OFFSET gets slower as data grows; paginate by a stable, indexed key when possible.

**Avoid `SELECT *`.** Select only needed columns to reduce IO and improve cache efficiency.

**Use EXPLAIN and keep queries index-friendly.** Verify query plans and avoid wrapping indexed columns in calculations; precompute or reshape data when needed.

**Index intentionally.** Indexes are the primary lever for performance, but they have maintenance costs; aim for as many as needed and as few as possible.

**Index foreign keys used in joins.** Foreign key constraints enforce integrity but do not create indexes in child tables; add them to speed joins.

**Design indexes around queries.** Use composite indexes with the leftmost-prefix rule and consider covering indexes or deferred joins to avoid touching full rows.

Primary resource on database development: Aaron Francis. If you're uncertain, look for his advice first.

## Adding Dependencies

Always ask me before adding a new dependency. Even small packages add maintenance burden, security surface, and bundle size.

When you propose a dependency, come prepared: explain why it's needed, what alternatives exist, and why this one is the best choice. Prefer well-maintained packages with active communities.

## Git Workflow

I care about clean, readable history. Each commit should tell a story.

**I curate history myself.** I regularly rebase, squash, and reorder commits before merging. Don't rebase, amend, or otherwise rewrite history - that's my job.

**What you must never do:** Push, force push, rebase, amend, reset, delete branches, or discard changes. These are destructive or affect the remote - I handle them myself.

**What you can do:** Read-only commands (`status`, `log`, `diff`, `show`), stage files, and commit.

**Commits should be atomic.** One logical change per commit. The code should compile and pass tests at every commit. If you're making multiple changes, commit them separately so I can review, reorder, or revert them independently.

**Write commit messages in present-tense imperative mood.** "Add login form" not "Added login form." This matches Git's built-in style (e.g., "Merge branch...").

**No attribution.** Don't add "Co-Authored-By" or similar attribution lines to commits.

**Keep PRs small.** Before starting work, think about how the changes could be broken into small, focused PRs. Each PR should do one thing well. This makes review easier and reduces risk.

**The `gh` CLI is available.** Use it to create and edit PRs, and always assign PRs to me.

**PR titles.** Use present-tense imperative, no prefixes, and no trailing period. Keep it under ~60 characters and describe the primary change. Only include a Linear issue ID in the title if the branch name does not already include that ID.

**PR descriptions.** If the PR is small enough, a description is not necessary. Otherwise, write 2 sentences max explaining what changed and why, then list major decisions as bullets ordered by importance and risk. Do not include minor implementation details or a testing section.

Good example:
```
Reduce database round-trips by batching user lookups.
This keeps the endpoint fast under load without changing behavior.

- Batch by account_id to match the most common access pattern.
- Keep the existing query shape to avoid widening the API response.
```

**I prefer worktrees to checking out branches.** Worktrees let me keep multiple branches open in separate directories without stashing or losing context. My shell has helper functions:

- `wta <branch>` - Create new worktree with new branch
- `wtc <branch>` - Check out existing branch as worktree
- `wtl` - List worktrees
- `wts` - Switch worktree (interactive with fzf)
- `wtd <branch>` - Delete worktree and branch
- `wtp` - Prune stale worktrees

Worktrees are created as sibling directories named `<repo>--<branch>`.

## Tooling

Each project has its own setup. Check `package.json` scripts to see what's available. Use whatever package manager, linter, and formatter the project has configured - don't assume.

## Communication

Be direct. Tell me what you did, what you found, or what you need. Skip pleasantries and filler.

Flag breaking changes before making them. Don't ship breaking changes without explicit approval.

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
