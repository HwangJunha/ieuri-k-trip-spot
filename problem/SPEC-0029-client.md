> spec: SPEC-0029 · source: `Specs/SPEC-0029/spec.md` (Obsidian) · status: approved

# SPEC-0029 · 클라이언트 설계

요구사항·수용 기준·계약은 스펙이 소유한다. 이 문서는 이 레포에 한정된 설계 결정만 담는다.

**새 화면도, 새 라우트도 없다.** 이 스펙은 기존 배선을 고친다.

## 1. 통합 — 무엇을 어디에 붙이는가

### 1.1 제거되는 것

| 대상 | 파일 | 사유 |
|---|---|---|
| 2단 채움 헬퍼 | `lib/common/pagination/origin_fill.dart` | `hasOrigin`이 사라져 전제가 소멸. 조정이 아니라 삭제(R-19) |
| 헬퍼 호출부 3곳 | `lib/domain/spot/provider/home_section_providers.dart:49`·`:87`, `lib/domain/event/provider/event_providers.dart:44` | 단일 호출로 대체 |
| 지도 이중 호출 | `lib/domain/map/view/map_screen.dart:345`·`:366` | `hasOrigin: true`/`false` 두 번 → 1회 |
| `hasOrigin` 인자 | `lib/domain/spot/repository/spot_repository.dart:45`·`:123`, `lib/domain/map/repository/map_repository.dart:31`, `lib/domain/event/repository/event_repository.dart:20` | 계약에서 삭제됨 |
| 오퍼레이션의 `$hasOrigin` | `spot_operations.graphql`(`Spots` L6, `PopularSpots` L253), `map_operations.graphql`(`MapViewport` L11), `event_operations.graphql`(`OngoingFestivals` L9) | 코드젠 재생성 필요 |
| 스와이프 2단 조회 | `swipe_providers.dart`의 `_fetchFirstPage`·`_maybePrefetch` | **표에 없었다** — 5.5절 |
| `SwipeQueue.originExhausted`·`nextHasOrigin` | `model/swipe_queue.dart` | 위가 사라져 죽은 값 — 5.5절 |
| `MapMarkerController.hasRoomIn` | `map_marker_controller.dart` | 지도 두 번째 흡수가 유일한 호출자 |

`origin_fill.dart`는 파일째 지운다. 남겨두면 다시 쓰인다.

**커밋된 SDL 3곳(`*_schema.graphql`)에서도 `hasOrigin`을 지운다** — 코드젠이 읽는 것은
이 파일이지 라이브 스냅샷이 아니다(CLAUDE.md §13).

### 1.2 수정되는 기존 파일

| 파일 | 변경 |
|---|---|
| `lib/common/localization/locale_controller.dart` | `select()`가 상태만 바꾸던 것에서, spot 관련 상태 무효화를 촉발하도록 확장(R-18·R-26) |
| `lib/common/network/graphql_client.dart:122` | `GraphQLCache` 키에 활성 언어 포함(AC-26.5) |
| `lib/domain/spot/provider/spot_detail_providers.dart:34` | `SpotCategoryCodes`에 비우기 연산 추가 |
| `lib/domain/spot/provider/spot_search_providers.dart:47` | 언어 변경 시 결과 리스트 무효화 |
| `lib/domain/map/provider/map_marker_controller.dart:23` | 언어 변경 시 누적 마커 비우기 |
| `lib/domain/spot/provider/retry_budget_providers.dart:19` | 언어 변경 시 예산 초기화 |
| `lib/domain/spot/repository/recent_searches_store.dart:40` | 저장 키에 언어 포함(R-21) |
| `lib/common/storage/draft_store_impl.dart` | 초안 복원 시 `spotId` 재검증 |
| `lib/domain/community/provider/post_composer_providers.dart:279-289` | 복원된 `spotId`가 해소되지 않으면 비움 |
| `lib/domain/spot/view/spot_detail_view.dart` | `SPOT_NOT_FOUND_IN_LOCALE` 분기(R-20) |
| `lib/domain/community/component/post_card.dart:293-319` | 해소 불가 spot 칩의 탭 차단(R-27) |
| `lib/domain/dm/component/message_quote_card.dart` | 같음 |

