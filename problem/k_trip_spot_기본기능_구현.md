# 이으리(ieuri) k-trip-spot 기본 기능 구현 — 요구사항 분석서

> **Step 1**: 앱 기반(테마·폰트·색상·로고) 확립 + 다국어(언어 선택) + 스플래시 + 온보딩.
> 기능을 쪼개서 단계적으로 진행한다. 로그인은 **Step 2**, 홈 스크린은 **Step 3**에서 진행한다.

---

## 0. 문서 정보

| 항목 | 내용 |
|---|---|
| 대상 앱 | `ieuri_k_trip_spot` (Flutter, 외국인 대상 실시간 위치기반 한국 관광 앱) |
| 이번 단계 | Step 1 — 기본 기능(디자인 시스템 + 첫 실행 플로우) |
| 상태 | **요구사항 분석 / 승인 대기** (구현 착수 전) |
| 설계 원칙 | 공용 기능은 `common/`에 두고 테마를 사용한다. 화면 위젯의 파일·클래스명은 `*_screen` 규칙을 따른다. |
| 근거 규약 | 프로젝트 `CLAUDE.md`(도메인 중심 · 레이어 의존 방향 · Riverpod · GraphQL 격리 · 보안 규칙) |

### 개정 이력
- v0.1 — 초안(테마/언어/스플래시/온보딩 범위 스케치)
- v1.0 — 본 분석서(결정사항 반영: Noto Sans 통일, light/dark, i18n=gen-l10n, 공용 배치)
- **v1.1 — Stitch 실제 디자인 반영: 전체 컬러 스킴, 스플래시 코랄 브랜드 화면(중앙 정렬), 온보딩 미디어 카드 레이아웃, big-size 스플래시 아이콘, 임시 좌상단 디버그 뒤로가기 버튼**

---

## 1. 개요 & 목표

Step 1의 목표는 **화면 기능이 아니라 앱의 토대**를 세우는 것이다.

1. 앱 전역에서 재사용할 **디자인 시스템**(색상·타이포·테마)을 확정하고 코드로 고정한다.
2. **다국어(EN/KO/JA/ZH)** 인프라를 구축하고, 사용자가 언어를 선택하면 이후 모든 화면이 그 언어로 렌더링된다.
3. 첫 실행 경험인 **스플래시 → 언어 선택 → 온보딩** 플로우를 구현한다.
4. 이 과정에서 앱 기반 패키지 스택(Riverpod / GoRouter / 다국어 / SVG / 스플래시 / 저장소)을 확립한다.

Step 1이 끝나면 Step 2(로그인)는 이미 갖춰진 테마·다국어·라우팅 위에 화면만 얹으면 되는 상태가 된다.

---

## 2. 범위 (Scope)

### 2.1 In Scope
- 색상 팔레트 → Material 3 `ColorScheme` (light/dark 양쪽)
- 폰트 = **Noto Sans**(다국어 통일) 및 타이포그래피 스케일
- 로고/아이콘 에셋 적용(런처 아이콘 · 스플래시 마크 · 워드마크)
- 라이트/다크 **테마** 정의 및 시스템 테마 추종
- **다국어 인프라**: Flutter 공식 `flutter_localizations` + `intl` + **gen-l10n(ARB)**
- **네이티브 스플래시**(정적 로고) + **인앱 스플래시**(선택 언어 반영)
- **언어 선택** 화면(최초 1회, 이후 변경 가능하도록 설계)
- **온보딩** 화면(최초 1회, 페이지 인디케이터/스킵/시작하기)
- 기반 의존성 스택 및 `pubspec.yaml` 에셋·폰트 등록

### 2.2 Out of Scope (명시적 제외)
- **로그인 / 인증** — Step 2
- **홈 스크린 / 실제 관광 기능** — Step 3
- 백엔드 GraphQL 연동(이번 단계는 서버 통신 없음 — 순수 클라이언트 로컬 플로우)
- 실제 온보딩 카피/일러스트 확정값 (→ Google Stitch 산출물, §11 참조)
- 설정 화면에서의 언어 재변경 UI (구조만 재변경 가능하게 두고, 화면 자체는 이후 단계)

---

## 3. 용어

