# 이으리(ieuri) k-trip-spot SNS 회원 기능 개발 — 요구사항 분석서

> **Step 3**: **SNS(구글·카카오·애플) 회원가입 · 로그인**을 구현한다.
> Step 2(이메일 회원가입/로그인/자동 로그인)의 인프라(`common/network`·`common/storage`·`AuthController`·라우팅 가드)를 **그대로 재사용**하고, 그 위에 SNS 인증 경로를 얹는다.
> 서버는 로컬 GraphQL 엔드포인트(`http://localhost:8888/graphql`, Android 에뮬 `10.0.2.2`)를 호출한다.

---

## 0. 문서 정보

| 항목 | 내용 |
|---|---|
| 대상 앱 | `ieuri_k_trip_spot` (Flutter, 외국인 대상 실시간 위치기반 한국 관광 앱) |
| 대상 서버 | `ieuri` (Kotlin/Spring Boot 4, Netflix DGS GraphQL, `org.around.ieuri.auth`) |
| 이번 단계 | Step 3 — SNS 회원 기능(구글·카카오·애플 회원가입 · 로그인) |
| 상태 | **요구사항 분석 / 승인 대기** (구현 착수 전) |
| 데이터 계층 | **GraphQL** (`graphql_flutter` + `graphql_codegen`), 엔드포인트 `http://localhost:8888/graphql` |
| SNS SDK | **공식 네이티브 SDK** — `google_sign_in`, `sign_in_with_apple`, `kakao_flutter_sdk_user` (확정) |
| 보안 | 토큰/시크릿은 **`flutter_secure_storage`** (via `common/storage`) — 비밀값은 절대 `SharedPreferences`/평문/로그 금지 |
| 근거 규약 | 앱 `CLAUDE.md`(도메인 중심·레이어·Riverpod·GraphQL 격리·보안), 서버 `CLAUDE.md`(DDD·헥사고날·CQRS) |
| 선행 단계 | Step 1(테마·다국어·스플래시·온보딩·라우팅), Step 2(이메일 auth 도메인·GraphQL/토큰 인프라) 완료 |
| 선행 서버 명세 | `ieuri-server/problem/회원_기능_개발.md`, `로그인_기능_개발.md` (SNS 서버 로직 이미 확정·구현됨) |
| 선행 앱 명세 | `problem/k_trip_spot_회원_기능_개발.md`(Step 2, 이메일) |

### 개정 이력
- v1.0 — 본 분석서(SNS 회원가입/로그인, 앱 식별자 통일, 서버 실검증기 구현 포함)

### 이 문서의 확정 사항 (사용자 승인 완료)
1. **앱 식별자 통일**: 전 플랫폼을 **`kr.ieuri.ktripspot`** 로 통일한다(§3).
2. **서버 범위**: SNS `id_token` **실검증기(구글·애플·카카오) 구현을 포함**한다. 현재 `DevSnsIdentityVerifier`(서명/발급자/audience 미검증 base64 디코드 stub)를 실검증 어댑터로 교체한다(§8).
3. **클라이언트 인증 방식**: **공식 네이티브 SDK**로 각 provider 로그인 후 `id_token`(카카오는 OIDC id_token, 애플은 identityToken)을 서버로 전달한다(§6).
4. **SNS 회원가입 이메일 UX**: **provider값 프리필 + 사용자 수정 가능**. provider 미제공 시 직접 입력. 이메일을 수정했거나 provider 미검증이면 6자리 코드 인증(`verifyEmail`)을 거친다(§5.2, 서버 정책 그대로).

---

## 1. 개요 & 목표

Step 2가 **이메일 인증 도메인**과 그 토대(GraphQL 클라이언트·`AuthLink`·토큰 저장·라우팅 가드)를 세웠다. Step 3의 목표는 **그 토대를 그대로 재사용**해 **SNS 인증 경로**를 추가하는 것이다. 새로 만드는 것은 "SNS로 어떻게 `id_token`을 얻어 서버로 넘기느냐"와 그것을 받는 화면·오퍼레이션뿐이며, 토큰 저장·세션 복원·자동 로그인·로그아웃·라우팅은 **바꾸지 않는다**.

1. **SNS 로그인** — 구글/카카오/애플 SDK로 인증 → `id_token` 획득 → `loginSns(provider, idToken)` → 기존 회원이면 accessToken(5분)·refreshToken(30일) 발급. **미가입 회원이면 서버가 `MEMBER_NOT_FOUND`로 거부** → 앱은 그 provider의 `id_token`을 들고 **SNS 회원가입 화면으로 유도**한다.
2. **SNS 회원가입** — SNS 인증이 된 상태에서 회원가입 화면으로 넘어간다. **이메일은 반드시 받는다**(provider값 프리필·수정 가능, 미제공 시 직접 입력) + 약관 동의 + 만14세 확인 → `registerSnsMember`. 성공 시 서버 정책에 따라 이메일 검증이 필요하면(`emailVerified=false`) `verificationId`로 이메일 인증 화면, 이미 검증되면(`emailVerified=true`) 바로 로그인 유도.
3. **로그인 유지·로그아웃·자동 로그인** — Step 2 인프라 그대로. SNS로 발급받은 토큰도 이메일 토큰과 **완전히 동일하게** 저장·복원·갱신·폐기된다(서버가 주는 JWT는 provider와 무관하게 동형).
4. **앱 식별자 통일**(선행 작업) — 콘솔 등록(구글 OAuth 클라이언트·애플 Service ID/Sign in with Apple·카카오 앱) 전에 전 플랫폼 식별자를 `kr.ieuri.ktripspot`로 통일한다(§3).
5. **서버 실검증기**(백엔드) — dev stub을 provider별 실제 `id_token` 검증으로 교체한다(§8).

**핵심**: Step 2 명세(`k_trip_spot_회원_기능_개발.md`)의 §4.1 플로우(언어 → 로그인/회원가입 → 온보딩 → 홈), §7 `AuthController`, §8 토큰 저장, §10 라우팅 가드는 **재사용 대상**이다. Step 3은 그 게이트 안에 **SNS 버튼과 SNS 전용 회원가입 화면**을 추가한다.

---

## 2. 범위 (Scope)

### 2.1 In Scope — 클라이언트(Flutter)
- **SNS SDK 통합**(`pubspec.yaml`): `google_sign_in`, `sign_in_with_apple`, `kakao_flutter_sdk_user` 추가 + 플랫폼 네이티브 설정(§3, §7).
- **SNS 인증 서비스**(`domain/auth/` 내): 각 provider에서 `id_token`을 얻는 얇은 어댑터. **provider별 SDK 호출은 한 곳(예: `repository` 또는 별도 `sns/` 서비스)에만** 격리하고, 결과(`provider`, `idToken`, provider가 준 이메일/이메일검증여부/닉네임/프로필이미지)를 도메인 모델로 반환.
- **GraphQL 오퍼레이션 추가**(`auth_operations.graphql`): `LoginSns`, `RegisterSnsMember`(2개). 서버 스키마(§6.2)와 정확히 일치.
- **repository 확장**(`AuthRepository`+`Impl`): `loginSns(...)`, `registerSnsMember(...)` 메서드 추가. 생성된 `*.graphql.dart`는 repository 안에만.
- **`AuthController` 확장**: `signInSns(provider)`, `signUpSns(...)` 메서드. Step 2 `signIn`/`signUp`과 같은 상태 전이(로딩→성공/실패). **미가입(`MEMBER_NOT_FOUND`) 감지 시 회원가입 라우트로 유도하는 신호**를 UI에 노출.
- **SNS 로그인 버튼**(로그인 화면): "Continue with Google / Apple / Kakao" 3개. 각 provider 브랜드 가이드 준수(§5.1).
- **SNS 회원가입 화면**(신규, `sns_sign_up_screen.dart`): 이메일(필수, provider 프리필·수정가능) + `agreement_checklist`(Step 2 컴포넌트 재사용) + 만14세 → `registerSnsMember`. 비밀번호 입력 **없음**(§5.2).
- **이메일 인증 화면 재사용**: `registerSnsMember` 결과 `emailVerified=false` & `verificationId` 존재 시 Step 2의 `EmailVerificationScreen`으로 진입(§5.3).
- **`Provider` enum**(도메인 model): `APPLE | GOOGLE | KAKAO` — 서버 enum과 대응(하드코딩 문자열 금지).
- **엔드포인트/토큰/에러 처리**: Step 2 인프라 재사용. SNS 페이로드도 동일한 `success`+`userErrors[].code` 규약(§6.4).
- **다국어**: SNS 카피("Continue with …", provider 미제공 이메일 안내 등)를 `l10n`(EN/KO/JA/ZH)에 추가.
- **라우팅**: `snsSignUp` 라우트 추가(미인증에서 접근 가능한 auth 라우트 집합에 포함). `id_token`/provider/프리필 이메일을 typed extra로 전달(§10).
- **테스트**: 레이어별(model/repository/provider/view) — 앱 `CLAUDE.md` §8.

