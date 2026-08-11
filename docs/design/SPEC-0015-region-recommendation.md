# 디자인 참조 — 지역 추천 화면 (SPEC-0015)

> 설계 문서: `problem/SPEC-0015-client.md` · 수용 기준: `Specs/SPEC-0015/spec.md` (R15·R20~R31)
> Stitch 프로젝트: `projects/8651053354437738829` (K-Trip Spot Design System)
> 디자인 시스템: `assets/073fee5b990e4b1eb2c918d7e9de2d8f`
> **Stitch 화면: `4b9e3cbb91ef49a4b99eb2747021e6c0` ("Recommended Regions", 780×1958)**

이 문서는 **레이아웃·컴포넌트 분해 참조**다. 수용 기준과 어긋나면 스펙이 이긴다.
색·폰트·간격 값은 여기 적힌 것을 복사하지 말고 `Theme.of(context)`에서 읽는다(DESIGN.md §12,
CLAUDE.md §9). 폰트는 Stitch가 이름한 Plus Jakarta Sans / Be Vietnam Pro가 아니라 앱이 쓰는
**Noto Sans**(+CJK 폴백) — `lib/common/theme/app_theme.dart`가 그대로 유지한다. 이 문서는
타입 *스케일*(제목/본문/라벨 크기 관계)만 참고한다.

## Stitch 생성 경위 (2026-08-11 갱신)

작성 당시에는 `generate_screen_from_text`가 타임아웃으로 실패해 목업 없이 이 문서를 썼다.
**이후 화면이 생성돼 상단에 id를 채웠다**(`4b9e3cbb91ef49a4b99eb2747021e6c0`).

구현은 목업이 나오기 전에 아래 근거로 완료됐고, **이후 목업과 대조했다(2026-08-11).**

구조는 일치한다 — 순위 배지·지역명·시도명·총점·5개 항목·부분 데이터 칩·카드마다 붙는 기준
시점, 그리고 항목 라벨(Expected Crowd / Visitor Volume / Stay Intensity / Spending
Intensity / Distance)까지 같다.

의도적으로 목업과 다르게 둔 것이 하나 있다. 정렬 안내 칩이 목업은 "Sorted by score",
구현은 **"Sorted by overall score"**다. 이 칩의 존재 이유가 "거리순이 아니라 종합 점수
순"임을 드러내는 것인데(설계 §4.2), "by score"만으로는 어떤 점수인지 모호해 거리순 오해를
막지 못한다. 이 문서 §3도 "Sorted by overall score"로 적고 있다 — 목업과 스펙이 어긋나면
스펙이 이긴다(문서 상단).

아이콘은 목업이 `sort`, 구현이 `leaderboard_outlined`인데 §3이 둘 다 허용한다.

이 문서가 근거로 삼은 것:
- `problem/SPEC-0015-client.md` (클라이언트 설계, §1~§8)
- `Specs/SPEC-0015/spec.md` R15·R20~R31, §7.5(결측 항목 생략)·§7.6(거리는 필터가 아님)·
  §7.8(빈 결과 두 상태)
- 이미 구현된 도메인 모델: `lib/domain/map/model/region_recommendation.dart`,
  `region_score.dart`(필드·enum이 확정돼 있어 화면이 그대로 소비한다)
- 이미 구현된 `lib/domain/map/provider/region_recommendation_provider.dart`(재시도 상한 3회,
  `AsyncValue` 상태, 위치 실패를 삼키는 처리까지 완료)
- `docs/design/SPEC-0014-map-congestion.md`(같은 map 피처의 톤·컴포넌트 명명 기준)
- 이미 구현된 `lib/domain/map/component/area_info_card.dart`(색+라벨 병기, `CongestionDisplay`
  포맷팅 재사용 패턴)와 `congestion_legend.dart`, `map_notice_banner.dart` 등 기존 map
  컴포넌트의 스타일 관행
- `lib/common/widget/floating_bottom_nav_scaffold.dart`(플로팅 네비바 실측 치수)
- `lib/common/theme/app_theme.dart` / `app_colors.dart`(M3 컬러 롤)