| 용어 | 정의 |
|---|---|
| 네이티브 스플래시 | OS가 앱 프로세스 기동 중 보여주는 정적 화면(`flutter_native_splash`). 언어별 변경 불가. |
| 인앱 스플래시 | Flutter 위젯으로 그리는 스플래시 화면. 선택 언어를 반영할 수 있음. |
| 첫 실행 플로우 | 스플래시 → 언어 선택 → 온보딩으로 이어지는 최초 진입 경험. |
| 소스 언어 | 번역의 원본. **한국어(KO)** 가 소스이며 EN/JA/ZH는 이를 번역한 것. |
| 표시 기본 언어 | 저장된 선택이 없을 때의 기본값. 기기 로케일 매칭, 미매칭 시 **영어(EN)**. |

---

## 4. 첫 실행 플로우 (상태 전이)

```
[앱 실행]
   │
   ▼
(네이티브 스플래시)  ← 정적 로고(mark). OS가 표시.
   │
   ▼
(인앱 스플래시)      ← 저장된 locale 로드. locale 있으면 그 언어로, 없으면 표시 기본 언어로 렌더.
   │
   ├─ onboardingCompleted == true  ─────────────►  Step 2 (로그인)  ※ 이번 범위 밖, 자리만
   │
   └─ onboardingCompleted == false
          │
          ▼
   (언어 선택 화면)   ← 4개 언어 중 선택 → locale 저장 → 앱 전역 즉시 반영
          │
          ▼
   (온보딩 화면)      ← N페이지, 인디케이터/스킵/다음, 마지막 "시작하기"
          │
          ▼
   onboardingCompleted = true 저장  ─────────────►  Step 2 (로그인)  ※ 자리만
```

- **재실행 시**: `onboardingCompleted == true`면 언어 선택·온보딩을 건너뛴다. locale은 저장값을 사용한다.
- **저장 위치**: `locale`, `onboardingCompleted` 모두 비밀값이 아니므로 `SharedPreferences`. (토큰·시크릿만 `flutter_secure_storage` — Step 2에서 적용.)
- **라우팅**: 위 전이는 `GoRouter`의 `redirect`로 구현(위젯 내 임시 분기 금지).

---

## 5. 기능 요구사항 — 디자인 시스템

### 5.1 색상 (Color)
시드 색상을 기준으로 Material 3 `ColorScheme`를 구성한다. 세부 톤(surface/on-* 등)은 **Google Stitch 산출물**을 따른다.

| 역할 | 브랜드 시드 | Stitch M3 role (light) |
|---|---|---|
| Primary | `#EA4A3F` | `#B2211D` |
| Secondary | `#17A2A2` | `#006A6A` |
| Tertiary | `#F5A623` | `#805200` |
| Neutral | `#88726F` | surface `#FFF8F7` 계열 |

- **(반영 완료)** 라이트 스킴은 Stitch `DESIGN.md`의 전체 M3 롤 세트를 그대로 사용한다(`AppTheme._lightScheme`). role `primary`는 시드(`#EA4A3F`)에서 대비 보정된 `#B2211D`.
- 다크 스킴은 브랜드 시드 기반 `fromSeed`(Stitch가 라이트만 제공 → 다크 톤은 후속).
- 위젯에서 하드코딩 색상 사용 금지 → 반드시 `Theme.of(context).colorScheme` 경유.
- 시맨틱 색상(혼잡도 low/med/high·success·warning)은 Step1 화면에서 미사용 → `ThemeExtension` 도입은 사용 시점(맵/혼잡도, Step3)으로 유예.

### 5.2 폰트 / 타이포그래피 (Typography)
- **기본 폰트 패밀리 = `Noto Sans`** (다국어 글리프 일관성 확보를 위해 통일). Google Stitch 디자인도 Noto Sans 기준으로 맞춘다.
- CJK 대응: `Noto Sans` + `fontFamilyFallback: [Noto Sans KR, Noto Sans JP, Noto Sans SC]` 로 EN/KO/JA/ZH 전 구간 글리프 깨짐 방지.
- 기존 `asset/fonts/Pretendard-*`는 **본 결정으로 대체**되었고, **저장소에서 이미 제거됨**(사용자 처리 완료).
- 타이포그래피 스케일은 M3 `TextTheme`을 Noto Sans weight에 매핑(display/headline/title/body/label). 구체 크기·weight는 Stitch 기준.
- ⚠️ **필요 에셋**: 현재 저장소에 Noto Sans 폰트 파일이 없다 → §10 준비물로 추가 필요.

### 5.3 로고 / 아이콘 에셋
현재 보유 에셋(`asset/icon/`)과 용도 매핑(잠정):

