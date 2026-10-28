---
name: code-review-task
description: Review the current diff against the approved plan, architecture, guidelines and rules, and list problems by severity. Use after implementation, before human review, or when the user says "code-review-task".
---

# code-review-task

1. Get the full diff of the current work.
2. Compare it with the plan: is anything missing, or anything extra that was not planned?
3. Compare it with `docs/architecture.md` (boundaries respected?), `docs/engineering-guidelines.md`, `docs/conventions.md` and `AGENTS.md`.
4. Check tests: do new behaviors have tests, do the tests really exercise them, and were any tests edited, skipped or loosened just to pass?
5. Check for secrets, debug leftovers and obvious security issues.
6. Report findings grouped by severity (blocker, major, minor, nit), each with file and line.
7. Do not fix anything unless asked. End by reminding the human to complete `docs/review-checklist.md`.
