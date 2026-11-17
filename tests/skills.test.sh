#!/usr/bin/env bash
# Every SKILL.md follows the Agent Skills format limits.
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
err() { echo "FAIL $1: $2"; fail=1; }
for f in skills/*/SKILL.md; do
  dir="$(basename "$(dirname "$f")")"
  [ "$(head -1 "$f")" = "---" ] || { err "$f" "no frontmatter"; continue; }
  fm="$(awk 'NR>1 && /^---$/ {exit} NR>1' "$f")"
  name="$(echo "$fm" | sed -n 's/^name: *//p')"
  desc="$(echo "$fm" | sed -n 's/^description: *//p')"
  [ "$name" = "$dir" ] || err "$f" "name '$name' != dir '$dir'"
  [[ "$name" =~ ^[a-z0-9-]{1,64}$ ]] || err "$f" "name must be lowercase-hyphen, <=64"
  [[ "$name" =~ claude|anthropic ]] && err "$f" "reserved word in name"
  [ -n "$desc" ] || err "$f" "missing description"
  [ "${#desc}" -le 1024 ] || err "$f" "description over 1024 chars"
  [[ "$desc" =~ \<|\> ]] && err "$f" "angle brackets in description"
  [ "$(wc -l < "$f")" -lt 500 ] || err "$f" "over 500 lines"
done
[ "$fail" = 0 ] && echo "skills: ok"
exit "$fail"