### 2.2 In Scope — 서버(백엔드)
- **SNS `id_token` 실검증기 구현**: `DevSnsIdentityVerifier`(단일 stub)를 provider별 실제 검증으로 교체(§8).
  - **Google**: `id_token`을 Google JWK로 **서명 검증** + `iss`(`accounts.google.com`/`https://accounts.google.com`)·`aud`(Google OAuth 클라이언트 ID)·`exp` 검증.
  - **Apple**: `identityToken`을 Apple public key(`https://appleid.apple.com/auth/keys`)로 **서명 검증** + `iss`(`https://appleid.apple.com`)·`aud`(앱 Service ID/Bundle ID)·`exp`·(가능 시)`nonce` 검증.
  - **Kakao**: OIDC `id_token`을 카카오 JWK로 서명 검증(+`iss`/`aud`(=REST API 키·앱 ID)/`exp`), 또는 access token 방식이면 카카오 사용자정보 API 조회 후 앱 ID 검증. **클라이언트가 OIDC id_token을 넘기는 방식으로 확정**(§6.1)이므로 JWK 검증 경로를 우선.
- **의존성 추가**(`build.gradle.kts`): JWK/JOSE 검증용 라이브러리(예: `nimbus-jose-jwt` 또는 Google API client) + JWK 조회용 HTTP 클라이언트(Spring `RestClient` 이미 사용 가능).
- **설정 키 추가**(`application.yaml`/`application-{profile}.yml`): provider별 `aud`(구글 클라이언트 ID·애플 Service ID·카카오 앱 키), JWK 엔드포인트, 필요 시 `iss`. 비밀 아님(공개 클라이언트 ID)이나 환경별로 분리.
- **프로파일 전략**: dev stub은 `@Profile("local")`(또는 `!prod`)로 남겨 로컬 개발에서 dev 토큰을 계속 쓸 수 있게 하고, 실검증기는 `@Profile("prod")`(또는 기본)로 활성. **포트 시그니처(`SnsIdentityVerifierPort.verify(provider, idToken): SnsIdentity`)는 그대로** — 구현만 교체(application 계층 무변경).

### 2.3 Out of Scope (명시적 제외)
- **서버 SNS 회원가입/로그인 애플리케이션·도메인 로직** — **이미 구현·확정됨**(`registerSnsMember`/`loginSns`, `MemberRegistrationService.registerBySns`, `AuthTokenService.loginBySns`, 도메인, Flyway `V1__create_member`의 `provider`/`provider_user_id`). **재정의/재구현하지 않는다.** 이번 서버 작업은 오직 **검증기 어댑터 교체 + 설정/의존성**.
- **SNS 계정 연동/통합**(같은 이메일의 google·kakao 계정 병합) — 서버 정책상 **다계정 허용**, 연동 없음(회원_기능_개발.md 결정사항).
- **자체(이메일) 회원가입/로그인** — Step 2에서 완료. 두 경로는 로그인 화면에서 공존.
- **Apple 토큰 revoke / 회원 탈퇴 시 SNS 연결 해제** — 탈퇴 스텝(서버 `withdrawMember`+`SnsTokenRevokerPort`)에서 처리. 이번 범위 밖.
- **프로필 편집·RBAC·관리자 기능** — 이후 단계.
- **httpOnly 쿠키·MFA·멀티디바이스 세션 UI** — 이후.

---

## 3. 앱 식별자 통일 (선행 작업, 확정: `kr.ieuri.ktripspot`)

> **왜 먼저 해야 하나**: 구글 OAuth 클라이언트, Apple Sign in with Apple(Service ID/App ID), 카카오 앱은 **번들 ID/패키지명 기준으로 콘솔에 등록**된다. 식별자가 플랫폼마다 다르거나 나중에 바뀌면 콘솔을 다시 등록해야 하므로, SNS 연동 전에 **하나로 확정**한다.

### 3.1 현재 상태 (조사 결과 — 실제 코드)
`kr.ieuri.ktripspot`는 **코드에 존재하지 않는다.** 현재는 **두 갈래**로 갈라져 있다:

| 플랫폼 | 현재 값 | 위치 |
|---|---|---|
| Android | `com.around.ieuri_k_trip_spot` | `android/app/build.gradle.kts` `namespace`(L8)·`applicationId`(L19) |
| Android(코틀린 패키지) | `com.around.ieuri_k_trip_spot` (선언) | `android/app/src/main/kotlin/com/around/**ieuri_flutter**/MainActivity.kt` (L1) |
| iOS | `com.around.ieuriFlutter` (+`.RunnerTests`) | `ios/Runner.xcodeproj/project.pbxproj` (L494/676/698, 테스트 L511/529/545) |
| iOS(Info.plist) | `$(PRODUCT_BUNDLE_IDENTIFIER)` 간접 참조 | `ios/Runner/Info.plist` (L13–14) |
| macOS | `com.around.ieuriFlutter.RunnerTests` (메인 타깃은 리터럴 부재) | `macos/Runner.xcodeproj/project.pbxproj` (L398/412/426) |
| Linux | `com.around.ieuri_k_trip_spot` | `linux/CMakeLists.txt` (L10 `APPLICATION_ID`) |
| Windows | (리버스-DNS 식별자 없음, CMake 프로젝트명만) | `windows/CMakeLists.txt` (L3) |
| Web | (식별자 없음, 표시명만) | `web/manifest.json` |
| pubspec | `name: ieuri_k_trip_spot` (Dart 패키지명 — **변경 안 함**) | `pubspec.yaml` (L1) |

**두 가지 불일치**:
1. **Apple(`com.around.ieuriFlutter`) vs 나머지(`com.around.ieuri_k_trip_spot`)** — 스템이 서로 다름.
2. **Android 패키지 선언 vs 디렉터리** — `MainActivity.kt`의 package는 `com.around.ieuri_k_trip_spot`인데 파일은 `.../com/around/ieuri_flutter/`에 있음(폴더명 불일치).

> Firebase 설정, `google-services.json`/`GoogleService-Info.plist`, 기존 OAuth 키, URL 스킴, entitlements는 **하나도 없다.** 따라서 식별자 변경 시 그쪽은 손댈 것이 없고, SNS 연동에서 **새로** 추가하게 된다(§7).

