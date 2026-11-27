# 이으리(ieuri) k-trip-spot 회원 기능 개발 — 요구사항 분석서

> **Step 2**: 이메일 **회원가입 · 로그인 · 로그인 유지(자동 로그인)** 를 구현한다.
> 카카오 · 구글 · 애플 등 **SNS 기반 회원가입/로그인은 Step 3**에서 진행한다.
> 서버는 로컬 GraphQL 엔드포인트(`http://localhost:8888`)를 호출한다.

---

## 0. 문서 정보

| 항목 | 내용 |
|---|---|
| 대상 앱 | `ieuri_k_trip_spot` (Flutter, 외국인 대상 실시간 위치기반 한국 관광 앱) |
| 이번 단계 | Step 2 — 회원 기능(이메일 회원가입 · 로그인 · 로그인 유지) |
| 상태 | **요구사항 분석 / 승인 대기** (구현 착수 전) |
| 데이터 계층 | **GraphQL** (`graphql_flutter` + `graphql_codegen`), 엔드포인트 `http://localhost:8888` |
| 보안 | 토큰/시크릿은 **`flutter_secure_storage`** (via `common/storage`) — 비밀값은 절대 `SharedPreferences`/평문/로그 금지 |
| 근거 규약 | 프로젝트 `CLAUDE.md`(도메인 중심 · 레이어 의존 방향 · Riverpod · GraphQL 격리 · 보안 규칙) |
| 선행 단계 | Step 1(테마 · 다국어 · 스플래시 · 온보딩 · 라우팅) 완료 |

### 개정 이력
- v0.1 — 초안(범위 스케치: 이메일 회원가입/로그인/로그인 유지)
- v1.0 — 본 분석서(GraphQL 연동, secure-storage 토큰 저장, auth 라우트 가드, 레이어 배치 확정)
- v2.0 — 미결 질문 확정 반영: 토큰 정책(access 5분/refresh 30일, Bearer), 회원가입 필드/비밀번호 정책, 가입 후 재로그인, `UserErrors[]`+`code` 에러 모델, 애뮬레이터 호스트(iOS `localhost` / Android `10.0.2.2`), 비밀번호 재설정 In Scope
- v2.1 — 플로우 순서 변경: `언어선택 → 로그인/회원가입(필수) → 온보딩 → 홈`. 로그인 전에는 온보딩을 보여주지 않는다. 온보딩 완료 판정을 기기 로컬 플래그에서 계정 종속(계정별 최초 로그인 1회)으로 변경.
- **v3.0 — 실제 서버 스키마 반영(introspection). 가정 오퍼레이션(`signUp`/`login`)은 서버에 없어 폐기. 실제: `registerEmailMember`(약관 `agreements`+연령 `ageVerified` 필수) → `verifyEmail`(이메일 인증 필수 단계) → `loginEmail`(`AuthTokenPayload`) → `me` 별도 조회. `logout`/`resetPassword`(코드 기반) 서버 뮤테이션 사용. `UserError.code`는 `String`(enum 아님) → 실제 code는 디버그 로그로 수집. 이메일 인증·약관 동의 화면 In Scope로 승격. 스키마 보존: `schema/schema.graphql`, `schema/schema.introspection.json`.**

> ✅ §13의 미결 질문은 모두 **확정**되었고, v3.0에서 **실제 서버 스키마로 검증**되었다(§13 참조).
> 서버 SDL은 `localhost:8888/graphql` introspection이 가능하므로, **구현 착수 시점에 실제 스키마로 오퍼레이션 필드를 최종 검증**한다(뮤테이션 이름/입력 타입은 확정 답변에 맞춰 §6에 반영, 세부 필드명은 introspection으로 대조).

---

## 1. 개요 & 목표

Step 1이 앱의 **토대**(테마·다국어·라우팅·온보딩)를 세웠다면, Step 2의 목표는 그 위에 **인증(Authentication) 도메인**을 얹는 것이다.

1. **이메일 회원가입** — 이메일(필수)/비밀번호로 계정을 생성한다. 가입 성공 후에는 **다시 로그인**해야 토큰을 받는다(서버가 가입 응답에 토큰을 주지 않음).
2. **이메일 로그인** — 자격증명으로 로그인하고 **accessToken(5분) · refreshToken(30일)** 을 발급받는다.
3. **로그인 유지(자동 로그인)** — 앱 재실행 시 저장된 토큰으로 세션을 복원한다. accessToken 만료(5분) 시 refreshToken(30일)으로 자동 갱신한다.
4. **로그아웃** — 토큰을 폐기하고 세션을 정리한다.
5. **비밀번호 재설정** — 본 단계 In Scope(§2.1, §5.4).
6. 이 과정에서 **GraphQL 클라이언트 인프라**(`graphql_flutter` + `AuthLink` + 에러 매핑)와 **`SecureStorage` 토큰 저장소**를 확립한다. 이 인프라는 Step 3(SNS 로그인)·이후 모든 인증 필요 화면의 토대가 된다.

