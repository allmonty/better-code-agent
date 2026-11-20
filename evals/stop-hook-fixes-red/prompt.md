---
description: In a bare project with a Makefile check target enforcing docstrings, the Stop hook must block finishing while red and drive the agent to fix the docstring check.
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, TodoWrite, Bash, Write, Edit]
---

Add `word_count(s)` to `textutils/text.py` returning `len(s.split())`, and add a unit test for it in `tests/test_text.py`. Run `python3 -m unittest tests.test_text` when done.
