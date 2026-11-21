# Roadmap

| Milestone | Status | Notes |
|---|---|---|
| v0.1 core: rules, templates, bootstrap, Stop hook, build/review skills, references | done | 2026-11-17 |
| Skill evals with `claude plugin eval` (baseline vs. plugin on real tasks) | done | 18 cases; results in the README. Next: real projects |
| Stack packs (TypeScript/React, Python, Elixir) as path-scoped rules | planned | |
| Adapters for Cursor, Copilot, Codex skills directories | planned | AGENTS.md already works there |
| CI template that runs `scripts/check.sh` on push and PRs | done | 2026-11-20; opt-in `review-change` workflow in `ci/github/` |
| Publish to GitHub (`allmonty/better-code-agent`) with install lines in the README | done | 2026-11-17 |

## Next up
In priority order. Tick items when done; prune ticked ones now and then.

1. [ ] Use the plugin on a real project and note which rules and skills earn their place.
2. [ ] Measure loading rules on demand vs. always (the ETH Zurich AGENTS.md study suggests lower cost), using the eval suite.
3. [ ] Stack packs and agent adapters (milestones above). Try `ci/github/review-change.yml` on a real PR (not yet run on GitHub).
4. [ ] Refresh `docs/REFERENCES.md` with `update-references` around mid-December 2026; the next Thoughtworks Radar is due in April 2027.

Done: post-fix Haiku reruns, long multi-task evals, "Use with any agent" README section, plugin icon and Stop hook fingerprint (2026-11-20). CI workflow template; skills trigger on build and whole-plan requests; skills anchored to the working directory (2026-11-20). Haiku plans and commits per task on its own via the session rule (2026-11-20). Stop hook coreutils portability and unborn-repo fix, repo self-CI, strict plugin validation (`.claude/CLAUDE.md`), 4 new eval cases, README reconciliation, community health files, and GitHub discoverability metadata (2026-11-20). Queued 3-run Sonnet/Haiku eval reruns (2026-11-21).

## Debt
- The OpenAI harness engineering post blocks automated fetching; its summary is from InfoQ coverage.
- `hooks/check-on-stop.sh:28` — a same-size edit to an untracked file within the same second goes unseen — hash contents if that bites.
