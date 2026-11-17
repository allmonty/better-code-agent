# Architecture

- Existing project: follow the architecture already there. Don't introduce a second style.
- New project or module: choose the smallest structure that fits, and record the choice in `docs/adr/`:
  - Script or single module: one job, little logic.
  - Layered (handler → service → repository): CRUD with modest rules.
  - Hexagonal / clean (domain core, ports, adapters): rich domain rules, several I/O adapters, or a long-lived core.
- Dependencies point inward. Domain code does not import the framework, the DB driver, or HTTP. Side effects live at the edges; the core is plain functions and data.
- Organise by feature or domain, not by technical type. Each module exposes a small public interface; other modules never reach into its internals.
- No layer, interface, or factory with one implementation "for later". Add the seam when the second case arrives.
- Make boundaries mechanical: once a structure is chosen, add a structural test or lint rule that fails on a forbidden import (dependency-cruiser, import-linter, ArchUnit, eslint-plugin-boundaries, ...). A rule only written down will drift.
- Validate input and handle errors at the boundary. Inside, trust your own types.
- Configuration comes from the environment, read once at startup and passed in.
