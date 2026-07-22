#!/usr/bin/env bash
# PreToolUse (Edit|Write): block layer/dependency-direction violations before the write lands.
# Exit 2 = block; stderr is surfaced to Claude as the reason.
# Data layer is GraphQL (graphql_flutter + graphql_codegen). The GraphQL client
# ("package:graphql" covers package:graphql and package:graphql_flutter) and
# generated operation types ("*.graphql.dart") must stay inside the repository.
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
case "$file_path" in *lib/*) ;; *) exit 0 ;; esac

body="$(printf '%s' "$content" | tr '\x01' '\n')"

fail() { echo "BLOCKED (layer rule): $1" >&2; echo "  file: $file_path" >&2; echo "  fix: $2" >&2; exit 2; }

# --- model purity ---
if [[ "$file_path" == *"/domain/"*"/model/"* ]]; then
  if grep -qE "package:(flutter|graphql|riverpod|flutter_riverpod|go_router)" <<<"$body"; then
    fail "model must be pure Dart" "remove flutter/graphql/riverpod/go_router imports; models hold no framework types"
  fi
  if grep -qE "/(repository|provider|view)/" <<<"$body"; then
    fail "model imports a higher layer" "models depend on nothing above them"
  fi
fi

# --- view / component must not touch the data layer ---
if [[ "$file_path" == *"/domain/"*"/view/"* || "$file_path" == *"/domain/"*"/component/"* ]]; then
  if grep -qE "/repository/|package:graphql|\.graphql\.dart" <<<"$body"; then
    fail "view/component imports the repository, the GraphQL client, or generated GraphQL types" "route data access through a provider; generated GraphQL types stay in the repository"
  fi
fi

# --- provider must not import view, the GraphQL client, or generated types ---
if [[ "$file_path" == *"/domain/"*"/provider/"* ]]; then
  if grep -qE "/view/|package:graphql|\.graphql\.dart" <<<"$body"; then
    fail "provider imports a view, the GraphQL client, or generated GraphQL types" "reach GraphQL only via the repository; providers don't import views or generated GraphQL types"
  fi
fi

# --- repository must not import material / provider / view ---
if [[ "$file_path" == *"/domain/"*"/repository/"* ]]; then
  if grep -qE "package:flutter/material|/provider/|/view/" <<<"$body"; then
    fail "repository imports material/provider/view" "repositories return models and depend only on model + common"
  fi
fi

# --- no cross-feature imports ---
current="$(sed -nE 's#.*/domain/([^/]+)/.*#\1#p' <<<"$file_path")"
if [[ -n "$current" ]]; then
  others="$(grep -oE "domain/[a-z0-9_]+/" <<<"$body" | sed -E 's#domain/([a-z0-9_]+)/#\1#' | sort -u | grep -v "^${current}$" || true)"
  if [[ -n "$others" ]]; then
    fail "cross-feature import ($current -> $(tr '\n' ' ' <<<"$others"))" "extract the shared code into lib/common/ instead of importing another feature"
  fi
fi

# --- local pagination re-implementation ---
if [[ "$file_path" == *"/domain/"* ]] && grep -qiE "class .*Pagination|nextCursor|hasMore|loadMore" <<<"$body"; then
  if ! grep -qE "common/pagination" <<<"$body"; then
    fail "pagination reimplemented inside a feature" "use common/pagination (PaginationListView / PaginationState)"
  fi
fi

exit 0
