---
name: e2e-flow-testing
description: Judgment criteria for Flutter e2e flow testing — how to select which journeys warrant e2e coverage, how to choose between tools, how to handle unstable tests, and how to interpret failures. Reference this when verification at the user-journey level is needed. Does not cover unit or widget test shape.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# E2E Flow Testing

E2E is expensive. It is slow, it needs a device, and it breaks easily. That makes **deciding what NOT to cover just as important as deciding what to cover.**

This document contains judgment criteria only. Write the actual test code to fit the situation.

## 1. What deserves e2e coverage

Do not attempt exhaustive coverage. Filter with a single question:

> **If this path breaks, can the user still use the app?**

Always cover:

- Authentication — login, token refresh, re-authentication after expiry, logout
- Permissions — whether the feature that depends on a permission actually works after the permission is granted
- Paths where data can be lost — create, update, delete
- Payment and anything involving money
- Cold start through to the first screen — if this breaks, nothing else matters

Do not cover:

- Rendering of a single widget
- Formatting, sorting, calculation logic
- State changes contained within one screen

Those belong to widget and unit tests, whose shape is governed by the `test-strategy` skill.

## 2. Write scenarios in the user's language

Do not describe a scenario using screen class names or provider names. Describe **who, trying to do what, taking which action, sees what result.**

- Bad: "verify that detailProvider updates on HomeScreen"
- Good: "a user who selects an item from the list can see its details"

One journey per test. Chaining several journeys together makes it hard to read where the break happened, and a failure in the first journey hides everything after it.

## 3. Tool selection

There is one criterion: **does the journey leave the Flutter widget tree?**

**integration_test** (bundled with the Flutter SDK) — for journeys that stay inside the widget tree. Navigation, form input, list retrieval, in-app state changes.

**patrol** — for journeys that cross into OS territory. Permission dialogs, system settings, notifications, social-login WebViews, camera and gallery, network toggles. integration_test cannot drive any of that, so here patrol is not a preference but a requirement.

In this project, **location permission** and **social login** are part of the core journeys, so design those two around patrol from the start. Patrol requires patrol_cli alongside it; widget tests continue to run under `flutter test`.

Do not add more tooling. If you hit something these two cannot handle, do not invent a workaround — propose it and get approval.

## 4. Element targeting

**Target by Key.** Do not locate elements by the text displayed on screen. A single copy change breaks it, and localization breaks it immediately.

If the widget you need has no Key, do not work around it with text or widget type — **add a Key to the production code.** This is the only case where e2e work may touch production code, and even then, record what was added and why in the report.

Name Keys consistently as `screen_role`. If every test invents its own convention, nobody will find anything later.

## 5. Waiting

**Never wait for a fixed duration.** This is the leading cause of unstable e2e tests. Three seconds is not enough on a slow day and wasted on a fast one.

- Wait on conditions — a widget appearing, disappearing, a response arriving
- After an animation or a screen transition, let frames settle before the next interaction
- Do not wait on a real network response without a bound. If the response never arrives, the test should fail rather than hang

## 6. Network and test data

Default to **controlled responses.** When an external API has an outage, the test goes red even though the code is fine — and once that happens repeatedly, nobody trusts the results anymore.

That said, **keep one smoke journey pointed at the real server.** If everything is stubbed, e2e will never catch a server contract that changed.

Whatever data a test creates, the test cleans up. A test that fails midway must not affect the next run.

## 7. State isolation

Every test starts from a point where **stored tokens, caches, and granted permissions are reset.**

- Do not depend on execution order between tests
- Permissions already granted on a real device change the outcome, so permission journeys must explicitly establish their starting state
- A journey that assumes a logged-in state must establish that state itself

## 8. Unstable tests

Run every new test **repeatedly and confirm it does not waver** before adopting it. Passing once is not passing.

If it wavers, **do not paper over it by raising the retry count.** The cause is almost always a violated waiting rule or a state isolation failure. Retries only hide the cause, and hidden instability is what makes you miss a real bug later.

If the cause cannot be found, quarantine it — but **never skip it silently.** Record the quarantine reason and suspected cause in a GitHub issue, and reference that issue from the test.

## 9. Interpreting failures

A report must not end at "the test failed." Every failure is one of three things, and determining which is part of the job.

- **Production bug** — the app genuinely misbehaves. Capture reproduction steps before anything is fixed. The fix belongs to whoever owns the implementation
- **Test bug** — the assertion or interaction order is wrong. Fix the test
- **Environment issue** — device, network, or build state. Fix neither the test nor the code

The report states which journey broke and where, what was expected versus what happened, how to reproduce it, and where the screenshots are.

## 10. Never do this

- Lower an assertion to make a test pass
- Skip or comment out a failing test and report completion
- Add test-only branches to production code
- Add meaningless journeys to hit a coverage number
- Report a pass for tests that never ran because no device was available

## Definition of done

- Every core journey defined in the requirements document passes
- New tests are stable across repeated runs
- Failed or quarantined items are captured as issues, each classified into one of the three failure categories