### 1.3 이 기능이 소유하지 않는 화면의 변경

두 곳을 건드리지만 이 기능의 화면은 아니다.

- **`preferences_screen.dart:110-120`** — 언어 선택이 무효화의 발화점이 된다. UI는 그대로고 `select()` 호출 이후의 파급만 바뀐다.
- **`post_composer_screen.dart:687-693`** — 복원된 초안의 spot 칩이 비워질 수 있다. 본문·사진은 보존된다(AC-26.2).

## 2. 언어 변경 시 무효화 — R-18 · R-26

### 2.1 왜 개별 구독으로는 부족한가

현재 방식은 각 프로바이더가 `ref.watch(localeControllerProvider)`를 선택적으로 다는 것이다. 다는 곳(`home_section_providers`·`event_providers`·`liked_spots_providers`·`swipe_providers`·`map_providers`)과 안 다는 곳(`spot_detail_providers`·`spot_search_providers`·`map_marker_controller`·`retry_budget_providers`·커뮤니티 전체·Q&A 전체)이 섞여 있다.

지금까지는 안 달아도 "낡은 제목이 보이는" 정도였다. **언어별 분리 이후에는 id 자체가 해소되지 않으므로 조용히 틀린 데이터이거나 오류 화면이 된다.** 선택적 구독으로는 빠진 곳이 계속 생긴다.

### 2.2 확산 지점을 하나로

기존에 유사한 메커니즘이 이미 있다 — spot이 사라졌을 때 `_dropFromSwipeSessions`(`spot_detail_providers.dart:130-140`)가 살아 있는 스와이프 세션에서 카드를 제거한다.

같은 모양을 쓰되 도달 범위를 넓힌다. 언어 변경 시 한 곳에서 무효화를 발화하고, 대상을 **명시적 목록**으로 관리한다(AC-18.4). 새 프로바이더가 생기면 목록에 추가하는 것이 규율이 된다 — 개별 프로바이더가 구독을 기억해야 하는 현재 방식보다 누락이 드러나기 쉽다.

무효화 대상: `SpotCategoryCodes`, `SpotSearch`, `MapMarkerController`, `MapViewport`,
`SpotRetryBudget`, 상세 컨트롤러 패밀리, 커뮤니티 피드·글 상세·장소 선택기, Q&A 프로바이더,
카테고리 선택 3종, GraphQL 캐시.

> **구현 중 수정(2026-08-21):** 여기서 홈·축제·좋아요·스와이프를 뺐다. 이미 locale을 watch
> 하고 있어 무효화하면 `CircularDependencyError`가 난다 — 5.5절.

### 2.3 저장소는 무효화가 아니라 분리

프로바이더는 비우면 되지만 저장소는 다르다.

- **최근 검색어**(`recent_searches`) — 언어별 키로 분리한다(R-21). 비우면 EN으로 돌아왔을 때 이력이 사라진다.
- **초안**(`community_post_draft`) — 비우면 안 된다. 사용자가 쓴 글이다. **복원 시 `spotId`만 재검증**하고, 해소되지 않으면 `spotId`를 비운 채 본문·사진을 복원한다(AC-26.2). `stored_draft.dart:93-97`이 카테고리 코드에 대해 이미 같은 패턴을 쓴다 — 그것을 `spotId`로 확장한다.
- **Q&A 열람 카운트**(`spot_qa_seen_answer_counts`) — 질문 id 기준이라 spot id를 담지 않는다. 손대지 않는다.
- **DM 메시지 캐시** — `spotQaOrigin`을 의도적으로 캐시하지 않는다(`message_cache_store.dart:102-110`). 안전하다. **인코딩 형식을 바꾸지 않는다.**

## 3. 교차 언어 spot id 차단 — R-27

### 3.1 잠복 구멍 2건

배선만 안 됐을 뿐 준비되어 있고, 두 모델의 주석이 "이 id는 `/spot/:id`에 그냥 넘겨도 안전하다"고 **약속**하고 있다.

