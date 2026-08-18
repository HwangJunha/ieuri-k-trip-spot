# K-TripSpot — Flutter App Guide (CLAUDE.md)

> Real-time, location-based tourism app for foreign visitors to Korea.
> English-first UI, multilingual (EN/KO/JA/ZH). Built for the 2026 Korea Tourism Organization OpenAPI competition.

This file is the **operating contract** for this repository. When a hook and this file disagree, the hook wins — fix the code, not the rule.

**Do not assume a rule is machine-enforced.** Only two hooks are actually installed
(`block-sensitive-paths.sh`, `block-insecure-storage.sh`); everything else here is a convention you
uphold by hand. Sections that say otherwise are stale — see the note at the end of §13. Believing a
missing hook was watching your back is how two contract breaks reached `dev`.

---

## 0. Talking to the user

**Write to the user in Korean** — 존댓말, not 반말. Code, identifiers, and conventional commit
prefixes (`fix(auth):`) stay English; sentences addressed to the user are Korean, including every
question and option in AskUserQuestion.

**Close with what needs checking, nothing else.** Three things belong in a final summary: choices
you made unilaterally, things only the user can verify (on-device appearance), and what you left
out of scope with a one-line why. **If there is nothing to check, say so and stop** — "완료했습니다"
is enough. Changed-file lists, test counts, and step recaps appear only when asked; don't retype
tool output as prose.

Verification is the exception: **always report failures and skips.** Passing is one line. When
tests weren't run because you're mid-development (§8), report `flutter analyze` the same way.

**Before the PR — run each of these once, in order.** During development only `flutter analyze`
runs; everything else waits for this list, and nothing here runs twice.

1. `flutter analyze` — must be clean
2. `dart run build_runner build` if any `.graphql`/`@riverpod` source changed (§11.5)
3. **Live-server operation sweep** if any `.graphql` operation changed (§13) — codegen passing
   proves nothing about the server
4. `flutter test` — once (§8)
5. Update `problem/SPEC-*.md` with what you decided and what you could not verify (§10)

If a step is skipped or fails, say which and why. "Couldn't check the contract, server was down"
is a fine report; silence that lets a green build imply a checked contract is not.

---

## 1. Core principles (priority order)

1. **Domain-centric design.** Organized by feature, not by technical type at the top level. Each
   domain owns its full vertical slice.
2. **Simple code.** Clean, small, obvious. The boring solution. No cleverness, no premature abstraction.
3. **Structural complexity only where the architecture demands it.** The layering
   (component/model/provider/repository/view) may add structure — only that. Complexity not
   justified by an architectural boundary is a smell.
4. **Simple tests.** One behavior per test, minimal mocking, no framework gymnastics.
5. **Security is not optional.** Secrets go through `flutter_secure_storage` via the common wrapper.
6. **Performance via Riverpod.** `select`, `family`, `autoDispose`, `const` widgets.

Lower number wins: **domain boundaries beat brevity; brevity beats everything else.**

---

## 1.5 Working speed

Most wasted time in this repo is not thinking or building — it is **redoing work that failed the
first time**, and **verifying the wrong thing**. Both are avoidable.

**Bulk edits: one file at a time, with a real parser.** Shell one-liners over many files are where
this goes wrong — `sed` with an unquoted `$FILES` word-splits, `-i ''` differs between BSD and GNU,
and a regex that looks right silently matches nothing. Prefer a short Python script that asserts
what it expects (`assert old in s`) so a bad pattern fails loudly instead of writing garbage. Never
pipe `find` into `sed` across the tree; use `find -exec … +` or a script.

**Mechanical merges of Dart files will collide.** Two test files each defining `_load` or
`_container` produce `duplicate_definition`, and top-level declarations after `main()` land inside
it if you split on the wrong brace. Rename collisions *first*, extract `main()` by brace balance,
then merge — and re-run just that file to confirm the test count is unchanged.

**Check the cheap thing before the expensive one.** `flutter analyze` is ~4s; the suite is ~45s;
codegen is 5–20s. Run analyze after each edit, the others once (§8, §13). If you are about to run
something slow twice in a row, you probably do not know what you are looking for yet — go read the
code instead.

**Verify the claim you are actually making.** "Codegen passed" is not "the server accepts this"
(§13). "My diff is clean" is not "this branch works" — when something breaks, `git log -S` the
symbol and check `origin/dev` before assuming it is yours or is not. Scope the check to the claim,
then stop; repeating a check you already passed is not diligence.