### 3.2 변경 대상 (전 플랫폼 → `kr.ieuri.ktripspot`)
> `applicationId`/`namespace`/`APPLICATION_ID`/`PRODUCT_BUNDLE_IDENTIFIER`는 리버스-DNS 형식(하이픈·언더스코어 없는 세그먼트)이 안전하다. `kr.ieuri.ktripspot`는 이 형식에 맞다. **Dart 패키지명(`pubspec.yaml`의 `name`)은 식별자와 별개이므로 `ieuri_k_trip_spot` 그대로 둔다.**

1. **Android**
   - `android/app/build.gradle.kts`: `namespace = "kr.ieuri.ktripspot"`, `applicationId = "kr.ieuri.ktripspot"`.
   - `MainActivity.kt`: `package kr.ieuri.ktripspot`로 변경 **+ 파일을 `android/app/src/main/kotlin/kr/ieuri/ktripspot/MainActivity.kt`로 이동**(디렉터리를 패키지에 일치). 기존 `com/around/ieuri_flutter/` 트리 제거.
   - `AndroidManifest.xml`: `package` 속성 없음(namespace 기반) — 그대로. `android:label`은 표시명이라 무관하나 원하면 정리.
2. **iOS**
   - `ios/Runner.xcodeproj/project.pbxproj`: `PRODUCT_BUNDLE_IDENTIFIER`를 `kr.ieuri.ktripspot`(3곳)·`kr.ieuri.ktripspot.RunnerTests`(3곳)로. `Info.plist`는 `$(PRODUCT_BUNDLE_IDENTIFIER)` 간접 참조라 무변경.
   - (SNS 연동에서 추가) URL 스킴/entitlements는 §7.
3. **macOS**
   - `macos/Runner.xcodeproj/project.pbxproj`: `RunnerTests` 3곳 → `kr.ieuri.ktripspot.RunnerTests`. **메인 타깃 식별자가 리터럴로 없으므로**, 빌드 설정/xcconfig에서 어떻게 해석되는지 확인 후 `kr.ieuri.ktripspot`로 명시. (macOS는 모바일 부산물일 수 있으니 실제 배포 여부에 따라 우선순위 낮춤.)
4. **Linux**: `linux/CMakeLists.txt` `APPLICATION_ID = "kr.ieuri.ktripspot"`.
5. **Windows/Web**: 리버스-DNS 식별자 없음 — 변경 불필요(표시명은 선택).

### 3.3 검증
- Android: `flutter build apk --debug`(또는 `./gradlew :app:assembleDebug`)로 패키지/네임스페이스 정합 확인, 앱 설치 후 실행.
- iOS: 프로젝트 열어 서명/번들 ID 정합 확인, 시뮬레이터 실행.
- 식별자 변경은 **기존 설치본과 다른 앱으로 인식**되므로(디버그 재설치 필요) 개발 기기에서 재설치.

---

## 4. SNS 인증 플로우 (상태 전이)

Step 2의 필수 게이트(언어 → 로그인/회원가입 → 온보딩 → 홈, §4.1)는 그대로. SNS는 **로그인 화면 안의 대체 진입점**이다.

```
[로그인 화면] (Step 2 이메일 폼 + SNS 버튼 3개)
      │  "Continue with Google/Apple/Kakao" 탭
      ▼
[provider SDK 인증]  ← google_sign_in / sign_in_with_apple / kakao_flutter_sdk_user
      │  성공: id_token(+provider가 준 email/emailVerified/nickname/picture)
      │  취소/실패: 로그인 화면 유지(에러 문구)
      ▼
loginSns(provider, idToken)  ─────────────────────────────┐
      │                                                    │
 ┌────┴─────┐                                              │
 ▼          ▼                                              │
성공        실패                                            │
토큰 저장    ├─ MEMBER_NOT_FOUND ──► [SNS 회원가입 화면] ◄──┘ (미가입 → 가입 유도)
→ me 조회   │      이메일(provider 프리필·수정) + 약관 + 만14세
→ 온보딩판정 │            │
            │      registerSnsMember(provider, idToken, email, ageVerified, agreements)
            │            │
            │      ┌─────┴──────┐
            │      ▼            ▼
            │    성공          실패
            │  emailVerified?  userErrors
            │   ├─ true ──► [로그인 화면] → 다시 "Continue with X" (또는 자동 loginSns 재시도)
            │   └─ false(+verificationId) ──► [이메일 인증 화면] → verifyEmail → 로그인
            │
            └─ 그 외 userErrors(예: 상태 비활성) ──► 에러 문구, 로그인 화면 유지
```

### 4.1 핵심 규칙
- **로그인 화면에서 자동 가입 없음**: `loginSns`가 `MEMBER_NOT_FOUND`면 서버는 가입시키지 않는다(로그인_기능_개발.md 결정). 앱이 **명시적으로 회원가입 화면으로 유도**한다. 이때 방금 받은 `id_token`과 provider, provider가 준 이메일을 **회원가입 화면으로 넘긴다**(재인증 없이 바로 가입).
  - **주의**: `id_token`은 짧은 만료(수 분~1시간)를 가진다. 회원가입 화면에서 사용자가 오래 머물면 만료될 수 있으므로, **`registerSnsMember` 제출 직전 만료가 의심되면 provider SDK로 조용히 재인증**해 새 `id_token`을 얻는 폴백을 둔다(선택 구현, 실패 시 사용자에게 "다시 시도" 안내).
- **회원가입 성공 후 토큰 없음**: `registerSnsMember` 페이로드는 `AuthTokenPayload`가 아니라 `RegisterSnsMemberPayload`(토큰 미발급). Step 2와 동일하게 **가입 후 로그인 필요**. 단 `emailVerified=true`면 이메일 인증을 건너뛰고 바로 로그인 유도.
- **이메일 검증 분기**(서버 정책, 회원_기능_개발.md §가입흐름):
  - 제출 이메일 == provider가 **검증해 준** 이메일 → `emailVerified=true`, 인증메일 없음 → 바로 로그인.
  - 사용자가 **수정**했거나 provider **미검증** → `emailVerified=false` + `verificationId` → **이메일 인증 화면**(Step 2 재사용).
- **토큰/세션/자동로그인/로그아웃**: SNS로 발급된 JWT는 이메일 경로와 동형. Step 2의 저장·복원·refresh·logout을 **그대로** 탄다(§8은 무변경).

---

## 5. 기능 요구사항 — 화면 (View)

### 5.1 로그인 화면 확장 — `login_screen.dart`
- 기존 이메일 폼 아래(또는 구분선 "or") **SNS 버튼 3개** 추가: **Continue with Google · Continue with Apple · Continue with Kakao**.
- 각 버튼: provider 브랜드 가이드(색/로고/문구) 준수. **Apple 버튼은 iOS/macOS에서 필수 노출**(App Store 심사 규정: 타 소셜 로그인 제공 시 Apple 로그인도 제공). Android에서 Apple 버튼 노출 여부는 정책 결정(웹 기반 Sign in with Apple 사용 가능).
- 탭 → provider SDK 인증 → `signInSns(provider)` 호출. 진행 중 로딩(버튼 비활성/스피너), 취소는 조용히 원복, 실패는 에러 문구.
- **미가입(`MEMBER_NOT_FOUND`)** → SNS 회원가입 화면으로 이동(§5.2), 성공한 `id_token`·provider·프리필 이메일 전달.
- 다국어: 버튼/에러 문구 모두 `l10n`.

