# 디자인 참조 — 지도 화면 (SPEC-0014)

> 설계 문서: `problem/SPEC-0014-client.md` · 수용 기준: `Specs/SPEC-0014/spec.md` (R18~R30)
> Stitch 프로젝트: `projects/8651053354437738829` (K-Trip Spot Design System)
> 디자인 시스템: `assets/073fee5b990e4b1eb2c918d7e9de2d8f`
> **Stitch 화면: 없음 — 아래 "Stitch 생성 갭" 참조**

이 문서는 **레이아웃·컴포넌트 분해 참조**다. 수용 기준과 어긋나면 스펙이 이긴다.
색·폰트·간격 값은 여기 적힌 것을 복사하지 말고 `Theme.of(context)`에서 읽는다(DESIGN.md §12,
CLAUDE.md §9). 폰트는 Stitch가 이름한 Plus Jakarta Sans / Be Vietnam Pro가 아니라 앱이 쓰는
**Noto Sans**(+CJK 폴백) — `lib/common/theme/app_theme.dart`가 그대로 유지한다. 이 문서는
타입 *스케일*(제목/본문/라벨 크기 관계)만 참고한다.

## Stitch 생성 갭 — 반드시 기록

이번 세션에서 Stitch MCP `generate_screen_from_text`를 5회 시도했으나 전부 실패했다
(타임아웃 4회, `invalid argument` 1회 — 짧은 프롬프트로 재시도해도 동일). `list_screens`로
매번 확인했지만 새 스크린이 생성되지 않았다 — Stitch 쪽 일시 장애로 판단된다.

**그래서 이 문서는 Stitch 목업 없이 작성됐다.** 대신 다음을 근거로 삼았다:
- `problem/SPEC-0014-client.md` (구현 경위 반영된 클라이언트 설계)
- `Specs/SPEC-0014/spec.md` R18~R30, §7.8(4항목 고정), §6.4(출처 표시)
- 이미 구현된 `lib/domain/map/view/map_screen.dart` (지도 SDK 연동, 유휴 판정)
- 이미 구현된 `lib/domain/map/model/congestion_palette.dart` (4단계 색 — **확정, 변경 금지**)
- 이미 구현된 `lib/domain/map/component/congestion_attribution.dart` (출처 표기 — **확정**)
- `lib/common/widget/floating_bottom_nav_scaffold.dart` (플로팅 네비바 실측 치수)
- `lib/common/theme/app_theme.dart` / `app_colors.dart` (M3 컬러 롤)
- 다른 화면의 실제 Stitch 스크린샷(Home, Spot Detail 등)에서 관찰되는 카드·버튼 스타일 관행

**slice-builder에게**: Stitch 스크린이 나중에 생성되면 이 문서 상단의 "Stitch 화면" 줄에
스크린 id를 채워 넣고, 아래 레이아웃과 실제 목업이 크게 어긋나면 이 문서를 갱신한다. 그 전까지
이 문서가 유일한 참조다 — 목업 부재가 구현을 막지 않는다.

---

## 화면 구조 (Stack, 하단 5탭 셸 안 — 2번째 탭)

```
Scaffold (map_screen.dart, 이미 구현됨)
└─ Stack
   ├─ KakaoMap                          전체화면, 배경
   │   └─ (서버 연동 후) 혼잡도 폴리곤 + spot/행사 마커 + 클러스터
   ├─ TruncatedNoticeBanner              상단, 상태바 아래 — R23
   ├─ CongestionLegend                   좌상단 — R24
   ├─ MapZoomControls                    우측, 세로 중앙쯤 — 줌 +/−
   ├─ MyLocationButton                   MapZoomControls 아래, 별도 원형 버튼
   ├─ AreaInfoCard                       하단, 플로팅 네비바 위 — R27 (구역 선택 시만)
   ├─ CongestionDegradedNotice           상단 배너 (혼잡도 실패 시만, TruncatedNotice와 배타적 위치 아님 — 동시 노출 가능하나 우선순위는 실패 안내가 위)
   └─ CongestionAttribution (구현됨)      좌하단 — R30, 항상 SafeArea 보장
FloatingBottomNavScaffold (셸 레벨, common/widget/)
   Map 탭 활성(2번째, index 1)
```

