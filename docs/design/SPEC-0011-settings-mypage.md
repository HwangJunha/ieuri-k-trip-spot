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

**이메일 변경(R7·R8)을 뺀 나머지 계약이 모두 들어왔다.** 2026-08-08 01:52 라이브
introspection(`localhost:8888/graphql`) 기준이다.

| 스펙 요구 | 오퍼레이션 | 라이브 스키마 |
|---|---|---|
| R3 내가 쓴 글 | `myPosts(first, after): PostConnection!` | ✅ 있음 |
| R5 닉네임 변경 | `changeNickname` | ✅ 있음 |
| R6 프로필 이미지 | `createProfileImageUploadUrl` → `confirmProfileImageUpload`, `removeProfileImage` | ✅ 있음 |
| R9·R10 약관 토글 | `agreements`, `updateAgreement` | ✅ 있음 |
| R11·R12 약관 게이트 | `agreements`, `agreeToRequiredTerms` | ✅ 있음 |
| R15 로그아웃 | `logout` | ✅ 있음 |
| R16 탈퇴 | `withdrawMember` | ✅ 있음 |
| **R7·R8 이메일 변경** | `requestEmailChange`/`confirmEmailChange` | **없음 — SPEC-0012 선행** |

**R7·R8은 SPEC-0012가 서버에서 끝나야 진행할 수 있다.** 사용자가 확인해 준 의존 관계다.
스키마에 이메일 변경 경로가 없고, 기존 `verifyEmail`은 **가입 검증 전용**이라 돌려 쓰면 안
된다 — 같은 뮤테이션에 두 의미를 얹으면 가입 흐름의 상태 기계가 이메일 변경에 끌려간다.
SPEC-0012가 끝난 뒤 이 문서 §4를 그대로 구현하면 된다.

`AgreementStatus`는 `termsCode`·`required`·`agreed`·`agreedAt`·`version`을 준다 — 필수/선택
구분과 동의 일자가 서버에서 오므로 클라이언트가 정하지 않는다.

### 구현 상태

| 요구 | 상태 |
|---|---|
| R1 설정 진입점·라우팅 | **구현** — 홈 우상단, `/settings` 아래 중첩 |
| R2 차단 목록 진입점 이동 | **구현** — 커뮤니티에서 제거, 설정에 추가 |
| R3 내가 쓴 글 | **구현** — `myPosts` 커서 페이징 |
| R4·R5·R6 프로필 수정 | **구현** — 닉네임·이미지 3단계·제거 |
| R9·R10 약관 관리 | **구현** — 필수 읽기 전용, 선택만 낙관적 토글 |
| R11·R12 필수 약관 게이트 | **구현** — 기존 세션 게이트와 같은 redirect에서 판정 |
| R13 반경 저장·복원 | **구현** — `AppPreferences` + `SearchRadiusController` |
| R14 언어 선택 UI | **구현** — 기존 `LocaleController`에 UI만 연결 |
| R15 로그아웃 위치 이동 | **구현** — 기존 로직 그대로, 설정으로 이동 |
| R16 탈퇴 | **구현** — `withdrawMember` |
| R19 연령 확인 게이트 | **이미 충족** — `AgreementItem.age`가 `required: true`라 `requiredSatisfied`에 포함됨. 스펙의 "확인 필요"는 확인 결과 보정 불필요 |
| **R7·R8 이메일 변경** | **미구현 — SPEC-0012 선행 필요** |

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

**`Liked Spots`는 빼기로 했다(사용자 결정).** 목업이 제안했고 스펙 인수 기준에는 없었는데,
좋아요를 누른 장소가 곧 그 목록이라 하단 탭과 목적지가 겹친다. 같은 곳을 두 군데서 여는
것은 중복이다.

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

## 4. 이메일 변경 — 2단계 (R7·R8) · **보류: SPEC-0012 선행**

> Stitch 화면: `screens/dbd1f6c981574e7cb8e95e238178af57` (입력), `screens/c2561988c97749898ace403d390c70eb` (검증)

