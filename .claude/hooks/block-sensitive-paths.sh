#!/usr/bin/env bash
# PreToolUse (Read|Edit|Write): block access to secret/credential files. Exit 2 = block.
set -euo pipefail

payload="$(cat)"
file_path="$(python3 - "$payload" <<'PY'
import json, sys
d = json.loads(sys.argv[1])
ti = d.get("tool_input", {}) or {}
print(ti.get("file_path", "") or ti.get("path", "") or "")
PY
)"

[[ -z "$file_path" ]] && exit 0

# Sensitive patterns for a Flutter mobile project.
case "$file_path" in
  *.env|*.env.*|*.pem|*.p12|*.jks|*.keystore|*key.properties|\
  *google-services.json|*GoogleService-Info.plist|\
  *.mobileprovision|*upload-keystore*|*secrets*|*.secrets*)
    echo "BLOCKED (sensitive path): access to $file_path is not allowed." >&2
    echo "  These files hold signing keys / credentials. Keep them out of agent context." >&2
    exit 2
    ;;
esac

exit 0
