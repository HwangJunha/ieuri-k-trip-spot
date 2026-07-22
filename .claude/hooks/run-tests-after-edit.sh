#!/usr/bin/env bash
# PostToolUse (Edit|Write): run the test that corresponds to the edited lib file.
# Maps lib/domain/<feature>/<layer>/<name>.dart -> test/domain/<feature>/<layer>/<name>_test.dart
set -euo pipefail

payload="$(cat)"
file_path="$(python3 - "$payload" <<'PY'
import json, sys
d = json.loads(sys.argv[1])
ti = d.get("tool_input", {}) or {}
print(ti.get("file_path", "") or "")
PY
)"

case "$file_path" in *lib/*.dart) ;; *) exit 0 ;; esac
# Skip generated files.
case "$file_path" in *.g.dart|*.freezed.dart) exit 0 ;; esac

# Derive the matching test path.
rel="${file_path#*lib/}"                 # domain/spot/model/spot.dart
base="${rel%.dart}"                       # domain/spot/model/spot
test_path="test/${base}_test.dart"        # test/domain/spot/model/spot_test.dart

if [[ -f "$test_path" ]]; then
  if ! out="$(flutter test "$test_path" 2>&1)"; then
    echo "Tests failing for $test_path:" >&2
    echo "$out" | tail -n 40 >&2
    exit 2
  fi
else
  # No test yet — remind, but don't block here (block-stop enforces coverage at the end).
  echo "note: no test found at $test_path for the edited file." >&2
fi

exit 0
