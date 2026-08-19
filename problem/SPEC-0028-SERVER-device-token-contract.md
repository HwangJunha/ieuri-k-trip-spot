# SPEC-0028 — 기기 토큰 계약 확인 요청

대상 오퍼레이션
- `Mutation.registerDeviceToken(input: RegisterDeviceTokenInput!)`
- `Mutation.deleteDeviceToken(input: DeleteDeviceTokenInput!)`
- `Mutation.updateNotificationPreference(input: UpdateNotificationPreferenceInput!)`
- `Me.notificationPreferences: [NotificationPreference!]!`

검증 환경: `http://localhost:8888/graphql` — **작업 내내 응답 없음(`http_code=000`)**

상태: 요청 중

## 무엇을 확인하지 못했나

클라이언트 배선(S2)을 전부 만들었으나 **네 연산 중 어느 것도 라이브 서버에 쏴 보지
못했다.** 서버가 떠 있지 않아 §13의 sweep이 돌지 않았다.

codegen은 통과했지만 그것은 커밋된 SDL 조각(`lib/domain/alarm/repository/alarm_schema.graphql`)
에 대한 검증일 뿐이고, 그 조각은 `Specs/SPEC-0028/contract.graphql` 초안을 보고 손으로
쓴 것이다. CLAUDE.md §13이 경고하는 상황 그대로다 — 양쪽에 같은 오해를 적으면 빌드는
초록인데 런타임에 전부 실패한다.

## 확인이 필요한 것

1. **S1이 배포됐는가.** 스펙의 전달 순서상 서버의 토큰 계약이 먼저인데, 실제로 나갔는지
   알 수 없다. 아직이면 클라이언트는 이 상태로 대기한다 — 등록이 실패해도 조용히
   실패하므로(R12) 앱은 정상 동작한다
2. **인자 이름이 계약대로인가.** SPEC-0021이 `startConversation(memberId:)`로 썼다가
   서버가 `counterpartMemberId`였던 선례가 있다. 특히 `RegisterDeviceTokenInput`의
   네 필드(`deviceId`·`fcmToken`·`language`·`platform`)를 확인해 주면 좋겠다
3. **`Locale` enum을 그대로 쓰는가.** 계약 §재사용은 tourism 스키마의 `Locale`
   (EN/KO/JA/ZH)을 기기 언어에 재사용한다고 했다. 클라이언트 조각에는 이 enum을 선언한
   곳이 없어 alarm 조각에서 새로 선언했는데, 서버 것과 값이 같은지 확인이 필요하다
4. **payload가 `BaseResponse`를 구현하는가.** 계약에는 `implements BaseResponse`가
   붙어 있으나 클라이언트 SDL에는 그 인터페이스가 없어 평범한 타입으로 뒀다. 응답
   형태가 같으면 문제없지만, 인터페이스가 필드를 강제한다면 알려 주면 좋겠다
5. **입력에 필수 필드가 더 있는가.** §13이 지적하듯 sweep은 `variables: {}`를 보내
   새로 생긴 필수 인자를 잡지 못한다. SPEC-0026의 `resolveSpotQuestion`이 그렇게
   새어 나갔다. 서버가 뜨면 리터럴 인자로 한 번씩 쏴 확인할 예정이다

## 서버가 뜨면 클라이언트가 할 일

```sh
URL=http://localhost:8888/graphql
# 1) sweep — 오퍼레이션 문서 검증
# 2) 리터럴 인자로 뮤테이션 3종 개별 확인(UNAUTHENTICATED면 형태 통과)
jq -n '{query:"mutation P { registerDeviceToken(input:{deviceId:\"d\",fcmToken:\"t\",language:EN,platform:ANDROID}) { success } }"}' \
  | curl -s -m 15 -X POST "$URL" -H 'Content-Type: application/json' -d @-
```

불일치가 나오면 `alarm_schema.graphql`과 `alarm_operations.graphql`을 고치고 codegen을
다시 돌린다. repository 밖으로 생성 타입이 나가지 않으므로 수정 범위는
`alarm_repository_impl.dart` 안에서 끝난다.
