#!/usr/bin/env bash
# The last commit renames title_case to to_title_case in text.py and its test,
# but textutils/report.py (not in the diff) still imports the old name.
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/../_fixtures/python-project.sh"
sed -i.bak 's/^def title_case/def to_title_case/' textutils/text.py
sed -i.bak 's/title_case/to_title_case/g' tests/test_text.py
rm -f textutils/*.bak tests/*.bak
git add -A && git commit -q -m "Rename title_case to to_title_case for clarity"