### 5.2 SNS 회원가입 — `sns_sign_up_screen.dart` / `SnsSignUpScreen`
- **진입 조건**: SNS 인증이 이미 성공한 상태(`id_token` 보유). 이 화면에서 provider 로그인을 다시 하지 않는다.
- 입력:
  - **이메일(필수)** — **provider가 준 이메일을 프리필하되 수정 가능**. provider 미제공(카카오 무이메일/애플 미제공/2회차 애플)이면 **빈 칸으로 직접 입력**. 형식 검증(RFC 기본).
  - **약관 동의 · 만14세** — Step 2의 **`agreement_checklist` 컴포넌트 재사용**(마스터 전체동의 + SERVICE/PRIVACY/LOCATION 필수 + MARKETING 선택 + 만14세). 필수 미충족 시 제출 버튼 비활성.
  - **비밀번호 입력 없음** — SNS 가입은 비밀번호를 받지 않는다.
- 액션: **가입하기** → `registerSnsMember(provider, idToken, email, ageVerified, agreements)`.
  - 성공 & `emailVerified=true` → **로그인 화면**(가입 이메일 프리필), 안내 문구.
  - 성공 & `emailVerified=false`(+`verificationId`) → **이메일 인증 화면**(§5.3).
  - 실패 → `userErrors[].code`/`field` 매핑(이메일 중복·약관 미동의·연령 미확인·`id_token` 만료 등).
- 안내 문구: "구글/카카오/애플 계정으로 인증되었습니다. 가입을 완료하려면 이메일과 약관 동의가 필요합니다."(l10n). provider 미제공 이메일 케이스는 "이메일을 입력해 주세요" 안내.

### 5.3 이메일 인증 화면 — **Step 2 `EmailVerificationScreen` 재사용**
- `registerSnsMember` 결과 `emailVerified=false` & `verificationId` 존재 시 진입. Step 2와 **동일 화면·동일 오퍼레이션**(`verifyEmail`/`resendVerification`). 신규 화면 만들지 않는다.
- 인증 완료(`verified=true`) → 로그인 화면(이메일 프리필).

### 5.4 공용 컴포넌트
- **재사용**: `auth_text_field`, `agreement_checklist`, `auth_failure_message`(모두 Step 2 `domain/auth/component/`).
- **신규(선택)**: `sns_login_button`(provider별 브랜드 버튼) — 로그인 화면에서만 쓰이면 `domain/auth/component/`. 다른 feature가 쓰지 않으므로 `common/` 승격 불필요.

---

## 6. 기능 요구사항 — 데이터 계층 (GraphQL & SNS SDK)

> GraphQL 격리(앱 `CLAUDE.md` §3): 생성된 `*.graphql.dart`·클라이언트는 **repository 안에만**. provider SDK 호출(`google_sign_in` 등)도 **repository(또는 그 아래 SNS 서비스)에만** 격리하고, `view`/`provider`는 도메인 모델만 본다.

### 6.1 SNS SDK — provider별 `id_token` 획득 (확정: 공식 네이티브 SDK)
| provider | 패키지 | 획득값 | 서버로 전달 |
|---|---|---|---|
| Google | `google_sign_in` | `GoogleSignInAuthentication.idToken` | `idToken` |
| Apple | `sign_in_with_apple` | `AuthorizationCredentialAppleID.identityToken` | `idToken`(= identityToken). **이름/이메일은 최초 1회만 옴** → 프리필에 사용, 없으면 사용자 입력. |
| Kakao | `kakao_flutter_sdk_user` | 카카오톡/카카오계정 로그인 → **OIDC `idToken`** | `idToken`. (카카오는 OIDC id_token을 넘기는 방식으로 확정 → 서버는 카카오 JWK로 검증) |

- **provider가 주는 부가정보**(email/email_verified/nickname/picture)는 프리필·표시에만 쓴다. **신뢰 경계는 서버**: 서버가 `id_token`을 재검증하고 최종 이메일 검증 여부를 판정한다.
- SDK 초기화: 카카오는 앱 시작 시 네이티브 앱 키로 `KakaoSdk.init(...)` 필요(§7). 구글/애플은 별도 초기화 최소.

### 6.2 GraphQL 오퍼레이션 (서버 스키마 기준 — 실제 `auth.graphqls` 확인 완료)

> 아래는 서버 `src/main/resources/schema/auth.graphqls`의 실제 SNS 타입이다. Step 2의 공통 페이로드 규약(`success` + `userErrors: [UserError!]!`, `UserError { code: String!, message, field }`)을 그대로 따른다.

```graphql
# SNS 로그인 — 기존 회원만. 성공 시 AuthTokenPayload(이메일 로그인과 동형).
mutation LoginSns($input: LoginSnsInput!) {
  loginSns(input: $input) {
    success
    userErrors { code message field }
    accessToken refreshToken tokenType
    accessTokenExpiresIn refreshTokenExpiresIn
  }
}
# input LoginSnsInput { provider: Provider!, idToken: String! }
# enum Provider { APPLE, GOOGLE, KAKAO }
# 미가입 시: success=false, userErrors[].code = (관측 필요, 예: MEMBER_NOT_FOUND)

# SNS 회원가입 — 토큰 미발급. emailVerified / (미검증 시)verificationId 반환.
mutation RegisterSnsMember($input: RegisterSnsMemberInput!) {
  registerSnsMember(input: $input) {
    success
    userErrors { code message field }
    emailVerified
    verificationId
  }
}
# input RegisterSnsMemberInput {
#   provider: Provider!, idToken: String!,
#   email: String!,               # 폼 제출 이메일(필수, provider 프리필·수정 가능)
#   ageVerified: Boolean!,
#   agreements: [AgreementInput!]!
# }
# input AgreementInput { termsCode: TermsCode!, agreed: Boolean! }
# enum TermsCode { SERVICE, PRIVACY, LOCATION, MARKETING }
```

- **재사용 오퍼레이션**(Step 2에 이미 존재, 추가 구현 불필요): `VerifyEmail`, `ResendVerification`, `RefreshToken`, `Logout`, `Me`. SNS 경로도 이들을 그대로 탄다.
- `graphql_codegen` 입력 SDL(`auth_schema.graphql`)에 `registerSnsMember`/`loginSns`/`RegisterSnsMemberInput`/`LoginSnsInput`/`Provider` 타입이 포함돼야 함 → introspection 스냅샷에서 갱신(앱 `CLAUDE.md` §13 스키마-우선 규약 준수: 구현 착수 시 `localhost:8888/graphql` 재introspection).

### 6.3 토큰 정책
- Step 2와 동일. `loginSns` → `AuthTokenPayload`(accessToken·refreshToken·tokenType=`Bearer`·`*ExpiresIn`) → `SecureStorage.writeTokens(...)`. `me` 별도 조회로 유저 확립. **SNS라고 달라지는 것 없음.**

### 6.4 에러 처리
- Step 2 §6.4 규약 재사용: `success==false` 또는 `userErrors` 비어있지 않음 → 도메인 실패. 최상위 `errors`/링크 예외 → `NetworkFailure`.
- **런타임으로 확정할 code**(스키마상 `String`이라 상수 미노출):
  - `loginSns` 미가입 → **미가입 유도의 트리거**가 되는 code(예상 `MEMBER_NOT_FOUND`) — **디버그 로그로 실제 문자열 수집 후 `AuthFailure`에 매핑**. 이 매핑이 §4의 "회원가입 유도" 분기를 결정하므로 **정확한 code 확인이 필수**.
  - `registerSnsMember` 이메일 중복·약관/연령 미충족·`id_token` 무효/만료 code도 동일하게 수집.
- 토큰/PII/원문 `id_token`은 **어떤 빌드에서도 로그 금지**(`GraphqlDebugLog`는 code/field만, 디버그 빌드 한정).

