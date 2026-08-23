# SPEC-0031 SERVER — 없는 공유 토큰이 INTERNAL_ERROR 로 온다

- 대상 오퍼레이션: `query SharedMap($token: String!)` (`sharedMap(token:)`)
- 확인 환경: `http://localhost:8888/graphql` (2026-08-24)
- 상태: 요청 중

## 무엇이 문제인가

**유효한 토큰은 정상 동작한다.** 존재하지 않는 토큰일 때 명세와 다른 오류 코드가 온다.

```sh
URL=http://localhost:8888/graphql
jq -n '{query:"query S($t: String!) { sharedMap(token:$t) { ownerNickname visitedCount } }",
        variables:{t:"definitely-not-a-real-token-xxxx"}}' \
  | curl -s -X POST "$URL" -H 'Content-Type: application/json' -d @- \
  | jq -r '.errors[0].extensions.code'
# INTERNAL_ERROR   ← 기대: SHARE_LINK_NOT_FOUND
```

커밋된 SDL 의 주석은 이렇게 적고 있다(`national_map_schema.graphql:28-29`).

```graphql
# 공유 링크 조회. 인증 없이 열린다.
# 오류: SHARE_LINK_NOT_FOUND(없거나 폐기됨) · SHARE_LINK_BLOCKED(차단).
sharedMap(token: String!): SharedMap!
```

## 왜 문제인가

클라이언트는 오류 코드로 화면을 가른다 — 없는 링크는 "만료되었거나 삭제된
링크"라고 말해 줘야 하고, `INTERNAL_ERROR` 는 "잠시 후 다시 시도"로 안내한다.
지금은 폐기된 링크를 연 사용자가 재시도만 반복하게 된다.

## 요청

없는·폐기된 토큰은 `SHARE_LINK_NOT_FOUND`, 차단된 링크는 `SHARE_LINK_BLOCKED`
로 내려 주세요. 유효한 토큰의 응답은 지금 그대로면 됩니다.

## 클라이언트 쪽 상태

공유 링크로 앱이 열리는 경로를 고쳤다(`lib/router/deep_link_parser.dart`).
`ktripspot://tour/korea-map/<token>` 이 라우트에 걸리지 않아 Page Not Found 가
뜨던 문제였고, 지금은 공유 지도 화면이 정상적으로 열린다.
