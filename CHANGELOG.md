# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-10-28

### Added
- `setup-ai-workflow` skill: detects a new or existing project, installs the templates, fills in `docs/` and `AGENTS.md`, verifies, and reports.
- Templates for the four stages: `docs/` (Planning), `AGENTS.md` and `.agents/skills/` (Rules + Skills), the five task skills `plan-task`, `groom-task`, `implement-task`, `code-review-task` and `finalize-task` (Daily Work), and `docs/review-checklist.md` (Own It).
- `CLAUDE.md` that imports `AGENTS.md`, and a `.claude/skills` symlink to `.agents/skills`, with a copy fallback when symlinks are unavailable.
- Command table in `AGENTS.md` as a fallback for tools that do not discover skills.
- Root `install.sh`: installs the templates into a project, or the skill for your user (`--skill`, `--skill-dir`, `--link`), and works when piped from `curl`. It never overwrites existing files.
- Smoke tests (`tests/smoke.sh`) and CI with ShellCheck on Linux and macOS.

### Fixed
- The template installer no longer joins its first `.gitignore` entry onto the last line when the existing `.gitignore` has no trailing newline.

[Unreleased]: https://github.com/tarektech/ai-workflow-kit/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/tarektech/ai-workflow-kit/releases/tag/v0.1.0
