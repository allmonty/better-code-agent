# Security Policy

## Scope

Because `better-code-agent` ships shell hooks (`hooks/`), bootstrap and check scripts (`scripts/`), and GitHub Actions workflow templates (`ci/github/`, `templates/.github/`), vulnerabilities that cause unintended command execution, credential exposure, or path traversal are treated as high priority.

## Reporting a Vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Instead, report vulnerabilities privately through GitHub Security Advisories:

https://github.com/allmonty/better-code-agent/security/advisories/new

Include:
- The affected file or workflow
- Steps or a minimal fixture to reproduce the issue
- Potential impact and any suggested mitigation

You will receive an acknowledgment as soon as possible, and a fix or mitigation plan before public disclosure.
