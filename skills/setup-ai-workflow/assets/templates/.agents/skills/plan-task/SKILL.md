---
name: plan-task
description: Create an implementation plan for a task before any code is written. Use at the start of every task, when the user says "plan-task", or asks to plan a feature, fix or refactor. Ends by stopping for human approval.
---

# plan-task

1. Read `AGENTS.md` and everything relevant in `docs/` (at least `architecture.md`, `engineering-guidelines.md`, `conventions.md`, `testing.md`).
2. Restate the task in your own words. If anything is ambiguous, ask before continuing.
3. List the affected modules and files, with real paths.
4. List risks, assumptions and open questions.
5. Write the plan to `plans/<task-name>.md`: goal, approach, affected files, risks, how it will be tested, out of scope.
6. **Stop.** Do not write code. Tell the human the plan is ready and wait for approval or edits.
