---
name: finalize-task
description: Open the pull request and merge after the human has completed the review checklist. Use only when the human explicitly approves, or when the user says "finalize-task".
---

# finalize-task

1. Ask the human to confirm that every item in `docs/review-checklist.md` is checked. If they are unsure or any item is unchecked, **stop and do not continue**.
2. Confirm tests and lint pass using the commands in `docs/testing.md`.
3. Prepare the PR following `docs/conventions.md`: title, description (what and why), link to the plan, and notes for reviewers.
4. Open the PR.
5. Merge only if the human explicitly told you to, using the merge method in `docs/conventions.md`.
6. Report the PR link and what was merged.
