#!/usr/bin/env bash
set -euo pipefail
hook="$(cd "$(dirname "$0")/.." && pwd)/hooks/session-context.sh"
out="$(echo '{"hook_event_name":"SessionStart"}' | "$hook")"
echo "$out" | python3 -c '
import json, sys
d = json.load(sys.stdin)["hookSpecificOutput"]
assert d["hookEventName"] == "SessionStart", d
ctx = d["additionalContext"]
for phrase in ("Never delete, skip, loosen or rewrite an existing test", "stop and ask the user"):
    assert phrase in ctx, phrase
' || { echo "FAIL: session context JSON"; exit 1; }
echo "session-context: ok"
