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
