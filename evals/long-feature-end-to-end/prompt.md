---
description: A three-part feature built end to end without a human in the loop should still be planned, tested per part, committed in steps, and reported with evidence.
max_turns: 80
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Skill, TodoWrite, Bash, Write, Edit]
---

Build this for the text utils. I'm away until tomorrow, so don't wait for me; make reasonable calls and tell me what you decided.

1. `slugify(title)` in `textutils/text.py`: lowercase, runs of spaces or punctuation become one hyphen, no leading or trailing hyphens.
2. `word_stats(text)` in `textutils/text.py`: returns `(count, most_frequent_word)`; case-insensitive, split on whitespace, ties broken alphabetically, `(0, None)` for empty text.
3. `report(name, body)` in `textutils/report.py`: the heading `# <Title Case Name> {#<slug>}`, then a line `Words: <count>, most frequent: <word>`. Keep `report_heading` working.
