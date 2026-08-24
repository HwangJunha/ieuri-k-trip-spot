# SPEC-0032 — 개발 번들 id 분리에 따른 서버·콘솔 작업

상태: 요청 중 (클라이언트 작업은 완료)

개발/운영을 한 기기에 함께 깔기 위해 번들 id를 갈랐다(2026-08-25).

| | 번들 id / applicationId |
|---|---|
| 운영 | `kr.ieuri.ktripspot` (변경 없음) |
| 개발 | `kr.ieuri.ktripspot.dev` (신규) |

**이 값을 아는 곳이 앱 밖에도 있다.** provider마다 무엇을 `aud`로 쓰는지가 달라
영향 범위가 갈린다.

| Provider | `aud` | 번들 분리 영향 |
|---|---|---|
| **카카오** | REST API 키 | **없음** — 그래서 카카오만 정상 동작했다 |
| **구글** | 웹 OAuth 클라이언트 id | 서버는 영향 없음. iOS 클라이언트는 번들별로 필요 |
| **애플** | **번들 id 그 자체** | **직격** — 서버 검증값과 콘솔 App ID를 모두 손봐야 한다 |

## 클라이언트에서 끝난 것

- iOS 구글 클라이언트 id를 flavor별 xcconfig로 분리(Firebase가 dev용을 이미 발급)
- Firebase 앱 4개 등록 완료(Android·iOS × dev·prod, 모두 `ieuri-d1127`)

## 서버가 해야 할 것

### 1. 애플 `aud` 검증값을 환경별로 나눈다

지금 서버는 `aud == kr.ieuri.ktripspot` 하나만 통과시킨다
(`AppleIdTokenVerifier`, 기획 문서 §8.3). 개발 앱이 보내는 토큰은
`aud`가 `kr.ieuri.ktripspot.dev`라 **전부 거부된다.**

```yaml
# application-dev.yml
sns:
  apple:
    audience: kr.ieuri.ktripspot.dev

# application-prod.yml
sns:
  apple:
    audience: kr.ieuri.ktripspot
```

**운영 프로파일에 개발 번들을 함께 허용하지 않는다.** 목록으로 두 값을 다 받으면
개발 빌드 토큰이 운영 서버에 통과한다.

### 2. 구글 `aud`는 그대로 둔다

구글 `id_token`의 `aud`는 **웹 클라이언트 id**다(`serverClientId`로 지정). 번들이
갈려도 이 값은 같아 서버 변경이 없다.

## 콘솔에서 해야 할 것 (앱 개발자)

### Apple Developer

1. **Identifiers → App IDs**에 `kr.ieuri.ktripspot.dev` 등록
2. 그 App ID에 **Sign in with Apple** capability 활성
3. 기존 운영 App ID의 설정은 건드리지 않는다

이걸 하지 않으면 개발 빌드에서 애플 로그인이 **암호 입력 후 멈춘다**(실기기 확인
2026-08-25 — 시뮬레이터 제약이 아니라 등록되지 않은 번들 id 때문이다).

### Google Cloud Console

Firebase가 iOS 클라이언트를 자동 생성했으므로 **추가 작업이 없을 가능성이 높다.**
안드로이드 개발 빌드에서 구글 로그인이 실패하면 그때
**OAuth 클라이언트(Android, 패키지 `kr.ieuri.ktripspot.dev` + 디버그 SHA-1)** 를
등록한다.

### 카카오

**작업 없음.** `aud`가 REST API 키라 번들과 무관하다. 다만 안드로이드는
키 해시가 패키지별로 다르므로, 개발 빌드에서 카카오 로그인이 실패하면
**`kr.ieuri.ktripspot.dev`의 디버그 키 해시**를 콘솔에 추가한다.

## 확인 순서

1. 서버가 `application-dev.yml`에 애플 audience를 넣는다
2. Apple Developer에 `.dev` App ID + Sign in with Apple 활성
3. 개발 빌드로 애플 로그인 → 성공하면 끝
