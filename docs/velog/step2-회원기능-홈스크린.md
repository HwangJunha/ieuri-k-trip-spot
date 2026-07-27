---
title: "[K-Trip Spot] Flutter로 외국인 관광앱 만들기 #2 — 이메일 인증·홈 스크린, 그리고 AI가 지어낸 GraphQL 스키마 잡기"
tags: [Flutter, Riverpod, GraphQL, graphql_codegen, 인증, 할루시네이션, ClaudeCode, 훅]
---

> 2026 한국관광공사 OpenAPI 공모전을 목표로 만드는 외국인 관광 앱 **K-Trip Spot**의 두 번째 기록.
> [#1(테마·다국어·온보딩 기반)](https://velog.io)에 이어, 이번엔 **이메일 인증 회원 기능**과 **홈 스크린**을 붙였다.
> 그런데 이 글의 진짜 주제는 따로 있다 — **AI 코딩 에이전트가 존재하지도 않는 GraphQL API를 지어냈고, 그걸 어떻게 잡고 재발을 막았는가.**

---

## 이번 스텝에서 만든 것

- **이메일 회원 기능**: 회원가입 → 이메일 인증 → 로그인 → 자동 로그인(토큰 갱신) → 로그아웃 → 비밀번호 재설정
- **홈 스크린**: 추천/행사/인기 spot 3개 섹션 + 하단 5탭 플로팅 내비게이션
- **하네스(훅)**: 브랜치 정책 + "스키마 먼저 확인" 강제

`flutter analyze` 무결점, `flutter test` 67개 통과. 하지만 여기까지 오는 길에 한 번 크게 헛디뎠다.

---

## 사건: AI가 `signUp`/`login`을 지어냈다

회원 기능을 시작할 때 서버는 이미 `localhost:8888/graphql`에 떠 있었다. 나는 에이전트에게 "이메일 회원가입·로그인을 만들라"고 시켰고, 결과물은 그럴듯했다.

```graphql
mutation SignUp($email: String!, $password: String!) {
  signUp(input: { email: $email, password: $password }) { ... }
}
mutation Login($email: String!, $password: String!) {
  login(input: { email: $email, password: $password }) { ... }
}
```

문제는 — **이 뮤테이션들은 서버에 존재하지 않았다.** 에이전트가 "이메일 인증 서버라면 보통 이렇게 생겼겠지"라고 **추측(할루시네이션)**해서 오퍼레이션·모델·에러 매핑을 통째로 지어낸 것이다. 테스트도 통과했다. 왜냐면 테스트도 그 가짜 스키마를 기준으로 짜여 있었으니까.

앱을 에뮬레이터에서 돌려서야 "네트워크 오류"만 뜨고, 실제로는 **필드명이 서버와 안 맞아 요청이 거부되고 있었다.**

### 교훈 1 — 에러 로그가 "네트워크 오류"만 뱉으면 아무것도 모른다

첫 대응은 **디버그 전용 로거**를 붙이는 거였다. 요청(오퍼레이션 + 변수)과 응답(data + errors)을 콘솔에 찍되, **비밀번호·토큰·인증코드는 마스킹**한다.

```dart
// kDebugMode에서만 동작. 릴리스는 no-op.
static void request(String op, Map<String, dynamic> vars) {
  if (!kDebugMode) return;
  debugPrint('[GraphQL] → $op\n  variables: ${_encode(_mask(vars))}');
}
```

`_mask`는 `password`/`token`/`secret`(부분 일치)과 `code`(정확 일치)를 `***`로 가린다. 여기서 함정 하나 — 처음엔 `code`를 부분 일치로 넣었더니 약관의 `termsCode`(SERVICE/PRIVACY…)까지 가려져서 디버깅이 안 됐다. **비밀인 `code`와 비밀 아닌 `termsCode`를 구분**해야 했다.

이 로거 덕분에 실제 응답이 보였다:

```
[GraphQL] ← registerEmailMember
  data: { "registerEmailMember": {
    "success": false,
    "userErrors": [ { "code": "MEMBER_ALREADY_REGISTERED", ... } ]
  } }
```

`signUp`이 아니라 `registerEmailMember`였다.

---

## 실제 스키마를 introspection으로 받기 — `BadFaithIntrospection`의 벽

이제 진짜 스키마를 봐야 했다. 표준 introspection 쿼리를 던졌더니:

```json
{ "errors": [ { "message": "This request is not asking for introspection in good faith - __Type.fields is present too often!",
  "extensions": { "classification": "BadFaithIntrospection" } } ] }
```

서버가 **표준 introspection을 봇/스크래핑으로 간주해 차단**하고 있었다. 표준 쿼리는 `FullType` 프래그먼트가 `__Type.fields`를 재귀적으로 여러 번 참조하는데, 그 반복 횟수가 임계치를 넘으면 막는다.

우회법은 간단했다 — **`fields`/`inputFields`를 스키마 전체에서 각각 1회만** 참조하도록 쿼리를 평탄화하면 통과한다. 한 방에 전체 타입·필드·인자·enum을 받아 `schema.introspection.json`에 저장했다.

받아 보니 실제 스키마는 내가 지어낸 것과 완전히 달랐다:

| 내가 지어낸 것(❌) | 실제 서버(✅) |
|---|---|
| `signUp(email, password)` | `registerEmailMember(email, password, **ageVerified**, **agreements[]**)` |
| `login` | `loginEmail` → `AuthTokenPayload` |
| 응답에 `user` 포함 | 로그인 응답엔 user 없음 → **`me` 쿼리 별도** |
| 이메일 인증 없음 | **`verifyEmail`(인증 필수 단계)** + `resendVerification` |
| `errors` 배열 | `success` + **`userErrors[].code`**(String, enum 아님) |

특히 **회원가입에 약관 동의·연령 확인이 필수**고, **가입 후 이메일 인증을 거쳐야만 로그인**할 수 있는 구조였다. 이건 화면 흐름 자체가 바뀌는 차이다.

---

## 교훈 2 — 재발 방지: "코드 짜기 전에 스키마부터" 훅

한 번 당했으니 시스템으로 막아야 했다. Claude Code의 **PreToolUse 훅**으로 규칙을 강제했다:

> `lib/**.dart`를 편집하기 전에, 신선하고 유효한 introspection 스냅샷이 없으면 **편집을 차단**한다.

```bash
# require-fresh-schema.sh (요약)
# 1) 스냅샷 존재?  2) "__schema" 포함?(BadFaith 에러 아님)  3) mtime 10분 이내?
# 하나라도 실패 → exit 2 로 차단 + 재-introspection 명령 안내
```

훅은 서버에 직접 못 붙으니(curl 샌드박스·서버 off 가능) **파일 신선도(mtime)**로 판정한다. 오래됐거나 없거나 에러 응답이면 코드 작성을 막고, 평탄화 introspection 명령을 콘솔에 인쇄해준다. (재밌게도, 이 글을 쓰는 도중 브랜치를 잘못 두고 편집하려다 **또 다른 훅(브랜치 정책)에 내가 막혔다** — 훅이 제대로 동작한다는 증거다.)

여기서 파일 두 개의 역할을 분리한 게 포인트다:

- `schema/schema.introspection.json` — **매 세션 바뀌는 검증용 스냅샷** → `.gitignore`
- `lib/domain/auth/repository/auth_schema.graphql` — **codegen 입력용 커밋된 SDL** → 사람이 스냅샷 보고 갱신

`graphql_codegen`은 후자를 읽어 타입 안전한 오퍼레이션을 생성한다. 생성된 `Mutation$...`/`Input$...` 타입은 **repository 안에만** 갇혀 있고, UI/provider로는 도메인 모델만 흘러나간다.

브랜치 정책 훅도 같이 넣었다 — `master`/`main`/`dev` 같은 보호 브랜치에서 직접 편집·커밋을 막고, 브랜치는 반드시 `feature/<기능명>`으로. (step 번호는 브랜치명에 넣지 않는다. 그건 스펙에 산다.)

---

## 회원 기능 구현 — 실제 스키마 기준으로

### 플로우: 로그인이 온보딩보다 앞

```
언어선택 → 로그인/회원가입(필수 게이트) → 온보딩(계정별 1회) → 홈
```

처음엔 "온보딩 → 로그인" 순서를 생각했지만, **로그인도 안 한 사용자에게 온보딩을 보여주는 게 부자연스럽다**는 판단으로 뒤집었다. 온보딩 완료 여부는 서버에 필드가 없어서 **계정(userId)별 로컬 플래그**로 관리한다.

### 토큰: secure storage + 자동 갱신

access(5분)/refresh(30일) 토큰은 `flutter_secure_storage`에만 저장한다(`common/storage` 래퍼가 유일한 접근점). `AuthLink`가 매 요청에 `Bearer`를 주입하고, 인증 에러가 나면 **한 번 refresh 후 원 요청을 재시도**한다. 이때 link ↔ auth provider의 순환 의존은 콜백 브릿지로 끊었다.

### 놓치기 쉬운 순서 버그

로그인 직후 `me`를 조회해 사용자 정보를 채우는데, 여기서 미묘한 버그가 있었다:

```dart
final tokens = await _repo.loginEmail(...);
final me = await _repo.fetchMe();   // ❌ 토큰 저장 전에 호출
await _persist(tokens);             // ← 너무 늦음
```

`AuthLink`는 **매 요청마다 secure storage에서 토큰을 읽는다.** 그런데 `fetchMe()`가 `_persist()`보다 먼저 실행되니, `me` 요청이 나갈 때 저장소가 비어 있어 인증 헤더 없이 나갔다 → 서버가 거부. Postman으로는 토큰을 직접 넣으니 됐던 것. `_persist`를 앞으로 옮기고 **회귀 테스트로 순서를 못 박았다**(버그 순서로 되돌리면 실패하는 걸 확인).

### 약관 UI는 페이지 대신 인라인

`agreements`가 필수라 약관 화면을 따로 만들까 했지만, 다나와식 **인라인 체크리스트**로 갔다 — "약관 전체 동의" 마스터 체크박스 + 개별 항목(만14세·서비스·개인정보·위치=필수, 마케팅=선택), 전문은 펼침. 별도 라우트 없이 회원가입 폼 안에서 끝난다.

---

## 홈 스크린 — 서버 API가 없을 때 UI를 완성하는 법

홈을 만들려는데 문제가 있었다. **서버 스키마에 spot/event/혼잡도 같은 관광 데이터 API가 아직 없었다**(auth/member만 존재). 그렇다고 홈을 미룰 순 없으니, **목(mock) 데이터를 repository 뒤에 격리**하는 방식으로 UI를 완성했다.

```
HomeRepository (interface)
      ↑
HomeRepositoryImpl  ← 지금은 목 데이터 반환 (async)
```

핵심은 **비동기 시그니처를 유지**하는 것. 나중에 서버 API가 생기면 `HomeRepositoryImpl`만 GraphQL 호출로 갈아끼우면 되고, provider·UI·위젯은 한 줄도 안 바뀐다. 목 이미지도 네트워크 이미지 대신 테마 색 블록으로(오프라인/테스트 안정성).

디자인은 **Google Stitch**의 "Home Screen"을 참조했다(MCP로 연결). 혼잡도 배지 색(여유/보통/혼잡)은 `ThemeExtension`으로 도입해 Map 화면과 공유할 수 있게 했다 — 하드코딩 색은 금지, 전부 테마 토큰 경유.

하단 내비는 `StatefulShellRoute.indexedStack`으로 **5탭 플로팅 내비**(Home/Map/Discover/Events/Chat)를 세웠다. 각 탭이 자체 네비게이션 스택을 유지하고, 셸 전체가 로그인 게이트 아래 있어 미인증 사용자는 어떤 탭에도 못 들어온다. Home 외 4탭은 지금은 플레이스홀더다.

---

## 아키텍처는 훅이 지킨다

이 프로젝트는 백엔드(Kotlin/DDD)와 결을 맞춰 **도메인 우선 + 레이어 구조**다. 그리고 그 규칙을 사람 리뷰가 아니라 **훅과 리뷰 서브에이전트**가 강제한다:

- `model`은 순수 Dart (flutter/graphql/riverpod import 금지)
- 생성된 GraphQL 타입은 **repository 밖으로 못 나감**
- 기능 간 교차 import 금지 → 공유물은 `common/`
- 토큰은 secure storage 래퍼로만

이번에 온보딩이 `common/`에 있으면서 auth provider를 import하는 **역방향 의존**이 리뷰에서 잡혔고, `domain/onboarding/`으로 승격해 해소했다.

---

## 마치며 — AI 코딩에서 진짜 배운 것

가장 큰 교훈은 **"그럴듯한 코드"와 "맞는 코드"는 다르다**는 것이다. 에이전트가 지어낸 `signUp`/`login`은 문법적으로 완벽했고 테스트도 통과했다. 하지만 **현실(서버 스키마)과 대조하지 않은 코드는 환상**이었다.

그래서 이번 스텝의 진짜 산출물은 회원 기능이나 홈 화면이 아니라, **"코드 짜기 전에 실제 스키마를 확인하도록 강제하는 훅"**일지도 모른다. AI에게 일을 시킬수록, 그 일을 검증하는 시스템이 더 중요해진다.

- **추적**: PR #4, 후속 이슈 #5(에러 코드 매핑)·#6(홈 서버 API)·#7(탭 본체)·#8(SNS 로그인)
- **다음**: 실제 `UserError.code` 수집 → 에러 문구 확정, 관광 데이터 API 연동, SNS 로그인(카카오·구글·애플)

> 다음 글에서는 SNS 로그인과 실제 관광 데이터 연동을 다룬다.