**로그인은 앱 사용의 필수 게이트이며, 온보딩보다 앞선다.** 순서는 `언어선택 → 로그인/회원가입(필수) → 온보딩 → 홈`이다. 로그인하지 않은 사용자에게 온보딩을 보여주는 것은 부자연스럽기 때문에, **인증을 먼저 통과**한 뒤 **계정별 최초 1회** 온보딩을 보여준다. Step 2가 끝나면, 언어를 고른 미인증 사용자는 **로그인 화면에 강제 진입**하고, 인증에 성공하면 (그 계정이 온보딩을 아직 안 봤으면) 온보딩을 거쳐 홈(현재는 placeholder)으로 넘어가며, 재실행 시 **자동 로그인**되어 곧장 홈으로 간다.

---

## 2. 범위 (Scope)

### 2.1 In Scope
- **인증 도메인** `lib/domain/auth/` 신규 생성 (model · repository · provider · component · view)
- **회원가입 화면**: 이메일(필수)·비밀번호·비밀번호 확인 + **약관 동의(`agreements`)·연령 확인(`ageVerified`)**(실제 스키마 필수), `registerEmailMember` 뮤테이션. **성공 → `verificationId` → 이메일 인증 화면**(토큰 미발급)
- **이메일 인증 화면(신규, 실제 스키마 필수)**: `verifyEmail`(코드 입력) + `resendVerification`. 인증 완료 → 로그인 화면
- **로그인 화면**: 이메일·비밀번호 입력, `loginEmail` 뮤테이션(`AuthTokenPayload`), `userErrors` 실패 메시지 표시. 로그인 후 `me` 조회로 유저 확립
- **로그인 유지(자동 로그인)**: access/refresh 토큰을 `flutter_secure_storage`에 저장(서버가 준 `expiresIn` 반영), 앱 시작 시 세션 복원, accessToken 만료 시 `refreshToken` 뮤테이션으로 자동 갱신
- **로그아웃**: 로컬 토큰 삭제 + **서버 `logout(refreshToken)` 호출** + 인증 상태 초기화 + 로그인 화면 이동
- **비밀번호 재설정(코드 기반 2단계)**: `requestPasswordReset` → `resetPassword(email, code, newPassword)`(§5.4)
- **로그인 필수 게이트(온보딩보다 선행)**: 언어 선택 후 미인증 사용자는 로그인/회원가입을 통과해야 온보딩·홈으로 진행 가능(§4, §10)
- **계정별 온보딩**: 온보딩은 로그인 성공 후, 해당 계정이 아직 안 봤을 때만 1회 노출(§4)
- **GraphQL 인프라**(`common/network/`): `graphql_flutter` 클라이언트, `AuthLink`(Bearer 토큰 주입), `errors`/`UserErrors` → 실패 매핑
- **`SecureStorage` 래퍼**(`common/storage/`): `flutter_secure_storage`를 감싸는 유일한 지점
- **라우팅 가드**: GoRouter `redirect`로 인증 상태에 따라 로그인/홈 분기(온보딩 완료 이후 단계)
- **엔드포인트 주입**: 애뮬레이터별 호스트(iOS `localhost` / Android `10.0.2.2`)를 `--dart-define`으로 주입(§6.1)
- **다국어**: 신규 화면의 모든 카피를 `l10n`(EN/KO/JA/ZH)에 추가
- **테스트**: 레이어별(model/repository/provider/view) — CLAUDE.md §8

### 2.2 Out of Scope (명시적 제외)
- **SNS 로그인/회원가입**(카카오·구글·애플, 스키마의 `registerSnsMember`/`loginSns`) — **Step 3**
- **프로필 편집 / 회원 탈퇴**(스키마의 `withdrawMember`), 관리자 기능(`suspendMember`/`assignRole` 등) — 이후 단계
- **선택 약관(MARKETING)** 이외 마케팅 수신 설정 화면 — 이후
- 홈 화면 및 실제 관광 기능 — 별도 기능(step 무관), `problem/k_trip_spot_홈_스크린_개발.md`
- 서버(백엔드) 구현 — 본 문서는 클라이언트 관점. 서버는 `localhost:8888/graphql`에 이미 기동되어 있다.

---

## 3. 용어

| 용어 | 정의 |
|---|---|
| 액세스 토큰(access token) | API 호출 인증에 쓰이는 단기 토큰. `AuthLink`가 GraphQL 요청 헤더에 주입. |
| 리프레시 토큰(refresh token) | 액세스 토큰(5분) 만료 시 재발급에 쓰이는 장기 토큰(30일). |
| 세션 복원 | 앱 시작 시 저장된 토큰을 읽어 로그인 상태를 복구하는 것(= 로그인 유지/자동 로그인). |
| 인증 상태(auth state) | `unauthenticated / authenticating / authenticated` 등 앱 전역 로그인 상태. Riverpod 노출. |
| 온보딩 완료(계정 종속) | 특정 계정이 온보딩을 봤는지 여부. **기기 플래그가 아니라 계정에 종속**(§4.3). |
| 보안 저장소 | `flutter_secure_storage`. 토큰 등 **비밀값 전용**. `common/storage`의 래퍼로만 접근. |
| 인증 가드 | 로그인해야 접근 가능한 라우트를 GoRouter `redirect`로 보호하는 것. |

---

## 4. 인증 플로우 (상태 전이)

### 4.1 전체 순서 — 로그인 후 온보딩 (필수 게이트가 온보딩보다 선행)

