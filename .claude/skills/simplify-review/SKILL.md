---
name: simplify-review
description: Read-only review that flags unnecessary complexity and applies a Flutter-calibrated SOLID lens (mainly SRP and DIP) to a Flutter feature (CLAUDE.md §1.2, §1.3). Complexity is acceptable only when it is an architectural boundary. Use when reviewing code quality, design, and readability.
allowed-tools: Read, Glob, Grep
---

# Simplify review

Read-only. Enforces "simple is best" for the code itself (CLAUDE.md §1.2) and the
rule that structural complexity is allowed only when the architecture demands it
(§1.3). It also applies a SOLID lens — calibrated for a codebase that is mostly
widget composition and function-based providers, not deep class hierarchies.

## The one test for every abstraction
Ask: is this complexity backed by one of the architectural boundaries in
CLAUDE.md §3 (the layer split, the GraphQL-to-domain-model mapping at the
repository, common extraction)? If yes, it's the sanctioned exception and stays.
If no, flag it and describe the simpler, direct version.

## What to flag (complexity)
- Interfaces or abstract classes with a single implementation and no boundary
  reason behind them.
- Wrappers, "manager/helper/util" layers, or generic type parameters that add
  indirection without a boundary.
- Premature configurability — options, flags, or hooks nothing uses yet.
- Clever one-liners, deeply nested conditionals, or long chained expressions that
  need a second read to parse.
- Deep widget trees that should be extracted into a named component.
- GraphQL-to-model mapping that has grown heavier than the data it maps — mapping
  should be a thin, obvious translation, not a framework.
- The reverse smell: duplication that a small shared helper in `common/` removes.
- Comments that exist to explain why the code is complex — usually a sign to
  simplify the code, not to keep the comment.

## Readability bar
Could a mid-level Flutter developer understand each file in a single pass? If
not, name the exact spot and propose the simpler shape.

## How to report
Advisory by nature. Group findings under **Simplicity** and **SOLID**. For each:
the file and line, what is over-built or which principle is strained, and the
simpler version. If the code is already simple and direct, say so — do not
manufacture nits, and do not add abstractions just to satisfy a SOLID label.
