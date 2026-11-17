# Planning and memory

Sessions don't remember each other. These files do:

| File | Holds |
|---|---|
| `docs/ROADMAP.md` | Milestones and their status, plus known debt |
| `docs/plans/<feature>.md` | One feature: goal, acceptance criteria, tasks, test plan, open questions |
| `docs/PROGRESS.md` | Append-only log: what was done, decided, next, blocked |
| `docs/adr/NNNN-*.md` | Decisions and why |

- Start of a session: read `git log --oneline -15`, the last entries of `docs/PROGRESS.md`, and the active plan. Run `scripts/check.sh` to confirm a green baseline before changing anything.
- Work that is bigger than one commit gets a plan first. Each task in it fits in one commit and names how it will be verified.
- One task at a time. Finish it, check it, commit it, log it, then pick the next.
- In a plan, tick tasks; don't delete or reword acceptance criteria or tests to fit what you built. If the plan is wrong, stop, edit it in a visible note, and say so.
- After each task, append to `docs/PROGRESS.md`: date, task, what changed, decisions, next step, blockers. Facts only, a few lines.
- Don't guess requirements or APIs. Read the code or docs, or write the question in the plan's Open questions and ask.
- When the same mistake happens twice, add a line to `AGENTS.md` or a rule so it doesn't happen a third time.
