---
name: bootstrap-project
description: Installs the better-code-agent guardrails into the current project - AGENTS.md, rules, roadmap/progress/plan/ADR files and a scripts/check.sh quality gate filled in for the detected stack. Use when starting a new project or adding guardrails to an existing one.
disable-model-invocation: true
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/bootstrap.sh *)
---

# Bootstrap project guardrails

Copy this checklist and tick it as you go:

```
- [ ] 1. Copy templates
- [ ] 2. Detect the stack
- [ ] 3. Fill scripts/check.sh
- [ ] 4. Fill AGENTS.md
- [ ] 5. Seed the roadmap
- [ ] 6. Prove the gate works
- [ ] 7. Commit
```

1. **Copy templates.** Run `${CLAUDE_PLUGIN_ROOT}/scripts/bootstrap.sh "$PWD"`. It never overwrites; note which files it skipped. Where a file already existed (for example an AGENTS.md), merge the missing sections into it instead of replacing it.
2. **Detect the stack** from manifests and lockfiles. Read `.claude/rules/stack-practices.md`. List the formatter, linter, type checker, test runner and e2e tool already configured; prefer those over new ones.
3. **Fill `scripts/check.sh`** with the format check, lint, type check and test commands, in that order, each failing the script on error. Use what the project already has (`npm run lint`, `make test`, ...). If a category has no tool, add the stack's standard one only after asking the user. Remove the "not configured" stub.
4. **Fill `AGENTS.md`**: the one-line description, the exact commands (check, single test, run app), and any conventions or gotchas you found that the code doesn't make obvious. Keep it short: no architecture tour, no generic advice.
5. **Seed `docs/ROADMAP.md`** with milestones the user names. Leave it empty if they name none; don't invent work.
6. **Prove the gate works.** Run `scripts/check.sh` and show the output. If it fails on existing problems, report them; fixing them is separate work, each fix its own commit.
7. **Commit** the guardrail files alone, with a message saying what was installed.

The Stop hook from the plugin now runs `scripts/check.sh` whenever you try to finish with changed files.
