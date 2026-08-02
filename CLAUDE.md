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
"통과" 한 줄로 족하다.

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

One behavior per test. Minimal mocks. Arrange–Act–Assert. Per-layer shape:

| Layer | Test shape |
|---|---|
| `model` | Pure unit tests: serialization round-trip, equality, value logic. No mocks. |
| `repository` | Unit test with a **mocked GraphQL client/link**. Assert the operation ran and the response mapped to the model. Include an `errors`-array case that must surface as a failure. |
| `provider` | `ProviderContainer` with overridden repository; assert emitted `AsyncValue` states. |
| `view` / `component` | Widget test with provider overrides; assert what the user sees, not internals. |

- Do not test framework code or generated code.
- If a test needs elaborate setup, the code under test is probably too complex — simplify the code first.

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

### When the spec is wrong

**Do not fix it in code.** On hitting an uncovered case, a technical impossibility, or a needed
contract change:

1. Stop.
2. Comment on the issue: `[AMEND] SPEC-XXXX: <what you hit and why>`
3. Wait for the planner's `/amend`.

The deviation that feels too small to report is exactly the one that makes the spec unreliable.

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

---

## 12. Branch policy (hook-enforced)

**작업 단위는 worktree가 기본이다.** 여러 작업을 동시에 돌리기 때문에, 각 작업은 자기
worktree에서 격리되어 돌아야 한다. 한 체크아웃을 공유하면 브랜치 전환이 서로의 작업 중인
파일을 덮고, 한쪽의 `flutter test`가 다른 쪽이 방금 고친 코드를 집어간다.

작업을 시작할 때 **EnterWorktree로 worktree를 만든 뒤** 편집을 시작한다. 이름은 아래
브랜치 규칙을 그대로 따른다(`feature/SPEC-0007-home-screen`). Orca에서 구동되는 경우
worktree는 Orca가 관리하므로, 이미 worktree 안이라면 새로 만들지 않고 그대로 쓴다.

예외는 worktree가 의미 없는 경우뿐이다 — 읽기 전용 조사, 질문 답변, 이미 격리된 세션.
사용자가 "여기서 바로 해"라고 하면 그 지시가 우선한다.

**Never work directly on a protected branch.** `master`, `main`, and `dev` are protected. Every
change — code, tests, specs — happens on a **topic branch** created first:

```
git checkout -b feature/SPEC-0007-home-screen
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
- Commit/push remain gated by the permission policy (`ask`/`deny`); the branch hook is an
  additional, independent guard.

---

## 13. Schema-first workflow (hook-enforced)

The GraphQL schema is the contract every operation and model is written against. Writing code against a guessed or stale schema is how operations drift from the server (a real hallucination happened: `signUp`/`login` were invented when the server actually has `registerEmailMember`/`loginEmail`). So **before authoring Dart code under `lib/`, refresh the live schema.**

- **The snapshot lives at `schema/schema.introspection.json`**, introspected from the running server (`http://localhost:8888/graphql`). It is a **per-session snapshot that changes over time — it is gitignored, never committed.**
- **The server blocks standard introspection** as `BadFaithIntrospection` (it rejects recursive `__Type.fields`). The hook sends the *flattened* introspection query (each of `fields`/`inputFields` referenced once) that passes.
- **Enforcement + auto-refresh:** the `require-fresh-schema.sh` PreToolUse hook gates `Edit`/`Write` on `lib/**.dart` (excluding generated `*.g.dart` / `*.graphql.dart`). If the snapshot is fresh (mtime within `SCHEMA_MAX_AGE_MIN`, default 10 min) and valid it passes immediately. If it is missing/stale/invalid, **the hook itself introspects the live server and rewrites the snapshot**, then passes — no manual step. The server is local-only, so this normally just works: keep it running. Only if the server is unreachable (or returns a non-schema) does the hook **block** and print the manual `! curl …` command to run. Specs, docs, tests, and ARBs are **not** gated. Override the endpoint with `GRAPHQL_INTROSPECT_URL` if the port changes.
- **codegen input vs. snapshot are different files.** `graphql_codegen` reads a committed SDL that lives beside the operations in the repository (e.g. `lib/domain/<feature>/repository/*_schema.graphql`); that is a stable, committed build input you update by hand from the introspection snapshot. The gitignored `schema/schema.introspection.json` is only the freshness/verification source — do not point codegen at it.

---