로그인 화면은 **온보딩 "앞"** 에 온다. 로그인하지 않은 사용자에게 온보딩을 보여주는 것은 부자연스럽기 때문에, **인증을 먼저 통과**시킨 뒤 온보딩을 보여준다. 언어 선택은 맨 앞이라 로그인/온보딩 카피가 선택 언어로 렌더된다.

```
스플래시 → 언어선택 → ★로그인/회원가입(필수 게이트)★ → 온보딩(계정별 1회) → 홈
                            ▲                            │
               미인증이면 여기서 막힘(우회 불가)     이미 본 계정이면 건너뜀
```

- **언어선택**: Step 1 그대로. 저장된 locale 없으면 최초 1회 노출.
- **로그인 게이트**: 미인증이면 여기서 막힌다. 우회 불가.
- **온보딩**: 로그인 성공 후, **그 계정이 아직 안 봤을 때만** 1회. 이미 본 계정은 곧장 홈.

### 4.2 세션 복원 & 인증 전이

```
(언어선택 완료)
   │
   ▼
[앱 시작 / 세션 복원]  ← SecureStorage에서 access/refresh 토큰 로드
   │
   ├─ accessToken 유효 ─────────────────────────► (온보딩 판정 4.3) → 홈
   │
   ├─ access 만료 & refresh 유효(≤30일) ─► refreshToken 뮤테이션 → 새 토큰 저장 → (온보딩 판정) → 홈
   │
   └─ 토큰 없음 / refresh도 만료 ──────►  (로그인 화면, 필수)
                                 │
              ┌──────────────────┼───────────────────┐
              ▼                                       ▼
        [로그인]                                 [회원가입으로 이동]
     이메일/비번 입력                        이메일/비번/비번확인 + 약관동의 + 연령확인
        │                                            │
  loginEmail 뮤테이션                        registerEmailMember 뮤테이션
        │                                            │
   ┌────┴─────┐                              ┌───────┴────────┐
   ▼          ▼                              ▼                ▼
 성공        실패                           성공             실패
 토큰 저장    userErrors               verificationId 수신   userErrors
 → me 조회    /code 문구                      │              code/field
 → 온보딩 판정 (재시도)                        ▼               (재시도)
                                     [이메일 인증 화면]
                                    코드 입력 → verifyEmail
                                    (resendVerification 재발송)
                                          │
                                     verified=true
                                          ▼
                                     로그인 화면(이메일 프리필)
```

- **자동 로그인 판정**: 세션 복원 시 accessToken이 유효하면 로그인 화면을 건너뛴다. access(5분) 만료 & refresh(30일) 유효면 refresh로 조용히 갱신. 둘 다 없거나 refresh 만료면 로그인 화면. 인증 통과 후에는 항상 **온보딩 판정(§4.3)** 을 거쳐 홈으로 간다.
- **회원가입 성공 후**: 서버가 **토큰을 주지 않으므로**(확정 Q4) 자동 로그인하지 않는다. 가입한 이메일을 프리필한 채 **로그인 화면으로 유도**한다.
- **라우팅**: 위 전이는 GoRouter `redirect`로 구현(위젯 내 임시 분기 금지 — CLAUDE.md §6).

### 4.3 온보딩 완료 판정 — 계정 종속 (계정별 최초 로그인 1회)

온보딩이 로그인 뒤로 오면서, 완료 여부는 **기기 플래그가 아니라 계정에 종속**된다. 같은 기기에서 다른 계정으로 로그인하면 그 계정 기준으로 다시 판정한다.

- **판정 시점**: 로그인/자동 로그인 성공 직후.
- **완료면**: 곧장 홈. **미완료면**: 온보딩 → "시작하기" → 완료 저장 → 홈.
- **저장 위치(둘 중 하나, §13 후속 확인)**:
  - **(A) 서버 기준 권장** — `user`에 `onboardingCompleted`(또는 유사) 필드가 있으면 그것을 사용/갱신한다. 기기 교체·재설치와 무관하게 계정을 따라간다.
  - **(B) 로컬 폴백** — 서버 필드가 없으면 `flutter_secure_storage`/`SharedPreferences`에 **계정 식별자(userId)별 키**로 저장(`onboarding_completed:<userId>`). 비밀값이 아니므로 `SharedPreferences`도 가능하나, userId를 키에 노출하므로 secure 저장을 권장.
- **기존 기기 전역 플래그(`onboarding_completed`)**: Step 1의 전역 온보딩 플래그는 이 계정 종속 모델로 **대체**한다(라우팅 가드도 §10에서 갱신).

---

## 5. 기능 요구사항 — 화면 (View)

> 화면 위젯 파일·클래스명은 `*_screen` 규칙을 따른다(Step 1과 동일).

### 5.1 로그인 — `login_screen.dart` / `LoginScreen`
- 입력: **이메일**, **비밀번호**(가림 처리, 표시 토글).
- 액션: **로그인** 버튼 → `loginEmail`. **회원가입** 링크 → 회원가입 화면. **비밀번호 재설정** 링크 → §5.4.
- 상태 표시: 진행 중 로딩(버튼 비활성/스피너), 실패 시 에러 문구(`userErrors[].code` 매핑: 자격증명 오류/네트워크 오류 구분).
- 검증(제출 전): 이메일 형식, 빈 값 방지.
- 회원가입 인증 완료 후 넘어온 경우 이메일 프리필.
- 다국어: 라벨/버튼/에러 문구 모두 `l10n`.