- `post_card.dart:46`·`:309` — `onSpotTap`이 선언·전달되나 호출부가 없다
- `message_quote_card.dart:29` — `origin.catalogId`를 읽으나 `build()`에서 쓰지 않는다

**주석을 철회한다**(AC-27.3): `lib/common/model/post_spot.dart:8`, `lib/common/model/spot_qa_origin.dart:14-15`. 특히 후자는 "카탈로그 id는 예외적으로 항상 유효하다(장소는 삭제되지 않는다)"고 적혀 있는데, 이 스펙 이후 거짓이다.

**서버 스키마에도 같은 문구가 4곳 있고, 서버가 함께 철회한다**(AC-27.4) — `ConversationSpotQaOrigin.catalogId`·`LikedSpot.id`·`SpotSuggestion.id`·`Festival.id`. 첫 번째가 `spot_qa_origin.dart`가 철회하는 바로 그 주장의 원본이다. 이 레포만 고치면 두 문서가 어긋난 채 남는다.

주석만 고치고 넘어가면 다음 사람이 선의로 배선한다. 두 위젯이 **해소 여부를 알 수 있어야** 한다.

### 3.2 두 경로는 결론이 다르다

해소 여부를 판정하는 방법이 경로마다 다르고, **결론도 반대다.** 하나로 뭉뚱그리면 안 된다.

#### 경로 A — 목록에서 온 참조: 서버를 믿는다

`PostSpot`이 활성 언어에서 해소되지 않으면 **서버가 그 글을 목록에 넣지 않는다**(R-23). 따라서 목록으로 받은 글의 `spot`은 항상 해소된 상태다.

클라이언트가 별도로 판정할 필요가 없다. **탭 배선을 해도 된다** — 단, 서버가 걸러 준다는 전제 위에서다. 이 전제가 깨지면(서버 필터 누락) 상세 진입 후 R-20 안내로 떨어진다.

해당 대상: `post_card.dart`의 spot 칩, `spot_questions_screen.dart`·`my_questions_screen.dart`의 spot 참조.

#### 경로 B — 스냅샷에서 온 참조: 믿을 수 없다

DM 인용의 `spotQaOrigin`은 **작성 시점의 스냅샷이고 목록 필터를 거치지 않는다.** 작성자의 언어에서 해소되던 값이 수신자의 언어에서는 해소되지 않을 수 있고, 시간이 지나 작성자 본인의 언어에서도 그럴 수 있다. `spotTitle`도 갱신되지 않는 스냅샷이다.

**탭을 열지 않는다**(AC-27.2). 현재도 열려 있지 않으므로 유지가 곧 준수다. `message_quote_card.dart:29`가 `origin.catalogId`를 읽고도 쓰지 않는 현재 상태가 정답이며, 이것이 미완성이 아니라 **의도된 것**임을 주석에 남긴다.

해당 대상: `message_quote_card.dart`.

| 경로 | 출처 | 서버 필터 | 탭 |
|---|---|---|---|
| A | 목록 응답 | 거침 | 허용 |
| B | 작성 시점 스냅샷 | 안 거침 | **금지** |

## 4. 오류 처리 — R-20

`spot_detail_view.dart`가 두 코드를 구분한다(AC-20.3).

| 코드 | 의미 | 안내 |
|---|---|---|
| `SPOT_NOT_FOUND` | 장소 자체가 없음 | 기존 안내 유지 |
| `SPOT_NOT_FOUND_IN_LOCALE` | 이 언어에서 볼 수 없음 | 전용 안내 후 홈 복귀 |

두 번째가 우회 진입의 마지막 방어선이다. 정상 경로에서는 도달하지 않는다.

`SpotFailure`(`lib/domain/spot/model/spot_failure.dart`)에 판별 수단을 추가한다. `isSpotMissing`이 이미 있으므로 같은 결을 따른다.

**연쇄 하나**: `_dropFromSwipeSessions`가 `isSpotMissing`으로 발화한다. 새 코드도 카드를 큐에서 빼야 한다 — 안 그러면 같은 카드가 계속 돌아온다.

## 5. 테스트가 붙는 단위

프로바이더/노티파이어와 도메인 모델 로직만이다. 위젯·통합 테스트는 범위 밖이다.

