#!/usr/bin/env bash
# Stop hook: run the project's check before the agent may finish.
# Also registered on SessionStart to record the starting state, so a session
# that changed nothing is never blocked by a repo that was already red.
# Exit 2 + stderr sends the agent back to fix it; exit 0 lets it stop.
# Env: BCA_DISABLE_STOP_HOOK=1 turns it off, BCA_MAX_BLOCKS (default 3) caps retries.
set -uo pipefail

input="$(cat)"
[ "${BCA_DISABLE_STOP_HOOK:-0}" = 1 ] && exit 0
cd "${CLAUDE_PROJECT_DIR:-$PWD}" || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

if [ -x scripts/check.sh ]; then
  cmd=(scripts/check.sh)
elif [ -f Makefile ] && grep -q '^check:' Makefile; then
  cmd=(make check)
else
  exit 0
fi

state="$(git rev-parse --git-dir)/better-code-agent"
mkdir -p "$state"
max="${BCA_MAX_BLOCKS:-3}"

# Fingerprint of the working state: HEAD, tracked changes, untracked files.
fp="$( { git rev-parse HEAD 2>/dev/null; git diff HEAD --binary 2>/dev/null || git diff --binary;
        git ls-files -z --others --exclude-standard | xargs -0 shasum 2>/dev/null; } | shasum | cut -d' ' -f1)"

sid="$(echo "$input" | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([A-Za-z0-9_-]*\)".*/\1/p' | head -1)"

# SessionStart: remember the state the session began in, then let it start.
if echo "$input" | grep -q '"hook_event_name"[[:space:]]*:[[:space:]]*"SessionStart"'; then
  [ -n "$sid" ] && echo "$fp" > "$state/start-$sid"
  find "$state" -name 'start-*' -mtime +7 -delete 2>/dev/null
  exit 0
fi

# The agent left the repo exactly as the session found it: nothing of its to check.
[ -n "$sid" ] && [ "$fp" = "$(cat "$state/start-$sid" 2>/dev/null)" ] && exit 0

# Nothing changed since the last green run, or since we last gave up on this state.
[ "$fp" = "$(cat "$state/last-green" 2>/dev/null)" ] && exit 0
[ "$fp" = "$(cat "$state/gave-up" 2>/dev/null)" ] && exit 0

# A fresh stop (not a continuation we caused) starts the retry count over.
echo "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' || rm -f "$state/blocks"

if out="$("${cmd[@]}" 2>&1)"; then
  echo "$fp" > "$state/last-green"
  rm -f "$state/blocks" "$state/gave-up"
  exit 0
fi

n=$(( $(cat "$state/blocks" 2>/dev/null || echo 0) + 1 ))
if [ "$n" -gt "$max" ]; then
  rm -f "$state/blocks"
  echo "$fp" > "$state/gave-up"
  printf '{"systemMessage":"better-code-agent: %s still fails after %s attempts. The agent was allowed to stop; the work is NOT green."}\n' "${cmd[*]}" "$max"
  exit 0
fi
echo "$n" > "$state/blocks"

{
  echo "Quality gate failed: \`${cmd[*]}\` (attempt $n of $max)."
  echo "Fix the cause, then finish. Don't skip, delete or loosen tests to get green."
  echo "If the failure is outside your change, say so to the user instead of hiding it."
  echo "--- last 60 lines ---"
  echo "$out" | tail -n 60
} >&2
exit 2
