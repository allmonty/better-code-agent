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
In priority order. Tick items when done; prune ticked ones now and then.

1. [ ] Use the plugin on a real project and note which rules and skills earn their place.
2. [ ] Make `plan-feature` and `implement-task` start on their own for "build X" requests and whole-plan runs (long-feature-end-to-end: no plan or step commits on any model; long-implement-whole-plan: no progress log). Re-measure with the long evals.
3. [ ] Measure loading rules on demand vs. always (the ETH Zurich AGENTS.md study suggests lower cost), using the eval suite.
4. [ ] Stack packs, agent adapters and the CI template (milestones above).
5. [ ] Refresh `docs/REFERENCES.md` with `update-references` around mid-December 2026; the next Thoughtworks Radar is due in April 2027.

Done: post-fix Haiku reruns, long multi-task evals, "Use with any agent" README section, plugin icon and Stop hook fingerprint (2026-11-20).

## Debt
- The OpenAI harness engineering post blocks automated fetching; its summary is from InfoQ coverage.