| 단위 | 검증 대상 | 요구사항 |
|---|---|---|
| 언어 변경 무효화 | 대상 목록의 상태가 비워지거나 재조회됨 | R-18 · R-26 |
| `SpotCategoryCodes` | 언어 변경 시 비워짐 | R-26 |
| `MapMarkerController` | 언어 변경 시 누적 마커가 비워짐 | AC-26.3 |
| `SpotRetryBudget` | 언어 변경 시 예산 초기화 | AC-26.4 |
| 초안 복원 로직 | 해소 불가 `spotId`는 비우고 본문·사진 보존 | AC-26.2 |
| 최근 검색어 저장소 | 언어별 키 분리, 언어 간 격리 | R-21 |
| 홈·축제 섹션 프로바이더 | 조회 1회 | AC-19.1 |
| 지도 뷰포트 프로바이더 | 조회 1회 | AC-19.2 |
| `SpotDetailController` | 두 오류 코드의 구분 처리 | R-20 |
| `SpotFailure` | 새 코드의 판별 | R-20 |

`origin_fill.dart`의 테스트는 파일과 함께 삭제한다.

**단위 테스트로 증명하지 않는 것**: `GraphQLCache` 키에 언어가 실제로 반영되는지는 `graphql_flutter` 내부 동작이라 라이브러리 책임이다(AC-26.5는 캐시 항목 분리라는 관찰 가능한 결과로 쓰였다). 화면 전환·라우팅 동작도 위젯 테스트 영역이라 범위 밖이다.

## 5.5 구현하며 갈린 결정 (2026-08-21)

설계와 다르게 간 곳과 그 이유다. 코드만 고치고 이 문서를 두면 다음 사람이 문서를 믿는다(§10).

### 설계가 빠뜨린 대상 3곳

`hasOrigin` 제거 범위가 1.1의 표보다 넓었다.

- **`swipe_providers.dart`** — 첫 조회가 원문/번역 2단이었고(`_fetchFirstPage`), 선제 조회도
  `queue.nextHasOrigin`으로 구간을 갈랐다. 둘 다 단일 조회로 접었다.
- **`SwipeQueue.originExhausted`·`nextHasOrigin`**(`model/swipe_queue.dart`) — 위가 사라지며
  죽은 값이 됐다. 필드를 지우고 `nextPage`·`isExhausted`를 한 줄 규칙으로 되돌렸다 —
  "마지막 페이지 뒤 0으로 되감기"라는 전환점이 없어졌다.
- **`MapMarkerController.hasRoomIn`** — 지도의 두 번째 흡수만이 호출자였다. 함께 지웠다.

### 무효화: "구독하지 않는 나머지"만 맡는다 (설계 §2.2 수정)

설계는 무효화 대상에 홈·축제·좋아요·스와이프를 넣었으나 **그렇게 하면 터진다.** 이미
`localeControllerProvider`를 watch 하는 provider를 다시 무효화하면 그 재빌드 도중 자기를
무효화하는 꼴이라 Riverpod이 `CircularDependencyError`를 던진다(실제로 났다).

그래서 `invalidateLocaleScopedState`는 **구독하지 않는 것만** 맡는다. 스스로 다시 빌드되는
쪽: `nearbySpotsSection`·`popularSpotsSection`·`happeningNowEvents`·`availableSpotCategories`·
`likedSpotsController`·`SwipeController`. 새 provider는 **둘 중 하나만** 고른다.

`mapViewport`는 구독하지 않으므로 무효화 대상이다(`currentCongestionBoundaries`와 혼동하기 쉽다).

### GraphQL 캐시는 있을 때만 만진다

`ref.read(graphqlClientProvider)`로 비우면 언어 변경이 클라이언트와 `SecureStorage`를
**생성**시킨다 — 아직 아무 쿼리도 나가지 않은 첫 실행의 언어 선택 화면에서도 그렇다.
`ref.exists`로 감쌌다. 없는 캐시에는 비울 것도 없다.

### 초안: 저장 시점의 언어를 함께 남긴다 (AC-26.2 구현 방법)