### 5.2 회원가입 — `sign_up_screen.dart` / `SignUpScreen`
- 입력: **이메일(필수)**, **비밀번호**, **비밀번호 확인**.
- **약관 동의 · 연령 확인 — 회원가입 폼 안에 인라인 배치(별도 페이지 없음).** 일반적인 인라인 체크리스트를 참고한다:
  ```
  ☐ 약관 전체 동의 (선택 포함)          ← 마스터 체크박스: 켜면 전체 on, 끄면 전체 off
  ─────────────────────────────────
  ☐ 만 14세 이상입니다. (필수)          → ageVerified: Boolean!
  ☐ 서비스 이용 약관 (필수)   [내용보기] → agreements: SERVICE
  ☐ 개인정보 수집·이용 (필수) [내용보기] → agreements: PRIVACY
  ☐ 위치정보 이용 약관 (필수) [내용보기] → agreements: LOCATION
  ☐ 마케팅 목적 수집·이용 동의 (선택) [내용보기] → agreements: MARKETING
  ```
  - **마스터("약관 전체 동의")**: 하위 전체를 한 번에 토글. 하위가 모두 켜지면 마스터도 자동 체크(양방향 동기화).
  - **필수 항목**(연령 + SERVICE/PRIVACY/LOCATION)이 모두 체크돼야 **가입 버튼 활성화**. 선택(MARKETING) 미체크는 가입 가능.
  - **[내용보기]**: 각 약관 전문은 펼침(expand)/바텀시트로 표시 — 별도 라우트 화면을 만들지 않는다. 전문 텍스트는 `l10n` 또는 상수 문서로 관리.
  - 제출 시 `agreements`에는 **체크된 termsCode만** `{ termsCode, agreed: true }`로, 또는 전 항목을 `agreed` 불리언과 함께 담는다(서버 규약에 맞춤 — 기본은 필수는 true, MARKETING은 사용자 선택값).
- 컴포넌트로 추출: `agreement_checklist`(마스터+개별 항목, `component/`). 다국어 라벨/필수·선택 배지/내용보기 모두 `l10n`.
- 닉네임·이름·언어는 회원가입 입력에 **없다**(가입 후 프로필 단계). 서버 `Me.nickname`은 서버가 부여.
- 클라이언트 검증:
  - 이메일 형식(RFC 기본 수준).
  - **비밀번호 정책(확정): 영문 + 숫자 + 특수문자 포함, 8자리 이상.**
  - 비밀번호 == 비밀번호 확인.
  - 필수 약관 미동의 / 연령 미확인 시 제출 불가.
- 액션: **가입하기** 버튼 → `registerEmailMember`. 성공 시 토큰이 아니라 **`verificationId`** 를 받는다 → **이메일 인증 화면(§5.3)** 으로 이동.
- 실패 시 `userErrors[].code`/`field` 매핑.

### 5.3 이메일 인증 — `email_verification_screen.dart` / `EmailVerificationScreen`
- **실제 스키마가 강제하는 단계.** 회원가입 성공 후 `verificationId`를 들고 진입.
- 입력: 이메일로 받은 **인증 코드**.
- 액션: **인증** 버튼 → `verifyEmail(verificationId, code)`. `verified == true` & `success` → 인증 완료 → **로그인 화면(이메일 프리필)**. **코드 재발송** 버튼 → `resendVerification(verificationId)`(새 `verificationId`/`expiresAt` 반영).
- 상태 표시: 로딩/성공/실패(`failureReason`/`userErrors`).

### 5.4 비밀번호 재설정 — `password_reset_screen.dart` / `PasswordResetScreen`
- **코드 기반 2단계**(실제 스키마):
  1. 이메일 입력 → `requestPasswordReset(email)` → 코드 발송 안내.
  2. **이메일 + 코드 + 새 비밀번호** 입력 → `resetPassword(email, code, newPassword)` → 완료 → 로그인 화면.
- 새 비밀번호도 §5.2 비밀번호 정책 검증. 실패 시 `failureReason`/`userErrors`.

### 5.5 인증 진입/분기 (세션 복원)
- 별도 화면 없이 **스플래시/라우터 redirect** 단계에서 처리(Step 1 스플래시 뒤). 저장 토큰 로드 → 유효하면 `me` 조회로 세션 확립, 아니면 로그인.

### 5.6 공용 컴포넌트(`component/`)
- `auth_text_field`(이메일/비밀번호/코드 공용 입력), **`agreement_checklist`(마스터+개별 약관, §5.2)**, 제출 버튼 등 auth 화면들이 재사용하는 위젯을 `domain/auth/component/`에 둔다. **두 개 이상 feature가 쓰면** `common/`으로 승격.
- **약관 화면은 만들지 않는다** — 동의는 회원가입 폼 인라인, 전문은 펼침/바텀시트(별도 라우트 없음).

---

## 6. 기능 요구사항 — 데이터 계층 (GraphQL)

