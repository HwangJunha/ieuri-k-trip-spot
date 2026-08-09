# K-TripSpot — Flutter App Guide (CLAUDE.md)

> Real-time, location-based tourism app for foreign visitors to Korea.
> English-first UI, multilingual (EN/KO/JA/ZH). Built for the 2026 Korea Tourism Organization OpenAPI competition.

This file is the **operating contract** for this repository. Rules here are enforced by hooks (deterministic) and reviewed by subagents/skills (probabilistic). When a hook and this file disagree, the hook wins — fix the code, not the rule.

---

## 0. 사용자와의 소통

**모든 응답과 질문은 한글로 한다.** 코드·식별자·커밋 메시지 제목의 관용 표현(`fix(auth):`)은
영어를 유지하되, 사용자에게 말하는 문장은 한글이다. 선택지를 묻는 질문(AskUserQuestion)도
질문·선택지·설명 전부 한글이다.

**작업 마무리는 "확인할 것"만 말한다.** 무엇을 했는지 길게 나열하지 않는다. 마지막 요약에
들어갈 것은 이 셋뿐이다:

1. **사용자가 판단해야 할 것** — 내가 임의로 정한 선택, 갈릴 수 있었던 판단
2. **사용자가 직접 확인해야 할 것** — 내가 검증하지 못한 것(실기기 육안 확인 등)
3. **범위 밖으로 남긴 것** — 왜 안 했는지 한 줄

**확인할 것이 없으면 그렇게 말하고 끝낸다.** "완료했습니다" 한 줄이면 충분하다. 변경 파일
목록, 통과한 테스트 개수, 구현 단계 나열은 사용자가 물었을 때만 쓴다 — 도구 출력에 이미
있는 것을 산문으로 옮겨 적지 않는다.

검증 결과는 예외다: 테스트가 **실패했거나 건너뛴 것이 있으면** 반드시 말한다. 통과했으면
"통과" 한 줄로 족하다. 개발 중이라 테스트를 안 돌린 경우(§8)에는 `flutter analyze` 결과를
같은 방식으로 말한다.

---

## 1. Core principles (in priority order)

1. **Domain-centric design.** Code is organized by feature/domain, not by technical type at the top level. Each domain owns its full vertical slice.
2. **Simple code.** The *code itself* stays clean, small, and obvious. Prefer the boring solution. No cleverness, no premature abstraction.
3. **Structural complexity only when the architecture demands it.** Layering (component/model/provider/repository/view) is allowed to add structure — but only that. Any complexity that is *not* justified by an architectural boundary is a smell. "Simple is best" applies to code; the layered structure is the one sanctioned exception.
4. **Simple tests.** Tests are as plain as the code. One behavior per test, minimal mocking, no test framework gymnastics.
5. **Security is not optional.** All tokens and sensitive values go through `flutter_secure_storage` (via the common wrapper). Never plaintext, never `SharedPreferences` for secrets.
6. **Performance via Riverpod.** Use provider scoping, `select`, `family`, and `autoDispose` to avoid unnecessary rebuilds. `const` widgets everywhere possible.

When two principles conflict, the lower number wins. In practice: **domain boundaries beat brevity; brevity beats everything else.**

---

## 2. Directory structure

```
lib/
├── common/                     # Cross-domain shared code ONLY (see §4)
│   ├── pagination/             # Pagination models + PaginationListView (shared)
│   ├── storage/                # SecureStorage wrapper over flutter_secure_storage
│   ├── network/                # graphql_flutter client, links (AuthLink), error mapping
│   ├── model/                  # Truly shared value objects / base types
│   └── widget/                 # Truly shared reusable widgets
├── domain/
│   └── <feature>/              # e.g. spot/, chat/, auth/, congestion/, event/
│       ├── component/          # Reusable widgets scoped to this feature
│       ├── model/              # Pure Dart models (freezed / json_serializable)
│       ├── provider/           # Riverpod providers (@riverpod codegen)
│       ├── repository/         # Data access (GraphQL): interface + impl, .graphql ops + generated *.graphql.dart
│       └── view/               # Screens / pages
├── router/                     # GoRouter configuration + route guards
└── main.dart

problem/                        # Feature specs as *.md (source of truth for implementation)
```

