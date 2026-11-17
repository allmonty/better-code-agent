# References: building guardrails for AI coding agents

Last reviewed: 2026-11-17

A living reading list behind this repo's rules, skills and hook. Refresh it with the `update-references` skill (see the README for a monthly schedule).

**Tiers.** **Official**: the vendors and standards bodies (Anthropic, OpenAI, GitHub, Google, Microsoft, Cursor, OWASP, the AGENTS.md standard). **Practitioner**: well-known engineers and publications. **Research**: studies, surveys, papers. **Vendor**: content from a company selling a related product; read for ideas, discount the numbers.
Each entry: title, author, link, date, tier, the takeaway, and where this repo applies it (*Applied*).

## Contents
- Harness engineering (guides and sensors)
- Instruction files (AGENTS.md, CLAUDE.md, rules)
- Skills
- Hooks and deterministic gates
- Specs, plans and task breakdown
- Testing AI-written code
- AI code review and human oversight
- Agent and supply-chain security
- Evidence: productivity and quality
- Related tools

## Harness engineering (guides and sensors)

- **Harness Engineering for Coding Agent Users** — Birgitta Böckeler, martinfowler.com — https://martinfowler.com/articles/harness-engineering.html — 2026-04-02 — Practitioner
  A harness is guides (feedforward: AGENTS.md, skills) plus sensors (feedback: tests, linters, review agents), each either computational (deterministic) or inferential (LLM). Run cheap checks before commit and expensive ones after; write sensor output so an agent can act on it; humans keep steering, especially on behaviour/spec.
  *Applied:* README framing; Stop hook messages written for the agent; `review-change`, `review-tests`.
- **Harness Engineering – first thoughts** — Birgitta Böckeler — https://www.martinfowler.com/articles/exploring-gen-ai/harness-engineering-memo.html — 2026-02-17 — Practitioner
  Summarises OpenAI's harness as context engineering, architectural constraints enforced by linters/structural tests, and "garbage collection" agents against entropy.
- **Context Engineering for Coding Agents** — Birgitta Böckeler — https://martinfowler.com/articles/exploring-gen-ai/context-engineering-coding-agents.html — 2026-02-05 — Practitioner
  Classifies rules, skills, subagents, hooks and MCP by who decides to load them (the model, the human, the agent software). Only hooks are deterministic; everything else depends on the model's reading.
- **Harness engineering: leveraging Codex in an agent-first world** — Ryan Lopopolo, OpenAI — https://openai.com/index/harness-engineering/ — 2026-02-11 — Official
  A team shipped a product with no hand-written code by investing in the environment: a structured `docs/` as the agents' system of record (maps, execution plans, design specs), layered architecture enforced by structural tests, and agents that open, evaluate and iterate on their own PRs.
  *Note:* openai.com blocks automated fetching; summary verified via InfoQ coverage: https://www.infoq.com/news/2026/02/openai-harness-engineering-codex/ (2026-02-21).
  *Applied:* `docs/` memory files, `rules/architecture.md` (make boundaries mechanical).
- **Effective harnesses for long-running agents** — Justin Young, Anthropic — https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents — 2025-11-26 — Official
  Agents tried to one-shot work and declared victory early. Fixes: a feature list the agent may only mark passing (never edit or remove tests), a progress file plus git history, a session-start routine (read git log and progress, run a basic check), one feature per session, and end-to-end verification as a user would.
  *Applied:* `rules/planning-memory.md`, `implement-task`, `verify-done`, `rules/testing.md`.
