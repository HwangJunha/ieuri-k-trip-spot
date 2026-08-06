#!/usr/bin/env bash
# Stop hooks: if there are pending changes under lib/, the full test suite must pass
# before the session ends. Exit 2 forces Claude to keep working (fix/add tests).
#
# **직전에 이미 통과했으면 다시 돌리지 않는다.** 전체 스위트는 ~19초이고 이 훅은
# 턴이 끝날 때마다 돈다 — 코드가 그대로인데 반복 실행하면 그 시간이 순수 낭비다.
# lib/test의 내용 지문을 남겨, 지문이 같으면 건너뛴다.
set -euo pipefail

# Only relevant inside a git repo.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# Any uncommitted changes touching lib/ or test/?
changed="$(git status --porcelain -- lib test 2>/dev/null || true)"
[[ -z "$changed" ]] && exit 0

# 지문은 **내용 해시**여야 한다. `git status --porcelain`은 "파일이 바뀌었다"까지만
# 알려 주므로, 그것만 쓰면 편집했다 되돌린 뒤에도 매번 다시 돌게 된다.
cache_dir="${TMPDIR:-/tmp}/ieuri-ktripspot-hooks"
mkdir -p "$cache_dir"
stamp_file="$cache_dir/last-green-suite"

fingerprint="$(
  {
    git ls-files -s -- lib test
    # 아직 add되지 않은 파일은 위 목록에 없다 — 경로와 내용 해시를 따로 더한다.
    git ls-files -o --exclude-standard -- lib test | while read -r f; do
      [[ -f "$f" ]] && shasum "$f"
    done
  } | shasum | awk '{print $1}'
)"

if [[ -f "$stamp_file" ]] && [[ "$(cat "$stamp_file")" == "$fingerprint" ]]; then
  exit 0
fi

if ! out="$(flutter test 2>&1)"; then
  echo "Not done: lib/test changes are present but the test suite is failing." >&2
  echo "$out" | tail -n 30 >&2
  echo "Fix or add tests before finishing (CLAUDE.md §8)." >&2
  # 실패는 기록하지 않는다 — 다음 턴에 반드시 다시 확인해야 한다.
  rm -f "$stamp_file"
  exit 2
fi

echo "$fingerprint" > "$stamp_file"
exit 0
