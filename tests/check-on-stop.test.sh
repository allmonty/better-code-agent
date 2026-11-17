#!/usr/bin/env bash
set -euo pipefail
hook="$(cd "$(dirname "$0")/.." && pwd)/hooks/check-on-stop.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*"; exit 1; }
run() { # <stop_hook_active> ; sets rc, err, out
  set +e
  out="$(echo "{\"hook_event_name\":\"Stop\",\"stop_hook_active\":$1}" \
    | CLAUDE_PROJECT_DIR="$tmp/repo" "$hook" 2>"$tmp/err")"; rc=$?
  set -e
  err="$(cat "$tmp/err")"
}

# Not a git repo: no-op.
mkdir -p "$tmp/repo"; run false; [ "$rc" = 0 ] || fail "non-git should pass"

cd "$tmp/repo" && git init -q && git config user.email t@t && git config user.name t
# Git repo without a check: no-op.
echo a > a.txt; run false; [ "$rc" = 0 ] || fail "no check should pass"

# Check that fails while BROKEN exists, and counts its runs.
mkdir scripts
cat > scripts/check.sh <<'SH'
#!/usr/bin/env bash
echo run >> "$(dirname "$0")/../.runs"
if [ -e BROKEN ]; then echo "test_foo FAILED"; exit 1; fi
SH
chmod +x scripts/check.sh
echo .runs > .gitignore
runs() { wc -l < .runs | tr -d ' '; }

touch BROKEN; run false
[ "$rc" = 2 ] || fail "failing check should block (rc=$rc)"
echo "$err" | grep -q "test_foo FAILED" || fail "output not passed to agent"
echo "$err" | grep -q "attempt 1 of 3" || fail "attempt count missing"

# Fixed: passes, and an unchanged state is not re-checked.
rm BROKEN; run true; [ "$rc" = 0 ] || fail "green check should pass"
before=$(runs); run false; [ "$(runs)" = "$before" ] || fail "re-ran check on unchanged state"

# Gives up after 3 blocks in a row, tells the user, then stays quiet on that state.
touch BROKEN; run false; [ "$rc" = 2 ] || fail "block 1"
run true; [ "$rc" = 2 ] || fail "block 2"
run true; [ "$rc" = 2 ] || fail "block 3"
run true; [ "$rc" = 0 ] || fail "should give up after 3"
echo "$out" | grep -q '"systemMessage"' || fail "give-up must tell the user"
before=$(runs); run false; [ "$rc" = 0 ] && [ "$(runs)" = "$before" ] || fail "nagged on given-up state"

# A new change re-arms the gate.
echo b > b.txt; run false; [ "$rc" = 2 ] || fail "new change should re-check"

# make check is used when there is no scripts/check.sh.
rm -rf scripts BROKEN
printf 'check:\n\t@echo make-check-ran; exit 1\n' > Makefile
run false; echo "$err" | grep -q make-check-ran || fail "make check not used"

# Kill switch.
echo c > c.txt
set +e; echo '{}' | BCA_DISABLE_STOP_HOOK=1 CLAUDE_PROJECT_DIR="$tmp/repo" "$hook" 2>/dev/null; rc=$?; set -e
[ "$rc" = 0 ] || fail "disable switch ignored"
echo "check-on-stop: ok"
