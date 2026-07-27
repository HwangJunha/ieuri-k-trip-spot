---
title: "[K-Trip Spot] Flutter로 외국인 관광앱 만들기 #1 — 테마·다국어·온보딩 기반 다지기"
tags: [Flutter, Riverpod, GoRouter, i18n, 다국어, DDD, 온보딩]
---

> 2026 한국관광공사 OpenAPI 공모전을 목표로, 한국을 방문한 외국인을 위한 실시간·위치기반 관광 앱 **K-Trip Spot**을 만들고 있다.
> 이 글은 그 첫 스텝(Step 1) — **화면 기능이 아니라 앱의 토대**(테마·폰트·색상·다국어·첫 실행 플로우)를 세운 기록이다.

---

## 왜 "기능"이 아니라 "기반"부터?

로그인·홈 화면부터 만들고 싶은 유혹이 크지만, 다국어 앱에서 색상·폰트·i18n·라우팅을 나중에 끼워 넣으면 전 화면을 다시 손봐야 한다. 그래서 Step 1은 의도적으로 **토대**만 세웠다.

- **Step 1 (이번 글)**: 디자인 시스템 + 다국어 + 첫 실행 플로우(스플래시 → 언어선택 → 온보딩)
- Step 2: 로그인/인증
- Step 3: 홈 & 실시간 관광 기능

Step 1이 끝나면 이후 화면들은 이미 갖춰진 테마·다국어·라우팅 위에 얹기만 하면 된다.

---

## 설계 원칙 — "도메인 우선, 공용은 공용에"

이 프로젝트는 백엔드(Kotlin/DDD)와 결을 맞춰 **feature/domain 우선 + 레이어 구조**를 택했다. 의존성은 아래로만 흐른다.

```
lib/
├── common/                 # 두 개 이상 기능이 공유하는 것만
│   ├── theme/              # ColorScheme, ThemeData
│   ├── localization/       # LocaleController, 지원 언어
│   ├── storage/            # SharedPreferences 래퍼
│   └── onboarding/         # 첫 실행 플로우(스플래시/언어선택/온보딩)
│       ├── provider/       # Riverpod 상태
│       └── view/           # *_screen.dart
├── l10n/                   # *.arb (gen-l10n 입력)
├── router/                 # GoRouter + redirect
└── main.dart
```

레이어 규칙(hook으로 강제):
- `model`은 **순수 Dart** — `flutter`/`graphql`/`riverpod` import 금지
- `view`/`component`는 repository·GraphQL 직접 접근 금지 → 반드시 provider 경유
- 기능 간 교차 import 금지 → 공유물은 `common/`으로

스플래시·언어선택·온보딩은 특정 도메인 기능이 아니라 **앱 진입 공용 플로우**라 `common/` 아래 두었다.

---

## 1. 다국어 — 가장 먼저, 그리고 가장 아팠던 부분

### gen-l10n(ARB)로 결정

다국어 방식은 여러 가지(easy_localization, slang 등)가 있지만, **업계 표준이자 Flutter 공식**인 `flutter_localizations` + `intl` + gen-l10n(ARB)로 갔다. 서드파티 의존 없이 컴파일 타임에 타입 안전한 접근자를 얻는다.

```yaml
# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_ko.arb
output-dir: lib/l10n/gen
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
```

한국어(`ko`)를 **소스 언어**로 두고 EN/JA/ZH는 이를 번역했다. 저장된 언어가 없으면 기기 로케일을 지원 언어와 매칭하고, 없으면 영어로 폴백한다.

```dart
enum AppLanguage {
  english('en', 'English', 'English', 'EN'),
  korean('ko', '한국어', 'Korean', 'KR'),
  japanese('ja', '日本語', 'Japanese', 'JP'),
  chinese('zh', '简体中文', 'Chinese', 'CN');
  // ...
  static AppLanguage resolveDefault(String deviceLanguageCode) =>
      fromCode(deviceLanguageCode) ?? AppLanguage.english;
}
```

언어를 바꾸면 `LocaleController`(Riverpod)가 `MaterialApp`의 `locale`을 갱신해 **앱 전역이 즉시 리렌더**된다.

```dart
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Locale build() {
    final saved = ref.watch(appPreferencesProvider).savedLanguage;
    if (saved != null) return saved.locale;
    final deviceCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return AppLanguage.resolveDefault(deviceCode).locale;
  }

  Future<void> select(AppLanguage language) async {
    await ref.read(appPreferencesProvider).saveLanguage(language);
    state = language.locale;
  }
}
```