**컨트롤 배치 기준값** — `FloatingBottomNavScaffold.barExtent`(80 + 8*2 = 96, `SafeArea` 별도)를
하단 여유로 확보한다. `AreaInfoCard`와 우측 버튼 그룹 모두 `bottom: barExtent + spacing.sm` 이상
띄운다 — 셸이 `extendBody: true`라 body가 네비바 아래까지 그려지므로 화면이 직접 보정해야 한다
(`floating_bottom_nav_scaffold.dart` 주석 참조).

---

## 컴포넌트 (`lib/domain/map/component/`)

| 컴포넌트 | 역할 | 비고 |
|---|---|---|
| `congestion_attribution.dart` | 출처 표기 텍스트 칩 | **이미 구현됨.** 변경 불필요 |
| `map_zoom_controls` (신규) | 줌 +/− 버튼 쌍 | §1 |
| `my_location_button` (신규) | 현재 위치로 이동 | §1 |
| `spot_marker` / `event_marker` (신규) | 개별 마커 위젯(또는 SDK 마커 아이콘 생성용 헬퍼) | §2 |
| `cluster_marker` (신규) | 클러스터 배지(개수 + 우세 카테고리 아이콘) | §2 |
| `congestion_polygon_layer` (신규) | 혼잡도 폴리곤 렌더 헬퍼 | §5(model) 소비 |
| `area_info_card` (신규) | 구역 선택 말풍선/카드 | §3 |
| `congestion_legend` (신규) | 범례 카드 | §4 |
| `truncated_notice_banner` (신규) | 잘림 안내 배너 | §5 |
| `congestion_degraded_notice` (신규) | 혼잡도 레이어 실패 안내 | §6 |

컴포넌트는 모두 `provider`가 노출하는 상태(마커 목록, 선택된 구역, `truncated` 플래그,
`degraded` 플래그)를 받아 그리기만 한다 — 자체적으로 GraphQL을 만지지 않는다
(CLAUDE.md §3, 계층 규칙).

---

## 1. 지도 위 컨트롤

**배경**: 카카오 지도는 두 손가락 탭(핀치 아닌 두 손가락 동시 탭)으로 축소하는데 이는 사용자가
알아채기 어렵다. 더블탭은 확대만 된다. 그래서 명시적 버튼이 필요하다(사용자 제공 사실).

### `map_zoom_controls`
- **배치**: 화면 우측, 세로로 화면 중앙보다 살짝 아래(엄지 도달 범위) — `right: spacing.md`,
  `bottom: barExtent + spacing.lg + myLocationButtonHeight + spacing.sm` 정도로 잡아
  `MyLocationButton`과 겹치지 않게 쌓는다.
- **구성**: 세로로 긴 `pill` 모양 컨테이너 하나에 `+`(위) / `−`(아래) 두 버튼, 가운데 얇은
  구분선. `Material` + `elevation`(M3 level 1~2), `surfaceContainerHigh` 배경, 아이콘은
  `onSurface` 또는 `primary`.
- **아이콘**: `Icons.add` / `Icons.remove`.
- **터치 타깃**: 각 버튼 ≥48dp(DESIGN.md §2).
- **동작**: 탭 시 `KakaoMapController`의 줌 레벨을 ±1 조정(정수 줌 — 설계 §2.1). 조정 후
  카메라가 멈추면 기존 유휴 판정 경로(§3.1)를 그대로 탄다 — 별도 분기를 두지 않는다.

### `my_location_button`
- **배치**: `map_zoom_controls` 바로 아래, 같은 `right` 정렬, 별도의 원형 버튼(그룹과 시각적으로
  분리 — 줌은 지도 조작, 위치는 별개 액션이므로 붙여서 하나의 그룹처럼 보이면 안 된다. 간격
  `spacing.sm` 이상 띄운다).
- **아이콘**: `Icons.my_location`.
- **스타일**: 원형 `FloatingActionButton`급 크기(48~56dp), `surface`/`surfaceContainerHigh`
  배경, `primary` 아이콘 — 브랜드 강조 없이 보조 액션 톤(DESIGN.md 버튼 규칙의 `OutlinedButton`
  급 강조).
- **동작**: `common/location/location_service`(기존 재사용, 설계 §1)로 현재 위치를 얻어 지도
  중심을 이동. 권한 거부 시 스낵바/토스트로 안내(별도 화면 없음 — 범위 밖 명시가 없어 표준
  거부 처리로 둔다. slice-builder가 기존 위치 권한 처리 패턴을 따른다).

