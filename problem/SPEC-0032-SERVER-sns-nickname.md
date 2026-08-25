# SPEC-0032 — SNS 가입에 닉네임을 싣는다 (서버 요청)

> 대상 오퍼레이션: `registerSnsMember`
> 확인 환경: `lib/domain/auth/repository/auth_schema.graphql`(커밋된 SDL).
> 라이브 서버는 확인하지 못했다 — 작성 시점에 `localhost:8888`이 내려가 있었다.
> **상태: 서버가 작업 중(사용자, 2026-08-25). 계약이 나오면 클라이언트를 잇는다.**

## 무엇이 비어 있나

카카오 로그인은 **이미 닉네임을 받아 오고 있다.** `sns_authenticator.dart`가
`UserApi.instance.me()`로 읽어 `SnsCredential.nickname`에 담는다.

그런데 그 값이 **아무 데도 가지 않는다.**

- 가입 화면(`sns_sign_up_screen.dart`)이 참조하지 않는다 — 입력칸도 없다.
- 계약에 실을 자리가 없다. 현재 `RegisterSnsMemberInput`은 이렇다.

```graphql
input RegisterSnsMemberInput {
  provider: Provider!
  idToken: String!
  email: String!
  ageVerified: Boolean!
  agreements: [AgreementInput!]!
  authorizationCode: String
}
```

`nickname` 인자가 없다.

## 왜 지금 요청하는가

SPEC-0032 본문 §6-b.1은 **"프리필용이며 서버로 보내지 않는다"**고 적고 있다. 그
근거는 "provider가 준 값을 쓴다는 요구가 무너진다"였고, 서버가 `id_token` 클레임에서
직접 읽는 것을 전제했다.

**카카오는 그 전제가 성립하지 않는다.** 카카오 `id_token`의 표준 클레임에 닉네임이
항상 실리는 것이 아니라, 프로필 동의 항목과 별개 API(`v2/user/me`)에 있다. 그래서
클라이언트가 받은 값을 넘기지 않으면 서버가 알 방법이 없다.

## 필요한 것

`registerSnsMember`가 닉네임을 받을 수 있으면 된다.

```graphql
input RegisterSnsMemberInput {
  ...
  nickname: String   # 선택. provider가 주지 않으면 비운다.
}
```

**선택 인자여야 한다** — Apple은 첫 로그인에만 이름을 주고 그 뒤로는 주지 않는다.
Google도 계정 설정에 따라 없을 수 있다. 값이 없다고 가입이 막히면 안 된다.

## 클라이언트가 할 일 (계약이 나온 뒤)

1. `auth_operations.graphql`의 `RegisterSnsMember`에 `nickname` 전달
2. `auth_repository_impl.dart`가 `SnsCredential.nickname`을 입력에 싣는다
3. `dart run build_runner build` + 라이브 스윕(§13)
4. 본문 §6-b.1의 "보내지 않는다"를 이 결정으로 갱신

**가입 화면에 입력칸을 두는 것은 별개 판단이다.** 서버가 받은 값을 그대로 쓸지,
사용자가 고칠 수 있게 할지는 계약이 정해진 뒤에 정한다 — 고칠 수 있게 하면
"provider가 준 값을 쓴다"는 원래 요구와 다시 부딪힌다.
