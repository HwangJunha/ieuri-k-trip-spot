---
name: test-strategy
description: Defines and reviews the per-layer test shape for the Flutter app (CLAUDE.md §8) — model unit tests, repository tests against a mocked GraphQL client, provider tests with a ProviderContainer, widget tests with provider overrides. Keeps tests simple. Use when writing or reviewing tests.
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

- **view / component** — widget tests that pump the widget inside a provider
  scope with overrides; assert what the user sees, not internal wiring.

## What to flag when reviewing
- A feature missing its repository test or provider test (both are Blocking).
- A repository test that hits a real endpoint instead of a mocked GraphQL layer.
- A repository test with no error-path case for the GraphQL `errors` array.
- Over-mocking: mocking things the test never asserts on.
- Tests with elaborate setup — usually a sign the code under test is too complex;
  simplify the code first.

## How to report
Missing repository or provider tests are **Blocking**. Over-mocked or
multi-behavior tests are **Advisory** with the simpler rewrite. For each: the
file and line, the issue, and the fix.
