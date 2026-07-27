# K-TripSpot — Flutter App Guide (CLAUDE.md)

> Real-time, location-based tourism app for foreign visitors to Korea.
> English-first UI, multilingual (EN/KO/JA/ZH). Built for the 2026 Korea Tourism Organization OpenAPI competition.

This file is the **operating contract** for this repository. Rules here are enforced by hooks (deterministic) and reviewed by subagents/skills (probabilistic). When a hook and this file disagree, the hook wins — fix the code, not the rule.

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

---

## 9. Code style

- Follow **Effective Dart** + `flutter_lints` (industry standard). The analyzer is authoritative.
- `const` constructors wherever the analyzer allows.
- Small widgets; extract a `component` when a widget grows past a screenful or is reused.
- No dead code, no commented-out blocks, no `print` in committed code.

---

## 10. Specs & design workflow

- **Feature specs live in `problem/*.md`.** Before implementing a feature, read its spec in `problem/`. The spec is the source of truth; if code and spec disagree, ask before diverging.
- **Design comes from Google Stitch via MCP.** When a screen needs a design, use the Stitch MCP tools (see the `ui-designer` subagent). Translate the Stitch output into `component/` and `view/` widgets that respect the layer rules above — do not paste generated markup that violates §3.

---

## 11. Standard workflow (subagent pipeline)

For a new feature, the intended flow mirrors the backend harness:

1. **(optional) `ui-designer`** — reads `problem/<feature>.md`, drives Stitch MCP to produce/refine the screen design, saves a design reference.
2. **`slice-builder`** — implements the full vertical slice for one feature: `model → repository → provider → component → view`, plus tests. Uses the `domain-slice-generator` skill to scaffold, then fills in logic.
3. **`architecture-reviewer`** (read-only) — verifies layer boundaries, dependency direction, GraphQL isolation, `common/` extraction, no cross-feature imports.
4. **`quality-reviewer`** (read-only) — verifies simplicity, test shape, Riverpod performance patterns, and secure-storage usage.

Reviews are read-only: they report, the parent agent (or `slice-builder`) applies fixes.

---

## 12. Branch policy (hook-enforced)

**Never work directly on a protected branch.** `master`, `main`, and `dev` are protected. Every change — code, tests, specs — happens on a **topic branch** created first:

```
git checkout -b feature/<short-kebab-name>
```

- `feature/<name>` is the **required convention** for new work. `fix/`, `hotfix/`, `chore/`, and `refactor/` prefixes are also accepted for their respective purposes.
- **Name the branch by the feature, never by a step number.** `feature/home-screen` — not `feature/step3-home-screen`. Step numbers live in the specs, not in branch names.
- This is enforced by the `require-feature-branch.sh` PreToolUse hook: while on a protected branch, `Edit`/`Write` and **git-mutating** Bash commands (`commit`/`merge`/`rebase`/`push`/…) are **blocked** (exit 2). Read-only git (`status`/`diff`/`log`) and `git checkout -b` / `git switch -c` / `git branch` are allowed so you can get onto a topic branch.
- When a task starts on a protected branch, create the topic branch **before** the first edit. The hook wins over this text — if it blocks you, switch branches, don't work around it.
- Commit/push remain gated by the permission policy (`ask`/`deny`); the branch hook is an additional, independent guard.

---

## 13. Schema-first workflow (hook-enforced)

The GraphQL schema is the contract every operation and model is written against. Writing code against a guessed or stale schema is how operations drift from the server (a real hallucination happened: `signUp`/`login` were invented when the server actually has `registerEmailMember`/`loginEmail`). So **before authoring Dart code under `lib/`, refresh the live schema.**

- **Refresh into `schema/schema.introspection.json`** by introspecting the running server (`http://localhost:8888/graphql`). This file is a **per-session snapshot that changes over time — it is gitignored, never committed.** Regenerate it each session (and whenever the server schema may have changed).
- **The server blocks standard introspection** as `BadFaithIntrospection` (it rejects recursive `__Type.fields`). Use the *flattened* introspection query (each of `fields`/`inputFields` referenced once) — the exact query is printed by the hook when it blocks. curl is sandboxed for the agent, so run it in the terminal with the `!` prefix.
- **Enforcement:** the `require-fresh-schema.sh` PreToolUse hook blocks `Edit`/`Write` on `lib/**.dart` (excluding generated `*.g.dart` / `*.graphql.dart`) unless the snapshot exists, actually contains a `__schema` (not an error response), and is fresh (mtime within `SCHEMA_MAX_AGE_MIN`, default 10 min). Specs, docs, tests, and ARBs are **not** gated. If blocked, re-introspect and retry — don't work around it.
- **codegen input vs. snapshot are different files.** `graphql_codegen` reads a committed SDL that lives beside the operations in the repository (e.g. `lib/domain/<feature>/repository/*_schema.graphql`); that is a stable, committed build input you update by hand from the introspection snapshot. The gitignored `schema/schema.introspection.json` is only the freshness/verification source — do not point codegen at it.

---