**slice-builder에게**: Stitch 스크린이 나중에 생성되면 이 문서 상단의 "Stitch 화면" 줄에
스크린 id를 채워 넣고, 아래 레이아웃과 실제 목업이 크게 어긋나면 이 문서를 갱신한다. 그 전까지
이 문서가 유일한 참조다 — 목업 부재가 구현을 막지 않는다.

---

## 화면 구조

지역 추천은 **독립 화면이 아니라 지도 진입 경로 중 하나**다(설계 §1). 지도 화면 위에서
진입하는 목록 화면으로, 하단 플로팅 네비바는 Map 탭이 활성 상태로 유지된다(카메라 이동으로
지도 화면에 복귀하는 것이 자연스러운 귀결이므로 별도 탭을 두지 않는다).

```
RegionRecommendationScreen (신규, lib/domain/map/view/)
└─ Scaffold
   ├─ AppBar
   │   ├─ title: "Recommended Regions" (l10n)
   │   └─ 뒤로가기 — 지도 화면으로 복귀(카메라 이동 없이)
   └─ body: 상태별 분기 (아래 "상태" 절)
       ├─ 로딩: 중앙 스피너 또는 스켈레톤 카드 3~4개
       ├─ 정상: SortIndicatorChip + RegionCard 리스트
       ├─ 빈 결과(데이터 모으는 중) / 빈 결과(조건 불충족): EmptyState
       └─ 오류: ErrorState(재시도 버튼, 상한 도달 시 버튼 숨김/비활성)
FloatingBottomNavScaffold (셸 레벨, 진입 경로에 따라 유지 또는 없음 — 아래 "진입 경로" 참조)
```

**진입 경로(갭으로 기록)** — spec/설계 문서 모두 이 화면으로의 진입 지점(지도 화면의 버튼·
메뉴 등)을 명시하지 않았다. 지도 화면에서 어떤 트리거로 진입하는지는 slice-builder가
`map_screen.dart`를 보고 자연스러운 위치(예: 앱바 액션 아이콘, 플로팅 버튼)를 정한다. 이
화면 자체는 지도 위 오버레이가 아니라 **별도 라우트의 전체 화면 리스트**로 설계한다 — 카드가
여러 개 쌓이고 스크롤이 필요해 지도 위 카드 형태(`AreaInfoCard`처럼 하단 고정)로는 부적합하다.

---

## 컴포넌트 (`lib/domain/map/component/`)

| 컴포넌트 | 역할 | 비고 |
|---|---|---|
| `region_card.dart` (신규) | 지역 카드 한 장 — 순위·지역명·시도명·총점·`ScoreBreakdown`·기준 시점 | §1 |
| `score_breakdown.dart` (신규) | 항목별 점수 막대 그룹 | §2 |
| `sort_indicator_chip` (신규) | "Sorted by overall score" 안내 칩 | §3 |
| `region_recommendation_empty_state` (신규) | 빈 결과 두 상태 안내 | §4 |
| `region_recommendation_error_state` (신규) | 오류 + 재시도 | §5 |

컴포넌트는 `RegionRecommendations` provider가 노출하는 `RegionRecommendationResult`
(`lib/domain/map/model/region_recommendation.dart`)만 소비한다 — 자체적으로 GraphQL을
만지지 않는다(CLAUDE.md §3).

---

## 1. `RegionCard` — 지역 카드

카드 하나 = 시군구 하나. `RegionRecommendation` 모델(이미 구현됨)의 필드를 그대로 그린다.

```
┌──────────────────────────────────────────┐
│ ①                                      88 │  ← ① 순위 배지(1,2,3…) 좌상단
│  Myeong-dong                              │  ← name (title-md급, bold)
│  Jung-gu, Seoul                           │  ← provinceName (body-sm, onSurfaceVariant)
│                                            │
│  ─ ScoreBreakdown (아래 §2) ─              │
│                                            │
│  (선택) "Based on partial data"           │  ← scoreFactorCount < 5일 때만
│  🕒 As of Aug 10, 3:30 PM                 │  ← dataBasisAt, observedAtLabel 재사용
└──────────────────────────────────────────┘
```

