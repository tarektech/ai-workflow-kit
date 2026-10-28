# Project rules

<!-- TODO: one-line project description. -->
Test command: `TODO: confirm`  ·  Lint command: `TODO: confirm`

## Rules
- Read `docs/architecture.md` before adding or changing a module.
- Follow `docs/engineering-guidelines.md` and `docs/conventions.md` for all new code.
- Every change needs a test (see `docs/testing.md`). Never edit a test just to make it pass.
- Use the workflow commands below in order. Never skip plan approval or the human review.
- Never merge or run `finalize-task` without explicit human approval.
- Never write secrets into any file.
- If unsure, ask instead of guessing.

## Workflow commands
When I say one of these, open the file and follow it exactly:

| Command | File |
|---|---|
| plan-task | .agents/skills/plan-task/SKILL.md |
| groom-task | .agents/skills/groom-task/SKILL.md |
| implement-task | .agents/skills/implement-task/SKILL.md |
| code-review-task | .agents/skills/code-review-task/SKILL.md |
| finalize-task | .agents/skills/finalize-task/SKILL.md |

Order: plan-task → (human approves) → groom-task → implement-task → code-review-task → (human reviews) → finalize-task. See `docs/workflow.md`.
