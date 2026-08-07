# 디자인 참조 — 설정 및 마이페이지 (SPEC-0011)

> 설계 문서: `problem/SPEC-0011-client.md` · 수용 기준: `Specs/SPEC-0011/spec.md` (R1~R20)
> Stitch 프로젝트: `projects/8651053354437738829` (K-Trip Spot Design System)
> 디자인 시스템: `assets/073fee5b990e4b1eb2c918d7e9de2d8f`
> 최종 갱신: 2026-08-07 (Stitch 목업 생성 시점)

이 문서는 **레이아웃·컴포넌트 분해 참조**다. 수용 기준과 어긋나면 스펙이 이긴다.
색·폰트·간격 값은 여기 적힌 것을 복사하지 말고 `Theme.of(context)`에서 읽는다 (DESIGN.md §12).

**목업의 샘플 콘텐츠는 디자인 확인용이다.** 닉네임 "Alex Kim", 게시글 내용 등은 전부 예시이며
실제 데이터는 서버에서 온다.

---

## 0. 서버 계약 상태 — 읽고 시작할 것

**이 스펙이 요구하는 서버 오퍼레이션 대부분이 아직 없다.** 2026-08-07 07:08 라이브
introspection(`localhost:8888/graphql`) 기준이며, 사용자가 "서버는 아직 작업 진행중"이라고
확인했다.

| 스펙 요구 | 오퍼레이션 | 라이브 스키마 |
|---|---|---|
| R11·R12 약관 게이트 | `agreements`, `agreeToRequiredTerms` | **없음** |
| R3 내가 쓴 글 | `myPosts` | **없음** |
| R5 닉네임 변경 | — | **없음** |
| R6 프로필 이미지 | 3단계 업로드·`removeProfileImage` | **없음** |
| R7·R8 이메일 변경 | `confirmEmailChange` | **없음** |
| R9·R10 약관 토글 | — | **없음** |
| R15 로그아웃 | `logout` | ✅ 있음 |
| R16 탈퇴 | `withdrawMember` | ✅ 있음 |

`TermsCode` enum(`SERVICE`/`PRIVACY`/`LOCATION`/`MARKETING`)과 `AgreementInput`은 존재하지만
**가입 시점 입력용**이고 조회·수정 경로가 없다. `MemberDetail`에도 약관 동의 상태 필드가 없다.

**따라서 UI/UX를 먼저 만들고 서버 계약이 붙으면 연결한다.** 이 문서는 그 UI의 기준이다.
계약이 붙는 시점에 필드 이름이 여기 적힌 가정과 다를 수 있으므로, repository를 쓸 때
**스냅샷을 다시 확인한다**(CLAUDE.md §13).

### 이번 작업에서 구현된 것 / 안 된 것

| 요구 | 상태 |
|---|---|
| R1 설정 진입점·라우팅 | **구현** — 홈 우상단, `/settings` 아래 중첩 |
| R2 차단 목록 진입점 이동 | **구현** — 커뮤니티에서 제거, 설정에 추가 |
| R13 반경 저장·복원 | **구현** — `AppPreferences` + `SearchRadiusController` |
| R14 언어 선택 UI | **구현** — 기존 `LocaleController`에 UI만 연결 |
| R15 로그아웃 위치 이동 | **구현** — 기존 로직 그대로, 설정으로 이동 |
| R16 탈퇴 | **구현** — `withdrawMember` 오퍼레이션 추가 |
| R19 연령 확인 게이트 | **이미 충족** — `AgreementItem.age`가 `required: true`라 `requiredSatisfied`에 포함됨. 스펙의 "확인 필요"는 확인 결과 보정 불필요 |
| R3 내가 쓴 글 | **빈 상태만** — `myPosts` 없음 |
| R4~R8 프로필·이메일 | **미구현** — 계약 없음 |
| R9~R12 약관·게이트 | **미구현** — 계약 없음 |

R11·R12 약관 게이트를 계약 없이 만들면 **항상 통과하거나 항상 막는 게이트**가 되어
라우터에 위험만 남는다. §10에 설계만 적어 두고 구현하지 않았다.

---

## 1. 진입점 (R1·R2)

설정은 탭이 아니라 **홈 화면 우상단**에서 들어간다. 하단 탭 5개는 SPEC-0008에서 고정됐다.

현재 홈 우상단에는 `LogoutButton`과 비활성 `favorite_border` 아이콘이 있다. 로그아웃은
설정 안으로 들어가므로(R15) 우상단에서 빠지고, 그 자리를 설정 진입점(`Icons.settings`)이 대신한다.