- **One feature = one folder under `lib/domain/`.** Never split a feature across the top level.
- A feature folder need not contain all five subfolders — only the ones it uses. But when it has them, they mean exactly what §3 says.

---

## 3. Layer definitions & dependency direction

The data layer is **GraphQL**, using `graphql_flutter` with `graphql_codegen` for typed operations. The GraphQL client and the generated `*.graphql.dart` types live **only** in the repository; the repository maps GraphQL responses to domain models so the transport schema never reaches the UI.

Dependencies point **downward only**. A layer may import layers below it, never above, never sideways into another feature's internals.

```
view  ─┬─▶ component
       ├─▶ provider ─▶ repository ─▶ model
       └─▶ model
component ─▶ provider, model
```

| Layer | May import | MUST NOT import |
|---|---|---|
| `model` | pure Dart, freezed, json_serializable | `flutter/*`, `graphql`/`graphql_flutter`, `riverpod`, `go_router` |
| `repository` | `model`, `graphql_flutter`, generated `*.graphql.dart`, `common/network`, `common/storage` | `flutter/material`, `provider/*`, `view/*` |
| `provider` | `repository`, `model`, `common/*` | `view/*`, `graphql_flutter`, `*.graphql.dart` (reach GraphQL only via the repository) |
| `component` | `provider`, `model`, `common/*` | `repository/*`, `graphql_flutter`, `*.graphql.dart` |
| `view` | `provider`, `component`, `model`, `common/*`, `router` | `repository/*`, `graphql_flutter`, `*.graphql.dart` |

**Hard rules (hook-enforced):**
- `model/**` is **pure**. No `package:flutter`, no `package:graphql` / `package:graphql_flutter`, no `package:riverpod`, no `package:go_router`. If a model needs a widget, it is not a model.
- `view/**` and `component/**` never import `repository/**`, `package:graphql(_flutter)`, or generated `*.graphql.dart` types. All data flows through a provider.
- Generated `*.graphql.dart` operation types stay inside the repository, which maps them to domain models in `model/`. They must not appear in `provider/**`, `component/**`, or `view/**`.
- **No cross-feature imports.** `domain/spot/**` must not import `domain/chat/**`. Anything two features share moves to `common/`.

---

## 4. What belongs in `common/`

`common/` is for code shared by **two or more features**, or infrastructure with no feature identity.

- **Pagination is common.** `PaginationState`, `PaginationParams`, cursor/page models, and `PaginationListView` live in `common/pagination/` and are reused by every list screen. A feature must not roll its own pagination.
- `SecureStorage` wrapper (`common/storage/`) is the *only* place `flutter_secure_storage` is imported.
- The `graphql_flutter` client, its links (including the `AuthLink`), and error→failure mapping live in `common/network/`. GraphQL returns HTTP 200 even on failure, so the mapping inspects the `errors` array — a populated `errors` array is a failure, not a success.
- Rule of thumb: if only one feature uses it, it belongs in that feature, not `common/`. Don't pre-share.

---

## 5. State management — Riverpod (code generation)

- Use **Riverpod 3 with code generation** (`@riverpod` / `riverpod_generator`). Do not hand-write `StateNotifierProvider` boilerplate.
- Async data (from the GraphQL repository) uses `AsyncNotifier` / `FutureProvider` generated forms; expose `AsyncValue` to the UI.
- **Performance:**
  - Read the narrowest slice: `ref.watch(provider.select((s) => s.field))`, never watch the whole object for one field.
  - Parameterize the provider (an `id` argument becomes a family via codegen) instead of duplicating providers.
  - Prefer `autoDispose` (the codegen default) unless the state must survive navigation — justify any keep-alive.
  - Repositories are exposed via a provider; widgets never construct a repository directly.
- Use the unified `Ref` (the per-provider `*Ref` types were removed in Riverpod 3).
- Widgets read providers via `Consumer`/`ConsumerWidget`; keep `ref.watch` calls close to where the value is used to minimize rebuild scope.

---

## 6. Routing — GoRouter

- All routes are declared centrally in `router/`. No inline `Navigator.push` for primary navigation.
- Auth-gated routes use GoRouter `redirect` reading the auth provider — not ad-hoc checks in widgets.
- Route params are typed; pass IDs, not whole model objects, across routes.

---

## 7. Security