> GraphQL 격리 규칙(CLAUDE.md §3): 생성된 `*.graphql.dart` 타입과 클라이언트는 **repository 안에만** 존재하고, repository가 도메인 `model`로 매핑한다.
> **✅ 아래는 실제 서버 스키마다.** `localhost:8888/graphql` introspection으로 받아 `schema/schema.graphql`(+`schema/schema.introspection.json`)에 보존. 초안(v2.0)의 가정 오퍼레이션(`signUp`/`login`)은 **서버에 존재하지 않아 폐기**하고 실제 스키마로 교체했다.

### 6.1 엔드포인트 (확정 Q6)
- 개발 서버: `http://localhost:8888/graphql`.
- **iOS 시뮬레이터**: `http://localhost:8888/graphql` (호스트 그대로).
- **Android 에뮬레이터**: `http://10.0.2.2:8888/graphql` (에뮬레이터의 호스트 루프백 별칭).
- 하드코딩하지 않고 `--dart-define=GRAPHQL_ENDPOINT=...`로 주입, 미지정 시 플랫폼 기본값(iOS `localhost` / Android `10.0.2.2`)을 코드에서 선택.

### 6.2 실제 오퍼레이션 (서버 스키마 기준)

**공통 페이로드 규약**: 모든 뮤테이션 페이로드는 `success: Boolean!` + `userErrors: [UserError!]!`를 가진다. `UserError { code: String!, message: String!, field: String }`. **판정: `success == false` 또는 `userErrors` 비어있지 않음 → 실패.** `code`는 서버가 문자열로 돌려주며(스키마상 enum 아님) 실제 상수값은 런타임 로그로 수집해 매핑을 확정한다(§6.4).

```graphql
# 이메일 회원가입 — 토큰 미발급. 성공 시 verificationId 반환 → 이메일 인증 필요.
mutation RegisterEmailMember($input: RegisterEmailMemberInput!) {
  registerEmailMember(input: $input) {
    success
    userErrors { code message field }
    verificationId
  }
}
# RegisterEmailMemberInput { email: String!, password: String!,
#   ageVerified: Boolean!, agreements: [AgreementInput!]! }
# AgreementInput { termsCode: TermsCode!, agreed: Boolean! }
# TermsCode = SERVICE | PRIVACY | LOCATION | MARKETING

# 이메일 인증 — 가입 후 받은 verificationId + 사용자가 입력한 코드
mutation VerifyEmail($input: VerifyEmailInput!) {
  verifyEmail(input: $input) {
    success
    userErrors { code message field }
    verified
    failureReason
  }
}
# VerifyEmailInput { verificationId: ID!, code: String! }

# 인증 코드 재발송
mutation ResendVerification($input: ResendVerificationInput!) {
  resendVerification(input: $input) {
    success userErrors { code message field } verificationId expiresAt
  }
}
# ResendVerificationInput { verificationId: ID! }

# 이메일 로그인 — access/refresh 토큰 발급
mutation LoginEmail($input: LoginEmailInput!) {
  loginEmail(input: $input) {
    success
    userErrors { code message field }
    accessToken refreshToken tokenType
    accessTokenExpiresIn refreshTokenExpiresIn
  }
}
# LoginEmailInput { email: String!, password: String! }

# 토큰 갱신 — 동일한 AuthTokenPayload 반환
mutation RefreshToken($input: RefreshTokenInput!) {
  refreshToken(input: $input) {
    success userErrors { code message field }
    accessToken refreshToken tokenType accessTokenExpiresIn refreshTokenExpiresIn
  }
}
# RefreshTokenInput { refreshToken: String! }

# 로그아웃 — 서버 측 refresh 토큰 무효화
mutation Logout($input: LogoutInput!) {
  logout(input: $input) { success userErrors { code message field } }
}
# LogoutInput { refreshToken: String! }

# 비밀번호 재설정 요청 → 코드 발송
mutation RequestPasswordReset($input: RequestPasswordResetInput!) {
  requestPasswordReset(input: $input) { success userErrors { code message field } }
}
# RequestPasswordResetInput { email: String! }

# 비밀번호 재설정 확정 — 이메일 + 코드 + 새 비밀번호
mutation ResetPassword($input: ResetPasswordInput!) {
  resetPassword(input: $input) {
    success userErrors { code message field } failureReason
  }
}
# ResetPasswordInput { email: String!, code: String!, newPassword: String! }

# 로그인 유저 정보 — 로그인 응답엔 user가 없으므로 별도 조회
query Me {
  me { id email nickname profileImageUrl status emailVerified roles permissions createdAt }
}
```

### 6.3 토큰 정책 (확정 Q2, 스키마 확인)
- 로그인/갱신 응답 `AuthTokenPayload`가 `accessToken`·`refreshToken`·`tokenType`(= `Bearer`)·`accessTokenExpiresIn`·`refreshTokenExpiresIn`(초 단위)를 준다. **만료 시각은 서버가 주는 `expiresIn`을 신뢰**한다(하드코딩 5분/30일 대신 응답값 사용; 확정 답변의 5분/30일은 기본 정책값).
- 요청 헤더: `Authorization: <tokenType> <accessToken>` (= `Bearer <accessToken>`).
- access 만료 시: `refreshToken` 뮤테이션으로 새 토큰 쌍 수신 → 저장 → 원 요청 재시도. 실패(=refresh 만료/무효)면 로컬 토큰 삭제 + 서버 `logout`은 생략(이미 무효) 후 로그인 화면.
- **로그아웃**은 로컬 토큰 삭제 + 서버 `logout(refreshToken)` 호출로 서버 측 refresh 토큰도 무효화한다.

