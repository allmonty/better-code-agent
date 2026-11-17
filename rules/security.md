# Security

- Validate every input that crosses a trust boundary (HTTP, CLI args, files, queues, env) with a schema, and reject what doesn't match.
- Queries are parameterised. Shell commands take argument arrays, never concatenated strings. File paths from input are resolved and checked against an allowed root.
- Encode output for its context (HTML, SQL, shell, logs).
- Authorise on the server for every access to a resource. Deny by default.
- Secrets never go in code, tests, fixtures, logs, or commits. Read them from the environment or a secret manager; keep `.env` in `.gitignore`.
- Never log tokens, passwords, or personal data.
- Before adding a package, confirm it exists in the official registry under that exact name and is the one you mean. Agents invent plausible package names, and attackers register them.
- Never disable TLS verification, CSRF protection, auth checks, or sandboxing to make something work. Fix the cause.
- Least privilege for credentials, containers, and DB users.
