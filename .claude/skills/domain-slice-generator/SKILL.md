---
name: domain-slice-generator
description: Procedure for scaffolding one new feature/domain under lib/domain/<feature>/ across the five layers (component, model, provider, repository, view) plus its tests. Use at the start of a new feature, before writing real logic. Rules live in CLAUDE.md; you write the code yourself from them.
allowed-tools: Read, Write, Bash
disable-model-invocation: true
---

# Domain slice generator

The _method_ for creating a feature's vertical slice. The _rules_ are in
CLAUDE.md (2–9); the _code_ you write yourself from those rules.

## When to use

- Starting a new feature that has a spec in `problem/<feature>.md`.
- Only create files that are missing; never overwrite an existing file.

## Procedure

**0. 시작 기준을 최신으로 맞춘다 (건너뛰지 않는다).**

```
git fetch origin
git log --oneline -3 origin/dev          # 로컬 dev와 다르면 로컬이 낡은 것이다
git checkout -b feature/SPEC-XXXX-<name> origin/dev
```

로컬 `dev`는 낡아 있다고 가정한다. 앞선 스펙이 이미 머지됐는데 안 내려와 있으면 그 위에서
만든 슬라이스에는 앞 작업이 통째로 빠지고, 같은 파일을 고치는 순간 앞 작업을 되돌리는
커밋이 된다. 나중에 리베이스로 충돌을 다시 푸는 비용이 `git fetch` 한 번보다 훨씬 크다.
worktree를 쓸 때도 같다 — 만들어진 브랜치가 낡은 기준이면 즉시 `origin/dev` 위로 옮긴다.

Take the feature name in `snake_case` (classes use its `PascalCase` form).
Read `problem/<feature>.md` first — it defines the model shape and screens.
Then create the slice bottom-up, each file obeying its layer's rules in
CLAUDE.md 3:

1. **model** — the domain model. Pure Dart (freezed / json_serializable); no
   flutter/dio/riverpod imports. Fields come from the spec.
2. **repository** — an abstract interface plus a Dio implementation that returns
   models. Secrets go through `common/storage`, HTTP through `common/network`.
3. **provider** — Riverpod 3 codegen (`@riverpod`, the unified `Ref`). Expose the
   repository via a provider so widgets never construct it; expose feature state
   as `AsyncValue`. Put parameters (e.g. an id) directly on the function —
   codegen makes the family, no `.family` modifier.
4. **component** — presentational widgets scoped to the feature; `const` where
   possible.
5. **view** — a `ConsumerWidget` (or `ConsumerStatefulWidget`) that reads
   providers only, never a repository or Dio directly.
6. **tests** — one per layer, in the shapes the `test-strategy` skill defines
   (model round-trip, repository with a mocked Dio, provider with a
   `ProviderContainer` + fake repository, widget test with provider overrides).

Then run, from the project root:

- `dart run build_runner build --delete-conflicting-outputs` (generates the
  freezed / riverpod parts)
- `dart format` and `dart analyze` on the new folders

## Don't

- Don't scaffold pagination — list features reuse `common/pagination`
  (`PaginationListView`, `PaginationState`).
- Don't create empty files for layers a feature doesn't need.
- Don't hand-write Riverpod boilerplate that codegen produces.
- Don't import another feature's internals — shared code goes to `common/`.

## Handoff

Report which files you created, then continue with `slice-builder` to fill in
the real logic from the spec. If the feature needs a design first, run
`ui-designer` (Stitch MCP) before this.