- **Tokens, refresh tokens, and any secret → `flutter_secure_storage`**, accessed *only* through `common/storage/SecureStorage`.
- **Never** put tokens/secrets in `SharedPreferences`, plaintext files, logs, or hardcoded constants.
- The GraphQL `AuthLink` (in `common/network`) reads the token from `SecureStorage`; the circular dependency between the link and auth state is resolved with a Stream/Signal pattern (do not reintroduce a direct provider→client→provider cycle).
- Do not log request/response bodies that may contain tokens or PII (GraphQL responses can carry both).

---

## 8. Testing (keep them simple)

### 언제 쓰는가 — **작업 완료 시점에 한 번**

**개발 중에는 테스트를 쓰지도, 돌리지도 않는다.** 요건이 자주 바뀌는 구간에서 테스트를
같이 쓰면, 바뀔 때마다 코드와 테스트를 두 번 고치게 되고 그 대부분이 버려진다. 빌드
검증은 `flutter analyze`로 한다 — 컴파일 오류만 잡으면 개발 중에는 충분하다.

**완료 시점은 사용자가 "작업 완료"라고 말한 때다.** 내가 판단하지 않는다. 그 말을 듣고
나서 비로소 테스트를 작성하고 전체 스위트를 돌린다.

예외는 하나뿐이다: **내 변경으로 기존 테스트가 거짓이 되면 그 자리에서 고친다.** 이건 새
테스트를 쓰는 것이 아니라 내가 깨뜨린 것을 치우는 일이다(§8 마지막 항목).

### 무엇을 쓰는가

One behavior per test. Minimal mocks. Arrange–Act–Assert. Per-layer shape:

| Layer | Test shape |
|---|---|
| `model` | Pure unit tests: serialization round-trip, equality, value logic. No mocks. |
| `repository` | Unit test with a **mocked GraphQL client/link**. Assert the operation ran and the response mapped to the model. Include an `errors`-array case that must surface as a failure. |
| `provider` | `ProviderContainer` with overridden repository; assert emitted `AsyncValue` states. |
| `view` / `component` | Widget test with provider overrides; assert what the user sees, not internals. |

- Do not test framework code or generated code.
- If a test needs elaborate setup, the code under test is probably too complex — simplify the code first.

**스위트는 빠르다 — 느리면 그건 깨진 테스트다.** 전체 `flutter test`는 약 11초다(테스트 300개
기준). 이보다 오래 걸린다면 실행이 느린 게 아니라 **테스트가 매달려 30초 타임아웃까지 가고
있는 것**이다. 가장 흔한 원인은 provider가 오류 상태로 떠서 `.future`가 완결되지 않는 경우이고,
그때 스택트레이스에 `Tried to use a provider that is in error state`가 찍힌다.

따라서 **테스트가 깨진 채로 다음 단계를 진행하지 않는다.** 깨진 스위트를 그대로 두고 계속
돌리면 매 실행이 30초씩 들고, 그 비용이 작업 전체 시간의 절반을 먹는다. 하나가 깨지면 그
자리에서 고친 뒤 이동한다.

**공통 의존을 새로 만들면 기존 테스트 셋업을 함께 고친다.** provider의 `build()`에 새 `watch`를
추가하는 것은 그 provider를 쓰는 **모든 테스트**에 새 override 요구를 심는 일이다. 예: locale을
watch하면 `sharedPreferencesProvider` override와 `TestWidgetsFlutterBinding.ensureInitialized()`가
필요해진다. 추가한 쪽이 파급을 정리한다 — 남의 테스트가 깨진 걸 발견하고 지우는 것은 해결이
아니다.

**e2e는 이 표의 일부가 아니라 예외적 수단이다.** 위 네 계층이 검증을 책임진다. e2e는
빌드·부팅·기기 왕복 때문에 유닛 테스트의 수십 배 시간을 먹으므로, 다음 두 경우에만 쓴다:

1. 사용자가 명시적으로 요청했을 때
2. 기능의 핵심 여정에 e2e가 **아예 없을 때** — 여정 하나를 추가

**실행은 작업당 1회.** 통과하면 끝이다. 안정성 확인을 명목으로 반복 실행하지 않는다 —
플레이키가 실제로 관측됐을 때만 1회 더 돌린다. 코드를 고친 뒤의 재검증은 여기 포함되지
않는다(그건 수정 확인이다). 판단 기준은 `e2e-flow-testing` 스킬에 있다.

