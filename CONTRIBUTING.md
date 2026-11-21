# Contributing to better-code-agent

Contributions are welcome — especially real-world field reports, stack packs, agent adapters, and eval cases that catch real agent failure modes.

## High-impact areas

See [`docs/ROADMAP.md`](docs/ROADMAP.md) for current priorities:

- **Real-project reports:** Which rules or skills helped, which got ignored, and what broke in practice (share in [GitHub Discussions](https://github.com/allmonty/better-code-agent/discussions)).
- **Stack packs:** Concrete starter `scripts/check.sh` and CI recipes (format, lint with complexity limit, type check, duplication check, tests) for TypeScript/React, Python, Go, Rust, Elixir, and other stacks.
- **Agent adapters:** Ergonomic setup for Codex, Cursor, Copilot, and Gemini CLI alongside Claude Code.
- **Eval cases:** New `evals/` scenarios that isolate a concrete coding-agent failure mode (see `evals/_fixtures/python-project.sh`).

## Local verification

Run these before opening a pull request:

```bash
scripts/check.sh
claude plugin validate --strict .
```

If you edited `docs/REFERENCES.md`:

```bash
scripts/check-links.sh
```

If you changed rules, skills, hooks, or eval graders, run the relevant [`claude plugin eval`](https://code.claude.com/docs/en/plugin-evals) case(s) and include the results in your PR description:

```bash
claude plugin eval . --allow-tools Bash Write Edit --scaffold --trust-plugin --threshold 0 --case <case-name>
```

## Conventions

This repo follows the rules it ships (see [`AGENTS.md`](AGENTS.md)):

- **Keep rules short and plain:** Plain wording, no all-caps emphasis, and only practices an agent would not follow by default. Keep each rule file under about 25 lines.
- **Skills format:** Must pass `tests/skills.test.sh` (Agent Skills frontmatter limits). Side-effect skills set `disable-model-invocation: true`, and skills refer to rules at `.claude/rules/<name>.md`.
- **Update templates when rules change:** When adding or renaming a rule in `rules/`, update the list in `templates/AGENTS.md`.
- **Portable bash:** Scripts must work on macOS and Linux using only `bash`, `git`, `curl`, and standard coreutils.
- **Verified sources:** Every claim added to `docs/REFERENCES.md` must come from a source you opened and read; mark secondhand summaries clearly.
- **One change per commit:** Keep commits focused, each with its tests and `scripts/check.sh` green.