- **Technology Radar Vol. 35** — Thoughtworks — https://www.thoughtworks.com/radar/techniques (PDF: https://www.thoughtworks.com/content/dam/thoughtworks/documents/radar/2026/11/tr_technology_radar_vol_35_en.pdf) — 2026-11 — Practitioner
  Adopt: mutation testing, agent sandboxing, progressive context disclosure, threat modeling. Trial: feedback flywheel (after each session, add what's worth sharing to AGENTS.md or skills and prune what no longer helps), risk-tiered human oversight, anchoring agents to a reference application, toxic flow analysis. Caution: agent instruction bloat, AI-driven documentation sprawl, human-in-the-loop theater.
  *Applied:* harness retro in `verify-done`, pruning in `rules/planning-memory.md`, agent rules in `rules/security.md`.
- **Feedback sensors for coding agents** — Thoughtworks Radar — https://www.thoughtworks.com/radar/techniques/feedback-sensors-for-coding-agents — 2026-04 (Trial) — Practitioner
  Wire compilers, linters, structural tests and test suites into the agent loop as backpressure; agents make custom linters and structural tests cheap to build.
  *Applied:* `scripts/check.sh` + Stop hook.
- **Codebase cognitive debt** — Thoughtworks Radar — https://www.thoughtworks.com/radar/techniques/codebase-cognitive-debt — 2026-04 (Caution) — Practitioner
  The gap between how much code agents produce and how much humans understand keeps widening. Counter it with feedback sensors, fitness functions, and deliberate effort to keep understanding the system.
  *Applied:* README "You still steer".

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
- **Codex best practices** — OpenAI docs — https://learn.chatgpt.com/docs/learn/best-practices — living doc — Official
  Plan first for complex or ambiguous work; keep AGENTS.md short and add a rule when Codex repeats a mistake (ask it for a retrospective); have it write tests, run checks and review its diff; keep review standards in a `code_review.md` referenced from AGENTS.md; one job per skill.
  *Applied:* harness retro in `verify-done`.
- **Adding repository custom instructions for Copilot** — GitHub Docs — https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions — living doc — Official
  `.github/copilot-instructions.md`, path-scoped `*.instructions.md` with `applyTo`, and AGENTS.md/CLAUDE.md/GEMINI.md. Keep it short; list build, test and lint commands in order.
- **Rules** — Cursor docs — https://cursor.com/docs/context/rules — living doc — Official
  `.cursor/rules/*.mdc` (always, glob or description-triggered), team rules, AGENTS.md. Under 500 lines, reference files rather than copying them, don't restate what a linter enforces, add rules only for repeated mistakes.
- **Provide context with GEMINI.md files** — Google Gemini CLI docs — https://geminicli.com/docs/cli/gemini-md/ — living doc — Official
  Global, workspace and just-in-time context files with `@file.md` imports; AGENTS.md is read when listed in `context.fileName`.
- **Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?** — Gloaguen, Mündler-Sasahara, Müller, Raychev, Vechev (ETH Zurich) — https://arxiv.org/abs/2602.11988 — 2026-02-12, v3 2026-09-29 — Research
  Across agents and models, context files (LLM- or human-written) didn't generally raise task success and added over 20% inference cost. Agents do follow them; repository overviews didn't help. Use them for non-standard practices only, and evaluate before adding more.
  *Applied:* trimmed `rules/code-quality.md` to lines with evidence behind them; `templates/AGENTS.md` excludes overviews.

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
- **Hooks guide** — Anthropic docs — https://code.claude.com/docs/en/hooks-guide — living doc — Official
  Worked patterns: format after every edit, block edits to protected paths (exit 2), a Stop hook that won't let the agent finish until checks pass.

## Specs, plans and task breakdown

- **How to write a good spec for AI agents** — Addy Osmani — https://addyosmani.com/blog/good-spec/ — 2026-01-13 — Practitioner
  Brief → agent-drafted spec → review before code. Cover commands, testing, structure, style, git workflow and boundaries (always / ask first / never). One task and the relevant spec section at a time; testable success criteria; keep the spec versioned and living.
  *Applied:* `plan-feature`, `templates/docs/plans/_template.md`.
- **My LLM coding workflow going into 2026** — Addy Osmani — https://addyosmani.com/blog/ai-coding-workflow/ — 2026-01-04 — Practitioner
  Spec, plan, then small chunks, each tested and committed; worktrees for experiments; a second model reviews; output is untrusted until read, run and tested.
- **Spec Kit** — GitHub — https://github.com/github/spec-kit — living repo — Official
  Spec-driven development as agent commands: constitution → specify → plan → tasks → implement → converge.
  Announcement: https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/ (2025-09-02).
  *Applied:* the plan/implement split; consider it for heavier, multi-person specs.
- **Understanding Spec-Driven-Development: Kiro, spec-kit, and Tessl** — Birgitta Böckeler — https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html — 2025-10-15 — Practitioner
  The counterweight: tools applied one heavy workflow to every problem size (a small bug became 4 user stories and 16 acceptance criteria), produced markdown tedious to review, and agents still ignored parts of the spec. Spec-first is valuable; size it to the work.
  *Applied:* `plan-feature` scales the plan to the change.
- **Augmented Coding: Beyond the Vibes** — Kent Beck — https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes — 2025-06-25 — Practitioner
  TDD with an agent: a `plan.md` of tests, "go" implements the next unmarked one; structural and behavioural changes in separate commits. Stop the agent when it loops, adds unrequested features, or disables/deletes tests.
  *Applied:* `implement-task` (one task, test first), `rules/commits.md`, `rules/testing.md`.
- **Best practices for coding with agents** — Lee Robinson, Cursor — https://cursor.com/blog/agent-best-practices — 2026-01-09 — Official
  Plan before coding and save plans; short rules added only after repeated mistakes; write tests first, confirm they fail, commit them, then implement without changing them; use a stop hook with an iteration cap.
- **Best practices for using Copilot to work on tasks** — GitHub Docs — https://docs.github.com/en/copilot/tutorials/coding-agent/get-the-best-results — living doc — Official
  Well-scoped tasks with acceptance criteria and files to touch; build/test commands in instructions; pre-install dependencies (`copilot-setup-steps.yml`) so the agent can test reliably.

## Testing AI-written code

- **Red/green TDD** (Agentic Engineering Patterns guide) — Simon Willison — https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/ — living guide (2026) — Practitioner
  "Use red/green TDD" is a prompt models understand: write the test, confirm it fails, then implement. Guards against non-working code, unnecessary code and regressions. Sister chapters: "First run the tests", "Agentic manual testing".
  *Applied:* `implement-task` steps 2–3.
- **Mutation testing** — Thoughtworks Radar — https://www.thoughtworks.com/radar/techniques/mutation-testing — 2026-11 (Adopt) — Practitioner
  The guard against "perpetually green" AI-written tests and inflated coverage. Agents can run it themselves; target domain code and recent changes since full runs are slow (Stryker, Pitest, cargo-mutants).
  *Applied:* `rules/testing.md`, `review-tests`.
- **LLMs Are the Key to Mutation Testing and Better Compliance** — Mark Harman, Meta — https://engineering.fb.com/2025/09/30/security/llms-are-the-key-to-mutation-testing-and-better-compliance/ — 2025-09-30 — Official (Meta engineering)
  ACH generates realistic mutants that no test catches yet, then has an LLM write tests that kill them; engineers accepted 73% of generated tests. Paper: https://arxiv.org/abs/2501.12862 (2025-01-22).
- **Agentic Property-Based Testing: Finding Bugs Across the Python Ecosystem** — Maaz, DeVoe, Hatfield-Dodds, Carlini — https://arxiv.org/abs/2510.09907 — 2025-10-10 — Research
  A Claude Code agent wrote Hypothesis property tests for 100 popular packages; 56% of its bug reports were valid (86% of the top 21); 3 patches merged, including to NumPy.
  *Applied:* property-based testing in `rules/testing.md`.

## AI code review and human oversight

- **About Copilot code review** — GitHub Docs — https://docs.github.com/en/copilot/concepts/agents/code-review — living doc — Official
  Its reviews don't count toward required approvals by default and it is "not guaranteed to spot all problems"; supplement with human review.
- **State of AI vs Human Code Generation** — CodeRabbit — https://www.coderabbit.ai/blog/state-of-ai-vs-human-code-generation-report — 2025-12-17 — Vendor (sells AI review)
  470 open-source PRs: AI-co-authored PRs had ~1.7× the issues of human-only ones, with logic issues 75% more common. Authorship was inferred.

## Agent and supply-chain security

- **Beyond permission prompts: making Claude Code more secure and autonomous** — Dworken, Weller-Davies, Anthropic — https://www.anthropic.com/engineering/claude-code-sandboxing — 2025-10-20 — Official
  Filesystem and network isolation together (either alone is escapable); cut permission prompts by 84% internally; open-source sandbox runtime. Docs: https://code.claude.com/docs/en/sandboxing, https://code.claude.com/docs/en/security.
  *Applied:* `rules/security.md` (agent section), README.
- **The lethal trifecta for AI agents** — Simon Willison — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/ — 2025-06-16 — Practitioner
  Private data + untrusted content + external communication lets an injected prompt exfiltrate data. "LLMs are unable to reliably distinguish the importance of instructions based on where they came from." Remove one leg.
  *Applied:* `rules/security.md`.
- **Designing agentic loops** — Simon Willison — https://simonwillison.net/2025/Sep/30/designing-agentic-loops/ — 2025-09-30 — Practitioner
  Run unattended ("YOLO") agents only in a sandbox with a network allowlist, staging-only credentials and a budget; pick tasks with test-based success criteria.
- **Agentic AI and Security** — Korny Sietsma, martinfowler.com — https://martinfowler.com/articles/agentic-ai-security.html — 2025-10-28 — Practitioner
  Containers with allow-listed egress, read-only tokens, secrets only in memory, research in a separate session, and "small steps that can be controlled and reviewed by humans."
- **Risks and mitigations for Copilot cloud agent** — GitHub Docs — https://docs.github.com/en/copilot/concepts/agents/cloud-agent/risks-and-mitigations — living doc — Official
  A reference control set: CodeQL, secret scanning and dependency checks before the PR; push to one branch only; a human must merge and the requester can't approve; workflows wait for approval; egress firewall; hidden characters and HTML comments stripped from input.
- **OWASP Top 10 for Agentic Applications 2026** — OWASP GenAI Security Project — https://genai.owasp.org/resource/2025-12-09/owasp-top-10-for-agentic-applications-for-2026 — 2025-12-09 — Official (standard)
  ASI01 goal hijack, ASI02 tool misuse, ASI03 identity and privilege abuse, ASI04 agentic supply chain, ASI05 unexpected code execution, ASI06 memory and context poisoning, ASI07 inter-agent communication, ASI08 cascading failures, ASI09 human-agent trust exploitation, ASI10 rogue agents (list from the announcement: https://genai.owasp.org/2025/12/09/owasp-top-10-for-agentic-applications-the-benchmark-for-agentic-security-in-the-age-of-autonomous-ai/; mitigations are in the PDF).
- **How Microsoft defends against indirect prompt injection attacks** — Andrew Paverd, MSRC — https://www.microsoft.com/msrc/blog/2025/07/how-microsoft-defends-against-indirect-prompt-injection-attacks — 2025-07-29 — Official
  Defence in depth: mark untrusted input, detect injections, deterministically block exfiltration channels (e.g. markdown images), require consent for actions.
- **An Introduction to Google's Approach for Secure AI Agents** — Díaz, Kern, Olive, Google — https://research.google/pubs/an-introduction-to-googles-approach-for-secure-ai-agents/ — 2025 — Official
  Agents need well-defined human controllers, carefully limited powers, and observable actions; combine deterministic controls with reasoning-based defences.
- **We Have a Package for You! (package hallucinations)** — Spracklen et al., USENIX Security 2025 — https://arxiv.org/abs/2406.10279 — 2024-06 (published 2025) — Research
  Hallucinated dependencies in ≥5.2% of commercial-model and 21.7% of open-model samples; 205,474 unique invented names. The basis for "slopsquatting".
  *Applied:* `rules/security.md` (verify every package against the registry).
- **Top AIs invent same fake PyPI and npm package names** — Maxwell Cooter, InfoWorld — https://www.infoworld.com/article/4200884/top-ais-invent-same-fake-pypl-and-npm-package-names.html — 2026-07-24 — Practitioner (press, reporting a non-peer-reviewed preprint)
  Five LLMs invented the same 127 package names; 53 were still unregistered and open to slopsquatting.
- **2025 GenAI Code Security Report** — Veracode — https://www.veracode.com/resources/analyst-reports/2025-genai-code-security-report/ — 2025 (Oct update) — Vendor (sells SAST/SCA)
  Security flaws in 45% of generated code samples; newer or larger models were not more secure.
- **AI Agent Standards Initiative** — NIST CAISI — https://www.nist.gov/caisi/ai-agent-standards-initiative — 2026-02 (in progress) — Official
  Requests for information and a concept paper on agent identity and authorization; no final guidance yet. Watch this.

## Evidence: productivity and quality

- **2025 State of AI-assisted Software Development (DORA)** — Google Cloud — https://dora.dev/research/2025/dora-report/ (PDF: https://services.google.com/fh/files/misc/2025_state_of_ai_assisted_software_development.pdf) — 2025-09 — Research
  ~5,000 professionals: AI acts as an amplifier of a team's existing strengths and weaknesses; it now correlates with higher throughput but still with lower stability; small batches and strong version control matter more with AI, not less.
  *Applied:* one-change commits, one task per session.
- **Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity** — Becker, Rush, Barnes, Rein (METR) — https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/ — 2025-07-10 — Research
  RCT, 16 developers, 246 tasks: 19% slower with AI while believing they were ~20% faster. Self-reports are unreliable; measure.
- **We are Changing our Developer Productivity Experiment Design** — METR — https://metr.org/blog/2026-02-24-uplift-update/ — 2026-02-24 — Research
  Late-2025 tools, 57 developers: point estimates of 18% (returning) and 4% (new) speedups, which METR calls very weak evidence because 30–50% of developers withheld tasks they wouldn't do without AI.
- **Speed at the Cost of Quality: How Cursor AI Increases Short-Term Velocity and Long-Term Complexity** — He, Miller, Agarwal, Kästner, Vasilescu (CMU), MSR '26 — https://arxiv.org/abs/2511.04427 — 2025-11, v3 2026-01-26 — Research
  Difference-in-differences on GitHub projects: a large but transient velocity gain; static-analysis warnings and complexity rise and persist, and drive the later slowdown. Quality assurance is the bottleneck.
  *Applied:* complexity and duplication checks in `rules/stack-practices.md`.
- **The Maintainability Gap: AI Code Quality in 2026** — GitClear — https://www.gitclear.com/the_ai_code_quality_maintainability_gap — 2026 — Vendor (sells code analytics)
  623M changes, 2023–2026: duplicated blocks +81%, error-masking constructs +47%, refactoring moves down to 3.8% of changed lines, two-week churn +15%.
  *Applied:* "reuse before writing" and "never swallow errors" in `rules/code-quality.md`; duplication check in `rules/stack-practices.md`.
- **Stack Overflow Developer Survey 2026 — AI** — Stack Overflow — https://survey.stackoverflow.co/2026/ai — 2026 — Research (survey)
  73% use coding assistants or agents daily; 48% trust AI only when they can easily validate its output; Claude Code (66%) and Copilot (59%) lead agent use. 2025 edition: https://stackoverflow.blog/2025/12/29/developers-remain-willing-but-reluctant-to-use-ai-the-2025-developer-survey-results-are-here/ (trust in accuracy fell to 29%; 66% spend more time fixing "almost right" code).
  *Applied:* the whole premise: make output easy to validate.
- **Vibe engineering** — Simon Willison — https://simonwillison.net/2025/Oct/7/vibe-engineering/ — 2025-10-07 — Practitioner
  Agents reward existing top-tier practice: automated tests, upfront planning, docs, version control, CI/linting, code review, manual QA, preview environments. "AI tools amplify existing expertise."

## Related tools

- **Ponytail** — Dietrich Gebert — https://github.com/DietrichGebert/ponytail — living repo — Practitioner
  "Lazy senior dev" skills: smallest complete change, review that reads beyond the diff, audit, `shortcut:` debt ledger. Complements this repo (scope discipline vs. process and gates).
  *Applied:* the `shortcut:` comment convention; plugin layout.