---

## 9. Code style

- Follow **Effective Dart** + `flutter_lints` (industry standard). The analyzer is authoritative.
- `const` constructors wherever the analyzer allows.
- Small widgets; extract a `component` when a widget grows past a screenful or is reused.
- No dead code, no commented-out blocks, no `print` in committed code.
- **주석은 한글로 작성한다.** 코드·식별자·API 이름은 영어를 유지하되, 설명 주석(`//`, `///` doc comment)은 한글로 쓴다.

---

## 10. Specs & design workflow

Requirements originate in the planner harness (`ieuri-planner`), not here. Two documents:

- **`Specs/SPEC-XXXX/spec.md`** (Obsidian vault) — requirements, acceptance criteria, applied
  policies. The authority on *what must be true*.
- **`problem/SPEC-XXXX-client.md`** (this repo) — the client-side design: screens, state
  transitions, navigation, which repository consumes which operation. The entry point for
  implementation.

**Read both before implementing.** The design document is where you start; the acceptance
criteria in the linked spec are what the widget and provider tests must satisfy. Satisfying the
design while missing an acceptance criterion is not done.

`problem/SPEC-*.md` is produced by the planner — **do not edit it**, a hook blocks it. Everything
else under `problem/` stays yours.

**`problem/SPEC-XXXX-client.md`는 반드시 커밋한다.** 이 설계 문서는 구현의 진입점이고,
왜 그렇게 만들었는지를 코드와 같은 이력에 남겨야 나중에 diff에서 근거를 되짚을 수 있다.
planner가 갱신했을 때도 그 버전을 함께 커밋한다 — 파일을 읽고 구현했는데 그 파일이 이력에
없으면, 리뷰어는 결정의 근거를 볼 수 없다. 편집이 금지된 것과 커밋이 필요한 것은 별개다.

### Design references

**Screen designs live in `docs/design/<name>.md`** — one file per screen or per spec, written by
`ui-designer` from the Stitch project and read by `slice-builder` before it builds any `view/` or
`component/`. This is the single location; there is no `problem/design/`.

A design reference records the layout, the components (named so they map onto `component/`), the
loading/empty/error states, and the Stitch screen id it came from. It is a *reference*, not an
authority: when it conflicts with the spec's acceptance criteria, the spec wins.

### 요건이 바뀌면 — **문서를 직접 고친다**

구현하면서 요건이 바뀌는 일은 흔하다. 예전에는 `[AMEND]`를 남기고 planner를 기다렸는데,
그 왕복 때문에 설계 문서가 코드보다 늘 뒤처졌다. 이제 **`problem/SPEC-*.md`는 이 저장소에서
직접 고친다.**

- 바뀐 요건을 문서에 반영하고 **같은 커밋에 담는다** — 코드와 근거가 갈라지지 않게.
- **무엇이 왜 바뀌었는지 적는다.** "사용자 결정", "서버 계약이 달랐다"처럼 근거를 남겨야
  나중에 diff에서 되짚을 수 있다.
- 코드로 때우고 문서를 그대로 두는 것이 가장 나쁘다 — 다음 사람이 문서를 믿고 반대로 고친다.

`Specs/SPEC-XXXX/spec.md`(Obsidian vault)는 **여전히 못 고친다.** 그건 원본이고 recorder의
것이다(아래).

### 정책이 걸리면 — **recorder에 요청 문서를 남긴다**

정책(`Specs/`의 POL-*, 정책 카탈로그)은 **여러 앱이 공유한다.** 한 앱의 사정으로 여기서
고치면 규칙이 조용히 갈라지고, 어느 쪽이 진짜인지 아무도 모르게 된다. 그래서 vault는
훅이 계속 막는다.

정책과 충돌하거나 정책을 바꿔야 한다고 판단하면, **사용자가 "작업 완료"라고 한 뒤에**
요청 문서를 만든다:

```
ieuri-recorder/problem/SPEC-XXXX-POLICY-<주제>.md
```