- **순위 배지**: 카드 좌상단, 작은 원형 또는 pill. 리스트 인덱스(1부터)로 구성 — 서버가
  순위 필드를 내려주지 않으므로 화면이 `regions` 리스트의 위치로 매긴다. `labelSmall`급
  텍스트, `surfaceContainerHigh` 배경.
- **총점 배지**: 카드 우상단, `totalScore`를 정수로 반올림해 크게 표시(`headlineSmall`급).
  배경은 `primary`(코랄) 계열 — SPEC-0014가 4단계 혼잡도에 이미 semantic color를 쓰고
  있으므로 점수 자체에는 별도 임계값 색 구분을 두지 않는다(스펙에 점수 구간별 색 규칙이
  없음 — 임의로 만들지 않는다, 갭으로 기록). `onPrimary` 텍스트.
- **지역명 / 시도명**: `name`을 `titleMedium` bold로, 바로 아래 또는 옆에 `provinceName`을
  `bodySmall` + `onSurfaceVariant`로 붙인다(§2.1 — "같은 이름 시군구 구분"이 목적이므로
  시각적으로 가깝게 배치해야 한다. 줄바꿈 시에도 두 텍스트가 한 그룹으로 보이게 spacing을
  좁게 유지).
- **`ScoreBreakdown`**: 아래 §2.
- **"Based on partial data" 칩**: `scoreFactorCount < 5`일 때만 노출(§2.2, R31). 작은
  `Chip` 또는 인라인 텍스트, `surfaceContainerHigh` 배경 + `Icons.info_outline` 14dp +
  `labelSmall`. **숫자(`scoreFactorCount`)는 그대로 노출하지 않는다** — 스펙이 명시적으로
  "그대로 노출할 필요는 없다"고 했고, 문구만으로 항목 수 차이를 인지시킨다.
- **기준 시점**: `dataBasisAt`을 `Icons.schedule`(또는 `Icons.access_time`) 14dp +
  `l10n.mapObservedAt(...)` 패턴으로 표시(§2.3, POL-038). **`CongestionDisplay.observedAtLabel`
  을 그대로 재사용**한다 — SPEC-0014가 이미 "지금/현재 금지, 로케일 포맷" 규칙을 구현해
  뒀으므로 새 포맷터를 만들지 않는다. l10n 키는 `mapObservedAt(time)`을 재사용하거나, 이
  화면 전용 문구가 필요하면 새 키를 추가하되 뜻은 동일하게 "(시점) 기준"으로 유지한다.
- **탭 동작**: 카드 전체가 탭 타깃(`InkWell`/`Card` onTap). 탭하면 지도 화면으로 이동해
  `RegionRecommendation.centerLat/centerLng`로 카메라를 이동한다(§3, `map_screen.dart`의
  기존 `CameraUpdate.newCenterPosition` 경로 재사용 — 새 카메라 이동 로직을 만들지 않는다).
- **터치 타깃**: 카드 전체 탭 영역이 48dp를 훨씬 넘으므로 별도 조정 불필요.
- **스타일**: `Card`, `surfaceContainerLow` 배경, `radius.lg`(20px 상당) 모서리, elevation
  1~2(리스트 카드이므로 지도 위 오버레이보다 낮은 elevation). 카드 간 세로 간격
  `spacing.md`.

---

## 2. `ScoreBreakdown` — 항목별 점수 막대

**총점만으로는 왜 추천됐는지 알 수 없다**(R23, 설계 §2.2)는 것이 이 컴포넌트의 존재 이유다.

```
Expected Crowd     ▓▓▓▓▓▓▓░░░  72
Visitor Volume     ▓▓▓▓▓▓▓▓░░  81
Stay Intensity     ▓▓▓▓▓░░░░░  54
Spending Intensity ▓▓▓▓▓▓░░░░  63
Distance           ▓▓▓▓▓▓▓▓▓░  91
```

- **입력**: `RegionRecommendation.scores`(`List<RegionScore>`, 이미 구현됨). 각 원소가
  `RegionScoreFactor`(enum) + `value`(0~100) + `fraction`(0.0~1.0, 이미 계산돼 있음)를
  갖는다.
