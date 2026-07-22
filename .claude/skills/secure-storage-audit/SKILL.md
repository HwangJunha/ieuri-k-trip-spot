---
name: secure-storage-audit
description: Read-only security audit ensuring all tokens and secrets go through flutter_secure_storage via the common/storage wrapper, and never through SharedPreferences, plaintext, logs, or hardcoded constants (CLAUDE.md §7). Use when reviewing anything touching auth, tokens, or storage.
allowed-tools: Read, Glob, Grep
---

# Secure storage audit

Read-only. Enforces CLAUDE.md §7. Anything that mishandles a secret is
**Blocking**.

## What to check

1. **Single secure-storage entry point.** `flutter_secure_storage` is imported
   and used in exactly one place — the `common/storage` wrapper. Any use of it
   elsewhere is Blocking; route it through the wrapper.

2. **No secrets in plain storage.** Tokens, refresh tokens, or any secret must
   not be written to SharedPreferences, plaintext files, or any non-secure
   store. Blocking.

3. **No hardcoded secrets.** No token, API secret, or password baked into a Dart
   constant or committed file. Blocking.

4. **No token or PII logging.** No logging of tokens, auth headers, or personal
   data. GraphQL responses can contain PII — don't log full request/response
   payloads. Blocking.

5. **Auth at the GraphQL link.** The access token is attached to GraphQL requests
   by an auth link in `common/network` that reads the token from the
   `common/storage` wrapper — not scattered across repositories. Confirm the
   link reads from secure storage and that token refresh flows through one place,
   without a provider-to-client-to-provider cycle.

6. **Keys defined once.** Storage keys are constants in `common/storage`, not
   scattered string literals.

## How to report
List each finding as the file and line, the risk, and the fix. Every confirmed
secret-handling issue is **Blocking**. If secrets are correctly isolated to
`common/storage` and attached only via the auth link, say so.
