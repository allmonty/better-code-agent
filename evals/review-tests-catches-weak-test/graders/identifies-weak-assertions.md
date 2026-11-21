---
type: llm
weight: 2
---

PASS if the response concludes the `slugify` tests cannot be trusted as-is because they only check type, non-null, or non-emptiness rather than exact expected output values (such as `"hello-world"` or `"foo-bar"`), and identifies missing edge cases or surviving mutations (punctuation, collapsing dashes, leading/trailing punctuation, empty input).
FAIL if it approves the `slugify` tests as sufficient or misses the weak assertions.