| 에셋 | 용도(잠정) |
|---|---|
| `app-icon.svg` | 런처 아이콘(iOS/Android) |
| `mark-coral.svg` | 라이트 테마 스플래시/포인트 마크 |
| `mark-white.svg` | 다크 테마 스플래시/포인트 마크 |
| `lockup-light.svg` | (어두운 배경용) 워드마크 락업 |
| `lockup-dark.svg` | (밝은 배경용) 워드마크 락업 |
| — 그 외 | Stitch 화면 스펙에 따라 지정 |

- SVG 렌더링을 위해 `flutter_svg` 사용.
- 워드마크 락업 기본값은 **`lockup-light.svg`** 를 사용한다(확정).

### 5.4 테마 (Theme)
- `ThemeData` **light/dark 2벌** 정의. `MaterialApp.themeMode = ThemeMode.system`으로 시스템 테마 추종.
- 색상·타이포·컴포넌트 테마(버튼/앱바 등)를 `common/theme/`에 집중. 화면 코드에서 개별 스타일 재정의 최소화.

---

## 6. 기능 요구사항 — 다국어 (i18n)

- **방식**: 업계 표준인 Flutter 공식 `flutter_localizations` + `intl` + **gen-l10n**. 서드파티 미사용.
- **지원 로케일**: `ko`, `en`, `ja`, `zh` (4개로 한정).
- **소스 언어**: `ko`(한국어)가 원본. `en/ja/zh`는 이를 번역한 ARB.
- **파일**: `lib/l10n/app_ko.arb`(템플릿), `app_en.arb`, `app_ja.arb`, `app_zh.arb`. `l10n.yaml`로 gen-l10n 설정.
- **표시 기본 언어**: 저장된 `locale`이 없으면 기기 로케일을 지원 4개와 매칭, 미매칭 시 **영어(EN)**.
- **동적 반영**: 사용자가 언어를 바꾸면 `MaterialApp`의 `locale`을 갱신하는 `LocaleController`(Riverpod)로 **앱 전역 즉시 반영**. 선택값은 `SharedPreferences`에 저장.
- 하드코딩 문자열 금지 → 모든 사용자 노출 문구는 ARB 키 경유(스플래시·온보딩 포함).

---

## 7. 기능 요구사항 — 첫 실행 화면

### 7.1 네이티브 스플래시 (`*_screen` 대상 아님 — 네이티브 설정)
- `flutter_native_splash`로 라이트/다크 각각 배경색 + 중앙 `mark` 로고를 설정.
- 정적이므로 다국어 텍스트 없음(로고만).

### 7.2 인앱 스플래시 — `splash_screen.dart` / `SplashScreen`
- 진입 시 저장된 `locale`·`onboardingCompleted`를 로드하고 다음 라우트로 분기(§4).
- 선택 언어에 맞는 텍스트/브랜드 표기를 반영(스펙: "언어에 맞게 변경").
- **고정 지연**(짧은 정적 표시) 후 다음 라우트로 전이한다(확정). 구체 지연값은 구현 시 상수로 지정.

### 7.3 언어 선택 — `language_selection_screen.dart` / `LanguageSelectionScreen`
- 4개 언어(EN/KO/JA/ZH)를 각 언어 자기 표기로 노출:
  **English / 한국어 / 日本語 / 中文（繁體）**
- 선택 즉시 `locale` 저장 + 앱 전역 반영 후 온보딩으로 진행.
- 최초 1회 강제 노출. 이후 재실행 시 건너뜀(설정에서 변경하는 경로는 이후 단계).

**표기 규칙(사용자 결정 2026-08-26).** 표기는 `AppLanguage.nativeName` 하나가
정하고, 언어 선택·설정·환경설정 세 화면이 그 값을 그대로 쓴다.

- **영어 이름을 덧붙이지 않는다.** 한때 "한국어 / Korean"처럼 보조 라벨을 함께
  적었는데, 자기 언어를 자기 문자로 보여 주는 것이 이미 목적을 다한다 — 영어를
  못 읽는 사용자에게는 군더더기이고, 읽는 사용자에게도 같은 말의 반복이다.
- **중국어는 괄호로 번체임을 밝힌다** — `中文（繁體）`. 중국어권 사용자에게는
  간체냐 번체냐가 곧 읽을 수 있느냐의 문제라 고르기 전에 알려야 한다. 전각
  괄호（）를 쓴다(중문 조판 표준이고 반각을 섞으면 자간이 튄다).

규칙은 `test/common/localization/app_language_test.dart`가 지킨다 — 영어 외
언어의 표기에 로마자가 섞이면 실패한다.

