#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*"; exit 1; }

# Missing or nonexistent target is an error.
"$root/scripts/bootstrap.sh" >/dev/null 2>&1 && fail "no-arg run should fail"
"$root/scripts/bootstrap.sh" "$tmp/nope" >/dev/null 2>&1 && fail "missing dir should fail"

# Existing files are kept.
echo "mine" > "$tmp/AGENTS.md"
out="$("$root/scripts/bootstrap.sh" "$tmp")"

[ "$(cat "$tmp/AGENTS.md")" = "mine" ] || fail "existing AGENTS.md was overwritten"
echo "$out" | grep -q "skip.*AGENTS.md" || fail "skip not reported"
for f in CLAUDE.md docs/ROADMAP.md docs/PROGRESS.md docs/plans/_template.md \
         docs/adr/0000-template.md .claude/rules/testing.md .claude/rules/security.md; do
  [ -f "$tmp/$f" ] || fail "missing $f"
done
[ -x "$tmp/scripts/check.sh" ] || fail "check.sh not executable"

# Second run creates nothing.
"$root/scripts/bootstrap.sh" "$tmp" | grep -q "^create" && fail "second run created files"
echo "bootstrap: ok"
