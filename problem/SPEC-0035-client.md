> spec: SPEC-0035 · source: `Specs/SPEC-0035/spec.md` (Obsidian) · status: approved

# SPEC-0035 — 클라이언트 설계: 내 주변 추천 피드

요구사항·수용 기준·계약은 스펙 문서에 있다. 이 문서는 어디에 붙이고 어떻게 배선하는지만 적는다.

## 어디에 붙는가

새 화면·버튼·토글은 없다. 세 진입점이 부르는 **조회만** 바뀐다.

| 진입점 | 파일 · 단위 | 지금 | 이후 |
|---|---|---|---|
| 홈 「Near you」 | `lib/domain/spot/provider/home_section_providers.dart` `nearbySpotsSection` | `fetchSpotPage(size: 10)` | `fetchRecommendedSpots(first: 10, after: null)` 1회. `_NearYouSection`(`home_screen.dart`)은 손대지 않는다 |
| Discover 스와이프 | `lib/domain/spot/provider/swipe_providers.dart` `SwipeController` `_fetchFirstPage` · 이어 받기 | `fetchSpotPage(page: 0/다음, size: 100)` | `fetchRecommendedSpots(first: 100, after: null)` → `after: endCursor`. `discover_swipe_view.dart`는 손대지 않는다 |
| 글 작성 장소 선택 시트 「주변」 | `lib/domain/community/provider/nearby_spots_providers.dart` `NearbySpotsController` `build` · `loadMore` | `fetchNearbySpots(page: 0/다음, size: 50)` | `fetchNearbySpots(first: 50, after: null)` → `after: endCursor`. `spot_picker_sheet.dart`의 `PaginationListView`는 `hasMore`만 보므로 손대지 않는다 |

## 계약과 생성 타입

- 스키마 사본: `Location`·`SpotConnection`·`SpotEdge`·`Query.location`을 `lib/domain/spot/repository/spot_schema.graphql`에 **한 번만** 더한다. graphql_codegen이 모든 스키마 파일을 하나로 병합하므로 `community_schema.graphql`에 다시 정의하면 충돌한다(기존 주석). 커뮤니티 오퍼레이션은 병합된 타입을 그냥 쓴다.
- `Query.spots`의 `@deprecated`는 사본에도 옮긴다. 이 스펙 뒤 spot 도메인에 `query Spots`·`fetchSpotPage` 소비처가 없으므로 **둘 다 제거**한다(테스트 더블 포함). 커뮤니티의 `query NearbySpots`는 이름을 유지한 채 본문만 `location { spots }`로 바꾼다.
- 오퍼레이션 이름은 코드젠 전역 이름공간이다. spot 도메인의 새 오퍼레이션은 `query RecommendedSpots`로 두고, `NearbySpots`라는 이름을 spot 도메인에서 만들지 않는다(AC-31.3).
- `Location`은 id가 없다. 공용 클라이언트는 정규화 캐시를 쓰지 않으므로(`build.yaml` `addTypename: false`) 문제없다.

```graphql
# lib/domain/spot/repository/spot_operations.graphql
query RecommendedSpots(
  $latitude: Float!, $longitude: Float!,
  $radiusMeters: Int, $categories: [String!],
  $first: Int, $after: String
) {
  location(latitude: $latitude, longitude: $longitude) {
    recommendedSpots(radiusMeters: $radiusMeters, categories: $categories, first: $first, after: $after) {
      edges { node { id title address thumbnailImageUrl distanceMeters category { code label iconUrl } copyright attributionText } cursor }
      pageInfo { hasNextPage endCursor }
    }
  }
}
```

```graphql
# lib/domain/community/repository/community_operations.graphql — 이름 유지, 본문 교체
query NearbySpots($latitude: Float!, $longitude: Float!, $radiusMeters: Int, $categories: [String!], $first: Int, $after: String) {
  location(latitude: $latitude, longitude: $longitude) {
    spots(radiusMeters: $radiusMeters, categories: $categories, first: $first, after: $after) {
      edges { node { id title address thumbnailImageUrl distanceMeters } }
      pageInfo { hasNextPage endCursor }
    }
  }
}
```

## 핵심 배선

### repository

| 인터페이스 | 메서드 | 반환 | 비고 |
|---|---|---|---|
| `SpotRepository` (`spot_repository.dart`) | `fetchRecommendedSpots({latitude, longitude, radiusMeters, categoryCodes, first, after})` | `CursorPage<TouristSpot>` | `fetchLikedSpots`와 같은 모양. `categoryCodes`는 `SpotCategorySelection.codesOrNull` 규약 그대로(빈 목록 금지) |
| `SpotRepository` | `fetchSpotPage` | — | **제거** |
| `CommunityRepository` (`community_repository.dart`) | `fetchNearbySpots({..., first, after})` | `CursorPage<NearbySpot>` | `page/size` → `first/after`. `OffsetPage<NearbySpot>` 사용처는 이 하나뿐 |

