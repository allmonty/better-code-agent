---
type: llm
focus: trace
weight: 2
---

PASS if the trace shows at least 3 distinct git commits created during this session (one per plan task, whether via separate Bash calls or multiple commits with distinct messages/hashes).
FAIL if fewer than 3 commits were created during the session (do not count pre-existing setup commits).
