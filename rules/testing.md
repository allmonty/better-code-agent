# Testing

- Every behaviour change ships with a test that fails without the change. Write it first and see it fail.
- Bug fix: first reproduce the bug with a failing test, then fix.
- Pick the cheapest level that can catch the bug:

| Level | Use for | Dependencies |
|---|---|---|
| Unit | Pure logic, branches, parsing, calculations | None. In-memory only. |
| Integration | Code that talks to a DB, queue, filesystem, HTTP client | Real ones: test containers, SQLite/temp dirs, local fakes of the real protocol |
| System / API | A running service through its public interface | Real service, seeded data |
| End-to-end | The few critical user journeys (sign-up, checkout, ...) | Browser automation (e.g. Playwright) as a user would |
| Contract | Boundaries with services you don't own | Recorded or consumer-driven contracts |

- Mock only what you don't control: third-party APIs, the clock, randomness. Don't mock your own modules; test through them.
- Test behaviour through the public interface, not private functions or call counts. A refactor that keeps behaviour must not break tests.
- One reason to fail per test. The name states the behaviour (`rejects_expired_token`, not `test_auth_2`).
- Deterministic: no sleeps, no real network in unit tests, fixed seeds and clocks, no dependence on test order.
- Never delete, skip, or loosen an existing test to get green. If a test is wrong, say why and change it in its own commit.
- Coverage is a hint, not a goal. For critical logic, run mutation testing (Stryker, mutmut, PIT, cargo-mutants, ...) on the changed code to see whether tests catch real faults.
- For parsers, serialisers, money and other code with a wide input space, add property-based tests (Hypothesis, fast-check, proptest, StreamData): round-trips, invariants, never-crashes.
- Claim a pass only with evidence: the command you ran and its output.