- **행 구성**: 항목당 한 행 — 라벨(고정폭 또는 `Expanded`) + 얇은 가로 막대
  (`LinearProgressIndicator` 또는 커스텀 `Container` 기반, height 6~8dp, `radius.full`) +
  값 텍스트(선택적, 공간이 부족하면 생략 가능 — 막대 길이 자체가 1차 정보).
- **막대 색**: teal(`secondary` 롤)을 기본으로 쓴다 — 총점 배지의 코랄(`primary`)과 색을
  분리해 "총점"과 "항목별 점수"가 다른 종류의 정보임을 시각적으로 구분한다(SPEC-0014가
  마커 색과 폴리곤 색을 분리한 것과 같은 원칙).
- **결측 항목 — 절대 0점 막대로 그리지 않는다**(핵심 제약, §2.2·R31). 구현 방식:
  - `RegionRecommendation.lacks(factor)`가 이미 구현돼 있으므로, 5개 항목
    (`congestion, visitorVolume, stayIntensity, spendingIntensity, distance`)을 순회하며
    `lacks(factor)`가 참이면 **그 행 자체를 렌더링하지 않는다** — 자리를 완전히 비운다.
  - 대안으로 "정보 없음" 텍스트 행을 회색으로 남기는 방식도 스펙이 허용하지만(§2.2 —
    "자리를 비우거나 '정보 없음'으로 표기"), **행을 아예 생략하는 쪽을 기본으로 권장**한다.
    이유: 위치 권한이 없는 사용자에게는 모든 카드에서 Distance 행이 사라지는데, 매 카드마다
    "정보 없음" 회색 행을 반복해서 보여주는 것보다 조용히 4개 항목만 보이는 편이 노이즈가
    적다. slice-builder가 실제 카드 밀도를 보고 "정보 없음" 표기로 바꿀 수 있다(갭으로 기록
    — 최종 선택은 실기기 확인 후).
  - `RegionScoreFactor.unknown`(서버가 추가한 미지 항목)도 그리지 않는다 — 모델 주석이 이미
    "화면은 이 값을 그리지 않는다"고 명시.
- **항목 순서**: enum 선언 순서(`congestion, visitorVolume, stayIntensity,
  spendingIntensity, distance`)를 고정 순서로 쓴다 — 카드마다 순서가 바뀌면 스캔하기
  어렵다.
- **라벨 문구**: "지금 한산함"류 표현 금지(§2.3, 핵심 제약). `congestion` 항목의 라벨도
  단순히 "Expected Crowd" 또는 "Crowd Forecast" 정도로 두고, 막대가 높을수록 좋다는 것은
  다른 항목과 동일한 시각 언어(긴 막대 = 좋음)로 전달한다 — 별도 설명 문구를 카드마다
  달지 않는다.

---

## 3. 정렬 기준 안내 (`SortIndicatorChip`, §4 핵심 제약)

**거리순이 아니라 총점순임을 화면에서 드러낸다**(설계 §4.2). 오해하면 "왜 더 가까운 데를 안
보여주지"로 읽힌다.

- **배치**: 리스트 최상단, `AppBar` 바로 아래 — 리스트를 스크롤하기 전에 반드시 보이는
  위치.
- **구성**: 작은 pill/chip. `Icons.sort` 또는 `Icons.leaderboard` + "Sorted by overall
  score"(l10n). 부제 형태로 앱바 subtitle에 통합해도 되고, 별도 chip으로 둬도 된다 —
  slice-builder가 앱바 높이 제약에 맞춰 선택.
- **`ScoreBreakdown`의 Distance 행**이 이 원칙의 1차적 해소책이라는 점도 함께 기억한다
  (설계 §4.2 — 사용자가 카드 안에서 "왜 이 순서인지"를 바로 확인할 수 있어야 한다).

---

## 4. 빈 결과 — 오류가 아니다 (`RegionRecommendationEmptyState`, §5.1·R15·R20)

**절대 오류 화면으로 그리지 않는다.** `RegionRecommendationResult`가 이미
`isAwaitingData` / `hasNoMatch` 두 게터를 구현해 뒀으므로 화면은 이 둘로만 분기한다.

