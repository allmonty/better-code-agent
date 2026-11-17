# Progress log

Append-only. Newest entry at the bottom.

## 2026-11-17: v0.1 core
- Done: scaffold and self-check; rules; templates; bootstrap.sh; Stop hook; build skills; review skills; references with link checker and update skill; README and memory files. Each in its own commit, each mutation-tested where it has logic.
- Decided: review skills use `context: fork` for a fresh-context reviewer (Anthropic best practices). The Stop hook keeps a per-repo retry counter in `.git/better-code-agent/` and gives up after 3 failures, instead of relying only on `stop_hook_active`, so a real fix attempt gets several tries but a broken environment can't trap the agent. Rules ship into `.claude/rules/` so Claude Code loads them, with AGENTS.md pointing other agents there.
- Next: try the loop end to end on a real project; then skill evals.
- Blocked: none.
