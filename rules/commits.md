# Commits

- One change per commit: a feature task, a fix, a refactor, tests only, or docs. A bug found along the way gets its own commit.
- Each commit includes its tests and passes `scripts/check.sh` on its own.
- Message: a short summary line, a blank line, then a body saying what changed and why. Follow the project's own convention (e.g. Conventional Commits) when it has one.
- Plan commit boundaries while working; commit each piece once its check passes instead of piling everything into one diff.
- Never commit secrets, generated build output, or unrelated formatting changes.
- Never rewrite published history or force-push without being asked.
