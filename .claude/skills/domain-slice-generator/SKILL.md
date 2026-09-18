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

- Starting a slice whose design is in `problem/SPEC-XXXX-client.md` (written by
  this repo — see CLAUDE.md §10). One slice = one acceptance criterion.
- Only create files that are missing; never overwrite an existing file.

## Procedure

**0. Start from an up-to-date base (don't skip this).**

```
git fetch origin
git log --oneline -3 origin/dev          # differs from local dev? local is the stale one
git checkout -b feature/SPEC-XXXX-<name> origin/dev
```

Assume local `dev` is stale. If an earlier spec was merged and you don't have it, the slice you
build on top of it is missing that work entirely — and the moment you touch the same file, your
commit reverts it. Re-resolving those conflicts in a later rebase costs far more than one
`git fetch`. The same holds in a worktree: if the branch it created sits on a stale base, move it
onto `origin/dev` right away.

Take the feature name in `snake_case` (classes use its `PascalCase` form).
Read `problem/SPEC-XXXX-client.md` first — it defines the entry point, the model
shape, and the screens for this slice.
Then create the slice bottom-up, each file obeying its layer's rules in
CLAUDE.md 3:

1. **model** — the domain model. Pure Dart (freezed / json_serializable); no
   flutter/GraphQL/riverpod imports. Fields come from the spec.
2. **repository** — an abstract interface plus a GraphQL implementation that
   returns models. The `graphql_flutter` client and the generated
   `*.graphql.dart` types stay inside the repository. Secrets go through
   `common/storage`, the client through `common/network`.
3. **provider** — Riverpod 3 codegen (`@riverpod`, the unified `Ref`). Expose the
   repository via a provider so widgets never construct it; expose feature state
   as `AsyncValue`. Put parameters (e.g. an id) directly on the function —
   codegen makes the family, no `.family` modifier.
4. **component** — presentational widgets scoped to the feature; `const` where
   possible.
5. **view** — a `ConsumerWidget` (or `ConsumerStatefulWidget`) that reads
   providers only, never a repository or the GraphQL client directly.
6. **tests** — one per layer, in the shapes the `test-strategy` skill defines
   (model round-trip, repository with a mocked GraphQL client — including an
   `errors`-array failure case, provider with a `ProviderContainer` + fake
   repository).

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
the real logic for this slice's acceptance criterion. If the feature needs a design first, run
`ui-designer` (Stitch MCP) before this.
