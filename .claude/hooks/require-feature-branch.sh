#!/usr/bin/env bash
# PreToolUse (Edit|Write|Bash): forbid working directly on a protected branch.
# All work must happen on a topic branch — feature/<name> (the standard), or one
# of fix/ hotfix/ chore/ refactor/. Editing files or running a git-mutating
# command while on master/main/dev is blocked.
# Exit 2 = block; stderr is surfaced to Claude as the reason.
set -euo pipefail

# Not a git repo → nothing to enforce.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '')"
# Detached HEAD or unknown → don't get in the way.
[[ -z "$branch" || "$branch" == "HEAD" ]] && exit 0

# Allowed topic-branch prefixes. feature/ is the required convention; the others
# are permitted for non-feature work.
case "$branch" in
  feature/*|fix/*|hotfix/*|chore/*|refactor/*) exit 0 ;;
esac

# On a protected/base branch. For Bash, only block git commands that MUTATE the
# branch (commit/merge/rebase/etc.) — read-only git and non-git commands are fine.
payload="$(cat)"
tool="$(printf '%s' "$payload" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_name",""))' 2>/dev/null || echo '')"

if [[ "$tool" == "Bash" ]]; then
  cmd="$(printf '%s' "$payload" | python3 -c 'import json,sys; print((json.load(sys.stdin).get("tool_input",{}) or {}).get("command",""))' 2>/dev/null || echo '')"
  # Allow branch creation/switching so Claude can get ONTO a feature branch.
  if grep -qE '\bgit[[:space:]]+(checkout[[:space:]]+-b|switch[[:space:]]+-c|branch)\b' <<<"$cmd"; then
    exit 0
  fi
  # Block only mutating git verbs.
  if grep -qE '\bgit[[:space:]]+(commit|merge|rebase|cherry-pick|revert|push|am|apply)\b' <<<"$cmd"; then
    :  # fall through to the block message
  else
    exit 0
  fi
fi

{
  echo "BLOCKED (branch policy): you are on protected branch '$branch'."
  echo "  All work must be on a topic branch — create one first:"
  echo "      git switch -c feature/<short-kebab-name> --no-track origin/dev"
  echo "  Convention: feature/ for new work (also allowed: fix/ hotfix/ chore/ refactor/)."
  echo "  --no-track가 중요하다: 빼면 upstream이 origin/dev로 잡혀, 인자 없는"
  echo "  git push 한 번이 작업 브랜치가 아니라 dev로 직행한다(CLAUDE.md §12)."
  echo "  Then re-run the edit/command. See CLAUDE.md §12 (Branch policy)."
} >&2
exit 2