### 6.5 repository 매핑
- `AuthRepository`에 `loginSns(SnsCredential)`, `registerSnsMember(SnsRegistration)` 추가. 반환은 도메인 model(`AuthSession`, `Me`, `SnsRegistrationResult{emailVerified, verificationId?}`). provider SDK 타입·GraphQL 생성 타입은 밖으로 새지 않는다.

---

## 7. 플랫폼 네이티브 설정 (SNS SDK 요구)

> 콘솔 등록은 §3의 통일된 식별자 `kr.ieuri.ktripspot` 기준으로 한다. 아래는 **코드/설정 파일에 들어갈 항목**이며, 실제 키/클라이언트 ID는 각 콘솔에서 발급받아 **`--dart-define` 또는 gitignore된 설정으로 주입**(하드코딩·커밋 금지).

### 7.1 Google (`google_sign_in`)
- **Android**: OAuth 클라이언트(Android, 패키지 `kr.ieuri.ktripspot` + SHA-1) 등록. `google-services.json` 사용 시 `android/app/`에 배치(현재 없음 → 신규). serverClientId(웹 클라이언트 ID)로 `id_token` audience 지정.
- **iOS**: OAuth 클라이언트(iOS, 번들 `kr.ieuri.ktripspot`) 등록. `Info.plist`에 **reversed client ID URL 스킴** 추가. `GoogleService-Info.plist` 또는 클라이언트 ID를 SDK에 주입.

### 7.2 Apple (`sign_in_with_apple`) — iOS 네이티브만 (확정)
- **iOS/macOS**: **"Sign in with Apple" Capability** 추가 → `ios/Runner/Runner.entitlements`(현재 없음 → 신규)에 `com.apple.developer.applesignin`. App ID(`kr.ieuri.ktripspot`)에 해당 capability 활성.
- **Android/웹 Apple 버튼은 이번 범위 밖(확정)** → Service ID·Return URL·`.p8` 키 **불필요**. Android에는 Apple 버튼을 노출하지 않는다(§5.1).
- 서버 `aud` 검증값 = **앱 Bundle ID `kr.ieuri.ktripspot`(확정)**. identityToken의 `aud`가 Bundle ID이므로 서버는 그것만 검증(§8.3).

### 7.3 Kakao (`kakao_flutter_sdk_user`)
- 카카오 개발자 콘솔에 앱 등록, **네이티브 앱 키/REST API 키** 발급. OIDC 활성화(id_token 수령).
- **앱 시작 시** `KakaoSdk.init(nativeAppKey: ...)` 호출(키는 `--dart-define` 주입).
- **Android**: `AndroidManifest.xml`에 카카오 로그인 리다이렉트용 `AuthCodeHandlerActivity` 스킴(`kakao{NATIVE_APP_KEY}://oauth`) 추가.
- **iOS**: `Info.plist`에 `LSApplicationQueriesSchemes`(`kakaokompassauth`, `kakaolink`) + 커스텀 URL 스킴(`kakao{NATIVE_APP_KEY}`) 추가.
- 서버 `aud` 검증값 = 카카오 앱 ID/REST API 키(§8).

### 7.4 시크릿 관리
- 네이티브 앱 키·클라이언트 ID는 **공개 식별자**(민감도 낮음)지만, 저장소 정책상 `--dart-define`/gitignore 설정으로 주입하고 하드코딩·커밋을 피한다. `google-services.json`/`GoogleService-Info.plist`/`Runner.entitlements`의 커밋 여부는 팀 정책에 따름(보통 gitignore).

---

## 8. 서버 — SNS `id_token` 실검증기 구현 (백엔드 In Scope)

> **불변**: `registerBySns`/`loginBySns`/스키마/도메인/Flyway는 이미 확정·구현됨 — **건드리지 않는다.** 이 절의 작업은 **outbound 어댑터 1개(검증기) 교체 + 설정/의존성**뿐이며, application/domain 계층은 무변경(포트 뒤 격리).

### 8.1 현재 상태
- `application/port/out/client/ClientPorts.kt`: `interface SnsIdentityVerifierPort { fun verify(provider: Provider, idToken: String): SnsIdentity }`, `data class SnsIdentity(providerUserId, email?, emailVerified, nickname?, profileImageUrl?)`.
- `infrastructure/adapter/out/client/DevSnsIdentityVerifier.kt` (`@Component`): `id_token`을 **base64url 디코드만** 하고 **서명/iss/aud/exp를 검증하지 않음**. 클래스 주석에 `TODO(prod)` 명시.

### 8.2 목표 구현
포트 시그니처 그대로, provider별 실검증으로 교체:

- **`GoogleIdTokenVerifier`** — Google JWK(`https://www.googleapis.com/oauth2/v3/certs`)로 서명 검증, `iss ∈ {accounts.google.com, https://accounts.google.com}`, `aud == 구글 OAuth 클라이언트 ID`(설정), `exp` 유효. 클레임 → `SnsIdentity`(sub=providerUserId, email, email_verified, name/given_name, picture).
- **`AppleIdTokenVerifier`** — Apple JWK(`https://appleid.apple.com/auth/keys`)로 서명 검증, `iss == https://appleid.apple.com`, **`aud == kr.ieuri.ktripspot`(Bundle ID, 확정)**, `exp` 유효, (전달되면)`nonce` 대조. Apple은 최초만 email 제공 → 없으면 `SnsIdentity.email=null`(폼에서 직접 입력).
- **`KakaoIdTokenVerifier`** — 카카오 OIDC JWK로 서명 검증, `iss`(카카오 OIDC issuer), `aud == 카카오 앱 키`(설정), `exp` 유효. (또는 access token 방식이면 카카오 userinfo API 조회 — 단, §6.1에서 OIDC id_token 확정이므로 JWK 경로.)
- **디스패치**: `SnsIdentityVerifierPort` 구현이 `provider`로 3개 검증기에 위임(예: `CompositeSnsIdentityVerifier`가 `Map<Provider, ProviderVerifier>` 주입), 또는 각 provider별 검증 로직을 한 어댑터에서 `when(provider)` 분기.

### 8.3 프로파일 & 설정
- **dev stub 유지**: `DevSnsIdentityVerifier`에 `@Profile("local")`(또는 `@Profile("!prod")`) → 로컬에서 dev 토큰으로 계속 개발. 실검증기는 `@Profile("prod")`(또는 기본, `@Primary`/`@ConditionalOnProperty`로 전환). **로컬 개발 흐름을 깨지 않는 것**이 중요.
- **설정 키**(`application.yaml` + 프로파일별):
  ```yaml
  ieuri:
    sns:
      google:
        client-id: ${GOOGLE_OAUTH_CLIENT_ID}      # aud 검증값
        jwks-uri: https://www.googleapis.com/oauth2/v3/certs
      apple:
        audience: kr.ieuri.ktripspot               # Bundle ID (iOS 네이티브만, 확정)
        jwks-uri: https://appleid.apple.com/auth/keys
        issuer: https://appleid.apple.com
      kakao:
        app-key: ${KAKAO_APP_KEY}                  # aud 검증값
        jwks-uri: https://kauth.kakao.com/.well-known/jwks.json
  ```
  - 클라이언트 ID/앱 키는 공개 식별자지만 환경별 분리. `prod`는 환경변수(fail-fast).
- **의존성**(`build.gradle.kts`): JOSE/JWK 검증 라이브러리(예: `com.nimbusds:nimbus-jose-jwt` 또는 `com.google.api-client:google-api-client`) + JWK 캐시. HTTP는 Spring `RestClient`(이미 가용). jjwt(HS256, 이미 있음)는 **자체 토큰용**이지 외부 RS256 id_token 검증엔 부적합하므로 별도 라이브러리 필요.

