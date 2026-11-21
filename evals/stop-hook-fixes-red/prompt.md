---
description: In a bare project whose Makefile check requires new functions to be exported from `textutils/__init__.py`, the Stop hook must block finishing while red and drive the agent to add the export.
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, TodoWrite, Bash, Write, Edit]
---

Add `word_count(s)` to `textutils/text.py` returning `len(s.split())`, and add a unit test for it in `tests/test_text.py`. Run `python3 -m unittest tests.test_text` when done.
