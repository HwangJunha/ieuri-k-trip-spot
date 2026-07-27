#!/usr/bin/env bash
# PreToolUse (Edit|Write): before writing Dart code under lib/, ensure a FRESH,
# VALID GraphQL introspection snapshot at schema/schema.introspection.json.
#
# The schema is the contract every operation/model is written against; a stale
# or missing snapshot is how hand-written operations drift from the real server
# (see the signUp/login hallucination). This hook keeps the snapshot current by
# introspecting the live server ITSELF when the snapshot is missing/stale/invalid
# — the server is local-only (http://localhost:8888/graphql), so a fetch from
# here is expected to work.
#
# Flow:
#   - snapshot fresh + valid           -> pass (no re-fetch)
#   - snapshot missing/stale/invalid   -> curl the server, save, validate
#       fetch ok  (has __schema, not BadFaith) -> save + pass
#       fetch fail (server down / network / BadFaith) -> block with guidance
#
# Standard introspection is rejected as BadFaithIntrospection, so we send the
# FLATTENED query (each of fields/inputFields referenced once) that passes.
#
# Exit 2 = block; stderr is surfaced to Claude as the reason.
set -euo pipefail

# Max snapshot age in minutes before it's considered stale (override via env).
MAX_AGE_MIN="${SCHEMA_MAX_AGE_MIN:-10}"
# GraphQL endpoint (local-only). Override via env if the port ever changes.
GRAPHQL_URL="${GRAPHQL_INTROSPECT_URL:-http://localhost:8888/graphql}"
# curl timeout so a down server never hangs the edit for long.
CURL_TIMEOUT="${SCHEMA_CURL_TIMEOUT:-8}"

root="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
snapshot="$root/schema/schema.introspection.json"

# The flattened introspection query the server accepts (fields/inputFields each
# referenced once — the recursive standard query trips BadFaithIntrospection).
read -r -d '' INTROSPECT_QUERY <<'EOF' || true
{"query":"{ __schema { queryType { name } mutationType { name } types { kind name description enumValues { name } inputFields { name type { kind name ofType { kind name ofType { kind name ofType { kind name } } } } } fields { name args { name type { kind name ofType { kind name ofType { kind name ofType { kind name } } } } } type { kind name ofType { kind name ofType { kind name ofType { kind name } } } } } } } }"}
EOF

# Read the Claude Code hook payload from stdin. Runnable by hand too: if stdin
# is a terminal (someone ran the script directly) there is no payload, so DON'T
# block waiting on `cat` — treat it as "no file_path". If stdin is a pipe but
# empty/slow, a short read timeout still prevents a hang. Either way the script
# always terminates with a clear result, no matter who runs it or how.
payload=""
if [[ ! -t 0 ]]; then
  # stdin is a pipe/file, not a tty. Read it, but never block forever.
  IFS= read -r -d '' -t 5 payload <&0 || true
fi
file_path="$(printf '%s' "$payload" | python3 -c 'import json,sys; print((json.load(sys.stdin).get("tool_input",{}) or {}).get("file_path",""))' 2>/dev/null || echo '')"

# Gate only Dart source under lib/ (the hook's job as a PreToolUse guard).
# Generated code and everything outside lib/ are never gated.
# When there is NO file_path (run by hand, or a non-Edit tool), we skip the
# gate but still fall through to the freshness check + auto-refresh below, so
# running this script directly is a useful "ensure the snapshot is current".
gate=1
case "$file_path" in
  */lib/*.dart|lib/*.dart) gate=1 ;;
  "") gate=0 ;;            # no payload → refresh-only mode, never block
  *) exit 0 ;;            # editing something outside lib/ → nothing to do
esac
case "$file_path" in *.g.dart|*.graphql.dart) exit 0 ;; esac

# A snapshot is usable if it exists, holds a real __schema (not a BadFaith
# error), and is younger than MAX_AGE_MIN minutes.
snapshot_valid() {
  [[ -f "$snapshot" ]] || return 1
  grep -q '"__schema"' "$snapshot" || return 1
  grep -q 'BadFaithIntrospection' "$snapshot" && return 1
  [[ -z "$(find "$snapshot" -mmin "+${MAX_AGE_MIN}" 2>/dev/null)" ]] || return 1
  return 0
}

# Fast path: current snapshot is fresh + valid, nothing to do.
if snapshot_valid; then
  exit 0
fi

# Report a failed refresh. In gate mode (a real Edit/Write hook call) exit 2 so
# Claude Code blocks the edit. In refresh-only mode (run by hand) exit 1: it's a
# failure to report, but there is no edit to block.
block() {
  {
    if [[ "$gate" == "1" ]]; then
      echo "BLOCKED (schema freshness): $1"
    else
      echo "schema refresh FAILED: $1"
    fi
    echo
    echo "  Tried to refresh the snapshot from $GRAPHQL_URL and failed."
    echo "  Start the local GraphQL server (reachable at $GRAPHQL_URL), then retry."
    echo "  To refresh manually:"
    echo "    curl -s -X POST $GRAPHQL_URL \\"
    echo "        -H 'Content-Type: application/json' \\"
    echo "        -d @- > \"$snapshot\" <<'EOF'"
    echo "    $INTROSPECT_QUERY"
    echo "    EOF"
    echo
    echo "  (Standard introspection is blocked as BadFaithIntrospection; the query"
    echo "   above is the flattened form that passes.)"
    echo "  See CLAUDE.md §13 (Schema-first workflow)."
  } >&2
  [[ "$gate" == "1" ]] && exit 2 || exit 1
}

# Snapshot is missing/stale/invalid: fetch it from the live server ourselves.
mkdir -p "$root/schema"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

# curl prints the 3-digit code (000 when it can't connect) and exits non-zero on
# failure; `|| true` keeps `set -e` from aborting so we can inspect the code.
http_code="$(
  curl -s -o "$tmp" -w '%{http_code}' \
    --max-time "$CURL_TIMEOUT" \
    -X POST "$GRAPHQL_URL" \
    -H 'Content-Type: application/json' \
    -d "$INTROSPECT_QUERY" 2>/dev/null || true
)"
http_code="${http_code:-000}"

# 000 = curl couldn't reach the server (down / network / sandbox).
if [[ "$http_code" == "000" ]]; then
  block "could not reach the server at $GRAPHQL_URL (curl failed — is it running?)."
fi
if [[ ! -s "$tmp" ]]; then
  block "server returned an empty response (HTTP $http_code)."
fi
if grep -q 'BadFaithIntrospection' "$tmp"; then
  block "server rejected introspection as BadFaithIntrospection (unexpected — the query is flattened)."
fi
if ! grep -q '"__schema"' "$tmp"; then
  block "server response holds no __schema (HTTP $http_code — likely an error payload)."
fi

# Valid schema fetched — commit it as the new snapshot.
mv "$tmp" "$snapshot"
trap - EXIT
echo "require-fresh-schema: refreshed snapshot from $GRAPHQL_URL (HTTP $http_code)." >&2
exit 0