커뮤니티 우상단에서는 **차단 목록 아이콘만** 제거한다. 숨긴 글 아이콘은 남는다 — 스펙의
결정이다. SPEC-0010이 "둘 다 내가 안 보이게 한 것을 되돌리는 화면이라 같은 자리에 있어야
한다"는 근거로 둘을 묶어 놨으므로, **그 근거가 깨진다는 점을 코드 주석에 남긴다**.

---

## 2. 설정 홈 — `SettingsScreen`

> Stitch 화면: `projects/8651053354437738829/screens/99fb90f0ad6041ea8dcf299221da743c`

```
┌──────────────────────────────────────────┐
│ ←  Settings                              │
├──────────────────────────────────────────┤
│ (◕)  Alex Kim                        ›   │  ← ProfileSummaryTile (탭 → 프로필 수정)
│      alex.kim@example.com                │
├──────────────────────────────────────────┤
│ ACTIVITY                                 │  ← 섹션 라벨 (작게, muted, 대문자)
│ 📄 My Posts                          ›   │
│ ♡  Liked Spots                       ›   │
│ ACCOUNT                                  │
│ 👤 Edit Profile                      ›   │
│ ✉  Change Email                      ›   │
│ 🚫 Blocked Users                     ›   │
│ PREFERENCES                              │
│ 📍 Search Radius            20 km    ›   │  ← 후행 값 표시
│ 🌐 Language                English   ›   │
│ LEGAL                                    │
│ 📋 Terms & Agreements                ›   │
│                                          │
│ ⏻  Log Out                               │  ← 여백 두고 분리, chevron 없음
│    Delete Account                        │  ← error 색
└──────────────────────────────────────────┘
```

**납작한 행 + 얇은 구분선. 카드 그림자를 쓰지 않는다.** 커뮤니티(SPEC-0010)와 같은 결이다.

컴포넌트 분해:

| 컴포넌트 | 역할 |
|---|---|
| `ProfileSummaryTile` | 아바타 + 닉네임 + 이메일, 탭하면 프로필 수정 |
| `SettingsSectionHeader` | 섹션 라벨 한 줄 |
| `SettingsTile` | 아이콘 + 제목 + (후행 값) + chevron |

`Liked Spots`는 이미 탭에 있지만(SPEC-0008) 설정에서도 들어갈 수 있게 둔다 — 목업의 판단이며
스펙 인수 기준에는 없다. **범위 밖으로 판단되면 빼도 된다.**

---

## 3. 프로필 수정 — `ProfileEditScreen` (R4~R6)

> Stitch 화면: `screens/485a45ce5a49405aa71b85aab877e32a`

```
┌──────────────────────────────────────────┐
│ ←  Edit Profile                  Save    │  ← 변경 없으면 Save 비활성
├──────────────────────────────────────────┤
│              ( ◕ )📷                     │  ← 아바타 + 카메라 배지
│        Change Photo    Remove            │  ← Remove는 error 색
│                                          │
│ Nickname                                 │
│ ┌──────────────────────────────┐  7/20   │
│ │ Alex Kim                     │         │
│ └──────────────────────────────┘         │
│ ⚠ This nickname is already taken.        │  ← 서버 NICKNAME_ALREADY_TAKEN
│                                          │
│ Email                                    │
│ ┌──────────────────────────┐  Change     │  ← 읽기 전용, 별도 화면으로
│ │ alex.kim@example.com     │             │
│ └──────────────────────────┘             │
└──────────────────────────────────────────┘
```

**닉네임 중복은 클라이언트가 미리 조회하지 않는다**(R5). 제출 전엔 형식만 보고, 중복은 서버
판정을 입력란 오류로 표시한다 — 미리 조회해도 조회와 제출 사이에 선점당할 수 있어 어차피
서버 오류를 처리해야 한다.

**프로필 이미지 업로드는 3단계다**(R6): URL 발급 → 스토리지 직접 PUT → 확정. 선언한
`contentType`·`contentLength`가 실제 PUT과 정확히 일치해야 서명이 유효하므로, 파일을 읽어
실제 크기를 구한 뒤 발급을 요청한다. **중간 실패가 남긴 임시 키를 정리한다** — 확정 전에
화면을 벗어나면 키가 떠돈다.

제거는 별도 동작(`removeProfileImage`)이라 교체와 제거를 한 화면에서 구분해 보여준다.

