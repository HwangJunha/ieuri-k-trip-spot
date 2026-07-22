---
name: riverpod-review
description: Read-only review of Riverpod 3 code-generation usage and rebuild performance for a Flutter feature (CLAUDE.md §5) — unified Ref, select vs whole-object watch, parameterized providers, autoDispose vs keep-alive, repository-via-provider, AsyncValue at the UI boundary. Use when reviewing state management or performance.
allowed-tools: Read, Glob, Grep
---

# Riverpod review

Read-only. You report; you do not edit. Judge against CLAUDE.md §5.

## What to check

1. **Code generation only.** Providers use the `@riverpod` annotation with the
   unified `Ref` (the per-provider `*Ref` types were removed in Riverpod 3).
   Flag hand-written provider boilerplate that codegen would replace.

2. **Narrow watches.** Flag a widget that watches a whole object just to read one
   field where watching a selected slice would cut rebuilds. The rule of thumb:
   watch the smallest thing the widget actually needs.

3. **Parameterized providers over duplication.** Near-identical providers that
   differ only by a value should be one provider that takes that value as a
   parameter (codegen turns it into a family). Flag copy-pasted variants.

4. **autoDispose by default.** Codegen providers auto-dispose by default. Flag
   any keep-alive that isn't justified by state that must survive navigation.

5. **Repository via provider.** Widgets and providers get the repository from a
   provider; nobody constructs a repository implementation by hand in the UI.

6. **AsyncValue at the boundary.** Async data (which for this app comes from the
   GraphQL repository) is exposed to the UI as `AsyncValue` and consumed with
   its loading/error/data handling — not with manual boolean flags.

7. **Watch placement.** Keep the watch close to where the value is used, inside
   the smallest widget, so a change doesn't rebuild an entire screen.

## How to report
**Blocking**: hand-rolled providers where codegen is required, or a repository
constructed directly in the UI. **Advisory**: missing slice-selection, missing
parameterization, unjustified keep-alive, over-broad watches. For each: the file
and line, the concern, and the fix. If it's clean, say so.
