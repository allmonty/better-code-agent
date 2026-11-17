---
name: architecture-decision
description: Chooses an architecture or technology for a project or module and records it as an ADR in docs/adr/, including how the decision is enforced (structural test or lint rule). Use when starting a project, adding a module or service, picking a database/framework/library, or when the user asks which architecture fits.
argument-hint: "[decision to make]"
---

# Architecture decision

Decision: $ARGUMENTS

1. **Gather the forces.** Read existing ADRs and the code. Find out from the code and the user: the domain's complexity, expected load and data size, team size, deployment target, the stack the team already knows, and what must stay easy to change.
2. **Default to what exists.** In an existing codebase the current architecture wins unless it blocks the requirement. Say so if it does.
3. **Compare two or three real options** against those forces, using `.claude/rules/architecture.md`: simple module, layered, hexagonal/clean, or the stack's opinionated framework structure. Include the cost of each: extra files, indirection, what tests look like.
4. **Recommend one** and say what would make you pick another.
5. **Write the ADR** as the next number in `docs/adr/` from `0000-template.md`, status `proposed`. Under Consequences, name the enforcement: the structural test or lint rule (e.g. import-linter contract, dependency-cruiser rule, ArchUnit test) that will fail when the boundary is crossed.
6. **Ask for approval**, then set the status to `accepted` and add the enforcement as a plan task or do it now as its own commit.
