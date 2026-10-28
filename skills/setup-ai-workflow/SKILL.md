---
name: setup-ai-workflow
description: Set up the 4-stage AI-assisted engineering workflow (Planning, Rules + Skills, Daily Work, Own It) in a repository so it works in both Claude Code and Cursor. Use this whenever the user says "set up the AI workflow", "init the workflow", "bootstrap this repo for AI", starts a new project, or wants AGENTS.md, docs/, and the plan/groom/implement/review/finalize task skills created in a new or existing project, even if they don't name the skill.
---

# Setup AI Workflow

Installs one source of truth plus thin adapters, so Claude Code and Cursor (and Codex/Copilot) follow the same rules:

```
AGENTS.md                         rules for all tools (source of truth)
CLAUDE.md                         only: @AGENTS.md
docs/                             Stage 01: architecture, guidelines, conventions, testing, workflow, checklist, decisions
.agents/skills/<name>/SKILL.md    the 5 task skills (source of truth)
.claude/skills -> ../.agents/skills   symlink (copy fallback)
```

`$SKILL_DIR` below means the folder that contains this SKILL.md.

## Ground rules
1. Never invent facts. Anything you cannot verify from the repo or from the user: write `TODO: confirm` and list it in the final report.
2. Never write secrets, tokens or credentials into any file.
3. Never overwrite existing files. The install script skips them; merge by hand only after the user approves.
4. Do not modify application code. Only docs, rules and skills.
5. Keep files short and specific.

## Steps

### 1. Detect the mode and confirm
Inspect the target repo (tree, README, build/package files, CI, tests, existing docs, any existing AGENTS.md, CLAUDE.md, .cursor, .claude, .agents).
- **New project** (empty or near-empty): ask the user, all at once: purpose and users; stack; modules and responsibilities; hard boundaries; test and lint commands; branch/PR/merge conventions.
- **Existing project**: reverse-engineer stack, modules, boundaries (from imports), test/lint commands, conventions and notable decisions. Show a summary and let the user correct it before writing docs.

Tell the user which mode you detected and wait for their go-ahead.

### 2. Install the templates
Run from the target repo root:

```bash
bash "$SKILL_DIR/scripts/install.sh" .
```

The script copies every template that does not already exist, creates the `.claude/skills` symlink (or a copy if symlinks fail), and prints what it created and skipped. Read its output.

### 3. Fill in the project-specific docs
Replace the `TODO` placeholders using the facts from step 1:
- `docs/architecture.md`: purpose, stack, modules with responsibilities, boundaries, data flow. Use real repo paths.
- `docs/engineering-guidelines.md`: error handling, logging, dependencies, security basics, what to avoid.
- `docs/conventions.md`: naming, structure, commit and PR conventions.
- `docs/testing.md`: how to run tests and lint, what must be tested.
- `docs/decisions/0001-adopt-ai-assisted-workflow.md`: set the date; add other verifiable past decisions with reasons.
- `AGENTS.md`: fill the project one-liner and the test/lint commands.

For files the script skipped (already existed), propose a merge or diff and wait for approval.

### 4. Verify
1. Every path referenced in AGENTS.md exists.
2. `.claude/skills` resolves to the same files as `.agents/skills`.
3. Give the user two test prompts, one for Claude Code and one for Cursor: "List the workflow skills you can see and the file each one comes from."
4. If a tool does not list them: use the command table in AGENTS.md (say "run plan-task"), and update Cursor to 2.4 or later.

### 5. Final report
1. Tree of files created or changed.
2. All `TODO: confirm` items and assumptions.
3. How existing files were handled (merged, skipped, awaiting approval).
4. The first 3 things the user should do next.

Then stop. Do not start feature work.
