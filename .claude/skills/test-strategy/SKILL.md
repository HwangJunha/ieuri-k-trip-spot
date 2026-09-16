---
name: test-strategy
description: Defines and reviews the per-layer test shape for the Flutter app (CLAUDE.md §8) — model unit tests, repository tests against a mocked GraphQL client, and provider tests with a ProviderContainer as the layers acceptance criteria are verified at; widget tests are advisory. Keeps tests simple. Use when writing or reviewing tests.
allowed-tools: Read, Glob, Grep
---

# Test strategy

Tests are as simple as the code: one behavior per test, arrange-act-assert,
minimal mocking. Don't test generated code or the framework. Judge against
CLAUDE.md §8.

## The shape for each layer

- **model** — pure unit tests with no mocks: serialization round-trips, equality,
  and any value logic.

- **repository** — unit tests against a mocked GraphQL layer, not a real network.
  Provide a fake or mock GraphQL client/link that returns a canned response, then
  assert the repository parsed it into the right domain model. Because GraphQL
  returns HTTP 200 even on failure, include a case where the response carries a
  populated `errors` array and assert the repository surfaces it as a failure —
  don't let error payloads pass as success.

- **provider** — tests with a `ProviderContainer` where the repository is
  overridden with a fake; assert the emitted `AsyncValue` states (loading then
  data, or error).

  The container only stands up if you override what the provider pulls in
  **transitively**, not just its direct dependency. When `SwipeController` watches
  locale, for instance, it needs a `sharedPreferencesProvider` override *and*
  `TestWidgetsFlutterBinding.ensureInitialized()` (it reads the device locale when
  no language is stored). Miss one and the provider comes up in an error state,
  `.future` never completes, and the test **hangs to the 30s timeout** — it shows
  up as slowness before it shows up as a failure message.

  For an autoDispose provider, hold a subscription with
  `container.listen(..., fireImmediately: true)` before reading it. Reading
  `.future` with no subscription discards it mid-load, with the same symptom.

  **The first failure path — `build()` throwing — cannot be reproduced at the
  provider level.** The AsyncNotifier is discarded while loading and the test
  hangs (holding a subscription first doesn't change it). Leave that path to a
  widget test; in provider tests, trigger the same failure with a `reload()` after
  a successful first load.

- **view / component** — widget tests are **Advisory, not required.** The
  planner writes acceptance criteria so they are satisfiable at the
  application/domain layer, and it no longer specifies screen composition — so no
  AC arrives that only a widget test can verify. Without an AC behind it there is
  no ground for making one Blocking.

  Write one where it earns its cost: the **failure path that provider tests
  cannot reproduce** (an AsyncNotifier discarded while loading, per the provider
  section above) belongs in a widget test. When you do write one, pump the widget
  inside a provider scope with overrides and assert what the user sees, not
  internal wiring.

## What to flag when reviewing
- A slice missing its repository test or provider test (both are Blocking — the
  acceptance criteria are verified at these layers).
- A missing widget test is **Advisory**, with one exception worth naming: a
  `build()`-throws path that provider tests demonstrably cannot cover.
- A repository test that hits a real endpoint instead of a mocked GraphQL layer.
- A repository test with no error-path case for the GraphQL `errors` array.
- Over-mocking: mocking things the test never asserts on.
- Tests with elaborate setup — usually a sign the code under test is too complex;
  simplify the code first.
- A suite that got slower (about 11s for 300 tests is normal) is usually **a hanging
  test**, not a performance problem. Look for `Tried to use a provider that is in
  error state` or `TimeoutException after 0:00:30` — the cause is nearly always a
  missing override above.
- A change that adds a new `watch` to a shared provider must fix the setup of
  **every existing test** that uses it. Finding someone else's test broken and
  deleting it is not a fix — the acceptance criterion it guarded disappears with
  it.

## How to report
Missing repository or provider tests are **Blocking**. Missing widget tests,
over-mocked tests, and multi-behavior tests are **Advisory** with the simpler
rewrite. For each: the file and line, the issue, and the fix.
