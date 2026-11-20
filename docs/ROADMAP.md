# Roadmap

| Milestone | Status | Notes |
|---|---|---|
| v0.1 core: rules, templates, bootstrap, Stop hook, build/review skills, references | done | 2026-11-17 |
| Skill evals with `claude plugin eval` (baseline vs. plugin on real tasks) | done | 11 cases; results in the README. Next: weaker models, longer tasks |
| Stack packs (TypeScript/React, Python, Elixir) as path-scoped rules | planned | |
| Adapters for Cursor, Copilot, Codex skills directories | planned | AGENTS.md already works there |
| CI template that runs `scripts/check.sh` and `review-change` on PRs | planned | Sensors after integration |
| Publish to GitHub (`allmonty/better-code-agent`) with install lines in the README | done | 2026-11-17 |

## Next up
In priority order. Tick or remove items as they're done.

1. [ ] Use the plugin on a real project and note which rules and skills earn their place.
2. [ ] Finish the post-fix eval reruns on Haiku (the overnight run on 2026-11-18 timed out on the eval service's side) and update the README cross-model table.
3. [ ] Eval cases for longer, multi-task work, where the guardrails should matter most.
4. [ ] Measure loading rules on demand vs. always (the ETH Zurich AGENTS.md study suggests lower cost), using the eval suite.
5. [ ] "Use with any agent" README section with a copy-paste prompt for Codex, Cursor and Gemini.
6. [ ] Stack packs, agent adapters and the CI template (milestones above).
7. [ ] Small debt below: plugin icon, untracked-file hashing in the Stop hook.
8. [ ] Refresh `docs/REFERENCES.md` with `update-references` around mid-December 2026; the next Thoughtworks Radar is due in April 2027.

## Debt
- `hooks/check-on-stop.sh`: hashes every untracked file on each stop and session start; slow in repos with huge untracked trees. Fix if it shows up in practice.
- The OpenAI harness engineering post blocks automated fetching; its summary is from InfoQ coverage.
- No plugin icon (validator warning).
