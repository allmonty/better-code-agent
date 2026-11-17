---
description: A multi-commit feature request should produce a written plan with testable criteria and verified tasks, and no code yet.
max_turns: 30
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, TodoWrite, Bash, Write, Edit]
---

I want to add word statistics to the text utils. Add `word_stats(text)` to `textutils/text.py` returning the word count and the most frequent word (case-insensitive, words split on whitespace, ties broken alphabetically, `None` for empty text). Then change `report_heading(name)` into `report(name, body)` in `textutils/report.py`, which returns the heading followed by a line `Words: <count>, most frequent: <word>`, and update its callers. Can you plan this out before we build anything?