**Say what you measured, not what you assume.** If a number varies run to run, give the range. If
the server was down, say the contract is unverified. A confident wrong report costs more than a
slow right one.

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
- A feature uses only the subfolders it needs; where present, they mean exactly what §3 says.
- `repository/` also holds `.graphql` operations, the committed `*_schema.graphql`, and the
  generated `*.graphql.dart`.
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

**Hard rules** (no hook enforces these — check them yourself; see the §13 note):
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

## 5. State management — Riverpod 3 (codegen)

- `@riverpod` / `riverpod_generator`. No hand-written `StateNotifierProvider` boilerplate.
- Async data uses generated `AsyncNotifier` / `FutureProvider`; expose `AsyncValue` to the UI.
- `ref.watch(provider.select((s) => s.field))` — never watch a whole object for one field.
- Parameterize (an `id` argument becomes a family) instead of duplicating providers.
- Prefer `autoDispose` (the codegen default); justify any keep-alive.
- Repositories are exposed via a provider; widgets never construct one.
- Use the unified `Ref` — the per-provider `*Ref` types were removed in Riverpod 3.
- Read providers via `Consumer`/`ConsumerWidget`, `ref.watch` close to where the value is used.

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

### 8. Testing

**Don't write or run tests while developing.** Requirements churn, and tests written alongside get
rewritten or thrown away twice over. `flutter analyze` is the build check during development.
**Done means the user said "작업 완료" — not your judgment.** One exception: if your change makes
an existing test false, fix it on the spot — that is cleaning up what you broke, not writing new
tests.

**Write tests and run the full suite exactly once, right before opening the PR.** Not after each
file, not to check your work as you go, not "one more time to be sure" — `flutter analyze` is the
during-development check and takes ~4s. The full suite takes 45–55s here, so running it six or
seven times across a task — as happened while writing this rule — costs more than the work did. If
that single run fails, fix and re-run **only what failed** (`flutter test <path>`), then run the
whole suite once more at the end — not per fix.

**Keep the suite cheap by writing fewer, bigger test files.** `flutter test` spawns an isolated VM
per file, so **file count — not test count — sets the runtime.** Measured on this repo: 215 view
tests in 21 files take 33s while 944 tests in 115 files take 37s, and ten small files cost about
the same as one 69-test file. Put every test for one subject in one file and separate concerns
with `group()`; splitting `swipe_controller_test` into consume/radius/retry-cap files buys nothing
and costs ~0.6s each.

Prefer the cheapest layer that can prove the behavior. A widget test that only checks a computed
string or a request payload belongs in `model`/`provider` — the same assertion at a fraction of
the cost.

One behavior per test. Minimal mocks. Arrange–Act–Assert.

| Layer | Test shape |
|---|---|
| `model` | Pure unit: serialization round-trip, equality, value logic. No mocks. |
| `repository` | Mocked GraphQL client/link. Assert the operation ran and mapped to the model. Include an `errors`-array case that surfaces as a failure. |
| `provider` | `ProviderContainer` with an overridden repository; assert emitted `AsyncValue` states. |
| `view` / `component` | Widget test with provider overrides; assert what the user sees, not internals. |

- Don't test framework or generated code. Elaborate setup means the code under test is too
  complex — simplify the code first.
- **New shared dependencies come with their own test fixes.** Adding a `watch` to a provider's
  `build()` imposes a new override on every test using it — watching locale, for instance,
  requires a `sharedPreferencesProvider` override and `TestWidgetsFlutterBinding.ensureInitialized()`.
  Whoever adds it cleans up the fallout; deleting someone else's broken test is not a fix.
- **e2e is an exception, not a step.** The four layers above own verification. Run e2e only when
  the user asks or when a core journey has none at all (add one journey), once per task; a second
  run only if flakiness was actually observed. Criteria: the `e2e-flow-testing` skill.

---

## 9. Code style

- **Effective Dart** + `flutter_lints`. The analyzer is authoritative.
- `const` wherever the analyzer allows. Extract a `component` when a widget passes a screenful
  or is reused.
- No dead code, no commented-out blocks, no `print`.
- **Comments are written in Korean** (`//` and `///`); code, identifiers, and API names stay English.

---

## 10. Specs & design

