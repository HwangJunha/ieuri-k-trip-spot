#!/usr/bin/env bash
# PreToolUse (Edit|Write): block insecure handling of tokens/secrets. Exit 2 = block.
set -euo pipefail

payload="$(cat)"
read -r file_path content < <(python3 - "$payload" <<'PY'
import json, sys
d = json.loads(sys.argv[1])
ti = d.get("tool_input", {}) or {}
fp = ti.get("file_path", "") or ""
content = ti.get("content") or ti.get("new_string") or ""
print(fp, content.replace("\n", "\x01").replace("\t", " "))
PY
)

case "$file_path" in *.dart) ;; *) exit 0 ;; esac
body="$(printf '%s' "$content" | tr '\x01' '\n')"

fail() { echo "BLOCKED (security): $1" >&2; echo "  file: $file_path" >&2; echo "  fix: $2" >&2; exit 2; }

# flutter_secure_storage may only be imported inside common/storage/
if grep -qE "package:flutter_secure_storage" <<<"$body"; then
  if [[ "$file_path" != *"/common/storage/"* ]]; then
    fail "flutter_secure_storage imported outside common/storage" "access secrets only through common/storage/SecureStorage"
  fi
fi

# secrets must not be persisted via SharedPreferences / plaintext
if grep -qiE "SharedPreferences" <<<"$body" && grep -qiE "token|secret|refresh|password|apiKey" <<<"$body"; then
  fail "secret persisted via SharedPreferences" "store tokens/secrets in flutter_secure_storage (common/storage)"
fi

# hardcoded secrets
if grep -qiE "(token|secret|apiKey|password)\s*=\s*['\"][A-Za-z0-9_\-]{8,}['\"]" <<<"$body"; then
  fail "hardcoded secret literal" "load secrets from secure storage / env, never hardcode"
fi

exit 0
