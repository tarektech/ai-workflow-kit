# 0001: Adopt the AI-assisted engineering workflow

- Date: TODO: set date
- Status: accepted

## Context
AI agents produce unreliable results when given large tasks without a written plan, shared rules or human review.

## Decision
Use a 4-stage workflow: written docs (Planning), shared rules and task skills (AGENTS.md, `.agents/skills/`), a fixed daily pipeline (plan → groom → implement → review → finalize), and mandatory human review before every merge.

## Consequences
- Docs and rules must be kept current as the architecture changes.
- Every task takes the same steps, and the human approves the plan and the merge.
- Rules and skills are tool-neutral, so Claude Code and Cursor follow the same files.
