---
name: plan-feature
description: Writes a plan in docs/plans/ before building - acceptance criteria, one-commit tasks with a verification each, a test plan and open questions - then stops for approval, or proceeds task by task when the user has said not to wait. Use first whenever the user asks to build, add or implement a feature or change that needs more than one commit, even if they say to just build it or that they are away; also when they ask to plan, spec or break down work.
argument-hint: "[feature description]"
---

# Plan a feature

Work in the user's project: the current working directory. Every path below is relative to it, not to this skill's own folder.

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
5. **Stop for approval.** Show the plan's tasks and open questions and ask for approval. Don't write code in this skill.
   If the user already said to go ahead without them ("just build it", "I'm away", "don't wait for me"), don't stop: answer the open questions with the most reasonable choice, record each one under the plan's Notes, set the status to `approved (by request)`, commit the plan, then implement the tasks one by one with the `implement-task` workflow.

A good task: "Add `RateLimiter.allow(key)` with a sliding window — verify: unit tests for limit, window reset, separate keys". A bad task: "Implement rate limiting".