---

## 4. 이메일 변경 — 2단계 (R7·R8)

> Stitch 화면: `screens/dbd1f6c981574e7cb8e95e238178af57` (입력), `screens/c2561988c97749898ace403d390c70eb` (검증)

```
1) Change Email                    2) Verify Email
┌────────────────────────┐        ┌────────────────────────┐
│ ←  Change Email        │        │ ←  Verify Email        │
├────────────────────────┤        ├────────────────────────┤
│ Current:               │        │ ⓘ Your email changes   │  ← amber 배너
│ alex.kim@example.com   │        │   only after verifying │
│                        │        │                        │
│ New Email Address      │        │ Enter the code sent to │
│ ┌────────────────────┐ │        │ alex.new@example.com   │
│ │ alex.new@...       │ │        │                        │
│ └────────────────────┘ │        │ [1][2][3][4][ ][ ]     │  ← 6자리
│ We'll send a 6-digit   │        │ ⚠ The code doesn't     │
│ code to this address.  │        │   match. Try again.    │
│                        │        │ Resend code in 0:47    │  ← 카운트다운
│ ┌────────────────────┐ │        │ ┌────────────────────┐ │
│ │     Send Code      │ │        │ │      Verify        │ │
│ └────────────────────┘ │        │ └────────────────────┘ │
└────────────────────────┘        └────────────────────────┘
```

**검증 전까지 프로필의 이메일은 기존 값이다**(R7 첫 기준). 변경 대기 중임을 amber 배너로
드러내지 않으면 사용자가 실패로 오해한다.

**코드 화면은 기존 `EmailVerificationScreen`과 형태가 같지만 다른 뮤테이션**
(`confirmEmailChange`)을 쓴다. 컴포넌트는 재사용하되 호출부를 분리한다.

**재발송 쿨다운 60초는 남은 시간을 카운트다운으로 보여준다.** `RESEND_COOLDOWN_ACTIVE`를
받고 나서 알리는 것보다 미리 막는 편이 낫다 — 서버 오류는 여전히 처리한다.

`failureReason`별 문구를 **구분한다**. 셋을 같은 문구로 묶으면 사용자가 다음 행동을 모른다:

| failureReason | 안내 |
|---|---|
| `CODE_MISMATCH` | 재입력 |
| `EXPIRED` | 재발송 |
| `MAX_ATTEMPTS_EXCEEDED` | 처음부터 |

---

## 5. 약관 관리 — `TermsScreen` (R9·R10)

> Stitch 화면: `screens/33be74cc744d4087ba930b6b94fadbd3`

```
┌──────────────────────────────────────────┐
│ ←  Terms & Agreements                    │
├──────────────────────────────────────────┤
│ Required agreements cannot be withdrawn  │
│ while using the service.                 │
│                                          │
│ REQUIRED                                 │
│ Terms of Service              ✓      ›   │  ← 토글 없음, 읽기 전용
│ Agreed Jan 12, 2026                      │
│ Privacy Policy                ✓      ›   │
│ Agreed Jan 12, 2026                      │
│                                          │
│ OPTIONAL                                 │
│ Location Data                    [ON ]   │  ← 토글
│ Used to recommend nearby spots           │
│ Marketing Notifications          [OFF]   │
│ Event and promotion updates              │
└──────────────────────────────────────────┘
```

**필수 항목은 토글하지 않는다** — 철회 경로가 없다. 읽기 전용으로 표시하고 동의 일자를 보여준다.

선택 항목(위치·마케팅)만 토글하며 **낙관적 업데이트를 적용하고 실패 시 되돌린다**
(CLAUDE.md 책임 분리표 — 낙관적 갱신과 롤백은 클라이언트).

**`TermsCode`는 식별자이며 화면 문구가 아니다**(POL-023). 표시 문자열은 l10n 키로 매핑한다:
`SERVICE`/`PRIVACY`/`LOCATION`/`MARKETING` → `termsService`/`termsPrivacy`/… 형태.

---

## 6. 반경·언어 — `PreferencesScreen` (R13·R14)

> Stitch 화면: `screens/15ca67e510ef43b8839e396a32cb5ba5`

```
┌──────────────────────────────────────────┐
│ ←  Preferences                           │
├──────────────────────────────────────────┤
│ SEARCH RADIUS                            │
│              20 km                       │  ← 큰 값 표시
│ ●━━━━━━━━━━━━━━━━━━━━━━━━━━━━━○          │
│ 0 km                          100 km     │
│ Set to 0 km to search only your          │
│ current location.                        │
│                                          │
│ LANGUAGE                                 │
│ English                              ✓   │
│ 한국어                                    │
│ 日本語                                    │
│ 中文                                      │
└──────────────────────────────────────────┘
```

