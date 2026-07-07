---
name: cursor-agents
description: >
  Spawn Cursor CLI headless agents (Composer models) as fast implementation subagents. Use
  proactively for well-scoped implementation work — mechanical refactors, boilerplate, parallel
  independent edits — and on explicit asks like "use cursor", "have composer do it", or "spawn
  cursor agents". Requires the Cursor CLI (`agent`).
compatibility: Requires the Cursor CLI (agent) and a Cursor account.
global_category: Delegation
---

# Cursor agents

Delegate well-scoped implementation tasks to Cursor CLI headless agents. They edit files directly and fast; you scope the work, review the diff, and own the result.

## Context

- CLI: !`command -v agent || command -v cursor-agent || echo "not installed"`
- Auth: !`agent status 2>&1 | head -2`

## Preflight

1. If the CLI is missing, install it: `curl https://cursor.com/install -fsS | bash` (installs `agent` into `~/.local/bin`).
2. If not logged in, ask the user to run `agent login` (interactive, opens a browser) or provide `CURSOR_API_KEY`. Don't attempt login yourself.
3. Omit `--model`: the CLI default is Cursor's fast agentic coding model, which is the right choice for delegated implementation. Only run `agent models` and pass `--model` when the task needs a different tier.

## When to delegate

Delegate to Cursor when the task is implementation with a checkable outcome: mechanical refactors, boilerplate, applying a known pattern across files, or several independent edits you can fan out.

Keep for yourself (or built-in subagents): search, analysis, review, design decisions, and anything that depends on conversation context you can't fit in one prompt.

## Invocation

```bash
agent -p --force --trust --workspace <repo-root> "$(cat <<'EOF'
<prompt>
EOF
)"
```

- `-p` is headless mode; `--force` lets the agent edit files and run commands without confirmation.
- `--trust` skips the workspace-trust prompt, which would otherwise hang a headless run.
- The HEREDOC keeps multi-line prompts with quotes and code intact; don't inline them into a quoted argument.
- Run via Bash with `run_in_background: true` — agent runs take minutes.
- Add `--output-format json` when you need to parse the result; it also returns a `session_id` for follow-ups.

## Prompt discipline

A headless agent cannot ask questions, so the prompt must stand alone:

- Name the exact files or directories to touch and the ones to leave alone.
- State acceptance criteria: what should compile, pass, or exist when it's done.
- Carry over any conventions from the conversation the agent can't infer from the code.
- Always include: "Do not run any git commands; version control is handled by the caller." An agent staging or stashing corrupts your view of the diff, and two agents sharing a tree can race on the git index.

## Parallel fan-out

One agent per independent task, each as its own background Bash call — not one mega-prompt.

- Concurrent agents share the working tree only when their tasks touch disjoint files *and* won't write shared state — lockfiles, generated code, and formatter sweeps all conflict even across disjoint sources.
- Otherwise isolate: `-w <name>` puts the agent in its own git worktree under `~/.cursor/worktrees/<repo>/<name>`. Review that worktree's diff and merge it back yourself.

## Follow-ups

To iterate on an agent's work with its context intact, resume its session:

```bash
agent -p --force --trust --resume <chatId> "<follow-up>"
```

Get the chat ID from the `session_id` field of a `--output-format json` run, or mint one upfront with `agent create-chat` when you know you'll iterate.

## Review

Cursor output is a draft, not a hand-off. After each agent finishes:

1. `git status` and `git diff` — read every change; drop anything out of scope.
2. Run the project's diagnostics (typecheck, lint, tests).
3. Fix or re-prompt (via `--resume`) until the diff is something you'd have written yourself.