### 💥 삽질 1 — 중국어·일본어 글자가 깨진다

여기서 첫 번째 벽. 처음엔 한글에 좋은 **Pretendard**를 기본 폰트로 썼는데, 중국어(简体)·일본어 화면에서 글리프가 깨지거나 두부(□)가 떴다. Pretendard는 한글+라틴은 완벽하지만 **CJK 전용 글리프 커버가 약하다.**

해결책은 **Noto Sans로 통일** + CJK 폴백 체인:

```dart
ThemeData(
  fontFamily: 'NotoSans',
  fontFamilyFallback: const ['NotoSansKR', 'NotoSansJP', 'NotoSansSC'],
  // ...
);
```

`pubspec.yaml`에 Noto Sans(Latin)와 KR/JP/SC를 각각 폰트 패밀리로 등록하고, 기본은 `NotoSans`, 없는 글리프는 폴백이 순서대로 채운다. EN/KO/JA/ZH 네 언어가 한 벌의 폰트 체계로 일관되게 렌더된다.

> 참고: 디자인(Stitch)은 Plus Jakarta Sans + Be Vietnam Pro를 지정했지만, 이 둘 역시 JA/ZH를 커버하지 못해 채택하지 않았다. **다국어 앱에서 폰트 선택은 "예쁨"보다 "글리프 커버리지"가 먼저다.**

---

## 2. 디자인 시스템 — Google Stitch → Material 3

디자인은 **Google Stitch**(MCP로 연동)에서 만든 디자인 시스템을 따랐다. Stitch가 내보낸 M3 컬러 롤 전체를 그대로 `ColorScheme`로 옮겼다.

```dart
static const ColorScheme _lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFB2211D),        // 시드 #EA4A3F에서 대비 보정된 실제 role
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD53B32),
  secondary: Color(0xFF006A6A),
  tertiary: Color(0xFF805200),
  surface: Color(0xFFFFF8F7),
  // ... 40여 개 롤 전체
);
```

