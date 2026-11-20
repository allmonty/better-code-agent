---
type: llm
focus: trace
weight: 2
---

PASS if the trace shows at least 2 distinct git commits created during this session (separate `git commit` invocations or distinct commit messages/hashes produced by the agent), rather than batching all work into one commit or making no commits.
FAIL if 0 or 1 commits were created during the session (do not count pre-existing setup commits).
