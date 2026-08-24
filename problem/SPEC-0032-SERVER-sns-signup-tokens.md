# SPEC-0032 — 서버 요청: `registerSnsMember`가 토큰을 함께 주면 좋겠다

대상 오퍼레이션: `registerSnsMember`
확인 환경: `http://192.168.219.101:8888/graphql` (라이브 introspection, 2026-08-25)
상태: 요청 중

## 무엇이 문제인가

SNS로 가입을 마친 사용자가 **로그인 화면으로 되돌아간다.** 방금 provider 인증을
끝낸 사람에게 다시 로그인을 시키는 셈이라 이상하다(사용자 지적 2026-08-25).

원인은 `registerSnsMember`가 **토큰을 주지 않는 것**이다. 라이브 introspection으로
확인한 응답 필드는 넷뿐이다.

```
RegisterSnsMemberPayload {
  success: Boolean!
  userErrors: [UserError!]!
  emailVerified: Boolean
  verificationId: String
}
```

토큰이 없으면 세션이 서지 않고, 라우터 게이트가 미인증으로 판정해 온보딩을
막는다(SPEC-0005 §10.2). 가입은 성공했는데 진입은 못 하는 상태다.

## 클라이언트가 지금 하는 일 (임시 우회)

인증이 이미 끝난 경우(`verificationId == null`) **같은 자격증명으로 `loginSns`를
한 번 더 호출한다** — `AuthController.signUpSns`.

- SDK를 다시 부르지 않는다. 그러면 방금 인증한 사용자에게 동의 창이 또 뜬다.
  받아 둔 `SnsCredential`을 그대로 재사용한다(`signInSns(reuse:)`).
- 로그인이 실패하면 삼키고 예전처럼 로그인 화면으로 보낸다. 가입 자체는
  성공했으므로 사용자가 직접 로그인하면 된다.
- idToken 수명이 5분이라(사용자 확인) 이 사이에 만료될 일은 사실상 없다.

## 요청

`registerSnsMember`가 `loginSns`와 같은 토큰 묶음을 함께 돌려주면 좋겠다 —
`accessToken`·`refreshToken`·`tokenType`·`accessTokenExpiresIn`·
`refreshTokenExpiresIn`.

**단, 코드 인증이 남은 경우(`verificationId != null`)에는 토큰을 주면 안 된다.**
미인증 세션이 서면 서버가 대부분의 오퍼레이션을 거부하는 상태로 앱에 들어가게
된다(SPEC-0024 R9).

### 이득

- 왕복이 둘에서 하나로 준다
- idToken 만료 창(현재 5분)에 기대지 않아도 된다
- 이메일 가입과 흐름이 같아진다 — 그쪽도 인증 완료 시점에 토큰이 나온다

### 서버가 이 요청을 받지 않아도 된다

지금 우회로 동작은 맞다. 왕복이 한 번 더 나가는 비용만 남는다.
