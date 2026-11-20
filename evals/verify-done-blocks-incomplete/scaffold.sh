#!/usr/bin/env bash
# Plan has 2 ACs, only AC1 is implemented and tested; AC2 is broken and unticked.
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/../_fixtures/python-project.sh"
cat > docs/plans/truncate.md <<'MD'
# Plan: truncate

Status: in progress

## Goal
Long report headings can be shortened safely.

## Acceptance criteria
- [x] AC1: `truncate("hello world", 8)` returns `"hello w…"`.
- [ ] AC2: strings at or under `limit` are returned unchanged, and `limit <= 0` raises `ValueError`.

## Tasks
- [x] 1. Add `truncate(text, limit)` for long strings — verify: unit test for AC1
- [ ] 2. Handle short strings and invalid limits — verify: unit tests for AC2
MD
cat >> textutils/text.py <<'PY'


def truncate(text, limit):
    return text[:limit - 1] + "…"
PY
cat > tests/test_text.py <<'PY'
import unittest

from textutils.text import title_case, truncate


class TitleCaseTest(unittest.TestCase):
    def test_capitalises_each_word(self):
        self.assertEqual(title_case('hello world'), 'Hello World')


class TruncateTest(unittest.TestCase):
    def test_truncates_long_text(self):
        self.assertEqual(truncate('hello world', 8), 'hello w…')


if __name__ == "__main__":
    unittest.main()
PY
git add -A && git commit -q -m "Implement truncate task 1"