### 7.4 온보딩 — `onboarding_screen.dart` / `OnboardingScreen`
- **구조(확정)**: **3페이지** + 페이지 인디케이터 + "스킵" + "다음" + 마지막 페이지 "시작하기".
- 완료(또는 스킵) 시 `onboardingCompleted = true` 저장 후 Step 2(로그인) 자리로 전이.
- **콘텐츠 (Stitch 반영 완료)**: 3페이지 = ①Swipe to Discover ②Avoid the Crowds ③Travel Together. 실제 카피를 EN/KO/JA/ZH ARB로 관리. 일러스트는 현재 Material 아이콘 플레이스홀더(swipe/insights/forum) — Stitch 이미지 에셋으로 교체는 후속.
- 모든 페이지 텍스트는 선택 언어로 렌더.

---

## 8. 비기능 요구사항

### 8.1 아키텍처 배치 (`common/` 중심)
스플래시·언어선택·온보딩은 특정 도메인 기능이 아닌 **앱 진입 공용 플로우**이므로 `common/` 아래 배치한다(사용자 결정).

```
lib/
├── common/
│   ├── theme/            # ColorScheme, TextTheme, ThemeData(light/dark)
│   ├── localization/     # LocaleController(Riverpod), 지원 로케일, 기본언어 결정
│   ├── storage/          # SharedPreferences 래퍼(플래그) — 시크릿은 Step2에서 secure_storage
│   └── onboarding/       # 첫 실행 플로우 화면(공용) — 스플래시/언어선택/온보딩
│       ├── provider/     # 첫 실행 상태(locale/onboardingCompleted) 프로바이더
│       └── view/         # splash_screen.dart / language_selection_screen.dart / onboarding_screen.dart
├── l10n/                 # *.arb (gen-l10n 입력)
├── router/               # GoRouter + redirect(첫 실행 분기)
└── main.dart
```

- `view/` 폴더 규칙(CLAUDE.md)과 `*_screen` 명명 규칙(스펙)을 **동시 충족**: 화면은 `view/`에 두고 파일·클래스명은 `*_screen`/`*Screen`.
- 레이어 의존 방향 준수: `view → provider → (repository 없음, 이번 단계는 로컬) → model`, `model`은 순수 Dart.
- 공용 첫 실행 플로우 폴더명은 **`common/onboarding/`** 로 확정.

### 8.2 의존성 / pubspec (Step 1에서 확립)
| 패키지 | 용도 |
|---|---|
| `flutter_riverpod` + `riverpod_annotation` (+ `riverpod_generator` dev) | 상태관리(코드생성) |
| `go_router` | 라우팅 + 첫 실행 redirect |
| `flutter_localizations`(sdk) + `intl` | 다국어(gen-l10n) |
| `flutter_svg` | SVG 로고/아이콘 |
| `flutter_native_splash` (dev) | 네이티브 스플래시 생성 |
| `shared_preferences` | locale/onboarding 플래그 저장 |
| `flutter_secure_storage` | (Step 2 대비 래퍼만 준비 가능, 실제 사용은 Step 2) |

- `pubspec.yaml`에 **Noto Sans 폰트 패밀리 등록**, `asset/icon/`·`asset/fonts/` 경로 등록, `flutter: generate: true`(gen-l10n).

### 8.3 상태관리 · 라우팅 · 영속성
- **Riverpod 3 코드생성**(`@riverpod`), `AsyncValue` 노출, `autoDispose` 기본. `LocaleController`는 앱 생명주기 동안 유지(keep-alive 정당화 대상).
- **GoRouter** 중앙 선언, 첫 실행 분기는 `redirect`. 라우트 파라미터는 타입 지정.
- **SharedPreferences**: 키 `locale`(String), `onboardingCompleted`(bool). 시크릿 아님.

### 8.4 성능 · 보안
- `const` 위젯 최대화, `ref.watch(select)`로 리빌드 최소화.
- 이번 단계는 토큰/PII 없음. 단 로깅에 민감정보 금지 원칙은 유지.

---

## 9. 테스트 전략 (CLAUDE.md 레이어별 규칙)

| 대상 | 테스트 |
|---|---|
| `model` (첫 실행 상태 등) | 순수 단위 테스트(직렬화/동등성/기본언어 결정 로직) |
| `provider` (`LocaleController`, 첫 실행 프로바이더) | `ProviderContainer` + 저장소 override, 방출 상태 검증 |
| `view`(splash/language/onboarding) | 위젯 테스트: 언어 선택 시 문구 변경, 온보딩 완료 시 전이, 인디케이터/버튼 동작 |
| 라우팅 redirect | onboardingCompleted 분기 위젯/유닛 테스트 |

