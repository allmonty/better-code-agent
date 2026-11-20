# Roadmap

| Milestone | Status | Notes |
|---|---|---|
| v0.1 core: rules, templates, bootstrap, Stop hook, build/review skills, references | done | 2026-11-17 |
| Skill evals with `claude plugin eval` (baseline vs. plugin on real tasks) | done | 11 cases; results in the README. Next: weaker models, longer tasks |
| Stack packs (TypeScript/React, Python, Elixir) as path-scoped rules | planned | |
| Adapters for Cursor, Copilot, Codex skills directories | planned | AGENTS.md already works there |
| CI template that runs `scripts/check.sh` on push and PRs | done | 2026-11-20; `review-change` in CI still open |
| Publish to GitHub (`allmonty/better-code-agent`) with install lines in the README | done | 2026-11-17 |

## Next up
In priority order. Tick items when done; prune ticked ones now and then.

1. [ ] Use the plugin on a real project and note which rules and skills earn their place.
2. [ ] Haiku still doesn't plan or commit in steps on long-feature-end-to-end (Sonnet does after the trigger change). Find what makes it skip `plan-feature`; re-measure.
3. [ ] Measure loading rules on demand vs. always (the ETH Zurich AGENTS.md study suggests lower cost), using the eval suite.
4. [ ] Stack packs, agent adapters and the CI template (milestones above).
5. [ ] Refresh `docs/REFERENCES.md` with `update-references` around mid-December 2026; the next Thoughtworks Radar is due in April 2027.

Done: post-fix Haiku reruns, long multi-task evals, "Use with any agent" README section, plugin icon and Stop hook fingerprint (2026-11-20). CI workflow template; skills trigger on build and whole-plan requests; skills anchored to the working directory (2026-11-20).

## Debt
- The OpenAI harness engineering post blocks automated fetching; its summary is from InfoQ coverage.
