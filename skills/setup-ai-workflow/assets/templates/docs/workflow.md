# Daily Workflow

Every task goes through the same stages, in the same order.

| # | Command | What the agent does | Your role |
|---|---|---|---|
| 1 | plan-task | Reads docs and rules, writes a plan to `plans/<task-name>.md` | **Approve the plan** |
| 2 | groom-task | Splits the plan into small steps, each with a success condition | Check the steps |
| 3 | implement-task | Builds one step at a time, runs tests and lint | Monitor |
| 4 | code-review-task | Reviews the diff against plan, architecture and rules | Read the findings |
| 5 | (you) | Complete `docs/review-checklist.md` | **Review** |
| 6 | finalize-task | Opens the PR and merges | Runs only after you approve |

## How to run a step
Say the command, e.g. "run plan-task for: add rate limiting to the API".
Tools that discover skills may also offer them as `/plan-task`. Otherwise the agent follows the file listed in `AGENTS.md`.

## Example
1. "plan-task: add CSV export to reports" → agent writes `plans/csv-export.md`, stops.
2. You edit or approve the plan.
3. "groom-task" → numbered steps with success conditions.
4. "implement-task" → step 1, tests green, step 2, and so on.
5. "code-review-task" → findings by severity; fix them.
6. You fill in the review checklist.
7. "finalize-task" → PR opened and merged.
