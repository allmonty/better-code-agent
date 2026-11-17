# Code quality

- Before writing, search the codebase for a helper, component, or pattern that already does it, and use it the way the surrounding code does.
- Match the conventions of the surrounding code over your own preference.
- Small, single-purpose functions. Names say what a thing is or does; no unexplained abbreviations.
- No dead code, commented-out code, unused parameters, or options nobody asked for.
- Errors: handle them or propagate them with context. Never swallow an error or catch everything to make a symptom go away.
- Comments say why, not what.
- Use the strictest typing the stack offers. Every `any`, cast, or lint suppression gets a one-line reason.
- Don't add a dependency for a few lines of code. When you add one, check it is maintained and the licence fits.
- Touch only what the task needs. Refactors go in their own commit, before or after the feature.
- A known limitation gets a comment `shortcut: <the limit>, <when to fix>` and an entry in `docs/ROADMAP.md` under Debt.
