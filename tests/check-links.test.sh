#!/usr/bin/env bash
set -euo pipefail
script="$(cd "$(dirname "$0")/.." && pwd)/scripts/check-links.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*"; exit 1; }

"$script" "$tmp/missing.md" >/dev/null 2>&1 && fail "missing file should fail"

# An unreachable URL (closed local port) is reported dead, with trailing punctuation stripped.
echo "- see http://127.0.0.1:9/x." > "$tmp/r.md"
set +e; out="$("$script" "$tmp/r.md")"; rc=$?; set -e
[ "$rc" = 1 ] || fail "dead link should exit 1"
echo "$out" | grep -q "^DEAD .* http://127.0.0.1:9/x$" || fail "bad report: $out"

# No links: passes.
echo "nothing here" > "$tmp/empty.md"
"$script" "$tmp/empty.md" >/dev/null || fail "file without links should pass"
echo "check-links: ok"