| 상태 | provider 게터 | 아이콘 | 문구(예시, l10n 키는 slice-builder가 확정) |
|---|---|---|---|
| 데이터 자체가 없음 | `isAwaitingData` (`dataBasisAt == null`) | `Icons.hourglass_empty` 또는 `Icons.data_usage` | "We're still gathering data for this feature. Check back soon." |
| 데이터는 있으나 조건 불충족 | `hasNoMatch` (`dataBasisAt != null`) | `Icons.search_off` | "No regions match right now. Try again later." |

- **공통 레이아웃**: 중앙 정렬, 아이콘(48~64dp, `onSurfaceVariant` 톤 — 오류 색인 `error`
  롤을 쓰지 않는다) + 제목(`titleMedium`) + 설명(`bodyMedium`, `onSurfaceVariant`).
  Stitch 프로젝트에 이미 있는 "muted outlined icon" 톤(`assets/`의 empty-state 아이콘
  생성물 참고)과 동일한 절제된 스타일을 따른다.
- **재시도 버튼을 두지 않는다** — 빈 결과는 오류가 아니므로 "다시 시도"가 아니라 "나중에
  확인"이 맞는 메시지다(§5.1, "재시도로는 해결되지 않는다"). 필요하면 당겨서 새로고침
  (`RefreshIndicator`)만 허용 — 이는 재시도 상한 카운터를 소모하지 않는 별도 경로로 둔다
  (갭으로 기록: pull-to-refresh와 재시도 버튼의 카운터 공유 여부는 spec에 명시가 없다.
  slice-builder가 `RegionRecommendations.retry()`를 pull-to-refresh에도 연결할지, 별도
  무제한 새로고침을 둘지 결정한다).

---

## 5. 오류 상태 (`RegionRecommendationErrorState`, §5.2·R28)

- **트리거**: provider의 `AsyncValue`가 `error` 상태일 때만(네트워크 실패 등 — 빈 결과와는
  다른 경로).
- **구성**: 중앙 정렬, `Icons.error_outline`(또는 `Icons.wifi_off` — 원인에 따라
  slice-builder가 선택), 설명 텍스트, "Retry" 버튼(`FilledButton`).
- **재시도 상한**: 횟수는 **별도 provider**가 센다(`regionRecommendationRetryCountProvider`).
  **상한(3회) 도달 시 버튼을 숨기거나 비활성화**하고, 대신 "여러 번 시도했지만 실패했습니다"
  류의 문구로 전환한다 — 계속 눌러도 반응 없는 버튼을 남겨두면 안 된다.
  **시간 기반 재시도 문구("N초 후 다시 시도")는 쓰지 않는다**(§5.2 — 근거 없는 수치이므로).
- **버튼 동작**:
  ```dart
  final counter = ref.read(regionRecommendationRetryCountProvider.notifier);
  if (counter.canRetry) {
    counter.record();
    ref.invalidate(regionRecommendationsProvider);
  }
  ```
  **상한을 목록 provider 안에 두지 않는 이유**: provider의 생명주기(폐기·재생성·지연 빌드)에
  횟수를 얹으면 "몇 번 조회됐나"가 구독 상태에 따라 달라진다 — 재시도 한 번에 요청이 두 번
  나가거나 상한을 넘겨 한 번 더 나가는 것을 실제로 측정했다. 횟수는 누른 사람이 세는 것이므로
  화면이 센다.

---

## 6. 로딩 상태

- 스펙에 로딩 화면의 세부 요구는 없다. 표준 처리로 둔다: 중앙 `CircularProgressIndicator`
  또는 카드 3~4개 분량의 스켈레톤(회색 블록)으로 리스트 레이아웃을 미리 암시. 두 방식 중
  선택은 slice-builder가 다른 화면(`Discover`, `Spot Detail`)의 로딩 패턴과 맞춰 정한다
  (갭으로 기록 — 이 앱의 로딩 패턴 통일 규칙이 별도 문서에 없다).

---

## 7. 다크 모드

