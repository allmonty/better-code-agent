---
type: llm
weight: 2
---

PASS if the response says that textutils/report.py still imports `title_case`, which the commit renamed, so it is now broken (fails to import, crashes or errors).
FAIL if the response does not identify textutils/report.py as broken by the rename, or approves the commit as ready.