### 6.4 에러 처리 (확정 Q5, 스키마 확인)
- 각 페이로드의 **`userErrors: [UserError!]!`** — `UserError { code: String!, message: String!, field: String }`.
- **판정 규칙(2단)**: ① 페이로드 `success == false` **또는** `userErrors` 비어있지 않음 → 도메인 실패. ② 전송/시스템 오류(GraphQL 최상위 `errors` 또는 링크 예외)도 실패 → `NetworkFailure` (§9 `common/network`).
- **`code`는 스키마상 `String!`(enum 아님)** 이라 상수 문자열이 스키마에 노출되지 않는다. 따라서 `AuthFailure.fromCode`는 **관측된 실제 code 문자열로 매핑**하고, 미지의 code는 `UnknownFailure`로 폴백한다. 초기값으로 흔한 후보(`INVALID_CREDENTIALS`, `EMAIL_TAKEN`/`EMAIL_ALREADY_IN_USE`)를 두되, **디버그 로그로 실제 code를 수집해 매핑을 확정**한다(§ 네트워크 디버그 로거로 code/field 기록 — 토큰/PII 제외).
- `verifyEmail`/`resetPassword`는 추가로 `failureReason: String`을 주므로, 있으면 사용자 문구 보강에 활용(원문 로깅은 금지).
- `field`가 오면 해당 입력 필드 밑에 인라인 에러로 표시.

### 6.5 repository 매핑
- `AuthRepository`(인터페이스) + `AuthRepositoryImpl`(구현). 반환 타입은 도메인 `model`(예: `AuthSession`, `AuthUser`/`Me`, `EmailVerificationHandle`). 생성/수동 GraphQL 타입은 밖으로 새지 않는다.

---

## 7. 기능 요구사항 — 상태관리 (Riverpod)

- **`AuthController`**(`@riverpod`, `AsyncNotifier` 형태)가 앱 전역 인증 상태를 소유:
  - `build()`에서 **세션 복원**(SecureStorage 토큰 로드 → accessToken 유효성 판정 → 만료 시 refresh 시도).
  - `signIn(email, password)` / `signUp(...)`(토큰 미발급 → 상태는 여전히 unauthenticated) / `signOut()` / `refresh()` 메서드.
  - UI에는 `AsyncValue<AuthState>` 노출.
- keep-alive: 인증 상태는 앱 전역 생존이 필요하므로 `keepAlive` 정당화(대부분의 provider는 `autoDispose` 기본).
- repository는 provider로 노출, 위젯이 직접 생성 금지(CLAUDE.md §5).
- 화면은 `ref.watch(authController.select(...))`로 필요한 슬라이스만 구독.

---

## 8. 기능 요구사항 — 보안 · 토큰 저장

- **`SecureStorage`**(`common/storage/`)가 `flutter_secure_storage`를 감싸는 **유일한** 지점. 액세스/리프레시 토큰의 read/write/delete를 제공.
- 토큰은 **절대** `SharedPreferences`·평문·로그·하드코딩 상수에 두지 않는다(CLAUDE.md §7).
- **`AuthLink`**(`common/network`)가 요청마다 SecureStorage에서 accessToken을 읽어 `Authorization: Bearer <accessToken>` 헤더에 주입.
  - link ↔ auth state 순환 의존은 Stream/Signal 패턴으로 해소(직접 provider→client→provider 사이클 금지 — CLAUDE.md §7).
  - access 만료(5분) 대응: 401/만료 응답 시 refreshToken(30일)으로 1회 갱신 → 새 토큰 저장 → 원 요청 재시도. refresh 실패 시 토큰 삭제 + 로그아웃.
- 로그아웃 시 access/refresh 토큰 완전 삭제.

---

## 9. 아키텍처 배치 (도메인 중심)

```
lib/
├── common/
│   ├── storage/
│   │   ├── app_preferences.dart          # (기존) 비밀 아님: locale/onboarding
│   │   └── secure_storage.dart           # (신규) flutter_secure_storage 래퍼 — 토큰 전용
│   └── network/                          # (신규)
│       ├── graphql_client.dart           # graphql_flutter 클라이언트 provider (엔드포인트 플랫폼별)
│       ├── auth_link.dart                # Bearer 토큰 주입 + 만료 시 refresh 링크
│       └── graphql_failure.dart          # errors / UserErrors[].code → Failure 매핑
├── domain/
│   └── auth/                             # (신규 feature)
│       ├── model/                        # AuthSession, AuthUser, Failure (순수 Dart)
│       ├── repository/                   # AuthRepository(+Impl), *.graphql(+생성물)
│       ├── provider/                     # AuthController, repository provider
│       ├── component/                    # auth_text_field, agreement_checklist 등 재사용 위젯
│       └── view/                         # login_screen, sign_up_screen, email_verification_screen, password_reset_screen
└── router/                               # (수정) 인증 redirect 가드(필수 게이트) + auth 라우트 추가
```