### 8.4 서버 테스트 (서버 `CLAUDE.md` §test)
- 각 검증기 유닛: **유효 토큰**(테스트 키페어로 서명) → `SnsIdentity` 매핑, **서명 불일치/`aud` 불일치/`exp` 만료/`iss` 불일치** → 검증 실패. JWK 조회는 스텁/고정 키.
- 포트 계약 불변 확인(application 계층 무변경) → 기존 `MemberRegistrationService`/`AuthTokenService` 테스트 그대로 통과.
- 외부 시스템(실 Google/Apple/Kakao 엔드포인트)은 테스트에서 호출하지 않음(메모리 [[test-scope-policy]]: app-external 시스템 제외, 클라이언트 목).

---

## 9. 아키텍처 배치

### 9.1 클라이언트 (도메인 중심, 앱 `CLAUDE.md` §2–§4)
```
lib/
├── domain/auth/
│   ├── model/
│   │   ├── sns_provider.dart          # (신규) enum SnsProvider { google, apple, kakao } ↔ 서버 Provider
│   │   ├── sns_credential.dart        # (신규) provider + idToken + provider가 준 email/nickname 등
│   │   └── sns_registration_result.dart # (신규) emailVerified + verificationId?
│   ├── repository/
│   │   ├── sns_authenticator.dart     # (신규) provider SDK 호출 격리(google_sign_in/apple/kakao) → SnsCredential
│   │   ├── auth_repository.dart       # (수정) loginSns / registerSnsMember 추가
│   │   ├── auth_repository_impl.dart  # (수정) 위 구현 + 매핑
│   │   └── auth_operations.graphql    # (수정) LoginSns / RegisterSnsMember 추가
│   ├── provider/
│   │   └── auth_controller.dart       # (수정) signInSns / signUpSns + MEMBER_NOT_FOUND 유도 신호
│   ├── component/
│   │   └── sns_login_button.dart      # (신규) provider 브랜드 버튼(재사용: agreement_checklist 등)
│   └── view/
│       ├── login_screen.dart          # (수정) SNS 버튼 3개
│       └── sns_sign_up_screen.dart    # (신규) 이메일 프리필 + 약관 + 만14세
└── router/app_router.dart             # (수정) snsSignUp 라우트 + 미인증 허용 auth 라우트에 포함
```
- provider SDK 호출은 `sns_authenticator.dart`에만 격리(`view`/`provider`는 도메인 모델만). 교체·모킹 용이.
- cross-feature import 금지. 토큰/네트워크는 `common/` 재사용.

### 9.2 서버 (DDD·헥사고날·CQRS, 서버 `CLAUDE.md`)
```
org/around/ieuri/auth/
├── application/port/out/client/ClientPorts.kt   # (불변) SnsIdentityVerifierPort — 시그니처 유지
└── infrastructure/adapter/out/client/
    ├── DevSnsIdentityVerifier.kt      # (수정) @Profile("local")
    ├── GoogleIdTokenVerifier.kt       # (신규) JWK 서명+aud+iss+exp
    ├── AppleIdTokenVerifier.kt        # (신규)
    ├── KakaoIdTokenVerifier.kt        # (신규)
    └── CompositeSnsIdentityVerifier.kt# (신규) provider 디스패치 → @Profile("prod")/@Primary
```
- **검증기는 outbound 어댑터** — application/domain 무변경. 포트 뒤에서 구현만 교체.

---

## 10. 라우팅 (GoRouter)

- `Routes`에 **`snsSignUp`**(`/sns-sign-up`) 추가. **미인증에서 접근 허용되는 auth 라우트 집합**(`login`/`signUp`/`emailVerification`/`passwordReset`)에 포함.
- `snsSignUp`은 typed extra로 **`SnsSignUpArgs(provider, idToken, prefilledEmail?, emailVerifiedByProvider)`** 를 받는다(모델 객체 대신 최소 값 전달). `id_token`은 라우트 파라미터로 넘기되 로그/URL 노출 최소화(extra 사용, 쿼리스트링 금지).
- redirect 우선순위(Step 2 §10)는 그대로. SNS 회원가입도 "언어 선택 && 미인증 → auth 라우트 허용" 규칙 안에서 동작.
- `registerSnsMember` 성공 후: `emailVerified=false`면 `emailVerification`(Step 2 라우트, `verificationId` 전달), `true`면 `login`(이메일 프리필). 위젯 내 임시 분기 금지 — 컨트롤러 상태 + redirect/명시 네비게이션.

---

## 11. 다국어 (i18n)

- 신규 카피를 `lib/l10n/app_{ko,en,ja,zh}.arb`에 추가하고 gen-l10n 재생성:
  - `continueWithGoogle` / `continueWithApple` / `continueWithKakao`
  - `orDivider`("or"/"또는")
  - `snsSignUpTitle` / `snsSignUpSubtitle`(예: "SNS 계정으로 인증되었습니다. 가입을 완료해 주세요.")
  - `snsEmailPrefillHint`(provider 미제공 이메일: "이메일을 입력해 주세요")
  - SNS 실패 문구(취소/네트워크/미가입 유도 안내 등)
- 소스 언어 KO, 미매칭 기본 EN(Step 1 규칙). 하드코딩 문자열 금지.

---

## 12. 테스트 전략

### 12.1 클라이언트 (앱 `CLAUDE.md` §8, 레이어별)
| 대상 | 테스트 |
|---|---|
| `model` (`SnsProvider`/`SnsCredential`/`SnsRegistrationResult`) | 순수 단위: enum↔서버 Provider 매핑, 값 로직. mock 없음. |
| `repository` (`AuthRepositoryImpl.loginSns/registerSnsMember`) | **mock GraphQL client**로 유닛. 오퍼레이션 실행 + 매핑 확인. 필수: **`loginSns` 성공→`AuthSession`(expiresIn 포함)**, **`loginSns` 미가입(`MEMBER_NOT_FOUND`)→도메인 실패로 식별**, **`registerSnsMember` `emailVerified=true`(verificationId 없음) vs `false`(+verificationId) 분기 매핑**, **`userErrors`/최상위 `errors`→실패**. |
| `repository` (`SnsAuthenticator`) | provider SDK를 **모킹**(플랫폼 채널). 각 provider가 `SnsCredential`(provider+idToken)을 반환/취소 시 도메인 취소 실패. **실 provider 호출 금지**([[test-scope-policy]]). |
| `provider` (`AuthController.signInSns/signUpSns`) | `ProviderContainer` + repository override. 방출 `AsyncValue`: 로딩→성공(토큰 저장·me), **미가입→회원가입 유도 신호**, 실패. |
| `view` (`login_screen` SNS 버튼 / `sns_sign_up_screen`) | 위젯 테스트 + override. **SNS 버튼 탭→인증 호출**, **이메일 프리필 표시·수정 가능**, **필수 약관 미동의 시 가입 버튼 비활성**, **성공 시 인증/로그인 화면 전이**. |
| 라우팅 | `snsSignUp` 미인증 접근 허용, 성공 후 전이 분기. |

### 12.2 서버 (서버 `CLAUDE.md` §test)
- §8.4: 각 `*IdTokenVerifier` 유닛(유효/서명불일치/aud/iss/exp), 포트 계약 불변, 외부 엔드포인트 미호출.

- 생성 코드(`*.graphql.dart`, `*.g.dart`, gen-l10n)·프레임워크·DGS codegen은 테스트하지 않는다.

---

## 13. 확정 사항 (Resolved) ✅

