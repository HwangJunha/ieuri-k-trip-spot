> spec: SPEC-0020 · source: `Specs/SPEC-0020/spec.md` (Obsidian) · status: draft

요구사항·수용 기준·계약 초안은 위 spec을 따릅니다. 이 문서는 클라이언트 설계 결정만 담습니다.

## 범위

1. 카테고리 단일 선택 → 다중 선택 전환, "전체 보기" 제거
2. 지도 화면 카테고리 필터 신설
3. spot 카드 디자인 정합 (커뮤니티 기준선)
4. 서브 컬러 교체

## 설계 결정

### 선택 상태를 provider로 올린다

현재 `CategoryBar`(`lib/domain/spot/component/category_bar.dart`)는 `selected == null`을 "전체"로 쓰는 단일 값 모델입니다. 이 표현은 다중 선택으로 확장되지 않습니다 — `null`이 "전체"와 "미선택" 두 의미를 겸하기 때문입니다.

선택 상태를 **비어 있을 수 없는 집합**으로 모델링하고 provider가 소유합니다. 위젯은 상태를 갖지 않습니다.

- 토글 로직(추가·해제·마지막 1개 해제 불가)은 provider에 있습니다. 위젯이 아니라 provider에 있어야 테스트가 위젯 없이 성립합니다(spec 테스트 범위).
- `selected == null` 표현은 제거합니다. "필터 없음"은 UI에 더 이상 존재하지 않습니다.
- 서버 전송 시 집합 → `categories` 리스트로 매핑합니다. 집합이 비는 경우는 provider가 만들지 않으므로 `[]`는 전송되지 않습니다(계약상 `EMPTY_CATEGORY_SET`).

> **서버 계약이 달랐다 (2026-08-14 확인, 서버 대기 중).** 라이브 introspection 결과
> `spots`·`likedSpots`·`searchSpots`·`mapViewport`·`popularSpots` 5개 쿼리가 전부
> `category: SpotCategory` **단수**만 받습니다. 리스트 인자는 이름을 불문하고 어느
> 쿼리에도 없으며, 배열을 보내면 `Expected an AST type of 'EnumValue' but it was a
> 'ArrayValue'`로 거절됩니다. AC5.1과 `EMPTY_CATEGORY_SET`은 현재 서버에서 성립하지
> 않습니다.
>
> 요청서: `problem/SPEC-0020-SERVER-categories-argument.md`. 서버에 인자가 추가될
> 때까지 다중 선택 본체(R1·R2·R5·R7)는 착수하지 않습니다 — 사용자 결정.
>
> `availableSpotCategories`(칩 목록)는 이상 없습니다. 언어별 차이도 설계대로
> 동작합니다(KO=`TRAVEL_COURSE` 포함·`TRANSPORT` 없음, EN=반대). 막힌 것은 목록을
> 읽는 쪽이 아니라 고른 값을 보내는 쪽입니다.

### 화면별 독립 (R12)

선택 provider는 **화면 단위로 인스턴스화**됩니다. 공용 단일 provider를 두고 화면들이 공유하는 구조가 아닙니다.

- Riverpod `family` 등으로 화면을 키로 구분하거나, 화면별 provider를 각각 선언합니다. 어느 쪽이든 한 화면의 선택 변경이 다른 화면을 재빌드시키지 않아야 합니다.
- 영속화하지 않습니다 — `flutter_secure_storage`·`SharedPreferences` 어디에도 선택 집합을 쓰지 않습니다. 재시작 시 각 화면은 R4 기본값으로 초기화됩니다.
- 나중에 "공유"로 바꾸는 것은 provider를 위로 올리면 되지만, 잘못 전파되는 상태를 걷어내기는 어렵습니다. 독립이 되돌리기 쉬운 방향입니다.

### 기본값과 폴백

최초 진입 기본값은 `TOURIST_SPOT`입니다. 다만 `availableSpotCategories`는 언어에 따라 달라집니다 — `TRAVEL_COURSE`는 KO 전용, `TRANSPORT`는 non-KO 전용입니다.

`TOURIST_SPOT`이 목록에 없으면 **목록의 첫 번째 값**을 선택합니다(AC4.2). 목록에 없는 값을 기본 선택으로 두면 어떤 칩도 선택되지 않은 화면이 나옵니다.

### 지도 필터

