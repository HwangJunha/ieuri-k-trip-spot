---
name: layer-boundary-review
description: Read-only review of the domain-centric structure, layer boundaries, dependency direction, and GraphQL isolation for a Flutter feature (CLAUDE.md §2-§4). Use after a feature is built or edited to catch boundary violations before it's considered done. Reports findings; does not edit.
allowed-tools: Read, Glob, Grep
---

# Layer boundary review

Read-only. You report boundary violations with the exact file and line and the
fix. You never edit. Judge against the structure and dependency rules in
CLAUDE.md §2-§4.

## What to check

1. **Domain-centric structure.** Every feature lives under
   `lib/domain/<feature>/` with only the subfolders it needs (component, model,
   provider, repository, view). No feature logic has leaked to the top level,
   and nothing feature-specific is hiding in `common/`.

2. **Model purity.** Files in a `model/` layer are pure Dart — no Flutter, no
   GraphQL client, no Riverpod, no routing. A model that pulls in a framework
   type is not a model.

3. **Dependency direction (downward only).** Confirm each layer depends only on
   layers below it:
   - view and component read providers; they never reach into the repository or
     the GraphQL client directly.
   - provider depends on repository and model; it does not import views or the
     GraphQL client.
   - repository depends on model (and common/network, common/storage); it does
     not import providers, views, or Flutter widgets.

4. **GraphQL isolation.** The GraphQL client and any generated GraphQL operation
   types stay inside the repository layer (and common/network). They must not
   appear in provider, component, or view. The repository returns domain models
   from `model/`, not raw generated GraphQL types — so the transport schema
   never leaks into the UI.

5. **No cross-feature imports.** One feature must not import another feature's
   internals. Anything two features share belongs in `common/`. Cross-feature
   navigation goes through the router, not a direct import.

6. **Pagination is shared.** List features reuse `common/pagination`. Flag any
   feature that re-implements paging locally.

7. **Structural complexity must be justified.** If an abstraction, layer, or
   indirection exists that is not backed by one of the architectural boundaries
   above, flag it as unjustified complexity (CLAUDE.md §1.3) — the layered
   structure is the only sanctioned exception to "simple is best".

## How to report
Group findings as **Blocking** (breaks a hard boundary rule) versus **Advisory**
(borderline or stylistic). For each: the file and line, the rule it breaks, and
the concrete fix. If the boundaries are clean, say so plainly — don't invent
findings.