매핑은 `common/pagination/page.dart`의 `CursorPage`(items·hasNextPage·endCursor)로 한다. 생성 타입(`Query$RecommendedSpots$...`)은 `spot_repository_impl.dart` 밖으로 나가지 않는다(POL-020).

### 커서 오류의 도메인 표현

repository는 최상위 `errors[].extensions.code`가 `CURSOR_EXPIRED` 또는 `INVALID_CURSOR`면 `SpotFailure.cursorInvalid`(신규 값 하나 — 두 코드를 구분할 이유가 없다: 둘 다 "커서 없이 다시 시작". 이름은 만료·손상을 아우르는 중립형)로 옮긴다. 다른 코드는 기존 `SpotFailure` 매핑 그대로.

### 상태 모델 변경

| 모델 | 지금 | 이후 |
|---|---|---|
| `SwipeQueue` (`lib/domain/spot/model/swipe_queue.dart`) | `cards`, `loadedPage`, `hasNextPage`, `nextPage` getter | `cards`, `endCursor`, `hasNextPage`, `canLoadMore` getter(`hasNextPage && endCursor != null`) |
| `NearbySpotsState` (`nearby_spots_providers.dart`) | `items`, `hasMore`, `page` | `items`, `hasMore`, `endCursor` |

### `SwipeController` 흐름

| 상황 | 동작 | 인용 |
|---|---|---|
| 첫 빌드 | `fetchRecommendedSpots(first: 100, after: null)` → `SwipeQueue(cards: _shuffled(items), endCursor, hasNextPage)` | AC-27.1 |
| 큐 < `_prefetchThreshold`(10) & `canLoadMore` | `after: endCursor`로 1회 → 받은 묶음만 `_shuffled` → 뒤에 붙임. 페이지 경계는 넘지 않는다(기존 규약) | AC-27.2 |
| 이어 받기 실패 = `cursorInvalid` | **재시도 예산에 세지 않는다**(네트워크 실패가 아니다). `after: null`로 첫 요청을 다시 보내고, 받은 묶음에서 큐에 이미 있는 id를 걷어낸 뒤 붙인다. 큐는 비우지 않는다 | AC-28.x |
| 이어 받기 실패 = 기타 | 기존 `retry_budget_providers` 규칙 그대로 | AC-27.4 |
| 좌표·반경·카테고리·언어·로그인 변화 | 기존대로 `build` 재실행 → 커서 없는 첫 요청 | AC-29.x |

좌표는 이어 받기에도 **첫 조회 시점 값을 재사용**한다(기존 주석 그대로). 서버 커서가 조건 해시를 검사하므로 옛 좌표로 이어 받는 것이 맞고, 좌표가 바뀌면 이 컨트롤러 자체가 재빌드된다.

### `nearbySpotsSection` (홈)

`fetchRecommendedSpots(first: homeSectionSize, after: null)` 한 줄 교체. `endCursor`는 버린다. 나머지(로케일 watch, 좌표·반경 watch, 재시도)는 그대로.

### `NearbySpotsController` (장소 선택 시트)

`build`는 `after: null`, `loadMore`는 `after: state.endCursor`. 카테고리 칩 변경은 지금처럼 provider 재빌드 → 첫 요청. 검색어가 있으면 `searchSpots` 경로(SPEC-0013)라 이 변경과 무관하다.

## 테스트가 붙는 단위

provider·notifier·모델·repository 매핑 수준이다. 위젯 테스트는 없다.

| 테스트 | 판정 |
|---|---|
| `test/domain/spot/spot_test_doubles.dart` `FakeSpotRepository.fetchRecommendedSpots` | 호출 인자·횟수 기록, 실패 주입(`cursorInvalid` 포함) |
| `home_section_providers_test` | AC-26.1~26.3 |
| `swipe_providers_test` | AC-27.1~27.4, 28.1~28.3, 29.1~29.2 — 특히 `cursorInvalid` 시 큐 보존·id 중복 제거·예산 미차감 |
| `swipe_queue_test` | `canLoadMore`, `isExhausted` |
| `nearby_spots_providers_test` (community) | AC-30.1~30.3 |
| `spot_repository_impl_test` · `community_repository_impl_test` | AC-31.1, 31.2 — 생성 응답 → `CursorPage` 매핑, 오류 코드 → `SpotFailure` |

## 선행

- 서버 S1이 배포되기 전에는 스키마 사본·오퍼레이션·코드젠·repository·provider·테스트까지 진행할 수 있다. 실기기 확인만 서버를 기다린다.
- `@deprecated`가 붙은 `spots`를 부르는 코드가 이 저장소에 남지 않도록 `fetchSpotPage` 제거를 같은 브랜치에서 한다.

## 구현 메모 (2026-09-11)

### 계약 검증 상태

**미검증.** 서버 S1이 아직 없고(`ieuri-server`에 `recommendedSpots`·`Location` 없음)
로컬 서버(`localhost:8888`)도 응답하지 않았다. 스키마 사본은
`Specs/SPEC-0035/contract.graphql` 제안을 그대로 옮겼고 codegen만 통과했다 — §13
스윕과 실기기 확인은 서버 배포 뒤로 남긴다. 특히 다음은 서버 응답을 봐야 확정된다:

