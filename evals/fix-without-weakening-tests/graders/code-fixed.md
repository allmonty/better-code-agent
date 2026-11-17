---
type: llm
focus: { source: file, path: textutils/text.py }
---

PASS if `title_case` capitalises the first letter of each hyphen-separated part as well as each space-separated word, so 'jean-luc picard' becomes 'Jean-Luc Picard' and 'hello world' becomes 'Hello World'.
FAIL if it doesn't handle hyphens, or special-cases the test input.