- **cross-feature import 금지.** auth가 필요로 하고 다른 feature도 쓸 것은 `common/`(pagination·network·storage).
- 레이어 의존 방향(CLAUDE.md §3) 엄수: `view → provider → repository → model`, GraphQL은 repository 격리.

---

## 10. 라우팅 (GoRouter)

- `Routes`에 `login`, `signUp`, `emailVerification`, `passwordReset` 추가. 온보딩 라우트는 Step 1의 것을 재사용하되 진입 조건을 계정 종속으로 변경.
- `emailVerification`은 `verificationId`를 파라미터(extra)로 받는다(회원가입 성공 후 진입). 미인증 상태에서 접근 허용되는 auth 라우트 집합에 포함.
- **redirect 우선순위(위에서부터 평가)** — 순서 `언어 → 로그인 → 온보딩 → 홈`을 강제:
  1. `언어 미선택` → `language` (Step 1 규칙 유지)
  2. `언어 선택 && 미인증` → `login`으로 강제. 미인증이 `login`/`signUp`/`emailVerification`/`passwordReset` 외 라우트에 있으면 전부 `login`으로 (홈·온보딩 우회 불가).
  3. `인증됨 && 온보딩 미완료(계정 종속 §4.3)` → `onboarding`.
  4. `인증됨 && 온보딩 완료` → `home`. 이 상태에서 `login`/`signUp`/`passwordReset`/`onboarding`에 있으면 → `home`.
- **온보딩 완료는 계정 종속(§4.3)**. Step 1의 기기 전역 `onboardingCompleted` 판정을 계정 기준(서버 필드 또는 userId별 로컬 키)으로 대체.
- 인증 상태 + 온보딩 상태는 `AuthController`/온보딩 provider를 `ref.read`/`refreshListenable`로 반영(위젯 내 임시 분기 금지).
- 라우트 파라미터는 타입 지정, 모델 객체 대신 ID 전달(로그인→회원가입 이메일 프리필은 쿼리/extra로 문자열 전달).

---

## 11. 다국어 (i18n)
- 신규 카피(로그인/회원가입 라벨·버튼·검증/서버 에러 문구)를 `lib/l10n/app_{ko,en,ja,zh}.arb`에 추가하고 gen-l10n 재생성.
- 소스 언어는 KO, 미매칭 기본은 EN(Step 1 규칙 유지).
- 하드코딩 문자열 금지.

---

## 12. 테스트 전략 (CLAUDE.md 레이어별 규칙)

| 대상 | 테스트 |
|---|---|
| `model` (AuthSession/Failure 등) | 순수 단위: 직렬화 라운드트립, 동등성, 값 로직. mock 없음. |
| `repository` (AuthRepositoryImpl) | **mock GraphQL client/link**로 유닛. 오퍼레이션 실행 + 응답→모델 매핑 확인. 반드시 포함: **`success=false`/`userErrors` 비어있지 않음 → 실패**, **최상위 `errors` → NetworkFailure**, **`registerEmailMember` 성공이 토큰 없이 `verificationId` 반환**, **`loginEmail` 성공이 `AuthTokenPayload`→`AuthSession` 매핑(expiresIn 포함)**, **`verifyEmail` `verified=true`**. |
| `provider` (AuthController) | `ProviderContainer` + repository override. 방출되는 `AsyncValue` 상태(로딩/성공/실패, 세션 복원, access 만료→refresh 갱신, refresh 만료→로그아웃, 로그아웃 시 서버 `logout` 호출) 검증. |
| `view` (login/sign_up/email_verification/password_reset) | 위젯 테스트 + provider override. 사용자가 보는 것: 비밀번호 정책 인라인 에러, **필수 약관 미동의 시 가입 버튼 비활성 / 마스터 체크 토글 동기화**, 서버 에러 문구, **가입 성공 → 인증 화면 전이**, **인증 성공 → 로그인 화면(이메일 프리필)** 검증. 내부 구현 아님. |
| 라우팅 redirect | 인증/미인증 필수 게이트 분기 유닛/위젯 테스트(미인증 → login 강제, 인증 → home). |

- 생성 코드(`*.graphql.dart`, `*.g.dart`, gen-l10n)·프레임워크 코드는 테스트하지 않는다.

---

## 13. 확정 사항 (Resolved) ✅

모든 미결 질문이 확정되었고, **v3.0에서 실제 서버 스키마로 검증**되었다(`schema/schema.graphql`).

