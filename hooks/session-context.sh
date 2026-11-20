#!/usr/bin/env bash
# SessionStart: give every session the rules that must hold even in projects
# without .claude/rules/. Eval runs showed the plugin's "get it green" skills
# made Sonnet rewrite a contradicting test unless this counterweight is present,
# and Haiku never chose the planning skill on its own for multi-commit work.
cat >/dev/null
cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"better-code-agent: Existing tests are the spec. Never delete, skip, loosen or rewrite an existing test to make a check pass. If tests contradict each other or one looks wrong, stop and ask the user which behaviour is intended, and leave the check red until they answer. Report a failing check honestly rather than forcing it green. Work that needs more than one commit starts with a plan in docs/plans/ (the plan-feature skill) and lands as one tested commit per task (implement-task), even when the user is away."}}
JSON