**반경은 서버 상태가 아니다.** 기존 `AppPreferences`(SharedPreferences) 로컬 저장을 쓴다.
0~100km 연속 슬라이더, 기본값 20km.

**0km가 유효값이다**(R13 네 번째 기준). 슬라이더 최솟값을 0으로 두되 0이 "현재 위치만"을
뜻한다는 것을 helper 문구로 드러낸다.

**이 값을 실제 조회에 반영하는 것은 이 스펙의 인수 기준에 없다.** 저장과 복원까지가 범위이며,
소비처 연결은 값이 있어야 가능하므로 순서상 다음 작업이다.

**언어는 이미 동작한다.** `LocaleController`가 선택값을 로컬 저장하고 `Accept-Language`로 매
요청 전송한다. **선택 UI만 붙이면 된다 — 새 상태 관리를 만들지 않는다.**

---

## 7. 내가 쓴 글 — `MyPostsScreen` (R3)

> Stitch 화면: `screens/84facf6ee74a4a12b0cce9b191ae50dc`

```
┌──────────────────────────────────────────┐
│ ←  My Posts                              │
├──────────────────────────────────────────┤
│ FOOD · GWANGJANG MARKET                  │
│ Best Bindaetteok in Seoul!         ┌───┐ │  ← 썸네일(있을 때만)
│ You can't miss the mung bean...    │   │ │
│ ♡ 12   💬 4   2 days ago           └───┘ │
│ ────────────────────────────────────────  │  ← 얇은 구분선
│ CULTURE · BUKCHON HANOK VILLAGE          │
│ Quiet morning walk                       │
│ ...                                      │
└──────────────────────────────────────────┘
```

**커뮤니티의 기존 `Post` 도메인 모델을 재사용한다.** `myPosts`는 `PostConnection`을 반환하므로
마이페이지용 모델을 따로 만들지 않는다(설계 §10).

**페이지네이션은 `common/pagination/`을 쓴다** — 기능이 자기 페이지네이션을 만들지 않는다
(CLAUDE.md §4).

빈 상태: 가운데 muted 아이콘 + "You haven't written any posts yet" + "Write your first post"
버튼. **목업에 별도 화면으로 생성되지 않았으므로 구현 시 위 형태로 만든다.**

---

## 8. 탈퇴 확인 — `AccountDeletionScreen` (R16)

> Stitch 화면: `screens/e598eff5956b44cab354faa278b2d79c`

```
┌──────────────────────────────────────────┐
│ ←  Delete Account                        │
├──────────────────────────────────────────┤
│                  ⚠                       │  ← error 색
│         This cannot be undone            │
│                                          │
│ Deleting your account permanently        │
│ removes:                                 │
│   💬 Your posts and comments             │
│   ♡  Your liked spots                    │
│   👤 Your profile and settings           │
│                                          │
│ ┌──────────────────────────────────────┐ │  ← error-container 톤
│ │ You will not be able to recover this │ │
│ └──────────────────────────────────────┘ │
│                                          │
│ ┌──────────────────────────────────────┐ │
│ │             Cancel                   │ │  ← 취소가 시각적으로 우세
│ └──────────────────────────────────────┘ │
│           Delete My Account              │  ← 약한 red text 버튼
└──────────────────────────────────────────┘
```

**취소가 기본 동작이 되도록 배치한다**(R16). 취소를 위에 두고 채워진 버튼으로, 파괴적 동작은
아래에 약한 텍스트 버튼으로 둔다.

**탈퇴 성공 후에는 로그아웃과 같은 정리를 한다** — 계정이 사라졌으므로 토큰 갱신 시도가
남아 있으면 안 된다.

---

## 9. 로그아웃 (R15)

**기존 `LogoutButton`의 로직을 그대로 쓰되 위치만 설정으로 옮긴다.**

**서버 호출이 실패해도 로컬 토큰을 지우고 로그인 화면으로 보낸다**(R15 세 번째 기준) —
실패로 사용자를 로그인 상태에 가두면 안 된다.

---

## 10. 필수 약관 게이트 (R11·R12) — 화면이 아니라 라우터

