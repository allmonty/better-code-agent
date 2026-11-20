---
name: implement-task
description: Implements tasks from an approved plan in docs/plans/ one at a time - restores context from git log and docs/PROGRESS.md, writes the test first, implements, runs scripts/check.sh, commits, ticks the task and logs progress, then moves to the next task if asked for more than one. Use whenever work follows a plan file - "next task", "continue the plan", "implement the plan", "do the whole plan", "continue where we left off" - or names a plan task.
argument-hint: "[plan file] [task number]"
---

# Implement plan tasks

Work in the user's project: the current working directory. Every path below is relative to it, not to this skill's own folder.

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
7. **Record.** Tick the task in the plan (set the plan to `in progress`, or `done` when every task and acceptance criterion is ticked, and update `docs/ROADMAP.md`). Append an entry to `docs/PROGRESS.md` (create it if missing): date, task, commit, decisions, next task, blockers. Commit these with the task, or as a docs commit right after.

Then report: what changed, the check output, the next task. If the user asked for the whole plan or several tasks, go straight on to the next task, from step 1, until they're done; otherwise stop here. Each task still gets its own test, check, commit and progress entry.

If the task turns out wrong or too big, don't improvise: add a note to the plan explaining why, propose the split or change, and ask.
