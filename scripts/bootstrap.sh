#!/usr/bin/env bash
# Copy the project templates and rules into a target project. Never overwrites.
# Usage: scripts/bootstrap.sh <target-dir>
set -euo pipefail

target="${1:-}"
if [ -z "$target" ] || [ ! -d "$target" ]; then
  echo "usage: $0 <existing-target-dir>" >&2
  exit 1
fi
root="$(cd "$(dirname "$0")/.." && pwd)"
target="$(cd "$target" && pwd)"

copy_tree() { # <source-dir> <dest-dir>
  local src="$1" dest="$2" rel
  while IFS= read -r f; do
    rel="${f#"$src"/}"
    if [ -e "$dest/$rel" ]; then
      echo "skip    $dest/$rel (exists)"
    else
      mkdir -p "$(dirname "$dest/$rel")"
      cp -p "$f" "$dest/$rel"
      echo "create  $dest/$rel"
    fi
  done < <(find "$src" -type f | sort)
}

copy_tree "$root/templates" "$target"
copy_tree "$root/rules" "$target/.claude/rules"

echo
echo "Next: fill in AGENTS.md (commands) and scripts/check.sh for this stack,"
echo "or ask the agent to run the bootstrap-project skill."
