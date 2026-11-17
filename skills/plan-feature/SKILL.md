---
name: plan-feature
description: Breaks a feature or large change into a written plan in docs/plans/ with acceptance criteria, one-commit tasks with a verification each, a test plan and open questions, then stops for approval. Use before any work bigger than one commit, or when the user asks to plan, spec or break down a feature.
argument-hint: "[feature description]"
---

# Plan a feature

Feature: $ARGUMENTS

1. **Read first.** Read `AGENTS.md`, `docs/ROADMAP.md`, the last entries of `docs/PROGRESS.md`, related ADRs, and the code the feature touches. Trace the real flow: entry points, data, callers, existing tests. Note helpers and patterns to reuse.
2. **Ask what you can't find.** If the goal, users, edge cases or constraints are unclear, ask before writing. Don't fill gaps with guesses.
3. **Write `docs/plans/<feature-slug>.md`** from `docs/plans/_template.md`, sized to the work: a two- or three-commit change gets a goal, a few criteria and its tasks, not user stories or a design essay. Drop template sections that would be empty.
   - Goal: what the user can do afterwards.
   - Acceptance criteria: observable and testable, numbered.
   - Out of scope: what you're deliberately not doing.
   - Design: where it fits in the existing architecture (`.claude/rules/architecture.md`). If it needs a real decision between options, add an ADR task.
   - Tasks: ordered, each fits in one commit, each ends with `verify:` naming the test or command. Start with the riskiest or most uncertain part. Include tasks for migrations, docs and e2e where needed.
   - Test plan: which level covers each acceptance criterion (`.claude/rules/testing.md`).
   - Open questions.
4. **Register it** in `docs/ROADMAP.md` with status `planned`.
5. **Stop.** Show the plan's tasks and open questions and ask for approval. Don't write code in this skill.

A good task: "Add `RateLimiter.allow(key)` with a sliding window — verify: unit tests for limit, window reset, separate keys". A bad task: "Implement rate limiting".