**아직 구현하지 않는다.** 서버에 이메일 변경 경로가 없고, 이는 **SPEC-0012가 끝나야 열린다**
(사용자 확인). 아래 설계는 그때 그대로 쓰기 위한 것이며, 착수 전에 **스냅샷을 다시 확인해**
실제 뮤테이션 이름과 `failureReason` 값이 여기 적힌 가정과 맞는지 대조한다(CLAUDE.md §13).

기존 `verifyEmail`을 돌려 쓰지 않는다 — **가입 검증 전용**이라 한 뮤테이션에 두 의미를
얹으면 가입 흐름의 상태 기계가 이메일 변경에 끌려간다. 설정 화면의 "Change Email" 진입점도
목적지가 생길 때까지 두지 않는다(비활성 진입점보다 없는 편이 낫다).

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

**필수 항목도 토글한다(설계 변경 — 사용자 결정).** 초안은 "철회 경로가 없으니 읽기
전용"이었으나, 누를 수 없는 스위치는 고장으로 읽힌다. 지금은 끌 수 있고 **끄는 순간
라우터 게이트(R11)가 걸려** 홈·탐색·커뮤니티가 막히며 동의 화면으로 보내진다 —
"동의하지 않으면 서비스 이용 불가"가 문구가 아니라 동작으로 드러난다. 설정·로그아웃·
탈퇴는 그때도 열려 있어 빠져나갈 길이 있다.

**필수/선택 구분은 서버가 정한다**(`AgreementStatus.required`). 위치정보는 현재 서버에서
**선택**이라 꺼도 서비스를 쓸 수 있다 — 클라이언트가 정책을 복제하지 않는다.

모든 항목에 **낙관적 업데이트를 적용하고 실패 시 되돌린다**(CLAUDE.md 책임 분리표 —
낙관적 갱신과 롤백은 클라이언트).

**부제는 동의했으면 일자만 보여준다**(사용자 결정). 이미 동의한 항목에서 궁금한 것은
설명이 아니라 "언제 동의했나"다. 미동의 항목은 필수면 서비스 이용 불가 안내를, 선택이면
무엇에 동의하는지 설명을 보여준다.

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

### 구현하며 정한 것 (설계와 다른 지점)

**1. 조회 실패는 게이트를 연다(fail-open).** 서버가 잠깐 죽으면 미동의 사용자가 잠시 홈에
닿는다. 반대로 막으면 **동의 화면의 동의 버튼도 같은 실패를 맞아** 사용자가 앱에 갇힌다 —
빠져나갈 길이 없는 쪽이 더 나쁘다고 판단했다. 서버가 각 뮤테이션에서 동의를 다시 검사하므로
게이트가 새도 실제 동의가 필요한 동작은 막힌다. **정책 보장을 가용성과 맞바꾼 것이라
확인이 필요하다.**

**2. 동의 화면은 `/required-terms` 최상위 라우트다.** 설계 §12에는 이 화면의 라우트가 아예
없었다. 설정 아래에 중첩하면 게이트가 로그인 직후에도 뜰 수 있어 뒤로 가기가 게이트에 다시
막히는 화면으로 떨어진다.

**3. 목적지 보관은 provider가 아니라 라우터 지역 상태다.** 리다이렉트는 **위젯 트리가
빌드되는 중에** 돌기 때문에, provider의 state를 여기서 쓰면 Riverpod이
`Tried to modify a provider while the widget tree was building`으로 던진다. 처음에 provider로
만들었다가 실기기에서 터질 버그를 라우터 통합 테스트가 잡았다. 이 값은 화면이 그리지 않으므로
provider일 이유도 없다.

**4. 순수 판정 함수만으로는 부족하다.** `resolveGate`를 표처럼 검증해도 **라우터에 연결되지
않으면 그대로 통과한다** — 실제로 목적지를 꺼내는 `take()`의 호출부가 없어 R12가 동작하지
않는데도 단위 테스트는 전부 초록이었다. `test/router/app_router_test.dart`가 배선까지 본다.

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
/settings/profile/email     이메일 변경 (R7·R8) — 보류, SPEC-0012 선행
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