| # | 항목 | 확정 |
|---|---|---|
| D1 | 앱 식별자 | 전 플랫폼 **`kr.ieuri.ktripspot`** 통일(§3). Dart 패키지명은 `ieuri_k_trip_spot` 유지. |
| D2 | 서버 범위 | SNS `id_token` **실검증기(구글·애플·카카오) 구현 포함**. dev stub은 `@Profile("local")` 유지(§8). |
| D3 | 클라이언트 인증 | **공식 네이티브 SDK**(`google_sign_in`/`sign_in_with_apple`/`kakao_flutter_sdk_user`) → `id_token` 서버 전달(§6.1). |
| D4 | 회원가입 이메일 UX | **provider값 프리필 + 수정 가능**, 미제공 시 직접 입력. 수정/미검증이면 `verifyEmail`(§5.2). |
| D5 | 미가입 로그인 | 서버가 `loginSns` 미가입을 거부(자동가입 없음) → 앱이 **SNS 회원가입 유도**(§4). |
| D6 | 서버 SNS 로직 | 이미 구현·확정 → **재구현 안 함**. 이번 서버 작업은 검증기·설정·의존성뿐(§2.3, §8). |

### 구현 착수 시 런타임/콘솔로 확정할 것
1. ~~**`loginSns` 미가입 code의 실제 문자열**~~ — **확정: `MEMBER_NOT_FOUND`.** 로컬 서버 e2e로 검증(loginSns 미가입 → `success:false`, `userErrors[].code = MEMBER_NOT_FOUND`). `AuthFailure.fromCode`가 이를 `memberNotFound`로 매핑해 §4 회원가입 유도 분기를 구동한다.
2. **`registerSnsMember` 이메일 중복·`id_token` 무효/만료 code** 문자열 — 실검증기(§8)의 무효 토큰은 `SNS_VERIFICATION_FAILED`. 이메일 중복 code는 실사용 시 추가 수집.
3. **콘솔 발급값**: 구글 OAuth 클라이언트 ID(Android SHA-1 포함)·애플 App ID(Sign in with Apple)·카카오 네이티브/REST 키 — §7 설정 주입값. **준비물 상세는 §16.** **→ 모두 발급 완료(§16).**
4. **`id_token` 만료 대응 폴백** 필요 여부(회원가입 화면 체류 중 만료) — §4.1. (미구현, 필요 시 후속.)

### 구현 완료 (2026-07-28)
- **앱 식별자 통일** `kr.ieuri.ktripspot`(전 플랫폼) + Android 빌드 차단(jni/AGP9) 해결. APK packagename 검증.
- **클라이언트**: SNS 모델·`LoginSns`/`RegisterSnsMember` 오퍼레이션·repository·`AuthController`(signInSns/signUpSns)·`SnsAuthenticator`(google_sign_in v7 / sign_in_with_apple / kakao) + 네이티브 설정(iOS URL 스킴·Apple entitlement·Android Kakao) + 로그인 버튼·SNS 회원가입 화면·라우팅·4개 언어 l10n. `flutter analyze` clean, 81 테스트 통과, APK 빌드 성공.
- **서버**: `DevSnsIdentityVerifier`→실검증기(Google/Apple/Kakao JWKS 서명+iss+aud+exp, Nimbus) 교체, `@Profile("local")`/`!local` 분리, `SnsProperties`+config, `SNS_VERIFICATION_FAILED` 예외. 검증기 5 케이스 + ArchUnit 통과.
- **e2e(로컬 서버)**: loginSns 미가입→`MEMBER_NOT_FOUND`, registerSnsMember(provider 이메일)→`emailVerified:true`, 로그인→토큰(access 299s/refresh 2591999s), registerSnsMember(수정 이메일)→`emailVerified:false`+verificationId. 전 경로 확인.

---

## 14. 인수 조건 (Acceptance Criteria)

1. **앱 식별자**가 전 플랫폼에서 `kr.ieuri.ktripspot`로 통일되고, Android `MainActivity.kt`가 일치하는 디렉터리(`kotlin/kr/ieuri/ktripspot/`)에 위치하며, Android/iOS가 정상 빌드·설치·실행된다(§3).
2. **로그인 화면**에 구글·애플·카카오 버튼이 노출되고, 탭하면 해당 SDK 인증이 뜬다. 취소는 조용히 원복된다(§5.1).
3. **기존 SNS 회원**이 버튼으로 로그인하면 `loginSns`로 access(5분)+refresh(30일) 토큰이 `flutter_secure_storage`에 저장되고, `me` 확립 후 온보딩 판정→홈으로 간다(이메일 로그인과 동일 흐름).
4. **미가입 SNS 사용자**가 로그인하면 서버 거부(미가입 code)를 받아 **SNS 회원가입 화면**으로 유도되며, 방금 받은 `id_token`·provider·프리필 이메일이 넘어간다(§4).
5. **SNS 회원가입**: 이메일이 provider값으로 프리필되되 수정 가능하고, provider 미제공 시 직접 입력한다. 필수 약관·만14세 충족 시에만 제출 버튼이 활성화된다. 제출 시 `registerSnsMember`가 호출된다(§5.2).
6. `registerSnsMember` 성공 시 `emailVerified=true`면 로그인 화면(이메일 프리필)으로, `false`(+`verificationId`)면 **이메일 인증 화면**(Step 2 재사용)으로 이동해 `verifyEmail`로 인증을 완료할 수 있다(§4, §5.3).
7. SNS로 발급된 토큰도 **자동 로그인·refresh·로그아웃**이 이메일 토큰과 동일하게 동작한다(Step 2 인프라 무변경).
8. GraphQL 실패(`success=false`/`userErrors`/최상위 `errors`)가 실패로 처리되고, 디버그 빌드에서만 code/field가 로깅되며 **`id_token`·토큰·PII는 어떤 빌드에서도 로그에 남지 않는다**(§6.4).
9. **서버**: SNS `id_token`이 provider별 실검증기로 **서명·`aud`·`iss`·`exp` 검증**을 통과해야만 가입/로그인이 성립하고(§8), 로컬 프로파일에서는 dev stub으로 개발이 계속 가능하다. application/domain 계층은 변경되지 않는다(포트 계약 불변).
10. 레이어 경계(§9)·의존 방향·GraphQL 격리·provider SDK 격리가 지켜지고, 레이어별 테스트(§12)가 통과한다.
11. 모든 신규 카피가 4개 언어(EN/KO/JA/ZH)로 제공된다.

---

## 15. 향후 단계 (참고)
- **회원 탈퇴 시 SNS 연결 해제**: 서버 `withdrawMember` + `SnsTokenRevokerPort`(현재 `DevSnsTokenRevoker` stub) 실구현 — Apple 토큰 revoke 포함.
- **SNS 계정 연동/통합**(같은 사람의 google·kakao 병합) — 현재 다계정 허용, 연동 없음.
- 프로필 편집, RBAC, 관리자 기능, 실기기 LAN 엔드포인트.

---

## 16. 개발 착수 전 준비물 체크리스트 (Prerequisites — 사용자 발급 필요)

> **개발 착수 조건**: 아래 "P0(필수)" 항목이 모두 갖춰지면 착수한다. 그 전까지는 콘솔 등록값(bundle id 기준)에 막혀 실제 SNS 인증이 동작하지 않는다.
> 착수 순서상 **§3 앱 식별자 통일(`kr.ieuri.ktripspot`)이 먼저**다 — 모든 콘솔 등록이 이 식별자를 기준으로 하기 때문. 식별자 통일은 콘솔 발급 없이 진행 가능하므로, 콘솔 발급을 기다리는 동안 병행한다.
>
> **확정(사용자 답변)**: Google=Firebase 프로젝트 사용 / Apple=iOS 네이티브만(aud=Bundle ID, Service ID·`.p8` 불필요) / 전달=준비되면.
>
> **전달 시 주의**: 아래 파일·키는 저장소에 커밋하지 않는다(gitignore) — 파일은 지정 경로에 직접 배치, 문자열 키는 `--dart-define`/환경변수로 주입. 전달은 안전한 채널로.