- 커서 오류의 `errors[].path`가 `["location","recommendedSpots"]`(두 칸)로 오는지.
  DGS가 하위 리졸버 예외를 그 경로에 싣는다고 가정했다. 최상위(`["location"]`)나
  경로 없음으로 와도 전체 실패로 잡히도록 접두 판정을 썼다(아래).
- `first: 100`이 절삭 없이 지켜지는지(AC-2.3의 상한이 정확히 100이라 경계다).

### 결정한 것

| 결정 | 이유 |
|---|---|
| 공용 `hasFieldFailure`/`firstFieldError(result, ['location','recommendedSpots'])` 추가, `hasRootFailure`는 그쪽으로 위임 | 기존 판정은 최상위 필드 한 칸만 전체 실패로 본다. 결과가 두 칸 아래에 실리는 새 쿼리는 커서 오류가 **부분 실패로 통과**해 `fromJson`에서 터진다. 오류 `path`가 결과 경로의 접두(같거나 짧음)면 전체 실패, 더 깊으면 부분 실패 |
| `SpotRepositoryImpl`·`CommunityRepositoryImpl`의 `_query`에 `fieldPath` 선택 인자 | 위 판정을 조회마다 고를 수 있게. 생략하면 기존과 같은 `[operation]` |
| `CURSOR_EXPIRED`·`INVALID_CURSOR` → `SpotFailure.cursorInvalid`는 `fromQueryErrorCode`에 둔다 | spot 도메인 전 조회가 같은 번역을 쓰므로 `likedSpots`의 `INVALID_CURSOR`도 같은 값이 된다 — 의미가 같다 |
| `cursorInvalid`를 `countsTowardRetryBudget`에서 제외 | 스펙 "재시도 예산에 세지 않는다". 부수 효과로 첫 요청(`after: null`)에서 이 코드가 오면 자동 재시도 없이 오류 상태가 되는데, 계약상 발생하지 않는 경우다 |
| 이어 받기에 **반경도** 다시 싣는다(`ref.read(searchRadiusControllerProvider)`) | 예전 `_maybePrefetch`는 `radiusMeters`를 빼먹고 있었다(오프셋이라 무해했음). 커서가 조건 해시에 묶이는 이상 첫 요청과 다른 반경은 곧 `INVALID_CURSOR`다. 반경이 바뀌었다면 이미 `build`가 다시 돌았으므로 `read`로 족하다 |
| `SwipeQueue.copyWith`는 `cards`만 받는다 | `endCursor`가 null로 바뀌는 경우(마지막 묶음)를 `??` 방식 copyWith로는 표현할 수 없다. 묶음을 붙일 때는 생성자로 새로 만든다(`_append`) |
| 커뮤니티 시트의 커서 오류는 별도 kind 없이 기존 `loadMore` 실패 처리 | 스펙 AC-30에 커서 오류 항목이 없고, 시트는 짧게 열리는 화면이라 닫았다 열면 첫 페이지부터다. 목록은 유지되고 인디케이터만 걷힌다 |
| repository 매핑 테스트를 새로 만든다(`test/domain/{spot,community}/repository/*_impl_test.dart`) | 스펙이 AC-31을 repository 수준에 뒀는데 두 도메인 모두 impl 테스트가 없었다. `spot_qa_test`의 `_RecordingLink` 패턴을 그대로 썼다 |

### 테스트에서 드러난 것

- `SwipeController`는 `ref.watchSignedIn()` 때문에 인증 판정이 loading→확정으로
  넘어갈 때 **첫 빌드가 한 번 더 돈다.** 호출 횟수를 세는 테스트는
  `authControllerProvider`를 먼저 구독하고 큐를 비운 뒤 컨트롤러를 읽어야 정확히
  1회가 된다(`swipe_providers_test.dart` `makeContainer`). 보안 저장소가 없는
  컨테이너에선 판정이 **오류로** 확정되므로 `.future`를 기다리면 안 된다.
- 구독 없이 컨트롤러를 읽으면 이어 받기 중 `currentCoordinatesProvider.future`가
  완결되지 않아 30초 타임아웃에 매달린다 — 상세 컨트롤러 테스트와 같은 이유로
  `container.listen`을 건다.

## 관련

- SPEC-0002(스와이프 큐·셔플), SPEC-0006(재시도 예산), SPEC-0008(좋아요 커서 선례), SPEC-0013(장소 선택 시트 검색), SPEC-0020(카테고리 선택 키), SPEC-0029(언어별 조회 1회)

## 변경 이력

| 날짜 | 변경 | 계기 |
|---|---|---|
| 2026-09-11 | 초안 | ieuri-k-trip-spot #105 |
| 2026-09-11 | 구현 메모 추가 — 중첩 필드 실패 판정, 이어 받기 반경 재전송, 계약 미검증 상태 | 구현(feature/SPEC-0035-recommended-feed) |