Requirements originate in the planner harness (`ieuri-planner`).

- **`problem/SPEC-XXXX-client.md`** (this repo) — the client design: screens, state transitions,
  navigation, which repository consumes which operation. Start here; the acceptance criteria in
  the linked spec are what provider and widget tests must satisfy. Meeting the design while
  missing an acceptance criterion is not done.
- **Commit it with the code.** The design is the entry point for implementation, so its history
  belongs beside the code's — including planner updates. A reviewer who can't see the file can't
  see the reasoning.
- **`docs/design/<name>.md`** — screen designs written by `ui-designer` from Stitch, read by
  `slice-builder` before it writes any `view/` or `component/`. Records layout, components (named
  to map onto `component/`), loading/empty/error states, and the Stitch screen id. It is a
  reference: where it conflicts with the spec's acceptance criteria, the spec wins.
- **`Specs/SPEC-XXXX/contract.graphql` is the planner's proposal; the server owns the schema.**
  Write operations against the live introspection snapshot (§13) — the proposal is what was
  asked for, the snapshot is what exists.
- One issue per repo per spec, opened by the planner. Branch naming: §12.

### When requirements change

Edit `problem/SPEC-XXXX-client.md` directly and commit it with the code, recording what changed
and why ("user decision", "server contract differed"). Patching code and leaving the doc stale is
the worst outcome — the next person trusts the doc and reverts you.

`Specs/SPEC-XXXX/spec.md` (Obsidian vault) stays read-only; a hook blocks it.

### Asking the server or a policy for something

**Two destinations, and the deciding factor is whether the work is finished.**

| Destination | When | What goes there |
|---|---|---|
| `problem/SPEC-XXXX-SERVER-<topic>.md` (this repo) | **while working** — the default | Anything you need from the server: a missing field, a wrong argument, a rule that doesn't fit |
| `ieuri-recorder/problem/SPEC-XXXX-POLICY-<topic>.md` | **only after the user says the task is done** | Cross-app policy changes (`POL-*`) that survived the whole implementation |

**Never write to `ieuri-recorder` mid-task.** It collects settled policy, not work in progress.
A request written halfway through is a guess: the next hour of implementation routinely
dissolves it, narrows it, or reveals that the real problem was elsewhere. Filing early means the
recorder arbitrates something that no longer exists, and withdrawing it costs more than waiting.

