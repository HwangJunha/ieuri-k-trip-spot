<!--
A template. Copy it to `problem/SPEC-XXXX-client.md` when a spec starts, then fill it in.
Don't edit the template in passing — change it together with CLAUDE.md §10.

This repo is the author. The planner supplies requirements and does not hand down screen
composition; deciding the entry point and how many screens exist is why this document exists.
-->

# SPEC-XXXX — Client design

## Requirements this design answers

(Reference only the FR/QR/BR **ids** from `spec.md` that constrain this design. Don't copy the
sentences — a copy doesn't follow the spec when the spec is corrected, and becomes a stale fact.)

## Entry points

| Requirement | Which screen | Which widget | What is added |
|---|---|---|---|
| FR-012 | `lib/domain/tourism/view/spot_detail_view.dart` | below the photo carousel | booking button row |

Write real file paths and widget names. "On the spot detail screen" is not an entry point.

**If no FR in `spec.md` requires reachability, stop here and ask the user** — there is no place to
attach a screen (CLAUDE.md §10, "Reachability is a requirement").

## Decisions

| # | Decision | Rationale | Alternative rejected, and why |
|---|---|---|---|
| D-01 | | | |

## Missing information

(Write "none" if there is none. **If this section is not empty, do not start implementing** — ask
the user directly, CLAUDE.md §10.)

## Scale assumptions

(For each item `spec.md` left as `미정` that **affects a screen**, fill in the value here and get
it approved. Write the approved value back into `spec.md` — but check first whether the server
already filled that field, and don't overwrite it if so.)

## Slices

| # | Acceptance criterion | Status |
|---|---|---|
| S1 | AC-001 | |

**One slice = one acceptance criterion = one branch.** When a slice is done, stop and leave a
place for a person to check it — don't roll on into the next one.

## Not in this scope

(What is deferred to a later slice. This is the guard against pre-built extension points and
screens nobody asked for: when `architecture-reviewer`'s reverse mapping reports `(none)`, it is
checked against this list.)

## Screens and states

(The states each screen can be in, and the transitions between them. Include loading, empty,
error, and denied.)

## Change history

| Date | Change | Why |
|---|---|---|
