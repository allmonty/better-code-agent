#!/usr/bin/env bash
# Repo self-check: shell syntax, JSON validity, then every tests/*.test.sh.
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
while IFS= read -r f; do
  bash -n "$f" || { echo "syntax error: $f"; fail=1; }
done < <(git ls-files --cached --others --exclude-standard '*.sh')

while IFS= read -r f; do
  python3 -m json.tool "$f" >/dev/null || { echo "invalid JSON: $f"; fail=1; }
done < <(git ls-files --cached --others --exclude-standard '*.json')

for t in tests/*.test.sh; do
  [ -e "$t" ] || continue
  echo "== $t"
  bash "$t" || fail=1
done

[ "$fail" -eq 0 ] && echo "all checks passed"
exit "$fail"
