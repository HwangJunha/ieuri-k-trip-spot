#!/usr/bin/env bash
# .env의 값을 --dart-define으로 넘겨 앱을 실행한다.
#
#   ./scripts/run.sh                     # flutter run
#   ./scripts/run.sh -d <device-id>      # 인자는 그대로 전달된다
#   BUILD=1 ./scripts/run.sh apk         # flutter build apk
#
# .env는 커밋되지 않는다. 형식은 README의 "SNS 설정" 절을 본다.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT/.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "error: $ENV_FILE 가 없다. .env를 만들고 값을 채운다." >&2
  echo "필요한 키: GOOGLE_SERVER_CLIENT_ID, GOOGLE_IOS_CLIENT_ID, KAKAO_NATIVE_APP_KEY" >&2
  exit 1
fi

# .env를 읽어 KEY=VALUE 만 취한다. 주석과 빈 줄은 버리고, 값의 따옴표는 벗긴다.
defines=()
while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%$'\r'}"                      # CRLF 대비
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  [[ "$line" =~ ^[[:space:]]*$ ]] && continue
  [[ "$line" != *=* ]] && continue

  key="${line%%=*}"
  value="${line#*=}"
  key="$(printf '%s' "$key" | tr -d '[:space:]')"
  value="${value#"${value%%[![:space:]]*}"}"   # 앞 공백
  value="${value%"${value##*[![:space:]]}"}"   # 뒤 공백
  # 감싼 따옴표 한 겹 벗기기 — .env에 "..." 로 써도 값에 따옴표가 섞이지 않게 한다.
  if [[ "$value" == \"*\" && ${#value} -ge 2 ]]; then
    value="${value:1:${#value}-2}"
  elif [[ "$value" == \'*\' && ${#value} -ge 2 ]]; then
    value="${value:1:${#value}-2}"
  fi

  [[ -z "$value" ]] && continue             # 빈 값은 넘기지 않는다(SDK 기본 경로를 쓴다)
  defines+=("--dart-define=$key=$value")
done < "$ENV_FILE"

if [[ ${#defines[@]} -eq 0 ]]; then
  echo "warning: $ENV_FILE 에서 읽은 값이 없다. SNS 로그인이 동작하지 않을 수 있다." >&2
fi

cd "$ROOT"
if [[ -n "${BUILD:-}" ]]; then
  set -x
  exec flutter build "${@}" "${defines[@]}"
else
  set -x
  exec flutter run "${defines[@]}" "${@}"
fi