`map_screen.dart`에는 현재 카테고리 필터가 없고, `mapViewportProvider(bbox, zoom)` 호출에 카테고리가 전달되지 않습니다. 서버 인자는 이미 존재하므로 배선만 추가합니다.

- 필터 변경도 **뷰포트 이동과 같은 디바운스 경로**를 지납니다(POL-037). 카테고리를 연달아 토글해도 조회는 정지 후 1회입니다.
- 지도는 기존에 `MapSearchBar`, `MapZoomControls`, `MyLocationButton`, `RegionRecommendationButton`, `SearchThisAreaButton`, `CongestionLegend`, `AreaInfoCard`가 이미 얹혀 있습니다. 필터를 추가할 때 이들과의 배치 충돌을 확인해야 합니다 — 지도는 이 앱에서 오버레이가 가장 많은 화면입니다.

### 카드 썸네일·간격 통일

목표는 `SpotCard`를 `PostCard`처럼 만드는 것이 **아닙니다** — spot에는 작성자도 댓글 수도 없어 같은 정보 위계를 가질 수 없습니다. R9의 범위는 **기계적 통일**로 한정됩니다.

핵심 원인은 **공통 썸네일 위젯과 공통 간격 정의의 부재**입니다. `LikedSpotCard`는 `Image.network`를 직접 호출하고 실패 시 빈 `ColoredBox`로 떨어집니다. 카드마다 로딩·실패 표현과 여백 값이 제각각인 것이 "성의 없다"의 기계적 실체입니다.

- 공통 썸네일 위젯을 `lib/common`에 두고 `SpotCard`·`LikedSpotCard`가 경유합니다(AC9.2).
- 로딩·실패 표현을 한 곳에서 정의합니다. 실패 시 빈 색 블록을 쓰지 않습니다(AC9.1).
- 카드 내부 여백·간격을 공통 정의로 빼고 카드별 하드코딩을 제거합니다(AC9.3).

> **구현 시 확인 (2026-08-14, 완료).** 공통 썸네일 위젯은 이미 있었습니다 —
> `lib/common/widget/spot_thumbnail.dart`의 `SpotThumbnail`이 URL 판별·`loadingBuilder`·
> `errorBuilder`를 모두 갖추고 `ImagePlaceholder`로 폴백하며, `SpotCard`·`EventCard`·
> `PopularSpotCard`·`SearchResultList`가 이미 경유하고 있었습니다. 실제 할 일은
> `LikedSpotCard`의 사설 `_Thumbnail` 하나였습니다 — 생 `Image.network`에
> `loadingBuilder`가 없어 로딩 중 흰 칸이 번쩍이고 실패 시 민 `ColoredBox`로 떨어지던
> 것을 `SpotThumbnail`로 돌렸습니다(AC9.1·AC9.2).
>
> AC9.3의 공통 여백 정의는 `lib/common/widget/card_metrics.dart`로 신설하고 두 카드의
> 하드코딩 값을 걷어냈습니다.

정보 위계 재설계와 시각적 리듬은 검증 기준을 세울 수 없어 이 스펙 범위 밖입니다(spec 미결 사항).

### 서브 컬러

| 대상 | 기존 | 신규 |
|---|---|---|
| `AppColors.secondary` | `#17A2A2` | `#A56200` |
| `AppTheme` 라이트 `secondary` | `#006A6A` | `#A56200` |

근거와 대비 측정값은 spec R10에 있습니다. 실사용처는 `score_breakdown.dart`, `onboarding_screen.dart` 2곳뿐이라 파급 범위가 작습니다.

**`#A56200`은 확정값이 아니라 출발점입니다** — 실제 화면을 보며 조정합니다. 조정 시에도 AC10.2~10.4(텍스트 4.5:1 / 비텍스트 3:1 / teal 잔존 없음)는 유지되어야 하며, 값을 바꾸면 R10 측정표를 갱신하고 amend합니다. 색상값이 `AppColors`·`AppTheme` 두 곳에 나뉘어 있으므로 조정 시 함께 움직여야 합니다.

`onSecondary`, `secondaryContainer`, `onSecondaryContainer` 등 파생 톤도 함께 재산출해야 합니다 — 라이트 스킴은 Stitch M3 export를 그대로 쓰고 있어 secondary 계열 톤이 teal 기준으로 잡혀 있습니다. 서브 컬러만 바꾸고 컨테이너 톤을 두면 teal 잔상이 남습니다.

