#!/usr/bin/env bash
# PreToolUse (Edit|Write): the vault is read-only in an implementation repo.
#
# **`problem/SPEC-*.md`는 이제 이 저장소에서 고칠 수 있다.** 구현하면서 요건이 바뀌는
# 일이 잦고, 그때마다 planner를 왕복하면 설계 문서가 코드보다 늘 뒤처진다. 요건 변경은
# 구현자가 문서에 바로 반영하고 같은 커밋에 남긴다.
#
# **정책은 여전히 recorder의 것이다.** Obsidian vault(스펙 원본·계약·정책 카탈로그·앱
# 레지스트리)는 계속 막는다 — 정책을 구현 저장소에서 고치면 여러 앱이 공유하는 규칙이
# 한 앱의 사정으로 조용히 갈라진다. 정책을 바꿔야 하면 `ieuri-recorder/problem/`에
# 요청 문서를 남긴다(CLAUDE.md §10).
#
# Blocked:  anything inside the Obsidian vault.
# Allowed:  everything under problem/ (SPEC-*.md 포함), and all source.
#
# Exit 2 = block; stderr is surfaced to Claude as the reason.
set -euo pipefail

payload=""
if [[ ! -t 0 ]]; then
  IFS= read -r -d '' -t 5 payload <&0 || true
fi

file_path="$(printf '%s' "$payload" \
  | python3 -c 'import json,sys; print((json.load(sys.stdin).get("tool_input",{}) or {}).get("file_path",""))' \
  2>/dev/null || echo '')"

[[ -z "$file_path" ]] && exit 0

base="$(basename "$file_path")"

block() {
  {
    echo "BLOCKED (planner-owned document): $file_path"
    echo
    echo "$1"
    echo
    echo "  정책·스펙 원본은 recorder가 소유한다. 여기서 고치지 말고 요청을 남긴다:"
    echo
    echo "    ieuri-recorder/problem/POLICY-<주제>.md"
    echo
    echo "  구현 저장소의 problem/SPEC-*.md는 자유롭게 고칠 수 있다 — 요건 변경은"
    echo "  구현자가 문서에 바로 반영한다."
  } >&2
  exit 2
}

# vault만 막는다 — specs, contracts, policy catalogue, app registry
if [[ -n "${IEURI_VAULT:-}" ]]; then
  vault="$(cd "$IEURI_VAULT" 2>/dev/null && pwd || echo "")"
  if [[ -n "$vault" ]]; then
    abs="$(cd "$(dirname "$file_path")" 2>/dev/null && pwd || echo "")/$base"
    case "$abs" in
      "$vault"/*)
        block "  The Obsidian vault belongs to the planner and recorder harnesses."
        ;;
    esac
  fi
fi

exit 0