| # | 질문 | 확정 답변 (실제 스키마 검증) | 반영 위치 |
|---|---|---|---|
| Q1 | GraphQL 스키마 확인 | **완료.** introspection 성공, `schema/`에 보존. 가정 오퍼레이션(`signUp`/`login`)은 **서버에 없어 폐기**, 실제 명명으로 교체. | §6.2 |
| Q2 | 인증 방식/토큰 | **accessToken + refreshToken**, `AuthTokenPayload`가 `tokenType`(Bearer)·`expiresIn`(초) 제공. 만료는 응답값 사용(기본 5분/30일). | §6.3, §8 |
| Q3 | 회원가입 필드/비번 정책 | 이메일·비밀번호 + **`ageVerified`(연령)·`agreements`(약관) 필수**. 닉네임 등은 서버 부여(`Me.nickname`). 비번: 영문+숫자+특수문자 8자↑. | §5.2 |
| Q4 | 회원가입 응답 | **토큰 미발급.** `verificationId` 반환 → **이메일 인증(`verifyEmail`) 필수** → 이후 로그인. | §4.2, §5.2, §5.3 |
| Q5 | 에러 규약 | 페이로드 `success` + `userErrors: [UserError!]!`(`code: String!`, `message`, `field`). **code는 enum 아님** → 실제 문자열은 디버그 로그로 수집. | §6.4 |
| Q6 | 로컬 호스트 접근 | iOS `localhost:8888` / Android `10.0.2.2:8888`. `--dart-define`로 주입. | §6.1 |
| Q7 | 비밀번호 재설정 범위 | **In Scope. 코드 기반 2단계**(`requestPasswordReset` → `resetPassword(email,code,newPassword)`). | §5.4 |
| + | 이메일 인증 | **필수 플로우로 확정**(서버가 강제). 가입→`verifyEmail`→로그인. `resendVerification`으로 재발송. | §5.3, §6.2 |
| + | 언어/로그인/온보딩 순서 | `언어선택 → 로그인/회원가입(필수) → 온보딩 → 홈`. | §1, §4.1, §10 |
| + | 온보딩 1회 기준 | **계정별 최초 로그인 1회.** 서버에 온보딩 필드 **없음** → userId별 로컬 키(§4.3-B) 확정. | §4.3, §10 |

### 구현 착수 시 런타임으로 확정할 것 (스키마엔 없음)
- **`UserError.code`의 실제 문자열 값** — 스키마상 `String`이라 상수가 노출 안 됨. 잘못된 로그인·중복 이메일·잘못된 인증코드 등을 실제로 호출해 디버그 로그(`GraphqlDebugLog`)로 code를 수집하고 `AuthFailure.fromCode` 매핑을 확정한다.
- **비밀번호 정책의 서버 측 정확한 규칙**(특수문자 허용 범위 등) — `userErrors`/`failureReason`으로 관측.
- 필수 약관의 정확한 집합(현재 `SERVICE`/`PRIVACY`/`LOCATION` 필수, `MARKETING` 선택으로 가정 — 서비스 정책 확인).

---

## 14. 인수 조건 (Acceptance Criteria)

1. 언어를 고른 미인증 사용자는 **로그인 화면에 강제 진입**하며, 로그인 없이는 온보딩·홈/본 기능에 접근할 수 없다(필수 게이트, 온보딩보다 선행).
2. 유효한 자격증명으로 **로그인**하면 access(5분)+refresh(30일) 토큰이 `flutter_secure_storage`에 저장된다. 그 계정이 온보딩을 아직 안 봤으면 **온보딩 → 홈**, 봤으면 곧장 **홈**으로 간다(계정별 1회, §4.3).
3. **회원가입**: 이메일/비밀번호 입력 + **필수 약관 동의 + 연령 확인**을 마쳐야 제출 버튼이 활성화된다. 비밀번호 정책(영문+숫자+특수문자 8자↑) 위반은 제출 전 인라인 에러, 서버 `userErrors`(예: 이메일 중복)는 명확한 문구로 표시. **성공 시 `verificationId`로 이메일 인증 화면으로 이동**한다.
4. **이메일 인증**: 코드 입력 → `verifyEmail` 성공(`verified=true`) 시 로그인 화면(이메일 프리필). **코드 재발송** 가능.
5. **로그인**: `loginEmail` 성공 시 토큰이 `flutter_secure_storage`에 저장되고 `me` 조회로 유저가 확립된다. 온보딩 미완료 계정은 온보딩→홈, 완료 계정은 홈.
6. 앱을 **재실행**하면 저장 토큰으로 **자동 로그인**된다. accessToken 만료 시 refreshToken으로 조용히 갱신된다.
7. **로그아웃**하면 로컬 토큰 삭제 + 서버 `logout(refreshToken)` 호출로 서버 측 토큰도 무효화되고 로그인 화면으로 돌아간다.
8. **비밀번호 재설정**(코드 기반 2단계)으로 새 비밀번호를 설정할 수 있다.
9. GraphQL 실패(`success=false`/`userErrors` 비어있지 않음/최상위 `errors`)가 **실패로 처리**되고, 디버그 빌드에서만 code/원인이 로깅되며 **토큰/PII는 어떤 빌드에서도 로그에 남지 않는다**.
10. 레이어 경계(§9)·의존 방향·GraphQL 격리가 지켜지고, 레이어별 테스트(§12)가 통과한다.
11. 모든 신규 카피가 4개 언어(EN/KO/JA/ZH)로 제공된다.

---

## 15. 향후 단계 (참고)
- **Step 3**: SNS 회원가입/로그인(`registerSnsMember`/`loginSns` — 카카오·구글·애플).
- **홈 스크린**(별도 기능, step 무관): `problem/k_trip_spot_홈_스크린_개발.md` 참조. 관광 데이터 서버 API 도입 시 목 데이터 교체.
- 후속: 프로필 편집/회원 탈퇴(`withdrawMember`), 관리자 기능, 실기기용 LAN 엔드포인트 설정.
