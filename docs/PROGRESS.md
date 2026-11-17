# Progress log

Append-only. Newest entry at the bottom.

## 2026-11-17: v0.1 core
- Done: scaffold and self-check; rules; templates; bootstrap.sh; Stop hook; build skills; review skills; references with link checker and update skill; README and memory files. Each in its own commit, each mutation-tested where it has logic.
- Decided: review skills use `context: fork` for a fresh-context reviewer (Anthropic best practices). The Stop hook keeps a per-repo retry counter in `.git/better-code-agent/` and gives up after 3 failures, instead of relying only on `stop_hook_active`, so a real fix attempt gets several tries but a broken environment can't trap the agent. Rules ship into `.claude/rules/` so Claude Code loads them, with AGENTS.md pointing other agents there.
- Next: try the loop end to end on a real project; then skill evals.
- Blocked: none.

## 2026-11-17: references refresh, two independent passes
- Done: in-context search plus a no-context subagent search, merged and verified (every URL opened or checked; secondhand claims marked). REFERENCES grew from 20 to ~50 sources, adding agent security, testing of AI-written code, review/oversight and empirical studies.
- Decided: applied the findings as separate commits: agent-safety rules in security.md; trimmed code-quality.md (ETH AGENTS.md study, Radar instruction bloat); duplication and complexity sensors; harness retro and pruning (Radar feedback flywheel, documentation sprawl); plans sized to the work (Böckeler SDD critique); property-based testing; risk-based review and sandboxing in the README.
- Not changed: rules still load every session from `.claude/rules/`. Moving them to on-demand loading would cut context cost (ETH study) but may lower adherence; worth an eval before deciding.
- Next: skill evals; then the on-demand rules question.
- Blocked: none.

## 2026-11-17: first eval run
- Done: `evals/` suite, 5 cases on a bootstrapped Python fixture, 3 runs per arm on Opus 5.5 (~$7 list-price estimate, billed to the subscription allowance, not money).
- Result: every case 1.00 with the plugin and 1.00 without it (Δ 0). The baseline agent read the bootstrapped `AGENTS.md`, plan and memory files and followed the same workflow, so on these tasks the project files carry the behaviour and the plugin's skills add nothing measurable. The Stop hook was seen working in a smoke run (blocked 3 times, then let the agent stop with the not-green warning, and the agent did not touch the tests).
- Decided: graders check file contents, not `Edit` calls, because agents also write files through Bash. Fixture uses Python because an asdf `node` shim can't run inside the eval sandbox.
- Next: bare-project variants (no templates) to measure the harness against nothing, and harder tasks where a strong model without guidance fails.
- Blocked: none.

## 2026-11-17: second eval round (bare-project and harder cases)
- Done: six new cases, 3 runs per arm; the first three ran twice (an inverted skip check in the local queue script reran them) and reproduced exactly. About $10 list-price estimate in total, on the subscription allowance.
- Result: with no templates in the project, the plugin raised bare-implement-next-task from 0.58 to 1.00 (without it: no commits, no progress log, test-first in 2/6) and bare-plan-a-feature from 0.50 to 1.00 (without it: plan only in chat, no plan file). bare-fix-without-weakening-tests 0.93 vs 1.00 (one judge-graded evidence miss with the plugin, within noise). stays-in-scope, reports-contradiction and review-traces-two-hops: 1.00 in both arms.
- Decided: the value is process discipline and durable memory, supplied by either the project files or the skills; judgment tasks need no help on Opus 5.5. The README Results section holds the tables.
- Next: run on a weaker model (`--model sonnet`/`haiku`) and on longer multi-task work, where guardrails are expected to matter more; then revisit loading rules on demand.
- Blocked: none.
