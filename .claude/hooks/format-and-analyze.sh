#!/usr/bin/env bash
# PostToolUse (Edit|Write): auto-format and analyze the edited Dart file.
# Runs after the write. On analyzer errors, exit 2 surfaces them to Claude to fix.
set -euo pipefail

payload="$(cat)"
file_path="$(python3 - "$payload" <<'PY'
import json, sys
d = json.loads(sys.argv[1])
ti = d.get("tool_input", {}) or {}
print(ti.get("file_path", "") or "")
PY
)"

case "$file_path" in *.dart) ;; *) exit 0 ;; esac
[[ -f "$file_path" ]] || exit 0

# Format silently (non-fatal).
dart format "$file_path" >/dev/null 2>&1 || true

# Analyze just this file; block on errors so Claude fixes them before moving on.
if ! out="$(dart analyze "$file_path" 2>&1)"; then
  echo "Analyzer issues in $file_path:" >&2
  echo "$out" >&2
  exit 2
fi

exit 0
