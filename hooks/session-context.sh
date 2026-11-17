#!/usr/bin/env bash
# SessionStart: give every session the rules that must hold even in projects
# without .claude/rules/. Eval runs showed the plugin's "get it green" skills
# made Sonnet rewrite a contradicting test unless this counterweight is present.
cat >/dev/null
cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"better-code-agent: Existing tests are the spec. Never delete, skip, loosen or rewrite an existing test to make a check pass. If tests contradict each other or one looks wrong, stop and ask the user which behaviour is intended, and leave the check red until they answer. Report a failing check honestly rather than forcing it green."}}
JSON
