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

  provider가 **전이적으로** 끌어오는 의존까지 override해야 컨테이너가 선다. 예를 들어
  `SwipeController`가 locale을 watch하면 `sharedPreferencesProvider` override와
  `TestWidgetsFlutterBinding.ensureInitialized()`가 함께 필요하다(저장된 언어가 없을 때
  기기 로케일을 읽기 때문). 빠뜨리면 provider가 오류 상태로 떠서 `.future`가 완결되지
  않고 **30초 타임아웃까지 매달린다** — 실패 메시지가 아니라 느려짐으로 먼저 드러난다.

  autoDispose provider는 `container.listen(..., fireImmediately: true)`로 구독을 유지한
  뒤 읽는다. 구독 없이 `.future`를 읽으면 로딩 중 폐기돼 같은 증상이 난다.

  **`build()`가 던지는 첫 실패 경로는 provider 단위로 재현되지 않는다.** AsyncNotifier가
  로딩 상태에서 폐기돼 테스트가 매달린다(구독을 미리 걸어도 같다). 그 경로는 위젯 테스트에
  맡기고, provider 테스트는 이미 성공한 뒤의 재조회(`reload()`)로 같은 실패를 유발한다.

- **view / component** — widget tests that pump the widget inside a provider
  scope with overrides; assert what the user sees, not internal wiring.

## What to flag when reviewing
- A feature missing its repository test or provider test (both are Blocking).
- A repository test that hits a real endpoint instead of a mocked GraphQL layer.
- A repository test with no error-path case for the GraphQL `errors` array.
- Over-mocking: mocking things the test never asserts on.
- Tests with elaborate setup — usually a sign the code under test is too complex;
  simplify the code first.
- 스위트가 느려졌다면(전체 300개 기준 약 11초가 정상) 실행 성능이 아니라 **매달린 테스트**를
  의심한다. `Tried to use a provider that is in error state`나 `TimeoutException after 0:00:30`이
  찍혔는지 본다 — 원인은 대개 위의 override 누락이다.
- 공통 provider에 새 `watch`를 추가한 변경은 그 provider를 쓰는 **모든 기존 테스트**의 셋업을
  함께 고쳐야 한다. 남의 테스트가 깨진 것을 발견하고 삭제하는 것은 해결이 아니다 — 그 테스트가
  지키던 인수 기준이 그대로 사라진다.

## How to report
Missing repository or provider tests are **Blocking**. Over-mocked or
multi-behavior tests are **Advisory** with the simpler rewrite. For each: the
file and line, the issue, and the fix.
