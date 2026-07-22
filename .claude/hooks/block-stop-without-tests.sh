#!/usr/bin/env bash
# Stop hooks: if there are pending changes under lib/, the full test suite must pass
# before the session ends. Exit 2 forces Claude to keep working (fix/add tests).
set -euo pipefail

# Only relevant inside a git repo.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# Any uncommitted changes touching lib/ or test/?
changed="$(git status --porcelain -- lib test 2>/dev/null || true)"
[[ -z "$changed" ]] && exit 0

if ! out="$(flutter test 2>&1)"; then
  echo "Not done: lib/test changes are present but the test suite is failing." >&2
  echo "$out" | tail -n 30 >&2
  echo "Fix or add tests before finishing (CLAUDE.md §8)." >&2
  exit 2
fi

exit 0
