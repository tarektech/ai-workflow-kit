# ai-workflow-kit

A tool-agnostic, AI-assisted engineering workflow that works the same way in **Claude Code** and **Cursor**.

You write the rules once, in `AGENTS.md` and `docs/`. Every agent reads the same files and runs the same five task skills: plan → groom → implement → review → finalize. A human approves the plan and reviews the result before anything is merged.

## The four stages

| Stage | What it is | Where it lives |
|---|---|---|
| **01 Planning** | Written project knowledge: architecture, guidelines, conventions, testing, decisions | `docs/` |
| **02 Rules + Skills** | Rules for every agent, plus the task skills | `AGENTS.md`, `.agents/skills/` |
| **03 Daily Work** | A fixed pipeline for every task | `plan-task` → `groom-task` → `implement-task` → `code-review-task` → `finalize-task` |
| **04 Own It** | A human checklist to complete before merging | `docs/review-checklist.md` |

## What gets installed in your project

```
AGENTS.md                              rules for all tools (source of truth)
CLAUDE.md                              one line: @AGENTS.md
docs/
  architecture.md                      purpose, stack, modules, boundaries, data flow
  engineering-guidelines.md            errors, logging, dependencies, security
  conventions.md                       naming, structure, commits, PRs, merging
  testing.md                           test/lint commands, what "passing" means
  workflow.md                          the daily pipeline, with an example
  review-checklist.md                  Stage 04: the human sign-off
  decisions/0001-adopt-ai-assisted-workflow.md
.agents/skills/
  plan-task/SKILL.md                   writes plans/<task>.md, then stops for approval
  groom-task/SKILL.md                  splits the plan into small steps with success conditions
  implement-task/SKILL.md              one step at a time, tests and lint after each
  code-review-task/SKILL.md            reviews the diff against plan, docs and rules
  finalize-task/SKILL.md               opens the PR; merges only with explicit approval
.claude/skills -> ../.agents/skills    symlink so Claude Code finds the same skills
```

The installer also adds `CLAUDE.local.md` and `.claude/settings.local.json` to `.gitignore`.

## How it stays tool-agnostic

- **`AGENTS.md` is the single source of truth.** `CLAUDE.md` only imports it with `@AGENTS.md`, so Claude Code and Cursor read identical rules.
- **Skills live in `.agents/skills/`.** `.claude/skills` is a symlink to that folder, so there is one copy to edit. If symlinks are not available (for example on some Windows setups), the installer copies the folder instead and tells you to re-copy after editing.
- **A command table is the fallback.** `AGENTS.md` maps each command (`plan-task`, `groom-task`, ...) to its `SKILL.md`. If a tool does not discover skills, saying "run plan-task" still works, because the agent opens the file listed in the table.

## Quick start

There are two ways to use the kit. Pick one.

### Option A: let your agent set it up (recommended)

Install the `setup-ai-workflow` skill once for your user:

```bash
git clone https://github.com/tarektech/ai-workflow-kit.git
```

```bash
cd ai-workflow-kit && ./install.sh --skill
```

This copies the skill to `~/.claude/skills/setup-ai-workflow`. Claude Code reads that folder, and Cursor 2.4 or later also discovers skills there. To install somewhere else, pass `--skill-dir`, for example `./install.sh --skill --skill-dir ~/.cursor/skills`.

Then open any project in Claude Code or Cursor and say:

> set up the AI workflow

The agent detects whether the project is new or existing, confirms what it found with you, installs the templates, fills in `docs/` and `AGENTS.md` from your codebase (marking anything it cannot verify as `TODO: confirm`), and gives you a final report. It does not touch application code.

### Option B: just copy the templates

From a clone, point the installer at your project:

```bash
./install.sh /path/to/your/project
```

Then replace the `TODO` placeholders in `AGENTS.md` and `docs/` yourself.

### Without cloning

The installer can download the kit by itself:

```bash
curl -fsSL https://raw.githubusercontent.com/tarektech/ai-workflow-kit/main/install.sh | bash -s -- --skill
```

To install the templates into the current directory instead, drop `--skill`. Set `AIWK_REF` to a tag (for example `AIWK_REF=v0.1.0`) to pin a version. As with any piped script, read [`install.sh`](install.sh) first.

### Safe to re-run

The installer never overwrites anything. Files that already exist are listed as skipped, and an existing `.claude/skills` folder is left alone with a warning. If you already have an `AGENTS.md` or `CLAUDE.md`, merge by hand, or let the skill propose a merge for you to approve.

## Daily use

Say the command in chat. Tools that discover skills may also offer them as `/plan-task` and so on.

| # | Command | The agent | You |
|---|---|---|---|
| 1 | `plan-task` | Reads the docs and rules, writes `plans/<task>.md`, stops | **Approve the plan** |
| 2 | `groom-task` | Splits the plan into small steps, each with a success condition | Check the steps |
| 3 | `implement-task` | Builds one step at a time, runs tests and lint | Monitor |
| 4 | `code-review-task` | Reviews the diff against the plan, architecture and rules | Read the findings |
| 5 | *(you)* | Waits | **Complete `docs/review-checklist.md`** |
| 6 | `finalize-task` | Opens the PR, merges only if you say so | Approve |

Example:

```
plan-task: add CSV export to reports
```

## Check that your tool sees the skills

Ask in both Claude Code and Cursor:

> List the workflow skills you can see and the file each one comes from.

If a tool does not list them, use the command table ("run plan-task") and update Cursor to 2.4 or later.

## Compatibility

| Tool | How it picks up the workflow |
|---|---|
| Claude Code | `CLAUDE.md` → `@AGENTS.md`; skills via `.claude/skills` |
| Cursor 2.4+ | `AGENTS.md`; skills via `.agents/skills` or `.claude/skills`, with the command table as fallback |
| Other agents that read `AGENTS.md` | Rules from `AGENTS.md`; skills via the command table |

The installer needs `bash`. Installing without a clone also needs `curl` and `tar`. It runs on Linux, macOS (including the default bash 3.2) and Git Bash on Windows.

## Repository layout

```
install.sh                         installer (templates into a project, or the skill for your user)
skills/setup-ai-workflow/
  SKILL.md                         the setup skill your agent follows
  scripts/install.sh               the non-overwriting template copier
  assets/templates/                everything that lands in your project
tests/smoke.sh                     end-to-end installer tests
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Changes are tracked in [CHANGELOG.md](CHANGELOG.md).

## Credits

The four-stage structure of this workflow is based on the **"AI for Software Engineers Guide" by Tech Yehia**. Read the original guide for the full reasoning behind it.

This repository is an independent, tool-agnostic implementation. It is not affiliated with or endorsed by Tech Yehia, and it does not include the guide's PDF, text or branding.

## License

[MIT](LICENSE) © tarektech
