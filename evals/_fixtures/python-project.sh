#!/usr/bin/env bash
# Shared fixture: a tiny dependency-free Python project with the guardrail
# templates installed, a configured check, and one commit.
# --bare: the same code and tests with no templates, rules or check script.
set -euo pipefail
plugin_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
bare=false; [ "${1:-}" = "--bare" ] && bare=true

git init -q -b main
git config user.email eval@example.com
git config user.name "Eval Runner"

$bare || "$plugin_root/scripts/bootstrap.sh" . >/dev/null

mkdir -p textutils tests
: > textutils/__init__.py
: > tests/__init__.py
cat > textutils/text.py <<'PY'
"""Text helpers used by the report generator."""


def title_case(s):
    return " ".join(w[:1].upper() + w[1:] for w in s.lower().split(" "))
PY
cat > textutils/report.py <<'PY'
from textutils.text import title_case


def report_heading(name):
    return f"# {title_case(name)}"
PY
cat > tests/test_text.py <<'PY'
import unittest

from textutils.text import title_case


class TitleCaseTest(unittest.TestCase):
    def test_capitalises_each_word(self):
        self.assertEqual(title_case('hello world'), 'Hello World')


if __name__ == "__main__":
    unittest.main()
PY
if ! $bare; then
cat > scripts/check.sh <<'SH'
#!/usr/bin/env bash
# Quality gate: the test suite (no other tools in this small project).
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m unittest discover -s tests -t . 2>&1
SH
chmod +x scripts/check.sh
sed -i.bak 's|^- Run one test: .*|- Run one test: `python3 -m unittest tests.test_text`|' AGENTS.md && rm AGENTS.md.bak
fi
printf '__pycache__/\n' > .gitignore

git add -A
git commit -q -m "Initial text utils with guardrails"
