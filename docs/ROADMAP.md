# Roadmap

| Milestone | Status | Notes |
|---|---|---|
| v0.1 core: rules, templates, bootstrap, Stop hook, build/review skills, references | done | 2026-11-17 |
| Skill evals with `claude plugin eval` (baseline vs. plugin on real tasks) | in progress | First run: Δ 0 on a bootstrapped fixture; bare-project and harder cases next |
| Stack packs (TypeScript/React, Python, Elixir) as path-scoped rules | planned | |
| Adapters for Cursor, Copilot, Codex skills directories | planned | AGENTS.md already works there |
| CI template that runs `scripts/check.sh` and `review-change` on PRs | planned | Sensors after integration |
| Publish to GitHub (`allmonty/better-code-agent`) with install lines in the README | in progress | Remote set; first push pending |

## Debt
- `hooks/check-on-stop.sh`: hashes every untracked file on each stop; slow in repos with huge untracked trees. Fix if it shows up in practice.
- The OpenAI harness engineering post blocks automated fetching; its summary is from InfoQ coverage.
- No plugin icon (validator warning).
