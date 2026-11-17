---
name: verify-done
description: Runs the definition-of-done check before claiming a task or feature is complete - every acceptance criterion backed by evidence, a fresh scripts/check.sh run, work committed, plan, progress log and roadmap updated, no leftovers. Use before saying work is done, finished, complete or ready, and when the user asks whether something is really done.
---

# Verify done

Don't report done until each line below holds, with evidence shown.

```
- [ ] Each acceptance criterion: the test name or command output that proves it
- [ ] scripts/check.sh run now, output shown, green
- [ ] User-facing change: the app was run, or its e2e test exercised the change
- [ ] git status clean; the work is committed in one-change commits
- [ ] No test deleted, skipped or loosened in this work (git diff of test files)
- [ ] No leftovers in the diff: debug prints, commented-out code, TODO without a `shortcut:` note
- [ ] Plan tasks ticked; plan status, docs/ROADMAP.md and docs/PROGRESS.md updated
- [ ] Known limits written down as `shortcut:` comments and under Debt in the roadmap
- [ ] Harness retro: anything to add (a mistake you or the user corrected twice) or prune (a rule that didn't apply or contradicts the code)?
```

1. Find the acceptance criteria in the active plan in `docs/plans/` (or the user's request if there is no plan).
2. Work through the list. Run commands; don't rely on earlier runs or memory.
3. For anything that fails, fix it if it's in scope, then rerun the whole list. If it's out of scope or blocked, say so.
4. For the harness retro, propose the exact line to add to or remove from `AGENTS.md` or `.claude/rules/`; don't edit them without the user's OK.
5. Report either **Done**, with the evidence for each line, or **Not done**, with what is missing.

If `/verify` is available and the change is user-facing, use it for the third line.
