---
type: regex
target: { source: file, path: textutils/text.py }
pattern: 'return " "\.join\(w\[:1\]\.upper\(\) \+ w\[1:\] for w in s\.lower\(\)\.split\(" "\)\)'
weight: 2
---
