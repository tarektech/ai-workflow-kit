---
name: groom-task
description: Split an approved plan into small ordered steps, each with a clear success condition. Use after the human approves a plan, or when the user says "groom-task".
---

# groom-task

1. Open the approved plan in `plans/<task-name>.md`. If it is not approved, stop and ask.
2. Split it into small, ordered steps. Each step should be reviewable on its own.
3. Give every step a success condition: a test that passes, a command with expected output, or an observable behavior.
4. Add the numbered steps to the plan file under a "Steps" heading.
5. Flag steps that touch anything outside the plan. Do not add scope silently.
6. Show the steps to the human and wait for confirmation.
