---
description: Reviewing weak AI-written tests should catch missing value assertions, surviving mutations, and untested edge cases.
max_turns: 30
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite, Bash]
---

Are the new `slugify` tests in `tests/test_text.py` good enough to trust, or do they miss anything?