`lib/common/theme/app_theme.dart`의 `AppTheme.dark`를 그대로 상속한다. 이 화면의 모든 색은
`Theme.of(context).colorScheme` 롤(`primary`, `secondary`, `surfaceContainerLow`,
`onSurfaceVariant` 등)로만 참조하므로 개별 다크 목업이 필요 없다 — SPEC-0014와 동일한 원칙
(§7).

---

## 8. 상태 요약

| 상태 | 화면 |
|---|---|
| 로딩 | §6 — 스피너 또는 스켈레톤 |
| 정상(목록 있음) | `SortIndicatorChip` + `RegionCard` 리스트(§1~§3) |
| 빈 결과 — 데이터 모으는 중(`dataBasisAt == null`) | §4 첫 번째 행 — 오류 아님 |
| 빈 결과 — 조건 불충족(`dataBasisAt != null`) | §4 두 번째 행 — 오류 아님 |
| 오류(네트워크 등) | §5 — 재시도 버튼, 상한 도달 시 버튼 숨김/비활성 |
| 위치 권한 없음 | 정상 목록과 동일하게 렌더 — 각 카드의 `ScoreBreakdown`에서 Distance 행만 생략(§2, R27). 별도 배너·안내를 추가하지 않는다(스펙에 요구 없음) |

---

## 9. 다국어

전부 텍스트·숫자·시각이라 로케일 포맷팅만으로 4개 언어(EN/KO/JA/ZH)를 지원한다. 지역명·
시도명은 서버가 활성 언어로 내려준다(`RegionRecommendation.name`/`provinceName` 주석 참조)
— 클라이언트가 별도 번역 테이블을 두지 않는다. 사용할 ARB 키(신규, slice-builder가 정확한
문구를 최종 확정):

```
mapRegionRecommendationsTitle          ("Recommended Regions")
mapRegionRecommendationsSortedByScore  ("Sorted by overall score")
mapRegionRecommendationPartialData     ("Based on partial data")
mapRegionRecommendationDataBasis(time) ("As of {time}")            ← mapObservedAt 재사용 검토
mapRegionRecommendationsGathering      ("We're still gathering data for this feature.")
mapRegionRecommendationsNoMatch        ("No regions match right now.")
mapRegionRecommendationsError          ("Couldn't load recommendations.")
mapRegionRecommendationsRetry          ("Retry")
mapRegionRecommendationsRetryExhausted ("Please try again later.")
mapScoreFactorCongestion / VisitorVolume / StayIntensity / SpendingIntensity / Distance
  (§2 항목 라벨 — "지금/현재/실시간" 금지, "Expected Crowd" 류 표현 사용)
```

기존 `mapObservedAt(time)`을 그대로 재사용할지 이 화면 전용 키를 새로 둘지는 문구 톤이
같으므로 slice-builder가 실제 구현 시 하나로 통일해도 된다(갭으로 기록).

---

## 갭 / 미확정

- **Stitch 목업 부재** — 위 "Stitch 생성 갭" 참조. 서비스 복구 시 생성해 이 문서를 시각적으로
  검증하고 스크린 id를 채운다.
- **지도 화면에서의 진입 트리거 위치** — spec·설계 문서 모두 명시하지 않음. slice-builder가
  `map_screen.dart`의 여유 공간(앱바 액션 등)에 배치.
- **결측 항목을 "행 생략" vs "정보 없음 회색 행"으로 그릴지** — 스펙은 둘 다 허용. 이 문서는
  행 생략을 기본으로 권장하되 최종 선택은 실기기 확인 후 slice-builder가 정한다.
- **총점 배지에 구간별 색을 둘지** — 스펙에 점수 구간별 색 규칙이 없어 임의로 만들지 않았다.
  단일 `primary` 톤으로 시작하고, 필요성이 확인되면 별도 `[AMEND]`로 요청한다.
- **pull-to-refresh와 재시도 버튼의 카운터 공유 여부** — §4에 기록. spec에 명시 없음.
- **로딩 화면의 정확한 형태(스피너 vs 스켈레톤)** — 앱 전체의 로딩 패턴 통일 규칙이 별도로
  없어 slice-builder가 다른 화면과 맞춰 정한다.