두 컨트롤 모두 `CongestionAttribution`(좌하단)과 하단 플로팅 네비바를 가리지 않는다 —
전부 우측/상단에 배치되므로 겹칠 여지가 없다.

---

## 2. 마커

### 종류 구분 — 아이콘 모양 (R21)
색으로만 구분하면 혼잡도 폴리곤 색과 섞인다(사용자 제공 제약). 그래서:

| 종류 | 아이콘 | 비고 |
|---|---|---|
| Spot(관광지) | `Icons.place` (핀 모양) | 마커 몸체는 중립색(흰 배경 + `primary` 아이콘, 또는 `primary` 배경 + `onPrimary` 아이콘) — 폴리곤 색과 무관하게 항상 읽혀야 한다 |
| 문화행사 | `Icons.event` 또는 `Icons.calendar_today` | 같은 중립 마커 몸체, 아이콘만 교체 — pin 모양 자체를 다르게 하거나(예: 사각 배지 vs 물방울 핀), 최소한 아이콘을 확실히 구분 |

**동반 표시 원칙(R21)**: 토글 필터 없음. `spots`와 `culturalEvents`(또는 provider가 합쳐 노출하는
마커 목록)를 받으면 항상 함께 그린다.

### `cluster_marker` (R2·R22)
- **모양**: 마커보다 큰 원형 배지. 배경은 `primary`(브랜드 코랄), 텍스트는 `onPrimary`.
- **내용**: 중앙에 개수 숫자(`label-lg`급), 우세 카테고리가 있으면 숫자 위/옆에 작은 카테고리
  아이콘, **우세 카테고리가 없으면(과반 미달) 아이콘 생략** — 숫자만 표시(스펙 R2, "부재로
  둔다"를 아이콘 미표시로 구현).
- **동작**: 탭 시 해당 클러스터 중심으로 확대(R22). 확대 후 유휴가 되면 기존 조회 경로를 타고
  자연히 개별 마커로 전환 — 클라이언트가 재클러스터링하지 않는다(설계 §4.2).

`spots`/`clusters`는 상호배타이므로 컴포넌트도 그 가정을 그대로 받는다: provider가 이미
"개별 마커 목록" 또는 "클러스터 목록" 둘 중 하나만 채워 내려준다.

---

## 3. 구역 선택 말풍선 (`area_info_card`, R27)

**정확히 이 네 항목만** — 늘리지 않는다(spec §7.8, 이미 결정됨):

```
┌──────────────────────────────┐
│  강남 MICE 관광특구              │  ← name (CongestionArea.name, 서버가 활성 언어로 제공)
│  ● 붐빔                        │  ← 색 점(CongestionPalette.dotOf) + 라벨(l10n, 색만 X)
│  3,000 – 3,500명                │  ← mapPopulationRange (min~max)
│  As of 03:30                    │  ← mapObservedAt — "지금"/"현재" 금지
└──────────────────────────────┘
```

- **배치**: 하단, 플로팅 네비바 위(`bottom: barExtent + spacing.sm`), 좌우 `spacing.md` 마진.
  선택 해제(다른 곳 탭 또는 닫기 아이콘) 시 사라진다.
- **스타일**: `surfaceContainer` 배경, `radius.lg`(20px 상당) 모서리, elevation 2~3(M3 카드
  기준). 닫기 버튼(`Icons.close`) 우상단 — 지도를 계속 조작할 수 있어야 하므로 말풍선이 지도를
  전부 가리면 안 된다(높이는 4줄 텍스트 + 패딩 정도로 작게).
- **혼잡 단계 라벨**: `mapCongestionRelaxed/Normal/SlightlyCrowded/Crowded` 키. 점 색은
  `CongestionPalette.dotOf(level)`(이미 구현됨, 변경 금지).
- **상권 정보(선택적으로 같이 보여줄 경우)**: §6.2 상권 3상태 규칙을 따로 적용 — 인구와
  기준 시각이 다르므로(spec §7.8 마지막 문단) 합쳐서 표시하지 않는다. 이번 스펙 범위에서
  상권을 이 카드에 포함할지는 spec에 명시가 없어 **상권 없이 4항목만**으로 우선 구현하고,
  상권을 추가하려면 별도 섹션(같은 카드 안 구분선 아래)으로 둔다 — 갭으로 아래 기록.

---

## 4. 혼잡도 범례 (`congestion_legend`, R24)

- **배치**: 좌상단, 상태바 아래. `TruncatedNoticeBanner`가 동시에 뜨면 배너 아래로 밀려난다
  (겹치지 않게 세로로 쌓는다).
- **구성**: 작은 카드, 4행 — 각 행에 색 스와치(원 또는 사각, `CongestionPalette.dotOf`) +
  라벨(`mapCongestionRelaxed/Normal/SlightlyCrowded/Crowded`).
- **스타일**: `surface`를 반투명(alpha ~0.85~0.9)으로 깔아 지도 위에서도 읽히게 —
  `CongestionAttribution`과 같은 패턴(반투명 배경 이유는 그 컴포넌트 주석 참조).
- **표시 조건**: 혼잡도 레이어가 표시될 때만(줌 게이트 R25 통과 + `degraded`가 아닐 때). 게이트
  미만이거나 `degraded`면 범례도 숨긴다 — 색이 없는데 범례만 떠 있으면 혼란을 준다.

---

## 5. 잘림 안내 배너 (`truncated_notice_banner`, R23)

- **문구**: `mapTruncatedNotice` ("Too many spots to show. Zoom in to see them all.")
- **배치**: 상단, 상태바 바로 아래. **지도를 막지 않는다** — 얇은 배너(1~2줄), 지도 전체를
  덮는 오버레이가 아니다.
- **스타일**: `tertiaryContainer` 또는 `surfaceContainerHigh` 배경(경고성이지만 `error`는
  과하다 — 마커가 정상적으로 보이는 상태이므로), 아이콘 `Icons.zoom_in` 또는
  `Icons.info_outline` + 텍스트. 닫기(X) 아이콘으로 dismiss 가능(재확인 배너가 매 조회마다
  다시 뜨는 게 자연스러움 — dismiss는 세션 내 일시적).
- **동작**: `truncated`가 참인 동안만 노출. 마커·클러스터는 그대로 표시(설계 §4.3 — "보이는
  것은 유효한 결과").

---

## 6. 혼잡도 레이어 실패 안내 (`congestion_degraded_notice`, R29)

- **트리거**: `seoulCongestion` provider가 `degraded` 상태(서울 API 실패, R11 — 최상위 오류
  아님, 데이터 안의 표식).
- **배치**: `TruncatedNoticeBanner`와 같은 상단 영역(둘 다 뜨면 세로로 쌓거나, 우선순위상
  이 안내가 더 중요하므로 위쪽에 둔다 — 잘림은 "더 볼 게 있다"는 긍정적 신호에 가깝고, 레이어
  실패는 "일부 기능 제한"이므로).
- **문구**: `mapCongestionUnavailable` ("Crowd levels are unavailable right now.")
- **스타일**: 얇은 인라인 배너, `errorContainer`까지는 과하고 `surfaceContainerHigh` +
  `Icons.info_outline`(또는 `Icons.cloud_off`) 정도로 — 전면 오류가 아니라 "일부 저하"를
  전달해야 한다(R29, 전면 오류 화면 금지가 명시적 요구).
- **동작**: 폴리곤만 그리지 않는다(또는 아예 폴리곤 레이어를 스킵). **spot·문화행사 마커,
  지도 팬/줌 조작, 줌 컨트롤, 내 위치 버튼은 전부 정상 동작**한다. `CongestionLegend`도
  숨긴다(보여줄 색이 없으므로). `CongestionAttribution`은 혼잡도 레이어가 안 보이는 동안은
  노출 의무가 없다(R30은 "혼잡도 레이어가 보이는 동안" 조건부) — 다만 현재 구현
  (`congestion_attribution.dart`)은 상시 노출로 되어 있고 주석에 "레이어가 붙으면 조건을
  건다"고 명시돼 있으므로, 이 조건화는 마커/폴리곤이 실제로 붙는 시점에 함께 처리한다.

---

## 7. 다크 모드

`lib/common/theme/app_theme.dart`의 `AppTheme.dark`(seed 기반 M3 dark)를 그대로 상속한다.
지도 위 오버레이 컴포넌트(범례, 배너, 말풍선, 컨트롤)는 모두 `Theme.of(context).colorScheme`을
통해 자동으로 다크 대응된다 — 개별 색 하드코딩이 없으므로 별도 다크 목업이 필요 없다.

**혼잡도 폴리곤 4색(`congestion_palette.dart`)은 다크에서도 동일하게 쓴다** — ARGB 상수라
다크 배경 위에서도 지도 타일보다 채도가 높아 구분된다(카카오 지도는 자체 다크 스타일이 없다면
라이트 타일 위에 그대로 얹힐 수 있음 — 이 경우도 반투명 40% 채우기가 타일과 충분히 대비된다).
다크 모드에서 지도 타일 자체가 어두워지는지는 kakao_map_sdk의 자체 다크 지원 여부에 달려있고,
이번 스펙 범위 밖(SDK 기능 문제, 갭으로 기록).

카드류(`AreaInfoCard`, `CongestionLegend`, 배너들)는 `surfaceContainer`/`surfaceContainerHigh`
롤을 쓰므로 다크에서 자동으로 어두운 표면 + 밝은 텍스트로 전환된다.

---

## 8. 상태 요약

| 상태 | 화면 |
|---|---|
| 초기 진입(서버 연동 전, 현재 구현) | 지도만 표시, 유휴 판정 동작, 마커/폴리곤 없음 |
| 정상(마커+혼잡도 있음) | 본 문서의 주 레이아웃 |
| 잘림(`truncated=true`) | §5 배너 + 마커는 그대로 |
| 혼잡도 실패(`degraded=true`) | §6 배너 + 폴리곤/범례 숨김, 마커·지도 조작 정상 |
| 구역 선택 | §3 카드 노출 |
| 지도 키 없음(구현됨) | 전체 화면 안내 텍스트로 대체(`mapKeyMissing`) — `map_screen.dart` 기존 분기 |
| 지도 로드 실패 | `mapLoadFailed` 문구 — 트리거 조건은 slice-builder가 SDK 콜백에서 확정 |

---

## 9. 다국어

전부 enum·숫자·시각이라 로케일 포맷팅만으로 4개 언어(EN/KO/JA/ZH)를 지원한다(설계 §7).
구역명은 서버가 활성 언어로 내려준다 — 클라이언트가 별도 번역 테이블을 두지 않는다.
사용할 ARB 키는 프롬프트에 이미 정리된 것과 동일:

```
mapCongestionRelaxed / Normal / SlightlyCrowded / Crowded
mapCommercialQuiet / Normal / Busy / VeryBusy / Unavailable / Estimated / Label
mapObservedAt(time) / mapPopulationRange(min, max)
mapCongestionUnavailable / mapTruncatedNotice / mapAttribution
mapKeyMissing / mapLoadFailed
navMap (하단 네비 라벨 — 이미 존재)
```

---

## 갭 / 미확정

- **Stitch 목업 부재** — 위 "Stitch 생성 갭" 참조. 서비스 복구 시 생성해 이 문서를 시각적으로
  검증하고 스크린 id를 채운다. 그 전까지 이 레이아웃은 텍스트 명세로만 존재한다.
- **말풍선에 상권 정보 포함 여부** — spec §7.8은 구역(인구) 4항목만 명시하고, 상권을 같은
  카드에 넣을지는 결정돼 있지 않다. 우선 4항목만 구현하고, 상권을 붙일 경우 별도 구분선 아래
  섹션으로 확장하는 안을 제안(§3 마지막 문단).
- **줌 컨트롤의 정확한 좌표/크기** — 목업이 없어 "우측, 세로 중앙쯤"으로만 기술. 실기기에서
  엄지 도달 범위와 지도 콘텐츠 가림을 보고 slice-builder가 최종 위치를 조정한다.
- **위치 권한 거부 시 UX** — 범위에 명시가 없어 표준 처리(토스트/스낵바)로 가정. 별도 화면 없음.
- **카카오 지도 자체 다크 타일 지원 여부** — SDK 기능이라 이번 조사 범위 밖.
- **마커 아이콘의 정확한 비주얼(핀 몸체 색, 그림자)** — "중립색이라 폴리곤과 안 섞여야 한다"는
  제약만 확정. 정확한 hex는 테마 토큰에서 뽑되 최종 선택은 slice-builder + 실기기 확인.
