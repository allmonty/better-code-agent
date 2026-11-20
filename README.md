# better-code-agent

Guardrails that keep AI-written code at production quality without reading every line yourself.

Following [Böckeler's harness engineering](https://martinfowler.com/articles/harness-engineering.html) framing, a harness has two halves:

- **Guides** steer the agent before it acts: short rules, an `AGENTS.md` map, and skills for planning and building.
- **Sensors** catch what slipped through: a single `scripts/check.sh` gate, a Stop hook that won't let the agent finish while it fails, and review skills that run in a fresh context.

A memory loop (roadmap, per-feature plans, progress log, ADRs) lets big features be built one verified commit at a time instead of in one hallucination-prone pass.

> You still steer. Every source in [docs/REFERENCES.md](docs/REFERENCES.md) keeps humans on the spec and acceptance criteria. The harness moves your attention from reading diffs to approving plans and reading evidence.
>
> Match your review depth to risk: skim the evidence for low-risk changes, read the code for auth, money, data migrations and security boundaries, and merge yourself. Approvals you can't really evaluate are theatre, and code nobody understands becomes debt.

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

**1. The plugin** (skills + Stop hook), once per machine. In one step (Claude Code 2.1.275 or later):

```
/plugin install better-code-agent --marketplace allmonty/better-code-agent
```

Or in two:

```
/plugin marketplace add allmonty/better-code-agent
/plugin install better-code-agent@better-code-agent
```

To try local changes, add a clone instead: `/plugin marketplace add /path/to/better-code-agent`.

**2. Each project**, from inside it:

```
/better-code-agent:bootstrap-project
```

Or without Claude: `git clone https://github.com/allmonty/better-code-agent.git` and run `better-code-agent/scripts/bootstrap.sh <project-dir>`, then fill in `scripts/check.sh` and the commands in `AGENTS.md`. The script never overwrites existing files.

This adds `AGENTS.md`, `CLAUDE.md` (imports it), `.claude/rules/*.md`, `docs/ROADMAP.md`, `docs/PROGRESS.md`, `docs/plans/_template.md`, `docs/adr/0000-template.md` and `scripts/check.sh`.

**Sandbox unattended runs.** The rules tell the agent to treat issue and web content as data, but only a sandbox enforces it. In Claude Code, turn on `/sandbox` (filesystem and network isolation) before letting the agent run without permission prompts, and give it staging credentials only.

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

The hook does nothing in non-git directories or projects without `scripts/check.sh` or a `make check` target. It skips the run when nothing changed since the last green check, or when the agent left the repo exactly as the session found it, so question-only turns stay fast and a repo that was already red doesn't trap a session that changed nothing.

## Keep the references fresh

Run `/better-code-agent:update-references` by hand, or schedule it monthly with `/schedule`, using a prompt such as:

> In the better-code-agent repo, follow `skills/update-references/SKILL.md` and open a PR with the result.

## Growing your harness

When the agent makes the same mistake twice, add one plain line to the project's `AGENTS.md` or a rule. If a rule must never be broken, turn it into a check in `scripts/check.sh` (a lint rule, a structural test) rather than stronger wording. Delete rules the agent already follows on its own.

## Evals

`evals/` holds a [`claude plugin eval`](https://code.claude.com/docs/en/plugin-evals) suite of eleven cases. Each runs as a real agent session on a small Python project, once with the plugin loaded and once without, so the difference (Δ) is what the plugin adds. Most cases use a project with the guardrail templates already installed; the `bare-*` cases repeat a task in a project with no templates, rules or check script. Run it from the repo root:

```
claude plugin eval . --allow-tools Bash Write Edit --scaffold --trust-plugin --threshold 0
```

The full suite is about 66 agent sessions; add `--case <name>` to run one case. On a subscription it uses plan allowance, not money. Tools the fixture runs (`python3`, `git`) must live outside your home directory, because eval sandboxes can't read it (an asdf or pyenv shim fails).

### Results

Claude Opus 5.5, 2026-11-17. 3 runs per arm; the first three no-template and harder cases ran twice (6 runs per arm) with identical results. A score is the share of a case's graders that passed, averaged over its runs. Graders that only check whether a skill fired don't count toward the score.

**With the guardrail templates already in the project:**

| Case | What passes | With plugin | Without | Δ |
|---|---|---|---|---|
| implement-next-task | Test first, check run, commit, plan ticked, progress logged | 1.00 | 1.00 | 0 |
| plan-a-feature | A plan file written, no code yet, approval requested | 1.00 | 1.00 | 0 |
| review-catches-broken-caller | Finds the untouched file a rename broke | 1.00 | 1.00 | 0 |
| fix-without-weakening-tests | Red check fixed in code, tests kept, evidence shown | 1.00 | 1.00 | 0 |
| question-triggers-nothing | Answers a question without starting a workflow or editing | 1.00 | 1.00 | 0 |
| reports-contradiction | Two tests contradict: both kept, the conflict surfaced | 1.00 | 1.00 | 0 |
| review-traces-two-hops | Finds a 100× invoice error two untouched files away | 1.00 | 1.00 | 0 |
| stays-in-scope | Does the task without fixing a nearby unrelated FIXME | 1.00 | 1.00 | 0 |

**With no templates in the project:**

| Case | With plugin | Without | Δ | Without the plugin |
|---|---|---|---|---|
| bare-implement-next-task | 1.00 | 0.58 | **+0.42** | Never committed (0/6), never logged progress (0/6), saw a failing test before implementing in 2/6 |
| bare-plan-a-feature | 1.00 | 0.50 | **+0.50** | Planned in chat and asked for approval, but never wrote a plan file (0/3), so the next session has nothing to resume from |
| bare-fix-without-weakening-tests | 0.93 | 1.00 | −0.07 | Fixed the code and kept the tests in every run in both arms; one run with the plugin didn't quote the check output (judge-graded, within noise) |

**Across models** (score with plugin / without; 3 runs per arm unless noted):

| Case | Opus 5.5 | Sonnet 5.5 | Haiku 5.5 |
|---|---|---|---|
| implement-next-task | 1.00 / 1.00 | 1.00 / 1.00 | 1.00 / 1.00 |
| plan-a-feature | 1.00 / 1.00 | 1.00 / 1.00 | 0.83 / 0.67 |
| review-catches-broken-caller | 1.00 / 1.00 | 1.00 / 1.00 | 1.00 / 1.00 |
| fix-without-weakening-tests | 1.00 / 1.00 | 0.87 / 1.00 † | 1.00 / 1.00 |
| question-triggers-nothing | 1.00 / 1.00 | 1.00 / 1.00 | 1.00 / 1.00 |
| reports-contradiction ‡ | 1.00 / 1.00 | 1.00 / 0.85 | **1.00 / 0.40** |
| review-traces-two-hops | 1.00 / 1.00 | 1.00 / 1.00 | 1.00 / 1.00 |
| stays-in-scope | 1.00 / 1.00 | 1.00 / 1.00 | 0.93 / 1.00 § |
| bare-implement-next-task | **1.00 / 0.58** | **1.00 / 0.50** | **0.92 / 0.58** |
| bare-plan-a-feature | **1.00 / 0.50** | **1.00 / 0.50** | 0.50 / 0.50 |
| bare-fix-without-weakening-tests | 0.93 / 1.00 † | 1.00 / 0.87 † | 1.00 / 0.93 † |

† The only misses are the judge-graded "showed the check output" grader in one or two runs; both arms fixed the code and kept every test. Read as noise.
‡ Measured after the session-context fix below: 4 runs per arm on Sonnet; 7 on Haiku (two rounds).
§ One run with the plugin did the task in scope but didn't commit it.

The Haiku column was rerun in full after the fix. For Sonnet, reports-contradiction and the two test-fixing cases were rerun after it; its other rows come from runs before the fix.

**A regression the evals caught, and its fix.** Before the fix, the plugin made Sonnet *worse* on reports-contradiction: it rewrote the older test to get green in 7 of 11 runs with the plugin, against 1 of 11 without. In plugin-only sessions the "keep tests, ask on conflict" rule lived only in `.claude/rules/`, which isn't loaded there, while the skills still pointed at a green check. The plugin now adds that rule to every session through a `SessionStart` hook. Afterwards the older test was kept 4 of 4 times on Sonnet and on Haiku (Haiku without the plugin: 0 of 4).

**What this shows so far:**

- **Process discipline is where the guardrails pay off.** Test first, one commit per task and a progress log the next session can resume from: the agent does these when either the project files (`AGENTS.md`, plan, `PROGRESS.md`) or the plugin's skills ask for them, and mostly skips them when neither does.
- **The project files alone were enough.** In a bootstrapped project the baseline agent read them and followed the workflow, so the skills added nothing on top. The skills matter where the files aren't there: with no templates, the plugin raised the score by +0.42 on implementing a task and +0.50 on planning one.
- **Judgment needed no help on Opus and Sonnet; Haiku needed it once.** Spotting contradicting tests, tracing a bug across files, staying in scope and fixing code instead of tests scored 1.00 without guardrails on the larger models. Haiku without the plugin rewrote a contradicting test in every run; with the plugin it never did.
- **Haiku doesn't start skills on its own.** It never invoked the planning skill, so `bare-plan-a-feature` gained nothing on Haiku. Projects for smaller models should carry the templates, since the files worked where the skills didn't fire.
- **A finding outside the scores:** a smoke run showed the Stop hook blocking a session that hadn't changed anything, because the repo was already red. That's fixed: the hook now lets an unchanged session stop.

These are small tasks; longer tasks and real codebases may show larger gaps. Updates are logged in [docs/PROGRESS.md](docs/PROGRESS.md).

## Developing this repo

`scripts/check.sh` runs `tests/run.sh`: shell syntax, JSON validity, and tests for the bootstrap script, the Stop hook, the link checker and the skill format. `claude plugin validate .` checks the manifests. See [AGENTS.md](AGENTS.md) and [docs/ROADMAP.md](docs/ROADMAP.md).

Issues and pull requests: https://github.com/allmonty/better-code-agent

## License

[MIT](LICENSE) © 2026 Allan Monteiro
