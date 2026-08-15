> spec: SPEC-0020 · source: `Specs/SPEC-0020/spec.md` (Obsidian) · status: approved (v1.1)

요구사항·수용 기준·계약 초안은 위 spec을 따릅니다. 이 문서는 클라이언트 설계 결정만 담습니다.

## 범위

1. 카테고리 단일 선택 → 다중 선택 전환, "전체 보기" 제거
2. 지도 화면 카테고리 필터 신설
3. spot 카드 디자인 정합 (커뮤니티 기준선)
4. 서브 컬러 교체

## 구현 순서와 서버 의존

**서버 작업 완료 — 전 단계 착수 가능합니다**(2026-08-15 라이브 확인, #74). 과도기 처리는 불필요해졌습니다.

다만 **카테고리 체계 자체가 바뀌었습니다.** `SpotCategory`가 enum이 아니라 객체이며, 클라이언트가 알던 전제 대부분이 무효입니다.

| 단계 | 작업 | 대응 | 상태 |
|---|---|---|---|
| 0 | `X-App-Key: k-trip-spot` 헤더 추가 (독립·선행 가능) | R13 | ✅ |
| 1 | 카테고리 모델 교체 — enum → `code`/`label`/`iconUrl` 객체 + 아이콘 매핑 | R11 | ✅ |
| 2 | `CategoryBar` 다중 선택 전환, "전체 보기" 칩 제거, 라벨을 `label`로 | R1·R2·R3·R11 | ✅ |
| 3 | 세 provider를 단일 값 → 집합으로, 기본값 `{TOURIST_SPOT}`·폴백·빈 목록 | R2·R4·R12 | ✅ |
| 4 | 집합 → `categories: [String!]` 매핑, 5개 연산 배선 | R5 | ✅ |
| 5 | ~~지도 카테고리 필터 신설 + 디바운스~~ — **철회** | R7·R8 | ❌ |
| — | 카드 썸네일·간격 · 서브 컬러 `#B4501E` | R9·R10 | ✅ |

**전 단계 구현 완료(2026-08-15).** `flutter analyze` 무결점, 테스트 1180개 통과.
남은 것은 스펙의 "테스트 대상 단위" 표에 있는 provider 단위 테스트 작성이며, CLAUDE.md
§8에 따라 사용자가 "작업 완료"를 선언한 뒤에 씁니다.

**1단계가 선행 조건입니다** — 로컬 `SpotCategory` enum과 `spotCategoryLabel()` l10n 매핑을 걷어내지 않으면 나머지가 전부 옛 타입에 묶입니다.

### 구현 중 확인된 서버 계약 차이 (2026-08-15, 라이브)

문서가 적지 않았거나 다르게 적은 것들입니다.

1. **`spotDetail(id:)`에서 `category` 인자가 사라졌습니다.** `SpotDetail.intro`·`infoItems`도 인자를 잃었습니다 — 서버가 spot 자신의 카테고리로 해석합니다. 문서 §1단계 상세는 "`fetchSpotDetail(id, category)`는 `category`가 필수 인자"라고 적고 있으나 무효입니다. 이에 따라 **상세 라우트의 `category` 쿼리 파라미터를 통째로 제거**했습니다.
2. **단수 `category` 인자는 병행이 아니라 제거됐습니다.** 과도기 없이 교체라, 클라이언트가 전환하지 않으면 조회가 전부 실패합니다.
3. **빈 배열 오류는 `EMPTY_CATEGORY_SET` 코드가 아닙니다.** `errorType: INTERNAL`에 Java 예외 클래스명(`EmptyCategorySetException`)이 그대로 실려 옵니다. 클라이언트는 빈 집합을 만들지 않으므로(마지막 1개 해제 불가) 실사용 경로는 아니지만, 코드로 분기할 수는 없습니다.
4. **모르는 코드는 오류가 아닙니다.** `categories: ["NOPE"]`는 조용히 빈 결과입니다 — 오타가 0건으로 나타나므로 디버깅 시 유의해야 합니다.
5. **`availableSpotCategories`는 `code` 알파벳순입니다.** `TOURIST_SPOT`이 목록의 7번째이며 첫 값이 아닙니다 — AC4.2의 "목록 첫 값 폴백"이 실제로 다른 값이 되는 상황이 흔합니다.
6. **커뮤니티 오퍼레이션도 손대야 했습니다.** 범위 밖이지만 같은 `spots`·`likedSpots`·`searchSpots`를 참조해, 인자를 바꾸지 않으면 codegen이 통과하지 않습니다. `NearbySpotCategory`·`TargetCategory` 타입 자체는 건드리지 않았습니다.

### 카테고리 코드의 위치 (2026-08-15 결정)

지도가 카테고리 필터를 갖게 되면서 **spot 전용이던 카테고리를 두 기능이 공유**하게 됐습니다. CLAUDE.md §4("두 기능 이상이 쓰면 `common/`")에 따라 공유 가능한 것을 `lib/common/category/`로 올렸습니다.

| 파일 | 이동 | 근거 |
|---|---|---|
| `spot_category.dart` | → `common/category/` | 순수 값 객체, import 0개 |
| `spot_category_selection.dart` | → `common/category/` | 위 하나만 참조 |
| `spot_category_toggle.dart` | → `common/category/` | 토글 규칙, 위 둘만 참조 |
| `spot_category_icon.dart` | → `common/category/` | `code` → Material 아이콘 |
| `category_bar.dart` | → `common/category/` | 네 화면이 공유하는 위젯 |

`CategoryBar`는 이동하면서 **가용 목록을 provider에서 직접 읽지 않고 인자로 받도록** 바꿨습니다(`ConsumerWidget` → `StatelessWidget`). 그대로 두면 `common/`이 도메인 provider를 watch하게 되어 의존 방향이 뒤집힙니다.

**`availableSpotCategoriesProvider`와 `spot_category_seed.dart`는 spot에 남깁니다.** 전자가 `SpotRepository`(GraphQL 오퍼레이션 포함)에 묶여 있어, common으로 올리면 `common/`이 도메인 데이터 접근을 갖게 됩니다 — 교차 기능 import보다 나쁜 위반입니다. 카테고리 *목록*은 서버 리소스이고 그 접근 경로를 spot이 소유하며, 지도는 소비자입니다.

결과적으로 map→spot 참조는 **5건에서 2건**으로 줄었고, 남은 둘은 그 목록 하나로 귀결됩니다. `common/category/`는 도메인을 전혀 참조하지 않습니다.

### 지도 필터 철회 (2026-08-16 사용자 결정)

**R7·R8을 구현했다가 걷어냈습니다.** 실기기에서 보니 검색창·범례·재검색 버튼·줌
컨트롤·현재 위치·추천 버튼이 이미 얹힌 위에 카테고리 바가 하나 더 들어가 가독성이
떨어졌습니다. 스펙 자신도 "지도는 이 앱에서 오버레이가 가장 많은 화면"이라며 배치
충돌을 경고하고 있었는데, 실제로 그 경고가 맞았습니다.

제거 대상: `MapSelectedCategory` provider, `mapViewport`의 `categoryKey` 인자,
지도 화면의 바·디바운스 핸들러(`_onCategoryFilterChanged`). 재검색 버튼 오프셋도
원래 값으로 되돌렸습니다.

리포지토리(`fetchViewport`의 `categoryCodes`)와 GraphQL 오퍼레이션의 `categories`
인자는 **남겨 둡니다** — 서버 계약이고, 나중에 다른 형태(예: 필터 시트)로 붙일 때
다시 쓸 수 있습니다. 지금은 항상 null이 갑니다.

### 커뮤니티 칩 계약 수정 (2026-08-16)

**커뮤니티 카테고리 줄이 아예 뜨지 않고 있었습니다.** 서버가 `communityChips`를
객체 배열에서 enum 배열로 바꿨는데 클라이언트가 따라가지 않아, 조회가 늘
`SubselectionNotAllowed`로 실패하고 화면이 `orElse`로 빈 위젯을 그렸습니다.

```
서버: communityChips: [TargetCategory!]!          (leaf)
옛 클라이언트: communityChips { category position }  → 거절
```

`CommunityChip` 타입과 `position` 필드는 서버에 더 이상 없습니다. 모델
(`community_chip.dart`)을 지우고 `TargetCategory`를 직접 씁니다.

**`origin/dev`에도 같은 상태였습니다** — 이번 작업이 만든 문제가 아니라 드러난
문제입니다. 페이크 리포지토리를 쓰는 위젯 테스트가 깨진 쿼리를 우회해 통과하고
있어 그동안 잡히지 않았습니다.

정렬은 이제 클라이언트가 잡습니다(`kCategoryDisplayOrder`) — 서버가 순서를
보장한다는 옛 주석들을 함께 정정했습니다.

### 커뮤니티 다중 선택 — 서버 대기 (2026-08-16)

칩 계약을 고쳐 줄이 정상적으로 뜨자, 커뮤니티만 단일 선택으로 남은 것이 드러났습니다.
다중으로 맞추려 했으나 **서버가 아직 받지 못합니다.**

```
posts(… category: TargetCategory …)   ← 단수뿐, 리스트 인자 없음
posts(category: [TOURIST_SPOT, RESTAURANT])
  → WrongType … Expected an AST type of 'EnumValue' but it was a 'ArrayValue'
```

spot이 #74 이전에 받던 것과 같은 오류입니다. 요청서:
`problem/SPEC-0020-SERVER-community-categories.md`.

서버에 인자가 추가될 때까지 **커뮤니티는 단일 선택을 유지합니다.** 위젯(`CategoryBar`)은
이미 다중을 지원하므로, 서버가 준비되면 provider를 집합으로 바꾸고 호출부를 잇는 것이
남은 일입니다 — spot에서 한 것과 같은 모양입니다.

`TargetCategory`가 enum이라 인자 형태가 두 갈래(`[TargetCategory!]` 또는 spot과 같은
`[String!]`)인데, 서버가 `TargetCategory`도 객체화할 계획인지에 달려 있어 요청서에서
양쪽을 열어 두었습니다.

### 함께 고친 기존 버그

- **지도 마커 탭이 늘 `touristSpot`으로 열렸습니다.** `map_repository_impl.dart`가 생성 enum의 `.name`(`TOURIST_SPOT`)을 실었는데 라우터는 Dart enum 이름(`touristSpot`)과 비교해 매칭이 영영 실패했습니다. 표기가 `code` 하나로 통일되며 사라졌습니다.
- **좋아요 목록 `loadMore()`에 카테고리 인자가 빠져 있었습니다** — 2페이지부터 필터가 풀렸습니다.

### 1단계 상세 — 카테고리 모델 전환

현재 `lib/domain/spot/model/spot_category.dart`는 서버 enum과 1:1로 맞춘 로컬 enum이며, 주석이 그 전제를 명시합니다("값 집합은 서버 `SpotCategory` enum과 1:1로 맞춘다"). **이 전제가 깨졌습니다.**

영향 범위는 생성 파일 제외 **30개 파일**입니다. 단순 치환이 아니라 도메인 모델 전환이므로 아래를 지킵니다.

**enum을 없애고 값 객체로 바꿉니다.** enum으로 남기면 서버가 새 카테고리를 추가할 때 파싱이 깨지거나 `unknown`으로 흘리게 되고, 그러면 "앱 업데이트 없이 늘어난다"는 서버 설계가 클라이언트에서 무효가 됩니다(AC1.3).

```
class SpotCategory {        // 예시 — 형태만 제시, 구현은 하네스 재량
  final String code;        // 안정 식별자. 비교·필터·전송은 전부 이 값
  final String label;       // 서버 제공 표시 문구. 클라이언트가 번역하지 않는다
  final String? iconUrl;    // null이면 기본 표현으로 폴백
}
```

- **동등성은 `code` 기준**입니다. 선택 집합의 원소 비교, 칩 선택 상태 판정이 전부 `code`로 이뤄집니다.
- `spotCategoryLabel(l10n, category)`(`spot_display.dart`)와 대응 arb 키는 **제거**합니다. 라벨은 `category.label`입니다.
- 카테고리를 담고 있던 모델들(`TouristSpot`·`LikedSpot`·`SpotDetail`·`MapMarker`·`SpotSuggestion` 등)의 필드 타입이 함께 바뀝니다. GraphQL 생성 타입은 리포지토리 경계에서 도메인 모델로 매핑합니다 — 생성 타입이 provider·위젯까지 새어 나가지 않게 합니다(POL-020).
- 커뮤니티의 `TargetCategory`·`NearbySpotCategory`는 **다른 enum이며 이 전환 대상이 아닙니다.** 이름이 비슷해 함께 고치기 쉬우나 서버 계약이 다릅니다.

**반드시 걷어내야 할 것 — 미지의 카테고리를 버리는 경로**

`spot_repository_impl.dart`의 현재 매핑이 서버의 확장성을 무력화합니다.

```dart
Enum$SpotCategory.$unknown => null,          // 436~447행 _categoryFromEnum
...
.map(_categoryFromEnum).whereType<SpotCategory>()   // 92~93행
```

모르는 값을 `null`로 만들고 `whereType`으로 걸러내므로, **서버가 카테고리를 추가하면 클라이언트에서 조용히 사라집니다.** 목록에서 빠지는 데 그치지 않고 그 카테고리의 spot이 표시될 때도 문제가 됩니다. AC1.3이 요구하는 것이 정확히 이 경로의 제거입니다.

전환 후에는 `code`가 문자열이므로 매핑 자체가 불필요합니다 — 서버 값을 그대로 담고, 모르는 코드는 **아이콘만** 기본값으로 떨어집니다(AC11.5). 값을 버리지 않습니다.

`_category`(도메인 → 생성 enum) 역방향 함수도 함께 사라집니다. 필터 전송은 `code` 문자열 배열이므로 변환이 없습니다(AC5.2).

**라우팅에 카테고리가 실려 다닙니다 — 표기가 바뀝니다**

`routes.dart`와 `picked_place.dart`가 상세 화면으로 카테고리를 **URL 쿼리 파라미터**로 넘깁니다. 현재 값은 Dart enum 이름(`SpotCategory.name` → `touristSpot`)이고, 서버 `code`는 `TOURIST_SPOT`입니다.

```dart
// routes.dart 375~377행 — enum 이름 기준 복원, 실패 시 touristSpot으로 폴백
SpotCategory _spotCategoryFrom(String? name) =>
    SpotCategory.values.where((c) => c.name == name).firstOrNull ??
    SpotCategory.touristSpot;
```

전환 후에는 **`code`를 그대로 실어야 합니다**(`TOURIST_SPOT`). `SpotCategory.values` 조회가 사라지므로 복원 로직도 단순 문자열 전달이 됩니다.

주의할 점 두 가지:

1. `spot_detail_route.dart`가 축제 상세를 `SpotCategory.festivalEvent.name`으로 하드코딩합니다 — `'FESTIVAL_EVENT'`로 바뀝니다.
2. `fetchSpotDetail(id, category)`는 `category`가 **필수 인자**입니다(서버 `intro`/`infoItems`가 요구). 즉 상세 화면은 카테고리 없이 열 수 없습니다.

**외부 딥링크는 없음을 확인했습니다**(2026-08-15) — Android intent-filter는 카카오 OAuth 콜백(`kakao{앱키}://oauth`) 전용이고, spot 상세로 들어오는 경로가 없습니다. 따라서 라우팅 표기 변경은 앱 내부에서만 닫히며 하위 호환 처리가 필요 없습니다.

### 아이콘 — `iconUrl` → Material → 중립

`iconUrl`은 현재 전 카테고리가 `null`입니다(실측). 즉 **당분간 Material 아이콘이 실제로 쓰이는 경로**이며, 매핑은 지금 필요합니다.

| `code` | Material 아이콘 |
|---|---|
| `TOURIST_SPOT` | `Icons.photo_camera_outlined` |
| `CULTURAL_FACILITY` | `Icons.museum_outlined` |
| `FESTIVAL_EVENT` | `Icons.celebration_outlined` |
| `TRAVEL_COURSE` | `Icons.route_outlined` |
| `LEISURE_SPORTS` | `Icons.hiking_outlined` |
| `LODGING` | `Icons.hotel_outlined` |
| `SHOPPING` | `Icons.shopping_bag_outlined` |
| `RESTAURANT` | `Icons.restaurant_outlined` |
| `TRANSPORT` | `Icons.directions_subway_outlined` |

- 9종은 **전체 집합**이며 한 언어에 다 나오지 않습니다 — 언어당 8종(공통 7 + KO `TRAVEL_COURSE` / 비KO `TRANSPORT`). 언어 전환 시 양쪽이 나타나므로 9종 모두 둡니다.
- 매핑에 없는 `code`는 **중립 기본 아이콘**으로 떨어집니다(AC11.5). 이 매핑은 유효성 검사가 아니라 "아는 것을 예쁘게 그리는" 최적화입니다 — `switch`를 exhaustive하게 쓰지 말고 기본값이 있는 조회로 두십시오. 그래야 서버가 카테고리를 추가해도 앱이 깨지지 않습니다(AC1.3).
- `iconUrl`이 생기면 그것이 우선하며, **로딩 실패 시에도 Material 아이콘으로 떨어집니다**(AC11.6).
- 커뮤니티 `category_chip_row.dart`에 같은 모양의 매핑이 있으나 `TargetCategory` enum 기준이라 재사용할 수 없습니다. `code` 문자열 기준으로 새로 두고, 공통화 여부는 재량입니다.

### `X-App-Key` 헤더 (R13)

**현재 클라이언트는 이 헤더를 보내지 않습니다.** 커뮤니티 리포지토리 주석에 언급만 있고 구현이 없습니다.

`lib/common/network/graphql_client.dart`의 `HttpLink` 정적 헤더에 `X-App-Key: k-trip-spot`을 넣습니다. `Accept-Language`처럼 요청마다 값이 달라지지 않으므로 `_AcceptLanguageLink` 같은 별도 Link는 필요 없습니다 — 정적 헤더와 컨텍스트 헤더는 `HttpLink`가 병합하므로 서로 덮어쓰지 않습니다(AC13.2).

**적용 지점** — `graphqlClient` provider 안의 `HttpLink` 생성부(현재 `GraphqlEndpoint.resolve()`와 `httpClient:`만 넘기고 있습니다):

```dart
// 앱 구분자. availableSpotCategories 등 앱별 노출 구성을 서버가 이 값으로 가른다.
// 값이 고정이라 요청마다 계산할 필요가 없어 HttpLink 정적 헤더에 둔다 —
// Accept-Language처럼 매번 달라지는 값만 Link로 싣는다.
const String _appKey = 'k-trip-spot';

final HttpLink httpLink = HttpLink(
  GraphqlEndpoint.resolve(),
  defaultHeaders: const <String, String>{'X-App-Key': _appKey},
  httpClient: _TimeoutHttpClient(),
);
```

상수는 `graphql_client.dart` 파일 상단에 두거나, 앱 식별자를 이미 모아둔 곳이 있으면 그쪽을 씁니다(POL-026 앱 식별자 규칙 확인 후 재량).

**병합 순서 확인됨**(`gql_http_link`): `{Content-type, Accept, ...defaultHeaders, ...contextHeaders}` 순으로 합쳐집니다. `X-App-Key`(정적)와 `Accept-Language`(컨텍스트)는 키가 달라 충돌하지 않습니다. 다만 **컨텍스트 헤더가 정적 헤더를 덮는 방향**이므로, 앞으로 같은 키를 Link에서 실으면 정적 값이 조용히 무시됩니다 — 정적 헤더에는 요청마다 달라지지 않는 값만 둡니다.

헤더가 없으면 서버는 "기본 앱"으로 읽습니다. 현재는 결과가 같아 증상이 없으나, 앱별 노출 구성이 갈리는 순간 조용히 잘못된 카테고리 목록을 받게 됩니다.

## 설계 결정

### 선택 상태를 provider로 올린다

현재 `CategoryBar`(`lib/domain/spot/component/category_bar.dart`)는 `selected == null`을 "전체"로 쓰는 단일 값 모델입니다. 이 표현은 다중 선택으로 확장되지 않습니다 — `null`이 "전체"와 "미선택" 두 의미를 겸하기 때문입니다.

선택 상태를 집합으로 모델링하고 provider가 소유합니다. 위젯은 상태를 갖지 않습니다.

> **2026-08-15 정정**: 아래 "비어 있을 수 없는 집합" 전제는 무효입니다. "전체" 칩이 돌아오면서 **빈 집합이 "전체"라는 정상 상태**가 됐습니다(위 §실기기 확인 후 변경 3건). 빈 집합은 서버로 `categories` 인자를 보내지 않는 것으로 표현되며, 빈 배열은 여전히 전송되지 않습니다.

- 토글 로직(추가·해제)은 provider에 있습니다. 위젯이 아니라 provider에 있어야 테스트가 위젯 없이 성립합니다(spec 테스트 범위).
- `selected == null` 표현은 제거합니다. "필터 없음"은 UI에 더 이상 존재하지 않습니다.
- 서버 전송 시 집합 → `categories` 리스트로 매핑합니다. 집합이 비는 경우는 provider가 만들지 않으므로 `[]`는 전송되지 않습니다(계약상 `EMPTY_CATEGORY_SET`).

**대상 provider는 이미 3개로 분리되어 있습니다** — R12(화면별 독립)는 신규 결정이 아니라 코드베이스가 따르던 규칙을 문서화한 것입니다. 각 provider의 `SpotCategory?`를 비어 있을 수 없는 집합으로 바꾸면 됩니다.

| provider | 파일 | 화면 |
|---|---|---|
| `SelectedSpotCategory` | `spot/provider/swipe_providers.dart` | Discover 스와이프 |
| `SelectedLikedCategory` | `spot/provider/liked_spots_providers.dart` | 좋아요 목록 |
| `SpotSearchCategory` | `spot/provider/spot_search_providers.dart` | 검색 |
| (신규) | 지도 | R7 — 새로 만듭니다 |

세 provider 모두 `@Riverpod(keepAlive: true)`이며 **이 성질은 유지합니다.** 상세 화면에 다녀오는 것만으로 필터가 풀리면 결과와 어긋나기 때문입니다(AC12.3). R12의 "비영속"은 **재시작 기준**이며(AC12.2), 영속 저장소에 쓰지 않는 것만을 요구합니다 — 세션 내 유지와 충돌하지 않습니다.

기존 주석들이 분리 근거를 이미 담고 있으므로(“같은 provider를 쓰면 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치운다”) 다중 선택 전환 시에도 그대로 둡니다.

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

### 실기기 확인 후 변경 3건 (2026-08-15, 사용자 결정)

구현을 실기기에서 본 뒤 사용자가 세 가지를 바꿨습니다. **아래 결정이 AC3.1·AC4.1·AC4.2보다 우선합니다** — 스펙의 그 기준들은 "전체" 상태가 없다는 전제 위에 서 있었고, 그 전제가 사라졌습니다.

**1. 칩 디자인을 커뮤니티 줄로 통일했습니다.** M3 `FilterChip`(높이 48) → 원형 아이콘 44×44 + 아래 라벨(줄 높이 88). 커뮤니티 `CategoryChipRow`의 모양이 앱의 기준선이 되었습니다.

`FilterChip`이 체크 표시로 알리던 선택 상태가 이 디자인에는 없어 **색·굵기만 남습니다.** 색만으로 상태를 알리면 색각 이상에서 구분되지 않으므로 `Semantics(selected:)`를 얹어 접근성 트리에 선택 여부를 명시했습니다.

**2. "전체" 칩이 모드 토글로 돌아왔습니다.** 맨 앞에 놓입니다.

- "전체"를 누르면 개별 선택이 전부 풀리고, 서버에는 `categories` 인자를 **보내지 않습니다**(빈 배열은 `EmptyCategorySetException`으로 거절됩니다 — 위 계약 차이 3번).
- 개별 칩을 누르면 "전체"가 꺼지고 그 칩이 켜집니다. 개별 칩끼리는 여전히 다중 선택입니다.
- 마지막 개별 칩을 끄면 선택이 비고 "전체"가 저절로 켜집니다.

따라서 **AC3.1("마지막 1개 해제 불가")과 AC3.2를 폐기했습니다.** 그 규칙의 근거는 "빈 집합은 사용자가 되돌릴 방법이 없는 막다른 상태"였는데, "전체"가 그 상태를 이름 있는 정상 상태로 만들었습니다. `SpotCategoryToggle.toggle()`의 length==1 가드와 `replace()`의 빈 집합 무시를 걷어내고 `selectAll()`을 더했습니다.

**AC4.1·AC4.2(기본값 `TOURIST_SPOT`·목록 첫 값 폴백)도 함께 폐기했습니다.** 진입 기본값과 "전체"를 둘 다 두면 앱을 켤 때마다 관광지만 걸린 화면이 뜨고 사용자가 매번 "전체"를 눌러야 합니다 — "전체"가 있는 이상 자연스러운 시작 상태는 그쪽입니다. 이에 따라 `spot_category_seed.dart`(그리고 그 회귀 테스트)와 `kDefaultSpotCategoryCode`가 사라졌습니다. 언어별 가용 목록 차이(KO `TRAVEL_COURSE` / 비KO `TRANSPORT`)에 대한 폴백 로직도 함께 불필요해졌습니다 — 심을 값이 없으면 폴백할 것도 없습니다.

부수 효과로 `map_screen.dart`의 spot 참조가 2건에서 **1건**(`availableSpotCategoriesProvider`)으로 줄었고, 빌드 중 provider 수정 위험(seed 경로)이 원천적으로 사라졌습니다.

Discover 빈 상태의 "카테고리 바꾸기" 버튼도 기본 카테고리가 아니라 "전체"로 되돌립니다 — "결과가 없으니 필터를 풀어 보라"는 이 버튼의 뜻에 맞습니다.

**3. 표시 순서를 고정했습니다.** 전체 → 관광지 → 문화시설 → 축제·공연 → 맛집 → 쇼핑 → 여행코스 → 레포츠 → 숙박(코드 목록은 `kCategoryDisplayOrder`). `TRANSPORT`는 사용자가 지정한 순서에 없어(비KO 언어에만 나옵니다) 아는 것 중 맨 뒤입니다.

**목록에 없는 코드도 버리지 않고 뒤에 붙입니다**(AC1.3) — 서버가 앱 업데이트 없이 카테고리를 늘릴 수 있어야 하므로 이 목록은 유효성 검사가 아니라 정렬 규칙입니다. `List.sort`가 아니라 훑어 담기로 구현한 이유는 Dart의 `sort`가 안정 정렬이 아니라서, 모르는 코드끼리의 순서가 다시 그릴 때 흔들릴 수 있기 때문입니다.

### 커뮤니티도 같은 위젯을 씁니다 (2026-08-15, 사용자 결정)

원래 스펙 §범위 밖은 커뮤니티 `CategoryChipRow`를 대상에서 제외했으나, 그 위젯의 **디자인이 기준선이 되면서** 방향이 뒤집혔습니다. 같은 모양이 두 벌 남으면 한쪽만 고쳐 갈라집니다.

`common/`이 `SpotCategory`도 `TargetCategory`도 알지 않도록 **표시 모델을 하나 두었습니다.**

| 파일 | 역할 |
|---|---|
| `common/category/category_chip_data.dart` | `CategoryChipData {id, label, icon}` + `kCategoryDisplayOrder` + `orderedCategoryChips()` |
| `common/category/category_bar.dart` | 도메인 타입을 모르는 바 본체 + 공개 `CategoryBarEntry` |
| `common/category/spot_category_bar.dart` | `SpotCategory` ↔ `CategoryChipData` 어댑터(네 화면이 같은 변환을 반복하지 않게) |

- spot은 라벨을 **서버**(`SpotCategory.label`)에서, 커뮤니티는 **l10n**(`targetCategoryLabel`)에서 가져옵니다. 바는 어느 쪽인지 모릅니다.
- 커뮤니티는 **단일 선택 그대로**입니다. 서버 계약이 카테고리 하나만 받으므로 이 통일은 모양에 관한 것이지 동작에 관한 것이 아닙니다. 재탭 해제("전체"로 복귀)도 그대로입니다. `TargetCategory`·`NearbySpotCategory`·provider·서버 계약은 건드리지 않았습니다.
- 커뮤니티는 서버 `position` 대신 `kCategoryDisplayOrder`를 따릅니다 — 사용자가 자리로 기억하는 줄이라 두 화면의 순서가 갈리면 안 됩니다.
- 커뮤니티의 아이콘 switch(`TargetCategory` 기준)를 걷어내고 공용 `spotCategoryIcon(code)`로 모았습니다. 같은 매핑 두 벌이 갈리면 같은 카테고리가 화면마다 다른 아이콘으로 보입니다.
- `TargetCategory` → 서버 코드 변환(`TOURIST_SPOT` 등)은 커뮤니티 위젯 안의 private switch입니다. 두 도메인이 같은 코드 문자열을 쓰는 것은 서버가 같은 코드 체계를 쓰기 때문이며, **타입을 합치지는 않습니다**(§3, `target_category.dart` 주석).

**"전체" 문구**: 새 공용 키 `categoryAll`("전체"/"All"/"すべて"/"全部")을 4개 arb에 추가했습니다. 커뮤니티는 자기 `communityCategoryAll`을 계속 씁니다 — 커뮤니티가 소유한 키를 공용 위젯이 빌리면 커뮤니티 문구 변경이 spot 화면까지 끌고 갑니다. 기존 `viewAll`("전체 보기"/"View all")은 섹션 헤더의 **링크** 문구라 필터 모드 이름으로 읽히지 않아 재사용하지 않았습니다.

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

정보 위계 재설계와 시각적 리듬은 검증 기준을 세울 수 없어 이 스펙 범위 밖입니다(spec §결정 사항).

### 서브 컬러

| 대상 | 기존 | 신규 |
|---|---|---|
| `AppColors.secondary` | `#17A2A2` | `#A56200` |
| `AppTheme` 라이트 `secondary` | `#006A6A` | `#A56200` |

근거와 대비 측정값은 spec R10에 있습니다. 실사용처는 `score_breakdown.dart`, `onboarding_screen.dart` 2곳뿐이라 파급 범위가 작습니다.

**`#A56200`은 확정값이 아니라 출발점입니다** — 실제 화면을 보며 조정합니다. 조정 시에도 AC10.2~10.4(텍스트 4.5:1 / 비텍스트 3:1 / teal 잔존 없음)는 유지되어야 하며, 값을 바꾸면 R10 측정표를 갱신하고 amend합니다. 색상값이 `AppColors`·`AppTheme` 두 곳에 나뉘어 있으므로 조정 시 함께 움직여야 합니다.

`onSecondary`, `secondaryContainer`, `onSecondaryContainer` 등 파생 톤도 함께 재산출해야 합니다 — 라이트 스킴은 Stitch M3 export를 그대로 쓰고 있어 secondary 계열 톤이 teal 기준으로 잡혀 있습니다. 서브 컬러만 바꾸고 컨테이너 톤을 두면 teal 잔상이 남습니다.

**다크 스킴은 시드 교체만으로 반영되지 않습니다(2026-08-14 구현 중 정정).** `copyWith(secondary:)`는 `secondary` 하나만 덮고 `onSecondary`·`secondaryContainer`·`onSecondaryContainer`는 시드(primary) 기준으로 남습니다. 파생 톤을 함께 덮도록 고쳤습니다. 또 어두운 배경에서는 `#A56200`이 텍스트 기준 4.5:1을 넘지 못해(3.55:1) 다크 `secondary`는 밝은 `#F0B968`을 씁니다.

> 아래 `#A56200` 기준 측정표는 **2026-08-14 중간 상태**이며 지금은 무효입니다.
> 최종 적용값은 이 절 끝의 "최종 적용값"을 보십시오.

### 서브 컬러 이동: `#A56200` → `#B4501E` (적용 필요)

ΔE(CIE Lab)로 재측정한 결과, 충돌은 `secondary` 본체가 아니라 **컨테이너 톤**에 있었습니다.

| 쌍 | ΔE (`#A56200`) | ΔE (`#B4501E`) |
|---|---|---|
| `secondary` / `tertiary` | 14.5 (구분됨) | 25.5 |
| `secondaryContainer` / `tertiaryContainer` | 52.5 (구분됨) | 60.6 |
| **`secondaryContainer` / `tertiaryFixed`** | **0.5 — 동일** | **13.2** |

`#FFDDB3`와 `#FFDDB4`가 1스텝 차이로 같은 색이었습니다. 상호 대비비 1.39:1을 근거로 본체가 충돌한다고 본 초기 진단은 과잉이었습니다 — 대비비는 명도만 재므로 색 구분의 척도가 아닙니다.

**`tertiary`는 옮기지 않습니다.** `email_change_pending_banner.dart`가 "error가 아닌 대기 상태"를 나타내는 amber로 쓰고 있어 의미가 색에 묶여 있습니다. 이동 대상은 `secondary`입니다.

적용할 값:

| 토큰 | 값 | 비고 |
|---|---|---|
| `AppColors.secondary` | `#B4501E` | H=20° — primary(2°)와 amber(38°) 사이 |
| 라이트 `secondary` | `#B4501E` | surface 4.88:1 · 흰 글자 5.11:1 |
| 라이트 `secondaryContainer` | `#FFDBCC` | |
| 라이트 `onSecondaryContainer` | `#7A3210` | container 대비 7.10:1 |
| 다크 `secondary` 계열 | 구현 시 산출 | 같은 hue 대역의 밝은 톤. 다크 surface 대비 4.5:1 이상 |

검증 기준은 spec **AC10.5**(모든 대응 톤 쌍 ΔE ≥ 10) · **AC10.6**(다크 대비)입니다.

### 최종 적용값과 실측 (2026-08-15, 적용 완료)

| 역할 | 라이트 | 다크 |
|---|---|---|
| `secondary` | `#B4501E` | `#FFB59B` |
| `onSecondary` | `#FFFFFF` | `#5A2100` |
| `secondaryContainer` | `#FFDBCC` | `#7A3210` |
| `onSecondaryContainer` | `#7A3210` | `#FFDBCC` |
| `secondaryFixed` / `Dim` | `#FFDBCC` / `#E5A183` | (라이트와 공유) |
| `onSecondaryFixed` / `Variant` | `#33150A` / `#7A3210` | (라이트와 공유) |

**AC10.5 — ΔE ≥ 10** (CIE Lab, tertiary 계열과의 분리)

| 쌍 | ΔE |
|---|---|
| `secondary` / `tertiary` | 25.5 |
| `secondaryContainer` / `tertiaryContainer` | 60.6 |
| `secondaryContainer` / `tertiaryFixed` | 13.2 |
| `secondaryFixed` / `tertiaryFixed` | 13.2 |
| `secondaryFixedDim` / `tertiaryFixedDim` | 34.9 |

**AC10.2 (≥4.5) · AC10.3 (≥3) · AC10.6 (다크)**

| 검증 | 라이트 | 다크 |
|---|---|---|
| onSecondary on secondary | 5.11 | 7.47 |
| secondary on surface | 4.88 | 10.08 |
| onSecondaryContainer on container | 7.10 | 7.10 |
| onSecondaryFixed on secondaryFixed | 12.98 | — |
| onSecondaryFixedVariant on secondaryFixed | 7.10 | — |
| 진행 막대 fill vs 트랙 (AC10.3) | 3.95 | — |

teal 잔존 0건(AC10.4). `*Fixed` 4종 포함 secondary 계열 전체를 교체했습니다.

**초기 진단 정정**: `#A56200`이 `tertiary`와 충돌한다고 본 근거는 상호 대비비 1.39:1이었는데, 대비비는 명도만 재므로 색 구분의 척도가 아닙니다. ΔE로 다시 재니 본체는 14.5로 구분되고 있었고, 실제 충돌은 `secondaryContainer`(`#FFDDB3`)와 `tertiaryFixed`(`#FFDDB4`)가 ΔE 0.5로 **사실상 같은 색**이었던 데 있었습니다.

### 라벨

칩 라벨은 l10n 문자열입니다(POL-023). enum 식별자가 UI에 노출되지 않습니다. 신규·변경 문자열은 EN/KO/JA/ZH 4개 arb 모두에 추가합니다(POL-022). 제거되는 "전체 보기"(`viewAll`) 키가 다른 화면에서도 쓰이는지 확인 후 정리합니다.

## 테스트 대상 단위

**provider / 도메인 모델 로직만.** 위젯 테스트·통합 테스트는 범위 밖입니다.

| 단위 | 검증 내용 | 대응 AC |
|---|---|---|
| 카테고리 선택 provider | 추가·해제 토글 | AC2.1, AC2.2 |
| ~~카테고리 선택 provider~~ | ~~마지막 1개 해제 불가~~ — **폐기**(2026-08-15 "전체" 도입) | ~~AC3.1~~ |
| ~~카테고리 선택 provider~~ | ~~9개 전부 선택 → 8회 해제 → 크기 1~~ — **폐기** | ~~AC3.2~~ |
| 카테고리 선택 provider | 마지막 1개를 꺼도 막지 않고 빈 집합("전체")이 된다 | 위 결정 |
| 카테고리 선택 provider | `selectAll()`이 선택을 비운다 | 위 결정 |
| 칩 표시 순서 | `kCategoryDisplayOrder`대로 정렬 · 모르는 코드는 뒤에 유지 | AC1.3 |
| 테마 값 검증 | secondary 계열 대비비(텍스트 4.5:1 / 비텍스트 3:1), teal 계열 잔존 없음 | AC10.1~10.4 |
| 아이콘 해석 | `iconUrl` 우선 · null이면 `code` 매핑 · 모르는 `code`는 중립 기본값 | AC11.2·11.4·11.5 |
| 카테고리 모델 매핑 | 생성 타입 → 도메인 값 객체, 동등성은 `code` 기준 | AC5.2 |
| GraphQL 링크 | `X-App-Key`가 실리고 `Accept-Language`와 공존 | AC13.1·13.2 |
| 카테고리 선택 provider | 화면별 인스턴스 독립 — 한 화면 변경이 다른 화면에 전파되지 않음 | AC12.1 |
| 카테고리 선택 provider | 재시작 시 기본값 초기화(영속 저장 없음) | AC12.2 |
| ~~카테고리 선택 provider~~ | ~~최초 기본값 `TOURIST_SPOT`~~ — **폐기**, 최초는 "전체"(빈 집합) | ~~AC4.1~~ |
| ~~카테고리 선택 provider~~ | ~~`TOURIST_SPOT` 부재 시 목록 첫 값 폴백~~ — **폐기**(심는 값이 없으면 폴백도 없다) | ~~AC4.2~~ |
| 선택 집합 → 쿼리 변수 매핑 | `categories` 리스트 생성, 빈 배열 미전송 | AC5.1 |
| 지도 조회 트리거 | 필터 변경 시 디바운스 후 1회 조회 | AC7.3 |

## 범위 밖

- 정보 위계 재설계·시각적 리듬 — R9 범위 밖입니다(spec §결정 사항). 실제 화면을 보며 조정할 사항이며, 필요 시 후속 스펙으로 분리합니다.
- `category` 인자 제거 — 별도 스펙입니다.
- ~~커뮤니티 `CategoryChipRow`~~ — **범위에 들어왔습니다**(2026-08-15 사용자 결정, 위 §커뮤니티도 같은 위젯을 씁니다). 그 위젯의 디자인이 앱 기준선이 되면서 공용 `CategoryBar`로 흡수했습니다. 단일 선택 동작과 서버 계약은 그대로입니다.
- 위젯 렌더링 검증 — 테스트 범위 밖입니다.