`spotId`가 지금 언어에서 해소되는지는 **클라이언트가 판정할 수 없다** — 서버만 아는 사실이다.
그래서 `StoredDraft.languageCode`를 새로 두고, 복원할 때 저장 당시와 언어가 다르면
`spotId`·`spotTitle`을 비운다(`restoredSpotId`/`restoredSpotTitle`). 본문·사진·제목은 그대로다.

SPEC-0029 이전 초안은 `languageCode`가 null이고, **그때도 장소를 비운다** — 어느 언어에서
저장했는지 알 수 없으므로 안전한 쪽으로 판단한다.

언어 코드는 `build()`에서 미리 읽어 둔다. `_writeNow`가 dispose 콜백에서도 불리는데 그
안에서는 `ref.read`가 금지돼 있다(`_storeRef`가 이미 같은 이유로 그렇게 한다).

### 안내 문구를 가르는 판정은 따로 둔다

`SpotFailure`에 판별을 둘 추가했다. 둘을 하나로 합치면 안 된다.

| 판정 | 쓰임 | 두 코드 |
|---|---|---|
| `isSpotMissing` | 스와이프 큐에서 카드 걷어내기 | **둘 다 참** — 어느 쪽이든 지금 안 열리므로 남기면 계속 돌아온다 |
| `isSpotMissingInLocale` | 사용자 안내 가르기(R-20) | `SPOT_NOT_FOUND_IN_LOCALE`만 참 |

상세 화면은 후자일 때 재시도 대신 **홈 복귀** 버튼을 준다 — 같은 언어로 다시 물어도 결과가
같으므로 재시도가 무의미하다. 기존 `spotDetailNotFoundBody`가 "삭제되었거나 현재 언어에서
제공되지 않을 수 있어요"로 두 경우를 뭉뚱그리고 있어 **4개 언어 모두 좁혔다.**
컴포저의 `userErrors` 분기에도 전용 문구를 넣었다.

### 최근 검색어는 provider가 아니라 저장소를 가른다

`recentSearchesStore`가 활성 언어를 watch 해 `recent_searches_<lang>` 키로 붙는다.
`RecentSearches.build()`도 저장소를 **watch** 해야 한다 — keepAlive라 read로 두면 언어를
바꿔도 이전 목록을 들고 있다. 예전 언어 무관 키(`recent_searches`)는 읽지 않는다: 그때 결과는
번역본이 섞인 다른 축의 목록이라 지금 언어의 이력이라 주장할 근거가 없다.

### 확인한 것과 확인하지 못한 것

- **라이브 서버로 확인**: `hasOrigin`은 실제로 삭제됐다(`spots`에 보내면
  `UnknownArgument`). 오퍼레이션 전량 sweep 검증 오류 0건. `Post.spot`은 nullable,
  `SpotQuestion.spot`은 non-null(introspection 직접 확인) — 7절 표와 일치한다.
- **확인하지 못함**: 서버가 재적재 배치를 아직 돌리지 않아 **모든 spot 조회가 빈 결과다.**
  따라서 "언어별로 다른 목록이 온다"·"좋아요가 언어별로 갈린다"는 **실데이터로 보지 못했다.**
  계약 형태만 확인했고 동작은 배치 이후 재확인이 필요하다.
- `popularSpots` 최소 좋아요 5는 서버 값이라 클라이언트가 알 수 없다 — 문서의 "10개 미만"
  주석만 걷어내고 숫자를 박지 않았다.

## 6. 선행 조건

**서버 슬라이스 S3과 동시 배포한다.** 순차가 아니다.

- S3 이전에 클라이언트를 배포하면: `hasOrigin`을 안 보내는데 서버가 아직 폴백을 해서 번역본이 섞여 나온다.
- S3 이후에 클라이언트를 배포하면: 삭제된 `hasOrigin` 인자를 보내 조회가 실패한다.

좋아요 목록·글 목록의 언어 한정 확인은 S4 이후다. S5(로컬 저장소 분리·무효화)는 S3과 함께 나가야 한다 — 언어 전환 시 낡은 id가 남는 문제가 S3 시점부터 발생한다.
