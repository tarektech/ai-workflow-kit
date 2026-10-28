---
name: implement-task
description: Implement a groomed plan one step at a time, running tests and lint after each step. Use after groom-task, or when the user says "implement-task".
---

# implement-task

1. Read the plan and its numbered steps. If there are none, run groom-task first.
2. Work on exactly one step at a time, following `docs/conventions.md` and `docs/engineering-guidelines.md`.
3. After each step, run the test and lint commands from `docs/testing.md`. Fix failures before moving on.
4. Never edit, skip or loosen a test just to make it pass. If a test is wrong, explain why and ask.
5. Stay inside the plan. If you find something outside it, note it and ask instead of doing it.
6. After each step, mark it done in the plan and say what changed.
7. When all steps are done, summarize the result and suggest running code-review-task.