한 가지 배운 점: **브랜드 시드 색(#EA4A3F)과 M3 role `primary`(#B2211D)는 다르다.** Material Theme Builder는 대비를 위해 seed에서 primary role을 어둡게 조정한다. 화면은 하드코딩 색이 아니라 항상 `Theme.of(context).colorScheme`의 role을 써야 라이트/다크·접근성이 자동으로 맞는다.

---

## 3. 첫 실행 플로우 — 스플래시 → 언어선택 → 온보딩

```
[앱 실행]
   → (네이티브 스플래시)         OS가 표시, 코랄 배경
   → (인앱 스플래시)             저장된 locale/onboarding 로드 후 분기
        ├ 온보딩 완료   → 홈(Step2 자리)
        └ 미완료        → 언어선택 → 온보딩(3페이지) → 홈
```

라우팅은 `GoRouter`, 분기는 위젯 내부 조건문이 아니라 **`redirect`로 선언적으로** 처리했다.

```dart
redirect: (context, state) {
  final completed = ref.read(onboardingControllerProvider);
  final loc = state.matchedLocation;
  if (completed && (loc == Routes.language || loc == Routes.onboarding)) {
    return Routes.home;            // 온보딩 끝낸 유저는 다시 안 봄
  }
  if (!completed && loc == Routes.home) {
    return Routes.language;        // 첫 유저는 홈으로 못 건너뜀
  }
  return null;
},
```

언어/온보딩 완료 여부는 비밀값이 아니므로 `SharedPreferences`에 저장한다. (토큰류는 Step 2에서 `flutter_secure_storage`로.)

### 완성된 화면

**스플래시** — 전체 코랄 브랜드 화면. 큰 흰색 앱 아이콘 + 화이트 타이포 + 로딩 바.
`![스플래시](여기에_splash_스크린샷_업로드)`

**언어 선택** — 카드형 리스트. 언어를 탭하면 그 자리에서 화면이 해당 언어로 즉시 바뀐다.
`![언어선택](여기에_language_스크린샷_업로드)`

**온보딩** — 상단 로고+Skip, 큰 미디어 카드(위치 라벨·하트 배지), primary 색 타이틀, 점 인디케이터.
`![온보딩](여기에_onboarding_스크린샷_업로드)`

---

## 트러블슈팅 모음 — 삽질이 곧 배움

### 💥 삽질 2 — 스플래시가 왼쪽으로 쏠렸다

밝은 배경 + 좌측 정렬 레이아웃이 원인이었다. Stitch 원본은 **전체 코랄 배경 + 완전 중앙 정렬**이라, 이 화면을 아예 다시 그리면서 `CrossAxisAlignment.center`와 `textAlign: TextAlign.center`로 통일해 해결.

### 💥 삽질 3 — `MaterialApp.router`의 builder에서 `GoRouter.of()`가 터진다

전역 back 버튼 오버레이를 `MaterialApp.router`의 `builder`에 달았더니:

```
No GoRouter found in context
```

`builder`의 context는 **Router보다 위**라서 `GoRouter.of(context)`가 없다. 해결은 오버레이를 **`ShellRoute`** 안으로 옮기는 것. ShellRoute의 subtree는 GoRouter 아래라 `context.go()`가 정상 동작하고, `state.matchedLocation`으로 현재 경로도 바로 얻는다.

```dart
ShellRoute(
  builder: (context, state, child) =>
      DebugBackButton(location: state.matchedLocation, child: child),
  routes: [ /* language, onboarding, home */ ],
),
```

### 💥 삽질 4 — 홈에서 뒤로가기가 먹히지 않는다

온보딩을 끝낸 뒤 홈에서 뒤로가기를 누르면 아무 반응이 없었다. 원인은 위의 `redirect` 가드 — `완료 상태 + /onboarding`은 다시 `/home`으로 튕겨낸다. 디버그용 back은 **온보딩 상태를 리셋한 뒤** 이동하게 해서 플로우를 재생할 수 있게 했다.

```dart
if (location == Routes.home) {
  await ref.read(onboardingControllerProvider.notifier).reset(); // completed=false
}
context.go(target);
```

### 💥 삽질 5 — 새 SVG 아이콘이 커밋에서 사라진다

스플래시용 아이콘 `app-icon-splash.svg`를 추가했는데 `git status`에 안 잡혔다. 범인은 macOS용 `.gitignore` 한 줄:

```gitignore
# Icon must end with two \r
Icon
```

macOS는 `core.ignorecase=true`라 이 `Icon` 패턴이 **`asset/icon/` 디렉터리와 대소문자 무시로 매칭**되어, 그 안의 새 파일이 통째로 무시됐다. 기존 SVG들은 이미 추적 중이라 영향이 없어 눈치채기 어려웠다. `git add -f`로 강제 추가해 해결.

---

## 테스트 전략 — 레이어별로 모양이 다르다

Flutter에서도 백엔드처럼 **레이어마다 테스트 형태**를 맞췄다.

| 대상 | 테스트 |
|---|---|
| `model` (AppLanguage 등) | 순수 단위 테스트, 목 없음 |
| `provider` (LocaleController 등) | `ProviderContainer` + prefs override |
| `view` | 위젯 테스트: 언어 탭 시 문구 전환 검증 |
| 플로우 | E2E: 스플래시 → 언어선택 → 온보딩 3페이지 → 홈 |

특히 **E2E 플로우 테스트**가 유용했다. `SplashScreen`의 고정 지연을 `tester.pump(Duration)`으로 넘기고, 실제 앱을 구동하며 각 화면 전환을 단언한다.

```dart
await tester.pump(const Duration(milliseconds: 1600)); // 스플래시 지연 통과
await tester.tap(find.text('한국어'));
await tester.tap(find.text('선택 완료'));
expect(find.text('스와이프로 발견하세요'), findsOneWidget); // 온보딩 1페이지
// ... 다음 → 다음 → 시작하기 → 홈
```

최종적으로 `flutter analyze` 무결점, `flutter test` 14개 통과.

---

## 정리 & 다음 스텝

Step 1에서 세운 것:
- ✅ Stitch 기반 M3 디자인 시스템 (light/dark)
- ✅ Noto Sans 통일로 EN/KO/JA/ZH 글리프 무결점
- ✅ gen-l10n 다국어 + 런타임 언어 전환
- ✅ 스플래시 → 언어선택 → 온보딩 첫 실행 플로우 (GoRouter redirect)
- ✅ Riverpod 3(codegen) 상태관리, 레이어별 테스트 14개

배운 것 한 줄 요약:
- **다국어 앱은 폰트 글리프 커버리지가 디자인보다 먼저다.**
- **분기는 위젯 조건문이 아니라 라우터 redirect로.**
- **디자인 시스템의 seed 색과 M3 role 색은 다르다 — 항상 role을 써라.**

다음 스텝(Step 2)은 **로그인/인증**. 이미 깔아둔 테마·다국어·라우팅 위에 화면만 얹으면 된다. 온보딩 실사진 에셋 교체와 디버그 back 버튼 제거도 함께.

읽어주셔서 감사합니다 🙌
