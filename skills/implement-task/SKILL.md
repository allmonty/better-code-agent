---
name: implement-task
description: Implements exactly one task from an approved plan in docs/plans/ - restores context from git log and docs/PROGRESS.md, writes the test first, implements, runs scripts/check.sh, commits, ticks the task and logs progress. Use when continuing planned work, or when the user says "next task", "continue the plan" or names a plan task.
argument-hint: "[plan file] [task number]"
---

# Implement one task

Target: $ARGUMENTS (default: the first unticked task of the plan marked `in progress`, else `approved`).

```
- [ ] 1. Restore context
- [ ] 2. Confirm a green baseline
- [ ] 3. Test first
- [ ] 4. Implement
- [ ] 5. Check
- [ ] 6. Commit
- [ ] 7. Record
```

1. **Restore context.** Run `git log --oneline -15` and `git status`. Read the last entries of `docs/PROGRESS.md`, the plan, and the code the task touches. If the working tree has someone else's uncommitted changes, stop and ask.
2. **Confirm a green baseline.** Run `scripts/check.sh`. If it is already red, report that and stop; don't build on a broken base.
3. **Test first.** Write the test(s) named in the task's `verify:` at the level `.claude/rules/testing.md` calls for. Run them and see them fail for the right reason.
4. **Implement** the smallest change that makes them pass, following `.claude/rules/code-quality.md` and `.claude/rules/architecture.md`. Stay inside the task; note anything else you find in the plan's Notes instead of fixing it now.
5. **Check.** Run `scripts/check.sh` until green. Never skip, delete or loosen a test to get there. If you can't get green, stop and report what fails and why.
6. **Commit** this task alone, per `.claude/rules/commits.md`.
7. **Record.** Tick the task in the plan (set the plan to `in progress`, or `done` when every task and acceptance criterion is ticked, and update `docs/ROADMAP.md`). Append an entry to `docs/PROGRESS.md`: date, task, commit, decisions, next task, blockers. Commit these with the task, or as a docs commit right after.

Then stop and report: what changed, the check output, the next task. Do one task per invocation; the next one starts with fresh context from the files.

If the task turns out wrong or too big, don't improvise: add a note to the plan explaining why, propose the split or change, and ask.
