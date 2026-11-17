#!/usr/bin/env bash
# The project's single quality gate: format check, lint, type check, tests.
# The better-code-agent Stop hook runs this before the agent may finish.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "scripts/check.sh is not configured yet." >&2
echo "Detect the stack (see .claude/rules/stack-practices.md) and replace this with its" >&2
echo "format-check, lint, type-check and test commands, e.g. 'npx tsc --noEmit && npx vitest run'." >&2
exit 1
