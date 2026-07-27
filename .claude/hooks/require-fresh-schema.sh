#!/usr/bin/env bash
# PreToolUse (Edit|Write): before writing Dart code under lib/, require a FRESH,
# VALID GraphQL introspection snapshot at schema/schema.introspection.json.
#
# The schema is the contract every operation/model is written against; a stale
# or missing snapshot is how hand-written operations drift from the real server
# (see the signUp/login hallucination). This hook forces a re-introspection
# before code is authored. It CANNOT reach the server itself (curl is sandboxed
# and the server may be down), so it judges freshness by file mtime and checks
# the file actually holds a schema (not a BadFaithIntrospection error).
#
# Exit 2 = block; stderr is surfaced to Claude as the reason.
set -euo pipefail

# Max snapshot age in minutes before it's considered stale (override via env).
MAX_AGE_MIN="${SCHEMA_MAX_AGE_MIN:-10}"

root="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
snapshot="$root/schema/schema.introspection.json"

payload="$(cat)"
file_path="$(printf '%s' "$payload" | python3 -c 'import json,sys; print((json.load(sys.stdin).get("tool_input",{}) or {}).get("file_path",""))' 2>/dev/null || echo '')"

# Only gate Dart source under lib/. Specs, docs, tests, config, ARBs, and the
# snapshot itself are not blocked — you must be able to edit them freely.
case "$file_path" in
  */lib/*.dart|lib/*.dart) ;;
  *) exit 0 ;;
esac
# Never gate generated code (codegen writes *.g.dart / *.graphql.dart).
case "$file_path" in *.g.dart|*.graphql.dart) exit 0 ;; esac

block() {
  {
    echo "BLOCKED (schema freshness): $1"
    echo
    echo "  Refresh the live GraphQL schema before writing code, then retry:"
    echo "    ! curl -s -X POST http://localhost:8888/graphql \\"
    echo "        -H 'Content-Type: application/json' \\"
    echo "        -d @- > \"$root/schema/schema.introspection.json\" <<'EOF'"
    echo "    {\"query\":\"{ __schema { queryType { name } mutationType { name } types { kind name description enumValues { name } inputFields { name type { kind name ofType { kind name ofType { kind name ofType { kind name } } } } } fields { name args { name type { kind name ofType { kind name ofType { kind name ofType { kind name } } } } } type { kind name ofType { kind name ofType { kind name ofType { kind name } } } } } } } }\"}"
    echo "    EOF"
    echo
    echo "  (Standard introspection is blocked as BadFaithIntrospection; the query"
    echo "   above is the flattened form that passes. curl is sandboxed for me, so"
    echo "   run it in your terminal with the '!' prefix, then re-run the edit.)"
    echo "  See CLAUDE.md §13 (Schema-first workflow)."
  } >&2
  exit 2
}

# 1) Must exist.
[[ -f "$snapshot" ]] || block "no snapshot at schema/schema.introspection.json."

# 2) Must actually contain a schema, not an error response (e.g. BadFaith).
if ! grep -q '"__schema"' "$snapshot"; then
  block "snapshot exists but holds no __schema (likely a failed/errored introspection response)."
fi
if grep -q 'BadFaithIntrospection' "$snapshot"; then
  block "snapshot is a BadFaithIntrospection error, not a schema. Use the flattened query below."
fi

# 3) Must be fresh (mtime within MAX_AGE_MIN minutes).
if [[ -n "$(find "$snapshot" -mmin "+${MAX_AGE_MIN}" 2>/dev/null)" ]]; then
  block "snapshot is older than ${MAX_AGE_MIN} min — re-introspect to confirm the schema hasn't changed."
fi

exit 0