**가장 주의할 부분이다.** 게이트는 라우터 리다이렉트로 구현하며 기존 세션 게이트(SPEC-0005)와
**같은 리다이렉트 경로에서 판정해야 한다.** 두 게이트가 각자 리다이렉트하면 서로를 되돌리는
순환이 생긴다.

판정 순서: **언어 → 인증 → 온보딩 → 필수 약관 → 목적지**

동의 안내 상태에서 허용되는 목적지는 **설정 화면 계열과 동의 화면뿐이다**(R11 네 번째 기준).
홈·탐색·커뮤니티는 전부 막힌다.

동의 상태는 `agreements` 쿼리로 읽고 **provider로 캐싱한다** — 매 라우팅마다 조회하면 화면
전환이 네트워크에 묶인다. `agreeToRequiredTerms` 성공 시 반환된 상태로 갱신하면 재조회 없이
게이트가 풀린다(R12 첫 기준).

**게이트 해제 후에는 원래 가려던 목적지로 복귀한다** — 진입 시점의 목적지를 보관해야 한다.

동의 안내 화면 자체는 Stitch 목업이 없다. §5의 약관 화면과 같은 컴포넌트를 쓰되 필수 항목만
보여주고 "동의하고 계속" 버튼을 두는 형태로 만든다.

---

## 11. 가입 폼 보정 (R18·R19) — 신규 화면 없음

기존 `SignUpScreen`·`SnsSignUpScreen`은 이미 구현돼 있고 요구사항과 대체로 일치한다.
**이 스펙에서 새로 만들지 않는다.**

| 확인 항목 | 상태 |
|---|---|
| SNS 가입 provider 이메일 프리필·수정 가능 (R18) | 구현됨 |
| provider가 이메일을 안 준 경우 안내 (R18) | `snsEmailPrefillHint`로 구현됨 |
| 필수 약관 미체크 시 제출 비활성 (R19) | `_agreements.requiredSatisfied`로 구현됨 |
| 연령 확인 미체크 시 제출 비활성 (R19) | **이미 충족 — 보정 불필요** |

설계 초안은 `sign_up_screen.dart:52`의 `_canSubmit`이 `requiredSatisfied`만 보므로 연령
확인이 게이트에서 빠졌다고 봤으나, **확인 결과 이미 포함돼 있다.**
`agreement_checklist.dart`의 `AgreementItem.age`가 `required: true`로 선언돼 있어
`requiredSatisfied`가 순회하는 `requiredItems`에 연령 확인이 들어간다. 연령 미체크면 제출
버튼이 비활성이다.

---

## 12. 라우트

```
/settings                   설정 홈 (R1)
/settings/my-posts          내가 쓴 글 (R3)
/settings/profile           프로필 수정 (R4·R5·R6)
/settings/profile/email     이메일 변경 (R7·R8)
/settings/terms             약관 동의 관리 (R9·R10)
/settings/preferences       반경·언어 (R13·R14)
/settings/delete-account    탈퇴 확인 (R16)
/blocked-users              기존 유지, 설정에서 진입 (R2)
```

**설정 홈 아래에 중첩한다** — 뒤로 가기가 설정 홈을 거쳐 진입 직전 화면으로 돌아가야 한다
(R1 세 번째 기준).

셸 밖의 최상위 라우트라 루트 내비게이터에 push되어 하단 탭을 덮는다 — 관광지 상세·글 상세와
같은 성격이다.

**차단 목록 화면(`BlockedUsersScreen`) 자체는 `community`에 그대로 둔다.** 옮기는 것은
진입점뿐이며, 화면을 이동시키면 `community` 리포지토리 의존이 `settings`로 끌려 들어온다.

---

## 13. 목업과 구현이 갈리는 지점

Stitch 목업은 **레이아웃 참고용**이고 다음은 구현에서 달라진다:

1. **색·폰트·간격 값을 복사하지 않는다.** 전부 `Theme.of(context)`/`ThemeExtension`에서 읽는다.
2. **아이콘은 `Icons.*`만** 쓴다.
3. **문자열은 전부 l10n 키다.** 목업의 영어 문구는 `app_en.arb`의 기준값이 되고 KO/JA/ZH도 채운다.
4. **샘플 데이터는 전부 예시다.** 실제 값은 서버에서 온다.
5. **빈 상태·로딩·오류 상태**는 목업에 대부분 없다. 각 화면에 `AsyncValue`의 세 갈래를 모두 그린다.
6. 목업의 `Liked Spots` 행은 스펙 인수 기준에 없다 — 넣을지는 구현 판단이다.
