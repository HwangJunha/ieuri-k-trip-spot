> spec: SPEC-0035 · source: `Specs/SPEC-0035/spec.md` (Obsidian, v2.0) · status: approved

# SPEC-0035 — 클라이언트 설계: 내 주변 추천

요구사항·수용 기준·계약은 스펙 문서에 있다. 이 문서는 어디에 붙이고 어떻게 배선하는지만 적는다.

> **2026-09-12 전면 재작성.** 첫 판(브랜치 `feature/SPEC-0035-recommended-feed`)은 v1.0 계약
> — `Query.location { spots, recommendedSpots }` 컨텍스트 타입·`SpotConnection` 커서·
> `CURSOR_EXPIRED`·장소 선택 시트 전환 — 을 따랐다. 서버가 그 전제("추천은 커서 페이지네이션
> 목록")를 폐기하고 PR #133에서 **루트 쿼리 `recommendedSpots` 하나(묶음, 커서 없음, `spots`
> 불변)** 로 다시 만들었으므로 그 브랜치와 문서는 버린다. 이 문서가 그 자리다.

## 계약 (서버 소유, 2026-09-12 확인)

```graphql
recommendedSpots(
  latitude: Float!, longitude: Float!,
  radiusMeters: Int = 20000, categories: [String!], first: Int = 20
): [Spot!]!
```

- **인증 필수**(`UNAUTHENTICATED`). Discover·홈 모두 로그인 화면이라 문제없다.
- **페이지가 아니라 묶음이다.** 서버가 이미 반응(좋아요·싫어요)한 장소를 뺀 뒤 점수(거리·면세·
  카테고리 다양성·취향)순 앞 `first`건을 준다. 다시 부르면 그 시점의 새 추천이 온다. `first`보다
  적게 오면 반경 안 후보 소진. 상한 100 초과는 절삭(오류 아님).
- 오류 코드는 전부 기존 재사용: `UNAUTHENTICATED`·`INVALID_COORDINATES`·`RADIUS_TOO_LARGE`·
  `EMPTY_CATEGORY_SET`. `categories` 규약은 `spots`와 같다(생략/null = 전체, 빈 배열 거절).
- **`Query.spots`는 불변**이고 그것이 "전체"다. `fetchSpotPage`·`query Spots`는 그대로 둔다.
- `Location`·`SpotConnection`·커서·`hasFieldFailure`·`SpotFailure.cursorInvalid`는 **만들지 않는다.**

## 어디에 붙는가

| 진입점 | 파일 · 단위 | 동작 |
|---|---|---|
| 홈 「Near you」 | `home_section_providers.dart` `nearbySpotsSection` | `fetchRecommendedSpots(first: 10)` 1회. 새로고침(좌표 무효화)이면 다시 1회(AC-10.1). `_NearYouSection`은 손대지 않았다 |
| Discover 카테고리 바 | `common/category/category_bar.dart`·`spot_category_bar.dart` | 「전체」 뒤에 **「추천」 항목**(`onRecommended`가 있을 때만 그림 — Discover 전용). 문구 `categoryRecommended`(EN "For you" / KO "추천" / JA "おすすめ" / ZH "推薦") |
| Discover 스와이프 | `swipe_providers.dart` `SwipeController` | family 키 `SwipeFeedKey(recommended, selection)`. 추천이면 `recommendedSpots(first: 100)` 묶음, 아니면 기존 `spots` 오프셋 |
| 상세 → 스와이프 세션 소비 | `routes.dart`·`spot_detail_view.dart`·`spot_detail_providers.dart` | 세션 키가 `SwipeFeedKey`로 바뀌어 `category` 쿼리 파라미터에 `source=recommended`가 더해진다 |
| 장소 선택 시트(community) | — | **손대지 않는다.** 서버가 `spots`를 안 바꿨다 |

## 「추천」과 칩의 관계 (사용자 결정 2026-09-12)

- **「추천」은 칩처럼 취급한다.** 독립으로 켜고 끄며 카테고리 칩과 함께 켜질 수 있다. 켜져 있으면
  소스가 `recommendedSpots`이고 켜진 칩이 `categories` 필터로 얹힌다. 끄면 기존 `spots`다.
- **기본은 켜짐**(첫 진입 = 추천 + 칩 없음). `RecommendedFeedToggle`(keepAlive, 로그아웃에 초기화).
- **「전체」는 칩도 추천도 켜지지 않은 상태에만 켜진다**(구현 판단 — 「전체」는 필터도 추천도 없는
  `spots`이므로). 「전체」와 빈 상태의 "카테고리 바꾸기"는 `selectAllSpots(ref)`로 칩과 추천을
  모두 끈다. 칩을 끄는 것만으로는 추천이 꺼지지 않는다.
- 바 순서: `[전체][추천][칩…]`. 아이콘 `auto_awesome_rounded`.

## 핵심 배선

### repository

| 인터페이스 | 메서드 | 반환 |
|---|---|---|
| `SpotRepository` | `fetchRecommendedSpots({latitude, longitude, radiusMeters, categoryCodes, first})` | `List<TouristSpot>` — `OffsetPage`도 `CursorPage`도 아니다(페이지 개념이 없다) |
| `SpotRepository` | `fetchSpotPage` | 그대로(전체 소스) |

오퍼레이션 `query RecommendedSpots($latitude, $longitude, $radiusMeters, $categories, $first)` —
선택 필드는 `Spots`와 같다. 스키마 사본에는 `Query.recommendedSpots` 필드 하나만 더했다.
생성 타입은 `spot_repository_impl.dart` 밖으로 나가지 않는다(POL-020). 오류는 최상위 `errors[]`
경로 `["recommendedSpots"]`로 오므로 기존 `hasRootFailure`/`fromQueryErrorCode` 그대로다.

