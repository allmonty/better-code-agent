#!/usr/bin/env bash
# Print the HTTP status of every URL in a markdown file; exit 1 if any is unreachable.
# Usage: scripts/check-links.sh [file]   (default: docs/REFERENCES.md)
# 403/429 count as reachable: some publishers block scripts but serve browsers.
set -uo pipefail
file="${1:-$(dirname "$0")/../docs/REFERENCES.md}"
[ -f "$file" ] || { echo "no such file: $file" >&2; exit 1; }

bad=0
for url in $(grep -oE 'https?://[^ )>`]+' "$file" | sed 's/[.,;]$//' | sort -u); do
  code="$(curl -sL -o /dev/null -w '%{http_code}' --max-time 20 "$url")"
  case "$code" in
    2??|403|429) echo "ok   $code $url" ;;
    *) echo "DEAD $code $url"; bad=1 ;;
  esac
done
exit "$bad"