### 16.1 공통 (선행)
| # | 항목 | 담당 | 상태 |
|---|---|---|---|
| C1 | 앱 식별자 `kr.ieuri.ktripspot`로 통일(§3) — Android/iOS/macOS/Linux | **개발(나)** | 콘솔 발급 대기 중 병행 가능 |
| C2 | Android debug SHA-1/SHA-256 지문(Firebase/Google 등록용) | **개발(나) 추출 완료** | ✅ 아래 값 |

**C2 — Android debug keystore 지문 (이 값으로 콘솔에 등록):**
```
SHA-1  : 27:27:F1:B7:65:B8:5A:D3:12:F3:9A:A7:8D:B8:0A:97:66:A2:93:D9
SHA-256: 3B:B7:8D:41:44:BF:56:53:1F:27:31:B9:22:35:DA:5E:67:F6:CA:C0:ED:B7:CE:7F:06:6A:A4:B4:F3:E4:6B:A1
```
> ⚠️ 이건 **로컬 debug keystore** 지문이다(개발용). **release/Play 앱 서명 키(및 Play App Signing 키)의 SHA-1도 별도로 등록**해야 실기기 릴리스·Play 배포에서 Google 로그인이 동작한다 → P1(배포 시).

### 16.2 Google (Firebase 프로젝트) — 사용자 발급
| # | 전달물 | 배치/사용처 | 우선순위 |
|---|---|---|---|
| G1 | **Firebase 프로젝트 생성** + Android 앱 등록(패키지 `kr.ieuri.ktripspot`, 위 SHA-1/SHA-256 등록) | 콘솔 | **P0** |
| G2 | **`google-services.json`** (Android 앱 등록 후 다운로드) | `android/app/google-services.json` | **P0** |
| G3 | Firebase에 iOS 앱 등록(번들 `kr.ieuri.ktripspot`) + **`GoogleService-Info.plist`** | `ios/Runner/GoogleService-Info.plist` | **P0** |
| G4 | **웹(server) OAuth 클라이언트 ID** — `id_token`의 `aud` 검증값(서버 §8.3 `ieuri.sns.google.client-id`) | 서버 설정 + 앱 `serverClientId` | **P0** |
| G5 | (배포 시) release/Play App Signing SHA-1 추가 등록 | 콘솔 | P1 |

> 전달 형태: G2·G3은 **파일**, G4는 **문자열**(웹 클라이언트 ID). Firebase 콘솔 > 프로젝트 설정 > 일반 탭에서 확인 가능.

### 16.3 Apple (Sign in with Apple, iOS 네이티브) — 사용자 발급
| # | 전달물 | 배치/사용처 | 우선순위 |
|---|---|---|---|
| A1 | Apple Developer에서 **App ID(`kr.ieuri.ktripspot`)에 "Sign in with Apple" capability 활성화** | Apple 콘솔 | **P0** |
| A2 | Xcode에서 **Signing & Capabilities → Sign in with Apple 추가** → `ios/Runner/Runner.entitlements` 생성(개발이 코드 반영, 팀 계정 로그인 필요) | 앱(나) + 팀 계정 | **P0** (팀 계정 접근 필요) |
| A3 | **Apple Developer Team ID**(엔타이틀먼트/서명 확인용) | 서명 설정 | **P0** |
| — | ~~Service ID / Return URL / `.p8` 키(Key ID·Team ID)~~ | **불필요** (iOS 네이티브만, aud=Bundle ID로 확정) | — |

> 서버 검증값: `ieuri.sns.apple.audience = kr.ieuri.ktripspot`, `issuer = https://appleid.apple.com`(§8.3). 별도 발급 파일 없음.
> ⚠️ Apple은 **최초 인증 1회만** 이름/이메일을 제공한다 → 앱은 provider 미제공 이메일을 직접 입력받는 UX로 이미 설계됨(§5.2). 개발 중 재테스트 시 [설정 > Apple ID > 로그인 사용 앱]에서 앱 연결을 삭제해야 이름/이메일이 다시 온다.

### 16.4 Kakao — 사용자 발급
| # | 전달물 | 배치/사용처 | 우선순위 |
|---|---|---|---|
| K1 | 카카오 개발자 콘솔 **앱 생성** + 카카오 로그인 활성화 + **OpenID Connect(OIDC) 활성화**(id_token 수령) | 카카오 콘솔 | **P0** |
| K2 | **네이티브 앱 키**(앱 시작 시 `KakaoSdk.init`) | `--dart-define=KAKAO_NATIVE_APP_KEY=…` | **P0** |
| K3 | **REST API 키 / 앱 ID** — 서버 `id_token` `aud` 검증값(서버 §8.3 `ieuri.sns.kakao.app-key`) | 서버 설정 | **P0** |
| K4 | 플랫폼 등록: Android 패키지 `kr.ieuri.ktripspot`(+ 키 해시), iOS 번들 `kr.ieuri.ktripspot` | 카카오 콘솔 | **P0** |
| K5 | 카카오 로그인 **동의항목**에서 이메일 수집 설정(선택 — 무이메일 케이스는 앱에서 직접 입력 처리) | 카카오 콘솔 | P1 |

> ⚠️ 카카오 Android는 SHA-1이 아니라 **키 해시**(base64)를 등록한다. **개발이 통일 식별자 확정 후 키 해시를 추출해 전달**할 테니, 그걸 카카오 콘솔에 등록하면 된다(K4).

### 16.5 착수 게이트 (Definition of Ready)
- **P0가 모두 갖춰지면 착수.** 구체적으로: (C1 완료) + (G1–G4) + (A1–A3) + (K1–K4).
- **부분 착수 가능**: provider별로 독립적이므로, 예를 들어 Google(G1–G4)만 먼저 오면 Google 로그인부터 구현·검증하고 나머지는 준비되는 대로 붙일 수 있다. Step 2 인프라 재사용이라 provider 추가는 저비용.
- **콘솔 발급 대기 중 병행할 것**(발급물 불필요): §3 앱 식별자 통일, `SnsProvider`/`SnsCredential` 도메인 모델, `LoginSns`/`RegisterSnsMember` GraphQL 오퍼레이션, repository/컨트롤러 시그니처, SNS 회원가입 화면 골격, l10n 카피, 서버 검증기 골격(로컬은 dev stub로 계속 동작).

### 16.6 사용자 전달 요약 (한 눈에)
**당신이 콘솔에서 발급 → 저에게 전달할 것:**
1. `google-services.json` (파일)
2. `GoogleService-Info.plist` (파일)
3. Google 웹(server) OAuth 클라이언트 ID (문자열)
4. Apple: App ID에 Sign in with Apple 활성화 + Apple Developer Team ID (문자열) — `.p8`/Service ID 불필요
5. Kakao 네이티브 앱 키 (문자열)
6. Kakao REST API 키/앱 ID (문자열)
7. Apple Developer / 카카오 콘솔에서 **플랫폼 등록**(패키지/번들 `kr.ieuri.ktripspot`, 제가 드린 SHA/키 해시 등록)

**제가 드릴 것(발급 전에):** 통일 식별자 확정 후 **Android 키 해시(카카오용)** 추출 전달. debug SHA-1/SHA-256(위 C2)은 이미 제공.
