#!/usr/bin/env bash
# Tasks 1-2 of a 3-task plan are done, committed and logged; task 3 is open.
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/../_fixtures/python-project.sh"
cat > docs/plans/text-features.md <<'MD'
# Plan: text features

Status: approved

## Goal
Report headings get URL anchors, and texts get a word count.

## Acceptance criteria
- [ ] AC1: `slugify("Hello, World!")` returns `"hello-world"`; runs of spaces or punctuation become one hyphen, no leading or trailing hyphens.
- [ ] AC2: `word_count("one two  three")` returns `3`; empty or whitespace-only text returns `0`.
- [ ] AC3: `report_heading("annual report")` returns `"# Annual Report {#annual-report}"`.

## Tasks
- [ ] 1. Add `slugify(title)` to `textutils/text.py` — verify: unit tests in `tests/test_text.py` for AC1
- [ ] 2. Add `word_count(text)` to `textutils/text.py` — verify: unit tests in `tests/test_text.py` for AC2
- [ ] 3. Make `report_heading` in `textutils/report.py` append the slug anchor — verify: unit tests in `tests/test_report.py` for AC3

## Test plan
Unit tests only.
MD
sed -i.bak -e 's/^Status: approved/Status: in progress/' -e 's/^- \[ \] 1\./- [x] 1./' -e 's/^- \[ \] 2\./- [x] 2./' -e 's/^- \[ \] AC1/- [x] AC1/' -e 's/^- \[ \] AC2/- [x] AC2/' docs/plans/text-features.md
rm docs/plans/text-features.md.bak
git add -A && git commit -q -m "Plan text features"
cat >> textutils/text.py <<'PY'


def slugify(title):
    import re
    return re.sub(r"[^a-z0-9]+", "-", title.lower()).strip("-")
PY
python3 - <<'PY'
p = "tests/test_text.py"
s = open(p).read()
s = s.replace("from textutils.text import title_case", "from textutils.text import slugify, title_case")
s = s.replace("\n\nif __name__", "\n\nclass SlugifyTest(unittest.TestCase):\n    def test_slugifies_punctuation(self):\n        self.assertEqual(slugify('Hello, World!'), 'hello-world')\n\n\nif __name__")
open(p, "w").write(s)
PY
cat >> docs/PROGRESS.md <<'MD'

## 2026-11-19: text-features task 1 slugify
- Done: slugify in textutils/text.py with tests.
- Next: task 2 word_count.
- Blocked: none.
MD
git add -A && git commit -q -m "Add slugify"
cat >> textutils/text.py <<'PY'


def word_count(text):
    return len(text.split())
PY
python3 - <<'PY'
p = "tests/test_text.py"
s = open(p).read()
s = s.replace("import slugify, title_case", "import slugify, title_case, word_count")
s = s.replace("\n\nif __name__", "\n\nclass WordCountTest(unittest.TestCase):\n    def test_counts_words(self):\n        self.assertEqual(word_count('one two  three'), 3)\n\n    def test_empty_is_zero(self):\n        self.assertEqual(word_count('   '), 0)\n\n\nif __name__")
open(p, "w").write(s)
PY
cat >> docs/PROGRESS.md <<'MD'

## 2026-11-19: text-features task 2 word_count
- Done: word_count in textutils/text.py with tests.
- Next: task 3 heading anchors in textutils/report.py.
- Blocked: none.
MD
git add -A && git commit -q -m "Add word_count"