**다크 스킴은 시드 교체만으로 반영되지 않습니다(2026-08-14 구현 중 정정).** `copyWith(secondary:)`는 `secondary` 하나만 덮고 `onSecondary`·`secondaryContainer`·`onSecondaryContainer`는 시드(primary) 기준으로 남습니다. 파생 톤을 함께 덮도록 고쳤습니다. 또 어두운 배경에서는 `#A56200`이 텍스트 기준 4.5:1을 넘지 못해(3.55:1) 다크 `secondary`는 밝은 `#F0B968`을 씁니다.

### 적용값과 실측 대비비 (2026-08-14)

| 역할 | 라이트 | 다크 |
|---|---|---|
| `secondary` | `#A56200` | `#F0B968` |
| `onSecondary` | `#FFFFFF` | `#452800` |
| `secondaryContainer` | `#FFDDB3` | `#663C00` |
| `onSecondaryContainer` | `#663C00` | `#FFDDB3` |

| 검증 | 라이트 | 다크 | 기준 |
|---|---|---|---|
| onSecondary on secondary | 4.83:1 | 7.61:1 | AC10.2 ≥4.5 |
| secondary on surface | 4.61:1 | 9.68:1 | AC10.2 ≥4.5 |
| onSecondaryContainer on container | 7.35:1 | 7.35:1 | AC10.2 ≥4.5 |
| 진행 막대 fill vs 트랙 | 3.73:1 | — | AC10.3 ≥3 |

teal 잔존 0건(AC10.4). `*Fixed` 4종도 함께 교체했습니다.

**미해결: `#A56200`이 기존 `tertiary` `#805200`과 색상환에서 2.8° 차이입니다**(둘 사이 대비 1.39:1). AC는 전부 통과하나 두 역할이 화면에서 거의 같은 색으로 보입니다. 실사용처가 `score_breakdown.dart` 1곳뿐이라 실제 영향은 작습니다 — 화면 확인 후 조정 대상.

### 라벨

칩 라벨은 l10n 문자열입니다(POL-023). enum 식별자가 UI에 노출되지 않습니다. 신규·변경 문자열은 EN/KO/JA/ZH 4개 arb 모두에 추가합니다(POL-022). 제거되는 "전체 보기"(`viewAll`) 키가 다른 화면에서도 쓰이는지 확인 후 정리합니다.

## 테스트 대상 단위

**provider / 도메인 모델 로직만.** 위젯 테스트·통합 테스트는 범위 밖입니다.

| 단위 | 검증 내용 | 대응 AC |
|---|---|---|
| 카테고리 선택 provider | 추가·해제 토글 | AC2.1, AC2.2 |
| 카테고리 선택 provider | 마지막 1개 해제 불가 | AC3.1 |
| 카테고리 선택 provider | 9개 전부 선택 → 8회 해제 → 크기 1, 9번째 해제는 무변화 | AC3.2 |
| 테마 값 검증 | secondary 계열 대비비(텍스트 4.5:1 / 비텍스트 3:1), teal 계열 잔존 없음 | AC10.1~10.4 |
| 카테고리 선택 provider | 화면별 인스턴스 독립 — 한 화면 변경이 다른 화면에 전파되지 않음 | AC12.1 |
| 카테고리 선택 provider | 재시작 시 기본값 초기화(영속 저장 없음) | AC12.2 |
| 카테고리 선택 provider | 최초 기본값 `TOURIST_SPOT` | AC4.1 |
| 카테고리 선택 provider | `TOURIST_SPOT` 부재 시 목록 첫 값 폴백 | AC4.2 |
| 선택 집합 → 쿼리 변수 매핑 | `categories` 리스트 생성, 빈 배열 미전송 | AC5.1 |
| 지도 조회 트리거 | 필터 변경 시 디바운스 후 1회 조회 | AC7.3 |

## 범위 밖

- 정보 위계 재설계·시각적 리듬 — R9 범위 밖입니다(spec §결정 사항). 실제 화면을 보며 조정할 사항이며, 필요 시 후속 스펙으로 분리합니다.
- `category` 인자 제거 — 별도 스펙입니다.
- 커뮤니티 `CategoryChipRow`(`lib/domain/community/component/category_chip_row.dart`) — 다른 enum(`CommunityChip`)을 쓰는 별도 위젯으로 이 스펙의 대상이 아닙니다.
- 위젯 렌더링 검증 — 테스트 범위 밖입니다.
