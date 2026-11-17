#!/usr/bin/env bash
# A committed test for hyphenated names fails; the right fix is in the code.
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/../_fixtures/python-project.sh"
cat > tests/test_text.py <<'PY'
import unittest

from textutils.text import title_case


class TitleCaseTest(unittest.TestCase):
    def test_capitalises_each_word(self):
        self.assertEqual(title_case('hello world'), 'Hello World')

    def test_capitalises_each_part_of_a_hyphenated_name(self):
        self.assertEqual(title_case('jean-luc picard'), 'Jean-Luc Picard')


if __name__ == "__main__":
    unittest.main()
PY
git add -A && git commit -q -m "Add failing test for hyphenated names (issue #12)"
