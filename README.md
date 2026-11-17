# better-code-agent

Guardrails that keep AI-written code at production quality without reading every line yourself.

Following [Böckeler's harness engineering](https://martinfowler.com/articles/harness-engineering.html) framing, a harness has two halves:

- **Guides** steer the agent before it acts: short rules, an `AGENTS.md` map, and skills for planning and building.
- **Sensors** catch what slipped through: a single `scripts/check.sh` gate, a Stop hook that won't let the agent finish while it fails, and review skills that run in a fresh context.

A memory loop (roadmap, per-feature plans, progress log, ADRs) lets big features be built one verified commit at a time instead of in one hallucination-prone pass.

> You still steer. Every source in [docs/REFERENCES.md](docs/REFERENCES.md) keeps humans on the spec and acceptance criteria. The harness moves your attention from reading diffs to approving plans and reading evidence.

## What's inside

| Piece | What it does | Runs |
|---|---|---|
| `rules/` | Code quality, testing levels, architecture, security, stack tooling, planning/memory, commits. About 100 lines in total. | Loaded every session from `.claude/rules/` |
| `bootstrap-project` | Installs templates and rules into a project, fills `scripts/check.sh` and `AGENTS.md` for its stack | You: `/better-code-agent:bootstrap-project` |
| `plan-feature` | Writes `docs/plans/<feature>.md`: acceptance criteria, one-commit tasks, test plan; stops for approval | You or the agent |
| `implement-task` | One task per run: restore context, green baseline, test first, check, commit, log | You or the agent |
| `architecture-decision` | Compares real options, writes an ADR, names the lint rule or structural test that enforces it | You or the agent |
| `review-change` | Fresh-context review that reads beyond the diff; ranked, verified findings | You or the agent (forked subagent) |
| `review-tests` | Would these tests catch a bug? Mutation thinking, weakened-test detection | You or the agent (forked subagent) |
| `verify-done` | Definition of done with evidence for each item | The agent, before saying "done" |
| `update-references` | Refreshes the reading list from official sources first | You, or a monthly routine |
| Stop hook | Runs `scripts/check.sh` (or `make check`) when the agent tries to stop; blocks on failure | Automatically |

## Install

**1. The plugin** (skills + Stop hook), once per machine:

```
/plugin marketplace add /path/to/better-code-agent      # or <owner>/better-code-agent once it's on GitHub
/plugin install better-code-agent@better-code-agent
```

**2. Each project**, from inside it:

```
/better-code-agent:bootstrap-project
```

Or without Claude: `/path/to/better-code-agent/scripts/bootstrap.sh <project-dir>`, then fill in `scripts/check.sh` and the commands in `AGENTS.md`. The script never overwrites existing files.

This adds `AGENTS.md`, `CLAUDE.md` (imports it), `.claude/rules/*.md`, `docs/ROADMAP.md`, `docs/PROGRESS.md`, `docs/plans/_template.md`, `docs/adr/0000-template.md` and `scripts/check.sh`.

**Other agents** (Codex, Cursor, Copilot, Gemini CLI, ...) read `AGENTS.md`, which points them to the rules and memory files. To get the skills too, copy `skills/*` into the directory your agent loads skills from (often `.agents/skills/`). The Stop hook is Claude Code only; elsewhere, run `scripts/check.sh` in CI or a pre-commit hook.

## The loop

```
plan-feature ──► you approve the plan
      │
      ▼
implement-task ──► test first → code → scripts/check.sh → commit → tick + log   (repeat per task)
      │                                    ▲
      │                     Stop hook blocks finishing while red
      ▼
review-change / review-tests ──► fix must-fixes as their own commits
      │
      ▼
verify-done ──► evidence for every acceptance criterion
```

New session? `implement-task` rebuilds context from `git log`, `docs/PROGRESS.md` and the plan, so nothing depends on chat history.

## Stop hook settings

| Env var | Default | Effect |
|---|---|---|
| `BCA_MAX_BLOCKS` | `3` | Failed checks in a row before the agent may stop anyway (you get a warning that the work is not green) |
| `BCA_DISABLE_STOP_HOOK` | unset | `1` turns the hook off |

The hook does nothing in non-git directories or projects without `scripts/check.sh` or a `make check` target. It skips the run when nothing changed since the last green check, so question-only turns stay fast.

## Keep the references fresh

Run `/better-code-agent:update-references` by hand, or schedule it monthly with `/schedule`, using a prompt such as:

> In the better-code-agent repo, follow `skills/update-references/SKILL.md` and open a PR with the result.

## Growing your harness

When the agent makes the same mistake twice, add one plain line to the project's `AGENTS.md` or a rule. If a rule must never be broken, turn it into a check in `scripts/check.sh` (a lint rule, a structural test) rather than stronger wording. Delete rules the agent already follows on its own.

## Developing this repo

`scripts/check.sh` runs `tests/run.sh`: shell syntax, JSON validity, and tests for the bootstrap script, the Stop hook, the link checker and the skill format. `claude plugin validate .` checks the manifests. See [AGENTS.md](AGENTS.md) and [docs/ROADMAP.md](docs/ROADMAP.md).
