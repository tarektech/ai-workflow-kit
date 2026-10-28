# Contributing

Thanks for helping improve ai-workflow-kit. Issues and pull requests are welcome.

## Principles

Every change should keep these true:

1. **Tool-agnostic.** `AGENTS.md` is the single source of truth. Never put rules only in `CLAUDE.md`, `.cursor/` or another tool-specific file. Skills live in `.agents/skills/`; `.claude/skills` is only a symlink to it.
2. **Never overwrite.** The installers must skip existing files and say so. Re-running must be safe.
3. **No invented facts.** Templates use `TODO: confirm` for anything project-specific. The setup skill must never guess.
4. **Human in the loop.** Skills stop for approval after planning and never merge without explicit approval.
5. **Short and specific.** Agents follow short, concrete files better than long ones. Prefer one clear sentence over three.

## Where things live

| You want to change | Edit |
|---|---|
| What lands in a user's project | `skills/setup-ai-workflow/assets/templates/` |
| How the agent sets up a project | `skills/setup-ai-workflow/SKILL.md` |
| How templates are copied | `skills/setup-ai-workflow/scripts/install.sh` |
| The entry point and the skill install | `install.sh` |

If you add, rename or remove a template, update the tree in `README.md` and the list in `SKILL.md`. If you add or rename a task skill, update the command table in `templates/AGENTS.md` and `templates/docs/workflow.md` too.

## Development setup

```bash
git clone https://github.com/tarektech/ai-workflow-kit.git
```

```bash
cd ai-workflow-kit && ./install.sh --skill --link
```

`--link` symlinks the installed skill to your clone, so your edits apply right away. If you already have the skill installed, remove `~/.claude/skills/setup-ai-workflow` first.

To try the templates, install them into a scratch project and run through the workflow in Claude Code and in Cursor:

```bash
mkdir -p /tmp/demo && ./install.sh /tmp/demo
```

## Tests

Run both before opening a pull request. CI runs the same checks on Linux and macOS.

```bash
bash tests/smoke.sh
```

```bash
shellcheck install.sh tests/smoke.sh skills/setup-ai-workflow/scripts/install.sh
```

Shell scripts must work with bash 3.2 (the macOS default): no associative arrays, `mapfile` or `${var,,}`. Add a check to `tests/smoke.sh` for any new installer behavior.

## Pull requests

- Keep each pull request to one change, and explain what changed and why.
- Add a line under `## [Unreleased]` in `CHANGELOG.md` for anything users will notice.
- For template or skill changes, describe how you tested them (which tool, which prompt, what the agent did).
- Write commit messages in the imperative mood, for example "Add Windows note to README".

## Attribution and third-party content

The workflow is based on the "AI for Software Engineers Guide" by Tech Yehia, credited in the README. Do not add the guide's PDF, copied passages, images, logos or other branding to this repository. Write everything in your own words.

## License

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
