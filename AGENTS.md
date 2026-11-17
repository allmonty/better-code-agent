# AGENTS.md

This repo is a Claude Code plugin and a template kit of guardrails for AI coding agents. Its own work follows the same rules it ships.

## Commands
- Check (must be green before any commit): `scripts/check.sh`
- Validate the plugin manifests: `claude plugin validate .`
- Check reference links (network): `scripts/check-links.sh`

## Where things are
- `rules/`: shipped to projects as `.claude/rules/`. `templates/`: copied into projects by `scripts/bootstrap.sh`.
- `skills/*/SKILL.md`: the plugin's skills. `hooks/`: the Stop hook. `tests/`: plain bash tests.
- Memory: `docs/ROADMAP.md`, `docs/PROGRESS.md`. Sources: `docs/REFERENCES.md`.

## Conventions
- Rules and skills: plain wording, no ALL CAPS, only what an agent wouldn't do by default. Each rule file stays under about 25 lines.
- Skills must pass `tests/skills.test.sh` (Agent Skills frontmatter limits). Skills with side effects set `disable-model-invocation: true`.
- Skills refer to rules as `.claude/rules/<name>.md`, the path they have in a bootstrapped project.
- When you add or rename a rule, update the list in `templates/AGENTS.md`.
- Every claim in `docs/REFERENCES.md` comes from a source that was opened and read; anything secondhand says so.
- Scripts are POSIX-friendly bash with no dependencies beyond git, curl and coreutils (they must run on macOS and Linux).
- One change per commit, with its tests (`rules/commits.md`).