**스펙 id를 앞에 붙인다.** 정책 충돌은 언제나 어떤 스펙을 구현하다 발견되고, `problem/`에는
서버·클라이언트가 같은 스펙에 대해 각각 문서를 남기기도 한다. id가 앞에 있어야 한 스펙의
문서들이 목록에서 붙어 보이고, 나중에 스펙·이슈·PR과 같은 열쇠로 되짚을 수 있다.

담을 것은 넷이다 — **무엇에 걸렸는지**(정책 번호와 문구), **실제로 부딪힌 상황**(어느 스펙의
어느 요구에서), **왜 지금 정책으로는 안 되는지**, **제안**(대안과 그 대가). 결정은 recorder가
한다. 작업 도중에 만들지 않는 이유는, 구현이 끝나 봐야 진짜 충돌인지 오해였는지 갈리기
때문이다.

**다른 하네스가 같은 스펙에 문서를 남겼는지 먼저 본다.** 서버가 이미 경위를 적어 두었으면
내 추측을 새로 쓰는 대신 그것을 인용하고, 내 문서의 제안이 그보다 부정확하면 **철회한다** —
같은 스펙에 서로 다른 제안이 둘 남으면 recorder가 어느 쪽을 승격할지 판단할 수 없다.

### Contract

`Specs/SPEC-XXXX/contract.graphql` is the planner's proposal; the server owns the final schema.
Write operations against the **live introspection snapshot** (§13), never against the proposal —
the proposal is what was asked for, the snapshot is what exists.

### Issues and branches

One issue per repo per spec, opened by the planner with the background, spec link, acceptance
conditions, and branch name. Branches are `feature/SPEC-XXXX-<short-kebab-name>` — see §12.

### Design

Design still comes from Google Stitch via MCP (see the `ui-designer` subagent), driven from
`problem/SPEC-XXXX-client.md` rather than a free-standing feature spec.

---

## 11. Standard workflow (subagent pipeline)

For a new feature, the intended flow mirrors the backend harness:

1. **`ui-designer`** — reads `problem/SPEC-XXXX-client.md`, drives Stitch MCP to produce/refine the screen design, saves a design reference to `docs/design/`. **Required for any feature with UI.** Skip it only when the change adds no screen and no component — and say so explicitly rather than skipping silently.
2. **`slice-builder`** — implements the full vertical slice for one feature: `model → repository → provider → component → view`, plus tests. **Reads `docs/design/` for the feature before writing any `view/` or `component/`**; if no design reference exists and the feature has UI, stop and run step 1 first. Uses the `domain-slice-generator` skill to scaffold, then fills in logic.
3. **`architecture-reviewer`** (read-only) — verifies layer boundaries, dependency direction, GraphQL isolation, `common/` extraction, no cross-feature imports.
4. **`quality-reviewer`** (read-only) — verifies simplicity, test shape, Riverpod performance patterns, and secure-storage usage.

Reviews are read-only: they report, the parent agent (or `slice-builder`) applies fixes.

**`e2e-runner`는 이 파이프라인의 기본 단계가 아니다.** e2e는 빌드·부팅·기기 왕복 때문에
유닛 테스트의 수십 배 시간을 먹으므로, 기능이 "완료"되기 위해 매번 거쳐야 하는 관문이
아니다. 사용자가 요청했거나 핵심 여정에 e2e가 아예 없을 때만 호출하고, 실행은 작업당
1회로 끝낸다(§8, `e2e-flow-testing` 스킬).

### 서브에이전트를 언제 쓰고, 무엇을 들려 보낼 것인가

**한 파일에서 끝나는 일은 직접 한다.** slice-builder는 스펙·가이드·설계 문서를 처음부터
다시 읽고 자기 컨텍스트를 세우므로, 시작 비용이 편집 자체보다 크다. 문구 하나, 상수 하나,
조건 한 줄을 바꾸는 데 부르면 그 비용만 내고 얻는 것이 없다.

| 일의 크기 | 방법 |
|---|---|
| 파일 1~2개, 이미 무엇을 고칠지 아는 경우 | **직접 편집** |
| 계층을 가로지르는 기능 추가(model→view+테스트) | slice-builder |
| 넓게 훑어야 하는 조사 | Explore |

