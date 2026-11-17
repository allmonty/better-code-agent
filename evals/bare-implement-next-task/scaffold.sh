#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/../_fixtures/python-project.sh" --bare
mkdir -p docs/plans
cat > docs/plans/slugify.md <<'MD'
# Plan: slugify

Status: approved
Roadmap: URL-friendly headings

## Goal
Report headings can be turned into URL slugs.

## Acceptance criteria
- [ ] AC1: `slugify("Hello, World!")` returns `"hello-world"`.
- [ ] AC2: runs of spaces or punctuation become one hyphen; no leading or trailing hyphens.

## Tasks
- [ ] 1. Add `slugify(title)` to `textutils/text.py` — verify: unit tests in `tests/test_text.py` for AC1 and AC2
- [ ] 2. Use `slugify` for anchor ids in `textutils/report.py` — verify: unit test for `report_heading`

## Test plan
Unit tests only.
MD
git add -A && git commit -q -m "Plan slugify"
