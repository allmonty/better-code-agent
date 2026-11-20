# AGENTS.md

<!-- One line: what this project is and who uses it. -->

A map, not a manual. Only what an agent can't work out from the code. Add a line when you've had to correct the agent twice.

## Commands
- Check (must be green before any commit or "done"): `scripts/check.sh`
- Run one test: <!-- e.g. pnpm vitest run path/to/file.test.ts -->
- Run the app: <!-- e.g. pnpm dev -->

## Where things are
- Rules: `.claude/rules/` (testing, architecture, security, code-quality, stack-practices, planning-memory, commits). Read the relevant one before that kind of work.
- Memory: `docs/ROADMAP.md`, `docs/PROGRESS.md`, `docs/plans/`, `docs/adr/`.

## Workflow
1. Start: read `git log --oneline -15`, the last entries of `docs/PROGRESS.md`, and the active plan; run the check.
2. Bigger than one commit: write a plan in `docs/plans/` and get it approved first.
3. One task at a time: test first, implement, check green, commit, log in `docs/PROGRESS.md`.
4. Done means: acceptance criteria met, check green with the output shown, plan and progress updated, committed.
5. Existing tests are the spec. Never delete, skip, loosen or rewrite an existing test to make a check pass. If tests contradict each other or one looks wrong, stop and ask which behaviour is intended.

## Conventions
<!-- Decisions not visible in the code, e.g. "use the error helpers in src/lib/errors.ts". -->

## Gotchas
<!-- Misleading spots, e.g. "src/legacy/ is live; don't copy its patterns". -->