**부를 때는 이미 확정된 사실을 함께 준다.** 라이브 스키마 필드, 실측한 시드 값, 원인
분석 결과처럼 내가 이미 확인한 것은 프롬프트에 적어 준다 — 안 적으면 에이전트가 같은
introspection과 같은 grep을 처음부터 다시 돌린다. "다시 유도하지 말고 사실로 받아라"라고
명시하는 편이 확실하다.

**생성 파일은 읽지 않는다.** `*.graphql.dart`·`*.g.dart`는 읽기가 차단돼 있다(권한 설정).
커뮤니티 오퍼레이션 하나가 500KB(~17만 토큰)라 한 번 열면 컨텍스트가 그대로 소모된다.
필요한 것은 **오퍼레이션 원문**(`*.graphql`)과 **커밋된 SDL**(`*_schema.graphql`)이고,
생성 결과가 맞는지는 codegen이 스키마로 이미 검증한다(§13).

---

## 11.5 도구가 멈췄을 때 (codegen·빌드)

**출력이 없는 것과 느린 것은 다르다.** `dart run build_runner build`는 이 프로젝트에서
**1~20초**다. 그보다 오래 걸린다면 느린 게 아니라 **멈춘 것**이고, 기다려서 해결되지 않는다.

판별은 출력으로 한다 — 진행 로그(`riverpod_generator on N inputs …`)가 흐르면 도는 중이고,
**한 줄도 없이 멈춰 있으면 시작조차 못 한 것**이다.

멈췄을 때는 아래 순서로 **끝까지** 간다. 중간 단계에서 우회하지 않는다:

```
dart run build_runner clean          # 1순위. asset_graph 캐시를 정상 경로로 비운다
dart run build_runner build          # 옵션 없이 재실행
```

`clean`으로도 안 되면 `rm -rf .dart_tool/build`가 다음 수단인데, **이 명령은 정책상
차단돼 있다**(`Bash(rm -rf:*)` deny — 실수 한 번이 치명적이라 유지하는 안전장치다).
우회하지 말고 사용자에게 실행을 요청한다:

```
! rm -rf .dart_tool/build && dart run build_runner build
```

`.dart_tool/build/lock/build_runner.lock`만 지우는 것은 **해결이 아니다.** 락은 원인이 아니라
증상이고, 손상된 asset_graph가 남아 있으면 다음 실행이 같은 자리에서 다시 멈춘다. 락 파일만
지우고 재실행하는 것을 반복하는 것이 이 문제에서 가장 흔한 시간 낭비다.

**실행 규율 두 가지.**

1. **`timeout`을 걸고 포그라운드로 돌린다.** `timeout 300 dart run build_runner build`.
   백그라운드로 던지면 kill될 때 락이 남고, 그 락이 다음 실행을 막아 문제가 번식한다.
2. **600초씩 기다리지 않는다.** 2분 안에 진행 로그가 없으면 끊고 위 절차로 간다.

**권한에 막히면 우회하지 말고 사용자에게 요청한다.** 명령이 거부됐다는 것은 그 경로를
쓰지 말라는 뜻이지, 비슷한 효과를 내는 다른 명령을 찾으라는 뜻이 아니다. 실제로
`rm -rf .dart_tool/build`가 거부됐을 때 `rm -f lock`으로 우회하며 한 시간을 쓴 적이 있다 —
"이 명령이 필요한데 막혀 있습니다"라고 한 줄 물었으면 끝날 일이었다.

---

## 12. Branch policy (hook-enforced)

**작업 단위는 독립 worktree가 기본이다.** 여러 작업을 **동시에** 돌리기 때문에, 각 작업은
자기 worktree에서 격리되어 돌아야 한다. **원본 체크아웃은 하나뿐이므로 그것을 공유하면
작업들이 서로를 망가뜨린다** — 브랜치 전환이 다른 작업의 편집 중인 파일을 덮고, 한쪽의
`flutter test`가 다른 쪽이 방금 고친 코드를 집어가고, `dart run build_runner`가 같은
`.dart_tool/build`를 두고 부딪힌다. 격리는 편의가 아니라 **동시 작업의 전제**다.

**Orca에서 구동되는 경우 worktree는 Orca가 만들고 관리한다.** 이미 그 안에 있으므로
새로 만들지 않고 그대로 쓴다. `EnterWorktree`를 다시 부르지 않는다.

