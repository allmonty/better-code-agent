---
name: review-change
description: Reviews a code change in a fresh context that never saw the reasoning behind it - correctness including code outside the diff, the plan's acceptance criteria, tests, architecture boundaries, security, load, and unneeded code - and reports ranked, verified findings with fixes. Use when the user asks to review changes, a commit, a branch or a PR, or before merging AI-written code.
argument-hint: "[commit | range | branch | PR number]"
context: fork
agent: general-purpose
background: false
---

# Review a change

Work in the user's project: the current working directory. Every path below is relative to it, not to this skill's own folder.

You are reviewing code you didn't write. Read only; don't edit files.

## 1. Get the change
Target: $ARGUMENTS
- Empty: uncommitted changes (`git diff HEAD` plus untracked files); if there are none, the last commit (`git show HEAD`).
- A commit, range or branch: `git diff <base>...<target>` (branch base: `main` or `master`).
- A PR number: `gh pr diff <n>` and `gh pr view <n>`.

## 2. Get the intent
Read `AGENTS.md`, the rules in `.claude/rules/`, and any plan in `docs/plans/` or ADR the change relates to (check commit messages and `docs/PROGRESS.md`). The plan's acceptance criteria are the spec.

## 3. Read beyond the diff
For every changed function, type, field, route or config key, grep its callers and users and read them. Many real bugs are in untouched files: a renamed field, a changed return type, a new required argument.

## 4. Check, in this order
1. **Correctness**: wrong logic, unhandled edge cases (empty, null, zero, max, unicode, concurrent), error paths, broken callers, data migrations without backfill or rollback.
2. **Spec**: each acceptance criterion is implemented and has a test. Anything built that wasn't asked for.
3. **Tests**: new behaviour has tests at the right level; tests would fail if the code broke; no test deleted, skipped or loosened (look for removed asserts, `.skip`, `xit`, `@pytest.mark.skip`, widened tolerances).
4. **Architecture**: forbidden dependency directions, logic in the wrong layer, reaching into another module's internals, new patterns that contradict the codebase or an ADR.
5. **Security**: unvalidated input at trust boundaries, injection, missing authorisation, secrets, unsafe deserialisation, invented or typo-squatted packages.
6. **Load**: N+1 queries, unbounded loops or result sets, missing pagination or timeouts, work in hot paths that should be cached or batched.
7. **Unneeded code**: abstractions with one use, dead code, options nobody asked for, duplicates of an existing helper.

Skip style and formatting; linters own that. A reviewer asked to find problems always finds something, so report only what matters for correctness, safety, maintainability or the spec.

## 5. Verify every finding
Before reporting, re-read the code and confirm the failure scenario is real. Drop anything you can't back with a concrete scenario. "No findings" is a valid result.

## 6. Report
Ranked, most severe first:

```
### [Must fix | Should fix | Consider] <one-line title>
`path/to/file.ext:line`
What happens: <concrete input or state → wrong result>
Fix: <the specific change>
```

End with a verdict: `Ready to merge`, `Merge after must-fixes`, or `Needs rework`, plus anything you could not check (e.g. couldn't run the app).