So while you are building, put every server-facing request in **this repo's `problem/`**, named
`SPEC-XXXX-SERVER-<topic>.md` (spec id first, so one spec's documents sort together). Commit it
with the code like any other design doc (§10) — a reviewer who can't see the request can't see
why the client works around something.

Head the file with the target operations, the environment you verified against, and a status line
(`상태: 요청 중` / `해소됨(날짜, 서버 PR)`). When the server resolves it, update that line in place
rather than deleting the file — the workaround in the code points at this document.

**Promoting to a policy request comes last.** After the user says 작업 완료, re-read what you
filed: if it turned out to be one spec's server gap, it stays here and nothing goes to the
recorder. Only a conflict with a shared `POL-*` — one that implementation confirmed rather than
merely suggested — becomes `ieuri-recorder/problem/SPEC-XXXX-POLICY-<topic>.md`.

Policies are shared across apps, so never fork one locally. A policy request covers four things:
which policy (number and wording), where it bit (which spec, which requirement), why the current
policy can't work, and a proposal with its cost. If another harness already filed on the same
spec, cite it instead of re-deriving, and withdraw yours if theirs is weaker-superseded — two
competing proposals leave the recorder unable to decide.
---

## 11. Subagent pipeline

`ui-designer` → `slice-builder` → `architecture-reviewer` Reviewers are
read-only: they report, `slice-builder` (or the parent) applies fixes. Each agent's own `.md`
defines its scope — don't restate it here.

- **`ui-designer` is required for any feature with UI**, and `slice-builder` reads `docs/design/`
  before writing any `view/` or `component/`. No design reference + UI in scope → stop and run
  `ui-designer` first. Skipping is allowed only when the change adds no screen and no component —
  say so explicitly rather than skipping silently.

**Don't delegate what fits in one file.** One or two files where you already know the fix → edit
directly; `slice-builder` rebuilds its whole context first, so its startup cost exceeds the edit.
A feature crossing layers (model→view+tests) → `slice-builder`. Broad investigation → Explore.
**Hand over what you already established** — live schema fields, measured values, root-cause
findings — and say to take them as given, or the agent re-runs the same introspection.

**Never read generated files.** `*.graphql.dart` and `*.g.dart` are permission-blocked; one
community operation is 500KB (~170k tokens). Read the operation source (`*.graphql`) and the
committed SDL (`*_schema.graphql`) — codegen already validated the output against the schema (§13).

---

### 11.5 When codegen hangs

`dart run build_runner build` takes 1–20s here. Longer means it is **stuck**, not slow. Judge by
output, not elapsed time — no progress lines at all means it never started.

- Run it in the foreground with `timeout 300`. Backgrounding leaves a lock behind when killed.
- Stuck → `dart run build_runner clean`, then rebuild. Deleting only
  `.dart_tool/build/lock/build_runner.lock` is not a fix: the corrupted asset_graph makes the
  next run hang in the same place.
- If `clean` fails, the next step is `rm -rf .dart_tool/build`, which is **denied by policy**.
  Ask the user to run it — do not route around a denied command with a similar one.

---

### 11.6 Stitch times out but keeps working

`mcp__stitch__generate_screen_from_text` routinely returns **"The operation timed out"** while the
screen is still being generated. **A timeout is not a failure**, and neither is an empty
`list_screens` right after one — generation lands minutes later. SPEC-0017 concluded "Stitch is
down" from four timeouts and hand-drew the mockups; all four had in fact succeeded.

- **Never retry on timeout.** Each retry queues *another* screen. The four SPEC-0017 calls produced
  four near-duplicate screens the user had to delete by hand.
- **Wait, then poll `list_screens`** (or `get_screen` if you captured the id). Minutes, not seconds
  — checking once at ~60s and again later is enough. Polling is free; regenerating is not.
- Report it as **pending, not failed.** If the session ends first, say the screens are still
  generating and name the project id so the next session can collect them — do not record
  "생성 실패" in a design doc, and do not substitute hand-authored mockups for a design that is
  merely late.
- Give the prompt the app's **real** structure, not DESIGN.md's original plan — the 5 tabs are
  Home/Map/Discover/Liked/Community, and the `Events`/`Chat` tabs in older mockups were never built.

`edit_screens` behaves differently from generation and is the right tool for a one-element tweak —
never regenerate a whole screen to add an icon.

- **Keep the edit prompt to the one thing you are changing.** A long prompt that re-describes every
  element to keep timed out; a two-sentence one succeeded instantly and returned the applied markup.
- After a successful edit, `get_screen` keeps returning the **previous** `htmlCode`/`screenshot` ids
  for a while — the render lags the DOM change. A stale id is not a failed edit; re-editing here
  just duplicates the change.

---

## 12. Branches & commits (convention — hook not installed, see §13 note)

**Every task runs in its own worktree.** Tasks run concurrently against one checkout, so
sharing it means a branch switch clobbers another task's edits and `build_runner` fights over
`.dart_tool/build`. Under Orca the worktree already exists — use it, don't call `EnterWorktree`
again. Starting here directly, create one before the first edit and leave the original checkout
clean. Exceptions: read-only investigation, answering questions, or the user says to work in place.

**Branch from `origin/dev`, never local `dev`** — assume local is stale; branching off it
silently drops already-merged work.
```
git fetch origin
git switch -c feature/SPEC-0007-home-screen --no-track origin/dev
git push -u origin feature/SPEC-0007-home-screen
```
- `--no-track` is required: without it a bare `git push` goes straight to `dev`. Never run
  `git push` without an explicit target. Unset a bad upstream with `git branch --unset-upstream`.
- Naming: `feature/SPEC-XXXX-<short-kebab>`; `fix/`, `hotfix/`, `chore/`, `refactor/` take the
  same shape. The spec id belongs in the branch name; a step number does not. Work with no spec
  uses `chore/<short-kebab>` — don't invent an id.
- To build on an unmerged branch, branch from *it*, and note the base in the PR body.
- `master`, `main`, `dev` are protected. `require-feature-branch.sh` *would* block `Edit`/`Write` and
  git-mutating Bash there; read-only git and branch creation stay open. Create the topic branch
  **before** the first edit.
- **Commit your own work.** One commit = one task, no unrelated changes. Include
  `problem/SPEC-*.md` in the same commit (§10).
- **Merging and PR merges are the user's**, committing and pushing are not.

---

## 13. Schema-first (convention — hook not installed, see note below)

Code written against a guessed schema drifts from the server — `signUp`/`login` were once
invented when the server has `registerEmailMember`/`loginEmail`.

- `require-fresh-schema.sh` gates `Edit`/`Write` on `lib/**.dart` (generated files excluded).
  Fresh snapshot (mtime within `SCHEMA_MAX_AGE_MIN`, default 10) → passes. Stale or missing →
  **the hook re-introspects and rewrites it**, then passes. Keep the local server running and this
  is invisible. Only an unreachable server blocks, printing the manual `! curl …` command.
  Specs, docs, tests, and ARBs are not gated. Override with `GRAPHQL_INTROSPECT_URL`.
- The snapshot is `schema/schema.introspection.json`, from `http://localhost:8888/graphql`.
  **Gitignored, never committed.** The server rejects recursive `__Type.fields` as
  `BadFaithIntrospection`; the hook sends a flattened query that passes.
- **Codegen reads a different file:** the committed SDL beside the operations
  (`lib/domain/<feature>/repository/*_schema.graphql`), updated by hand from the snapshot.
  Never point codegen at the gitignored snapshot.

**Codegen passing is NOT schema verification.** It validates operations against the *committed SDL*
— a file you hand-edit. Write the wrong thing in both places and the build is green while every
request fails at runtime. This has now happened twice: SPEC-0020 deleted the `intro`/`infoItems`
category argument the server still required (breaking the whole detail screen), and SPEC-0021
guessed `startConversation(memberId:)` when the server wanted `counterpartMemberId`.

**So: when you touch a `.graphql` operation, fire it at the live server before you call it done.**
Send the operation document with `operationName` and `variables: {}`; anything reported as
`ValidationError` is a real mismatch (ignore `coerced Null` — that is just the empty variables).
Auth errors mean the shape passed. One sweep over every operation document takes ~30s:

```sh
URL="${GRAPHQL_INTROSPECT_URL:-http://localhost:8888/graphql}"
# 서버 확인이 먼저다 — 죽어 있어도 아래 루프는 조용히 끝나 "불일치 0건"처럼 보인다.
curl -s -m 5 -o /dev/null "$URL" || { echo "server down — contract NOT verified"; exit 1; }
for f in lib/domain/*/repository/*_operations.graphql; do
  op=$(grep -m1 -oE '^(query|mutation|subscription) [A-Za-z_]+' "$f" | awk '{print $2}')
  jq -n --rawfile q "$f" --arg op "$op" '{query:$q, operationName:$op, variables:{}}' \
    | curl -s -m 25 -X POST "$URL" -H 'Content-Type: application/json' -d @- \
    | grep -o '"message":"Validation error[^"]*' | sed "s|^|$f: |"
done
```

Run it **once, before the PR**, alongside the test suite (§8) — not per edit. If the server is
down, say so and mark the contract as unverified in the spec doc; do not let a green build imply
a checked contract.

**The sweep does not catch a newly-required input field.** It sends `variables: {}`, so a missing
required argument comes back as `coerced Null` — exactly what you are told to ignore as noise. A
server that adds `resolved: Boolean!` to an existing input passes the sweep and fails at runtime.
That is how SPEC-0026 shipped a `resolveSpotQuestion` that could never succeed.

So after a clean sweep, **hand-send one payload per mutation whose input you touched** — literal
arguments, not `{}`. `UNAUTHENTICATED` means the shape passed; `WrongType … is missing required
fields '[x]'` means the input grew an argument you do not send:

```sh
jq -n '{query:"mutation P { resolveSpotQuestion(input:{questionId:\"1\"}) { success } }",variables:{}}' \
  | curl -s -m 15 -X POST "$URL" -H 'Content-Type: application/json' -d @-
```

Only the operations you changed — the sweep covers the rest.

> **Note (2026-08-16):** `require-fresh-schema.sh` and `require-feature-branch.sh` are referenced
> here and in §12 as hook-enforced, but **neither file exists and neither is registered** in
> `.claude/settings.json` — only `block-sensitive-paths.sh` and `block-insecure-storage.sh` run.
> Treat both sections as conventions you must follow by hand until the hooks are written. Assuming
> the snapshot auto-refreshes is exactly how the two contract breaks above got in.
---