**Orca를 거치지 않고 이 저장소에서 직접 시작하는 경우, 편집을 하기 전에 스스로
worktree를 만든다.** `EnterWorktree`로 만들고 그 안에서 작업한다. 이름은 아래 브랜치
규칙을 그대로 따른다(`feature/SPEC-0007-home-screen`). **원본 체크아웃은 항상 깨끗하게
비워 둔다** — 거기서 편집하면 그 순간 다른 작업이 못 들어온다.

예외는 격리가 의미 없는 경우뿐이다 — 읽기 전용 조사, 질문 답변, 이미 worktree 안인 세션.
사용자가 "여기서 바로 해"라고 하면 그 지시가 우선한다.

**브랜치를 따기 전에 반드시 `git fetch`부터 한다.** 로컬 `dev`는 낡아 있다고 가정한다 —
다른 작업이 이미 머지됐는데 로컬에 안 내려와 있으면, 그 위에서 만든 브랜치에는 앞선 작업이
통째로 빠진다. 그 상태로 같은 파일을 고치면 앞 작업을 되돌리는 커밋이 되고, 나중에 리베이스로
충돌을 다시 풀어야 한다.

```
git fetch origin
git log --oneline -3 origin/dev     # 로컬 dev와 다른지 확인
git switch -c feature/SPEC-0007-home-screen --no-track origin/dev
```

**분기 기준은 `origin/dev`이지 로컬 `dev`가 아니다.** worktree를 쓸 때도 같다 — EnterWorktree가
만든 브랜치가 낡은 기준에서 출발했다면 즉시 `origin/dev` 위로 옮긴다.

### `--no-track`이 붙은 이유 — 실제로 사고가 났다

**`git checkout -b <새브랜치> origin/dev`는 upstream을 `origin/dev`로 자동 설정한다.**
분기 기준을 준 것뿐인데 추적 대상까지 걸린다. 그러면 인자 없는 `git push` 한 번이
**작업 브랜치가 아니라 `dev`로 직행**하고, PR도 리뷰도 없이 보호 브랜치에 커밋이 쌓인다.

SPEC-0011에서 실제로 그렇게 됐다. 브랜치를 딸 때 출력에 `set up to track 'origin/dev'`가
찍혔는데 흘려봤고, 나중에 `origin/dev..HEAD`가 0으로 나왔을 때도 원인을 짚지 못했다 —
**브랜치를 갓 딴 직후가 아닌데 원격과 차이가 0이면 그 자체가 이상 신호다.**

그래서 두 가지를 지킨다:

1. **분기할 때 `--no-track`을 붙인다.** 기준으로 삼는 것과 추적하는 것은 다른 일이다.
2. **`git push`를 인자 없이 쓰지 않는다.** 항상 대상을 적어 어디로 가는지 명령에 드러낸다:

   ```
   git push -u origin feature/SPEC-0007-home-screen
   ```

이미 upstream이 잘못 걸린 브랜치는 `git branch --unset-upstream`으로 뗀다 — 커밋을
건드리지 않는 안전한 작업이다.

**`dev`·`master`에 직접 push하거나 머지하지 않는다.** 그건 사용자의 몫이고, 내 권한이
아니다(§12 커밋 항목과 같은 이유).

실제로 이걸 빠뜨려 SPEC-0007을 SPEC-0006이 빠진 코드 위에서 전부 구현한 적이 있다. 시작 전
`git fetch` 한 번이면 없었을 일이다.

**아직 머지되지 않은 앞 작업 위에서 이어야 한다면 `origin/dev`가 아니라 그 브랜치에서 딴다.**
`dev`에서 따면 앞 작업이 통째로 빠진 코드 위에서 만들게 되고, 나중에 같은 파일을 고쳤을 때
앞 작업을 되돌리는 커밋이 된다. 이 경우는 PR 본문에 **어느 브랜치 위에 쌓았는지** 적어 두어
리뷰어가 머지 순서를 알 수 있게 한다.

**Never work directly on a protected branch.** `master`, `main`, and `dev` are protected. Every
change — code, tests, specs — happens on a **topic branch** created first:

```
git switch -c feature/SPEC-0007-home-screen --no-track origin/dev
```

- `feature/SPEC-XXXX-<short-kebab-name>` is the **required convention** for spec-driven work.
  `fix/`, `hotfix/`, `chore/`, and `refactor/` take the same shape for their respective purposes.