- 생성 코드(`*.g.dart`, gen-l10n)·프레임워크 코드는 테스트하지 않는다.

---

## 10. 필요 에셋 / 준비물

| 항목 | 상태 |
|---|---|
| Noto Sans 폰트 파일(Latin + KR/JP/SC weight) | **미보유 → 추가 필요** |
| 온보딩 일러스트/아이콘 | Stitch 산출물 대기 |
| 색상 세부 톤(surface/on-* 등) | Stitch 산출물 대기 |
| Google Stitch MCP 접근 | **현재 세션 미연결** — 값 확정은 접근 가능 시점에 |

---

## 11. 결정 완료 사항 (Resolved)

1. **온보딩 콘텐츠**: **3페이지**로 확정. 문구·일러스트는 **Google Stitch 최종본**을 따른다.
2. **폴더명**: 첫 실행 플로우 공용 폴더는 **`common/onboarding/`** 로 확정.
3. **Pretendard 제거**: Noto Sans 통일에 따라 **저장소에서 이미 제거됨**(사용자 처리 완료).
4. **락업 로고**: 워드마크 기본값은 **`lockup-light.svg`** 사용.
5. **인앱 스플래시 표시**: **고정 지연** 방식으로 확정.
6. **언어 미매칭 기본값**: **영어(EN)** 로 확정.

### 남은 준비물 / 후속
- ~~Noto Sans 폰트 파일 추가~~ ✅ 완료.
- ~~Google Stitch 접근~~ ✅ 연결됨 — 색상 전체 스킴·온보딩 3페이지 카피·화면 레이아웃 코드 반영 완료.
- **폰트 불일치(주의)**: Stitch 타이포는 Plus Jakarta Sans + Be Vietnam Pro(프로즈엔 Pretendard 언급)이나, 두 라틴 폰트는 JA/ZH 글리프 미커버 → 승인된 결정대로 **Noto Sans 유지**. 타입 스케일 수치는 M3 기본과 동일해 시각 차이 없음. Stitch 폰트를 실제로 바꿀지는 확인 필요.
- 온보딩 미디어: 현재 그라데이션 플레이스홀더 카드(캡션·위치·하트 배지 포함) → 실제 장소 사진 에셋으로 교체(후속).
- 네이티브 스플래시: 코랄 배경 적용 완료, 로고 PNG는 후속(현재 배경색만). 다크 색상 톤(Stitch 라이트만 제공).
- **임시 디버그 뒤로가기 버튼**: 좌상단 전역 오버레이(ShellRoute), 홈에서는 온보딩 상태 리셋 후 재생. 배포 전 제거 대상.
- big-size 스플래시 아이콘 `asset/icon/app-icon-splash.svg`(흰 카드+코랄 로고) 신규 적용.

---

## 12. 인수 조건 (Acceptance Criteria)

- [ ] 앱 실행 시 네이티브 스플래시(라이트/다크)에 로고 마크가 표시된다.
- [ ] 최초 실행에서 인앱 스플래시 → 언어 선택 → 온보딩 순으로 진행된다.
- [ ] 언어를 선택하면 스플래시·온보딩을 포함한 모든 화면 문구가 해당 언어로 즉시 바뀐다.
- [ ] 지원 언어는 EN/KO/JA/ZH 4개이며, 미선택 시 기기 로케일 매칭·미매칭 시 영어로 표시된다.
- [ ] 온보딩 완료(또는 스킵) 후 재실행하면 언어선택·온보딩을 건너뛴다.
- [ ] 라이트/다크 테마가 시스템 설정을 따라 전환된다.
- [ ] 모든 화면에서 텍스트가 Noto Sans로 렌더되며 4개 언어 글리프가 깨지지 않는다.
- [ ] 색상은 지정 팔레트 기반 M3 ColorScheme를 통해서만 사용된다(하드코딩 없음).
- [ ] 스플래시/언어선택/온보딩 화면 파일·클래스명이 `*_screen`/`*Screen` 규칙을 따르고 `common/` 아래에 위치한다.
- [ ] 첫 실행 분기가 GoRouter `redirect`로 구현된다.

---

## 13. 향후 단계 (참고)
- **Step 2**: 로그인/인증 (secure storage 토큰, GraphQL AuthLink).
- **Step 3**: 홈 스크린 및 실시간 위치기반 관광 기능.
