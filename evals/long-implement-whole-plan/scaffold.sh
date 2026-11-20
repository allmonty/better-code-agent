#!/usr/bin/env bash
# No templates; an approved 3-task plan to implement in one go.
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/../_fixtures/python-project.sh" --bare
mkdir -p docs/plans
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
git add -A && git commit -q -m "Plan text features"
