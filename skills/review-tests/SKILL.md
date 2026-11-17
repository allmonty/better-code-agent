---
name: review-tests
description: Audits whether tests would actually catch bugs - mentally mutates the code under test, checks assertions, test level, mocking, flakiness, acceptance-criteria coverage, and any skipped, deleted or loosened tests. Use when the user asks if tests are good enough, before trusting AI-written tests, or after a feature's tests are written.
argument-hint: "[path | commit | range]"
context: fork
agent: general-purpose
background: false
---

# Review tests

You are checking tests someone else wrote. Read only; don't edit files.

## 1. Scope
Target: $ARGUMENTS
- Empty: tests changed in uncommitted work, else in the last commit.
- A path: those tests and the code they cover.
- A commit or range: tests and code changed there.

Read `.claude/rules/testing.md` and the plan's acceptance criteria in `docs/plans/` if one applies.

## 2. For each piece of code under test
Pick its most important branches and mentally apply mutations: flip a condition, change `<` to `<=`, return early, drop a call, swap two arguments, return an empty value. For each, ask: does some test fail? A mutation that survives is a finding. If the project has a mutation tool configured (Stryker, mutmut, PIT, ...), run it on the changed files and use its report.

## 3. Check each test
- **Asserts behaviour**: specific expected values on outputs or visible effects, not just "no exception" or "was called".
- **Right level**: unit for logic, integration with real dependencies for I/O, e2e only for critical journeys.
- **Mocks**: only things the project doesn't control. Mocking the project's own modules hides integration bugs.
- **Deterministic**: no sleeps, real clock, unseeded randomness, network, or reliance on test order.
- **Readable**: the name says the behaviour; one reason to fail; setup is not longer than it needs to be.
- **Not weakened**: in the diff, look for deleted tests, removed asserts, new skips, widened tolerances, snapshots updated without explanation.

## 4. Coverage of intent
Map each acceptance criterion and each error path to a test. List the ones with none. Where example tests can't cover a wide input space (parsing, serialisation, arithmetic), suggest the property-based test to add.

## 5. Report
Ranked findings, each with the test or code location, the surviving mutation or gap, and the test to add or change. End with: tests that can be trusted, tests that can't, and the missing ones.