### 상태 모델

| 모델 | 변경 |
|---|---|
| `SwipeFeedKey` (신규, `model/swipe_feed_key.dart`) | `recommended: bool` + `selection: SpotCategorySelection`. 값 동등성은 둘 다. `scopeKey`(`recommended/…` / `all/…`)가 재시도 예산 키 |
| `SwipeQueue` | `loadedPage`가 **`int?`** — 추천 묶음 소스에서는 null(페이지가 없다). `nextPage`는 그때 null. `copyWith`는 `cards`·`hasNextPage`만 받는다(null을 `??`로 덮지 않으려고). 두 소스를 한 타입에 두되 페이지 번호를 지어내지 않는 최소 변경을 골랐다 |
| `RecommendedFeedToggle` (provider) | `bool`, 기본 true, keepAlive, `watchSignedIn()` |

### `SwipeController` 흐름 (추천 소스)

| 상황 | 동작 | 인용 |
|---|---|---|
| 첫 빌드 | `fetchRecommendedSpots(first: 100)` → `SwipeQueue(cards: 받은 순서 그대로, loadedPage: null, hasNextPage: 받은 수 ≥ 100)` | AC-10.2 |
| 큐 < 10 & `hasNextPage` | **같은 인자로 다시 부른다.** 받은 묶음에서 큐에 있는 id + 이 세션에서 넘긴 id(`_seenIds`)를 걷어낸 뒤 뒤에 붙인다. `hasNextPage = 받은 수 ≥ 100 && 새 카드 > 0` | AC-10.2, §5 |
| 걷어낸 뒤 새 카드 0장 또는 `first` 미만 | `hasNextPage=false` → 더 부르지 않는다(무한 재요청 방지). 큐를 다 쓰면 기존 소진 상태 | AC-10.2 |
| 보충 실패 | 기존 규칙 — 큐 유지, 다음 스와이프에서 재시도, 예산 미차감 | — |
| 좌표·반경·카테고리·언어·로그인·추천 토글 변경 | 기존대로 재빌드(또는 다른 family 인스턴스) → 큐를 비우고 첫 묶음부터 | AC-10.3 |

**섞지 않는다.** 전체 소스는 페이지 안에서 셔플하지만(같은 카페의 사용자들이 같은 순서를 보는
것을 막으려고), 추천 묶음은 서버 배열이 계약이다 — 카테고리 반복 감점으로 닮은 카드가 연달아
오지 않게 배열한 것이고 취향으로 이미 사용자마다 다르다(POL-019).

`_seenIds`는 세션(빌드)마다 비우며 스와이프·상세 소비·사라진 카드 id를 모은다. 반응 뮤테이션이
커밋되기 전 재요청하면 방금 넘긴 카드가 한 번 더 올 수 있어서다(§5). 반응 전송이 실패한 카드도
이 세션 안에서는 다시 오지 않는다 — 의도한 부수 효과다.

전체 소스(`spots` 오프셋)는 손대지 않았다. `_maybePrefetch`가 반경을 함께 싣도록 한 줄 고쳤다
(예전엔 빠뜨렸는데 오프셋이라 무해했다 — 서버 기본 20km와 사용자 반경이 다르면 2페이지부터
다른 반경이었다).

## 테스트가 붙는 단위

| 테스트 | 판정 |
|---|---|
| `spot_test_doubles.dart` `FakeSpotRepository.fetchRecommendedSpots` | 인자·횟수 기록, `feed` 교체로 다음 묶음 흉내, 실패 주입 |
| `swipe_providers_test.dart` (신규) | AC-10.2(첫 100·같은 인자 재요청·겹침 제거·소진·0장 정지·보충 실패), AC-10.3(좌표 무효화·추천 토글), 전체 소스 오프셋 유지 |
| `home_section_providers_test.dart` | AC-10.1(first: 10 1회, 새로고침 1회) |
| `spot_models_test.dart` | `SwipeQueue` 묶음(loadedPage null), `SwipeFeedKey` 동등성·scopeKey |
| `spot_detail_route_test.dart` | `source=recommended` → 추천 세션 키 |
| `category_bar_recommended_test.dart` (신규) | 「추천」 항목 렌더·순서·「전체」 배타·칩과 공존 |

## 검증 (2026-09-12)

- `flutter analyze` 깨끗, `build_runner build` 통과, `gen-l10n` 반영.
- **§13 라이브 스윕: 로컬 `ieuri-server` `feature/SPEC-0035-recommended-spots`(8888)** 에 대해
  검증 오류 0건. `RecommendedSpots` 문서·리터럴 페이로드 모두 `UNAUTHENTICATED`(경로
  `["recommendedSpots"]`)로 답해 형태 통과. dev 클러스터는 서버 PR #133 머지 전이라 쓰지 않았다.
- 실기기 확인은 남았다: 「추천」 항목 모양(사진 위 흰 라벨), 추천 순서가 거리순이 아닌 것,
  반응 5개 이상 회원에서 취향 반영, 보충 시 겹침 제거.

## 관련

- SPEC-0002(스와이프 큐·셔플), SPEC-0006(재시도 예산), SPEC-0020(카테고리 선택 키), SPEC-0029(언어별 조회 1회)

## 변경 이력

| 날짜 | 변경 | 계기 |
|---|---|---|
| 2026-09-11 | 초안(v1.0 계약 — `location`·커서) | ieuri-k-trip-spot #105 |
| 2026-09-12 | **전면 재작성 — 서버 계약 변경(루트 쿼리·커서 없음·spots 불변)**. 「추천」 칩·기본 켜짐은 사용자 결정 | ieuri-server PR #133, 사용자 결정(2026-09-12) |
