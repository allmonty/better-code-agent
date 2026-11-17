# References: building guardrails for AI coding agents

Last reviewed: 2026-11-17

A living reading list behind this repo's rules, skills and hook. Refresh it with the `update-references` skill (see the README for a monthly schedule).

**Tiers.** **Official**: Anthropic, OpenAI, GitHub, the AGENTS.md standard. **Practitioner**: well-known engineers and publications. **Vendor**: companies selling a related product; read for ideas, discount the numbers.
Each entry: title, link, date, tier, the takeaway, and where this repo applies it.

## Harness engineering (guides and sensors)

- **Harness Engineering for Coding Agent Users** — Birgitta Böckeler, martinfowler.com — https://martinfowler.com/articles/harness-engineering.html — 2026-04-02 — Practitioner
  A harness is guides (feedforward: AGENTS.md, skills) plus sensors (feedback: tests, linters, review agents), each either computational (deterministic) or inferential (LLM). Run cheap checks before commit and expensive ones after; write sensor output so an agent can act on it; humans keep steering, especially on behaviour/spec.
  *Applied:* README framing; Stop hook messages written for the agent; `review-change`, `review-tests`.
- **Harness Engineering – first thoughts** — Birgitta Böckeler — https://www.martinfowler.com/articles/exploring-gen-ai/harness-engineering-memo.html — 2026-02-17 — Practitioner
  Summarises OpenAI's harness as context engineering, architectural constraints enforced by linters/structural tests, and "garbage collection" agents against entropy.
- **Harness engineering: leveraging Codex in an agent-first world** — Ryan Lopopolo, OpenAI — https://openai.com/index/harness-engineering/ — 2026-02-11 — Official
  A team shipped a product with no hand-written code by investing in the environment: a structured `docs/` as the agents' system of record (maps, execution plans, design specs), layered architecture enforced by structural tests, and agents that open, evaluate and iterate on their own PRs.
  *Note:* openai.com blocks automated fetching; summary verified via InfoQ coverage: https://www.infoq.com/news/2026/02/openai-harness-engineering-codex/ (2026-02-21).
  *Applied:* `docs/` memory files, `rules/architecture.md` (make boundaries mechanical).
- **Effective harnesses for long-running agents** — Justin Young, Anthropic — https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents — 2025-11-26 — Official
  Agents tried to one-shot work and declared victory early. Fixes: a feature list the agent may only mark passing (never edit or remove tests), a progress file plus git history, a session-start routine (read git log and progress, run a basic check), one feature per session, and end-to-end verification as a user would.
  *Applied:* `rules/planning-memory.md`, `implement-task`, `verify-done`, `rules/testing.md`.

## Instruction files (AGENTS.md, CLAUDE.md, rules)

- **Best practices for Claude Code** — Anthropic docs — https://code.claude.com/docs/en/best-practices — living doc — Official
  Keep CLAUDE.md short: commands, misleading spots, decisions not in the repo, anything corrected twice. Give the agent a pass/fail check; enforce must-always rules with hooks, not emphasis; review with a fresh context and "skip style".
  *Applied:* `templates/AGENTS.md`, `scripts/check.sh` gate, Stop hook, forked review skills.
- **Manage Claude's memory** — Anthropic docs — https://code.claude.com/docs/en/memory — living doc — Official
  CLAUDE.md loading, `.claude/rules/` with path filters, staying under ~200 lines.
  *Applied:* bootstrap copies rules into `.claude/rules/`.
- **AGENTS.md** — Agentic AI Foundation (Linux Foundation) — https://agents.md/ — living standard — Official
  Open format read by Codex, Cursor, Copilot, Gemini CLI, Jules, Zed and others. Typical sections: overview, build/test commands, code style, testing, security; nested files in monorepos, nearest wins.
  *Applied:* `templates/AGENTS.md`, `CLAUDE.md` imports it.
- **Custom instructions with AGENTS.md** — OpenAI Codex docs — https://learn.chatgpt.com/docs/agent-configuration/agents-md — living doc — Official
  Codex reads a global file, then one per directory from the repo root down; closer files override; 32 KiB combined default limit; `AGENTS.override.md` for temporary overrides.