- **The spec id belongs in the branch name; a step number does not.** SPEC-0007 is a permanent
  identifier shared by the spec, the issue, the working log, and the published post — carrying it
  in the branch makes the whole chain greppable from any one of them. A step number
  (`feature/step3-home-screen`) encodes a plan ordering that stops being true the moment the plan
  changes, which is why it stays out.
- Work with no spec behind it — a chore, a dependency bump, an experiment — uses
  `chore/<short-kebab-name>` with no id. Do not invent a spec id to satisfy the convention.
- This is enforced by the `require-feature-branch.sh` PreToolUse hook: while on a protected
  branch, `Edit`/`Write` and **git-mutating** Bash commands (`commit`/`merge`/`rebase`/`push`/…)
  are **blocked** (exit 2). Read-only git (`status`/`diff`/`log`) and `git checkout -b` /
  `git switch -c` / `git branch` are allowed so you can get onto a topic branch.
- When a task starts on a protected branch, create the topic branch **before** the first edit.
  The hook wins over this text — if it blocks you, switch branches, don't work around it.
- **커밋은 내가 한다.** `git commit`은 권한 정책에서 `allow`다(2026-08-10 사용자 결정 —
  그전에는 `deny`였고 메시지만 제안했다). 작업이 끝나면 스테이징하고 커밋까지 마친다.
  - **커밋 단위는 작업 단위다.** 한 커밋에 관련 없는 변경을 섞지 않는다 — 나중에 되돌릴 때
    같이 딸려 온다. 계층을 가로지르는 한 기능(model→view+테스트)은 한 커밋이 맞다.
  - **설계 문서(`problem/SPEC-*.md`)를 같은 커밋에 담는다**(§10) — 코드와 근거가 갈라지지
    않게.
  - `dev`·`master`에 직접 커밋하지 않는다. 그건 브랜치 훅이 막지만, 막히기 전에 내가
    지킨다.
- **`git push`도 할 수 있지만 대상을 명시한다**(`git push -u origin feature/...`). 인자 없는
  `git push`는 쓰지 않는다 — upstream이 잘못 걸려 있으면 보호 브랜치로 직행한다(§12).
- **머지와 PR 머지는 여전히 사용자 몫이다.** 커밋 권한이 생겼다고 그것까지 넘어온 것은 아니다.
- 브랜치 훅은 그와 별개인 독립 방어선이다.

---

## 13. Schema-first workflow (hook-enforced)

The GraphQL schema is the contract every operation and model is written against. Writing code against a guessed or stale schema is how operations drift from the server (a real hallucination happened: `signUp`/`login` were invented when the server actually has `registerEmailMember`/`loginEmail`). So **before authoring Dart code under `lib/`, refresh the live schema.**

- **The snapshot lives at `schema/schema.introspection.json`**, introspected from the running server (`http://localhost:8888/graphql`). It is a **per-session snapshot that changes over time — it is gitignored, never committed.**
- **The server blocks standard introspection** as `BadFaithIntrospection` (it rejects recursive `__Type.fields`). The hook sends the *flattened* introspection query (each of `fields`/`inputFields` referenced once) that passes.
- **Enforcement + auto-refresh:** the `require-fresh-schema.sh` PreToolUse hook gates `Edit`/`Write` on `lib/**.dart` (excluding generated `*.g.dart` / `*.graphql.dart`). If the snapshot is fresh (mtime within `SCHEMA_MAX_AGE_MIN`, default 10 min) and valid it passes immediately. If it is missing/stale/invalid, **the hook itself introspects the live server and rewrites the snapshot**, then passes — no manual step. The server is local-only, so this normally just works: keep it running. Only if the server is unreachable (or returns a non-schema) does the hook **block** and print the manual `! curl …` command to run. Specs, docs, tests, and ARBs are **not** gated. Override the endpoint with `GRAPHQL_INTROSPECT_URL` if the port changes.
- **codegen input vs. snapshot are different files.** `graphql_codegen` reads a committed SDL that lives beside the operations in the repository (e.g. `lib/domain/<feature>/repository/*_schema.graphql`); that is a stable, committed build input you update by hand from the introspection snapshot. The gitignored `schema/schema.introspection.json` is only the freshness/verification source — do not point codegen at it.

---