## Skills

- **Skill authoring best practices** — Anthropic docs — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices — living doc — Official
  Concise (assume the model is smart), third-person descriptions with what and when, name ≤ 64 lowercase-hyphen chars, description ≤ 1024, body < 500 lines, checklists for multi-step workflows, validate-fix-repeat loops, scripts for deterministic steps.
  *Applied:* all `skills/`, enforced by `tests/skills.test.sh`.
- **Equipping agents for the real world with Agent Skills** — Zhang, Lazuka, Murag, Anthropic — https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills — 2025-10-16 — Official
  Skills load by progressive disclosure (metadata, then SKILL.md, then files); published as an open standard in Dec 2025.
- **Extend Claude with skills** — Anthropic docs — https://code.claude.com/docs/en/skills — living doc — Official
  Frontmatter such as `disable-model-invocation`, `allowed-tools`, and `context: fork` (run in a fresh subagent).
  *Applied:* review skills fork; side-effect skills are user-invoked only.

## Hooks and deterministic gates

- **Hooks reference** — Anthropic docs — https://code.claude.com/docs/en/hooks — living doc — Official
  Stop hook exit 2 sends stderr back to the agent and keeps it working; `stop_hook_active` and an 8-continuation cap prevent endless loops.
  *Applied:* `hooks/check-on-stop.sh`.

## Specs, plans and task breakdown

- **How to write a good spec for AI agents** — Addy Osmani — https://addyosmani.com/blog/good-spec/ — 2026-01-13 — Practitioner
  Brief → agent-drafted spec → review before code. Cover commands, testing, structure, style, git workflow and boundaries (always / ask first / never). One task and the relevant spec section at a time; testable success criteria; keep the spec versioned and living.
  *Applied:* `plan-feature`, `templates/docs/plans/_template.md`.
- **Spec Kit** — GitHub — https://github.com/github/spec-kit — living repo — Official
  Spec-driven development as agent commands: constitution → specify → plan → tasks → implement → converge.
  *Applied:* the plan/implement split; consider it for heavier, multi-person specs.
- **Augmented Coding: Beyond the Vibes** — Kent Beck — https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes — 2025-06-25 — Practitioner
  TDD with an agent: a `plan.md` of tests, "go" implements the next unmarked one; structural and behavioural changes in separate commits. Stop the agent when it loops, adds unrequested features, or disables/deletes tests.
  *Applied:* `implement-task` (one task, test first), `rules/commits.md`, `rules/testing.md`.

## Practice and evidence

- **Vibe engineering** — Simon Willison — https://simonwillison.net/2025/Oct/7/vibe-engineering/ — 2025-10-07 — Practitioner
  Agents reward existing top-tier practice: automated tests, upfront planning, docs, version control, CI/linting, code review, manual QA, preview environments. "AI tools amplify existing expertise."
- **2025 State of AI-assisted Software Development (DORA)** — Google Cloud — https://services.google.com/fh/files/misc/2025_state_of_ai_assisted_software_development.pdf — 2025-09 — Official (research)
  Survey of ~5,000 professionals: AI acts as an amplifier of a team's existing strengths and weaknesses, and long-standing practices such as working in small batches matter more with AI, not less.
  *Note:* takeaway from the report's coverage; the PDF itself was not read in full.
  *Applied:* one-change commits, one task per session.

## Security

- **Top AIs invent same fake PyPI and npm package names** — Maxwell Cooter, InfoWorld — https://www.infoworld.com/article/4200884/top-ais-invent-same-fake-pypl-and-npm-package-names.html — 2026-07-24 — Practitioner (press, reporting a non-peer-reviewed preprint)
  Five LLMs invented the same 127 package names; 53 were still unregistered and open to "slopsquatting".
  *Applied:* `rules/security.md` (verify every package against the registry).

## Related tools

- **Ponytail** — Dietrich Gebert — https://github.com/DietrichGebert/ponytail — living repo — Practitioner
  "Lazy senior dev" skills: smallest complete change, review that reads beyond the diff, audit, `shortcut:` debt ledger. Complements this repo (scope discipline vs. process and gates).
  *Applied:* the `shortcut:` comment convention; plugin layout.
