# SPEC-0019 클라이언트 — 장소 식별자가 언어 무관해진다

서버가 TourAPI의 언어별 행을 한 장소로 묶었다. 이전에는 같은 장소가 언어마다 다른
id였고, 일본어로 누른 좋아요가 영어로 바꾸면 사라졌다. 이제 `Spot.id`는 언어를 바꿔도
변하지 않는다.

이 문서는 서버 변경(ieuri PR #76)에 대응하는 **클라이언트 쪽 작업**을 기록한다.

## 1. 인자 이름 변경 (Breaking)

`spotId` → `catalogId`. 라이브 introspection으로 다섯 자리를 모두 확인했다.

| 위치 | 확인된 형태 |
|---|---|
| `Query.posts` | `catalogId: ID` |
| `CreatePostInput` | `catalogId: ID` |
| `EditPostInput` | `catalogId: ID` |
| `CreateFeedItemInput` | `catalogId: ID!` |
| `ReactToSpotInput` | `catalogId: ID!` |

**서버 요청서와 다른 점:** 요청서는 `Mutation.updatePost`라고 적었지만 이 앱이 쓰는
연산은 `editPost`이고 입력 타입은 `EditPostInput`이다. 이름만 다르고 변경 내용은 같다.

**바뀌지 않은 것:** `Query.spotDetail(id:)`은 인자 이름이 그대로 `id`다. 값의 의미만
언어 무관 식별자로 바뀌었다. `Spot.id`·`PostSpot.id`·`SpotDetail.id`도 필드 이름은
그대로이며, 서로 호환되므로 `Spot.id`를 `posts(catalogId:)`나
`reactToSpot(catalogId:)`에 그대로 넘긴다.

### 어디까지 이름을 바꿨나

**전송 이름을 따라가는 것만 바꿨다** — SDL, `.graphql` 연산, 그리고 그 값을 서버까지
나르는 repository·provider 인자다.

**바꾸지 않은 것:** `PostDraft.spotId`, 스와이프 큐의 지역 변수, `/post-composer`의
`spotId` 쿼리 파라미터. 이들은 앱 안에서만 도는 이름이라 전송 규약과 무관하다. 함께
바꾸면 이 스펙과 상관없는 변경이 섞인다.

## 2. 저장된 id 캐시 — 무효화할 것이 없다

서버 요청서는 "id 캐시를 비우는 마이그레이션이 필요하다"고 했다. **이 앱에는 해당하는
저장소가 없다.** 확인한 것:

| 저장소 | 무엇이 들어 있나 | 판정 |
|---|---|---|
| `AppPreferences` | `locale`, `search_radius_km` | id 없음 |
| `RecentSearchesStore` | 검색 **문자열** | id 없음 |
| `MessageCacheStore` | DM 메시지, `conversationId`로 키 | 장소 id 아님 |

즐겨찾기·최근 본 장소는 서버가 들고 있고 매번 조회한다. 딥링크는 `/spot/:id`로 그때
받은 id를 쓴다. **따라서 마이그레이션 코드를 넣지 않았다** — 지울 것이 없는데 코드를
넣으면 다음 사람이 있지도 않은 캐시를 찾게 된다.

## 3-A. 별건: 홈·좋아요가 언어를 바꿔도 한국어로 남던 버그

사용자가 "영어로 들어갔는데 왜 한국어 데이터가 나오는가"를 지적해 확인했다.
**SPEC-0019와 무관한 기존 결함이다.** `catalogId` 교체가 만든 것이 아니다.

### 원인

`Accept-Language` 헤더는 정상이다(링크 체인 end-to-end로 확인했고, 라이브 서버도
`en`/`ko`에 각각 영어·한국어 제목을 정확히 돌려준다 — **id는 양쪽 동일**해 SPEC-0019
서버 작업도 의도대로 동작한다).

문제는 **쿼리가 다시 나가지 않는 것**이었다. 홈·좋아요 탭은
`StatefulShellRoute.indexedStack`의 브랜치라 설정 화면에 가 있어도 계속 mount된다.
구독이 끊기지 않으니 `autoDispose`가 돌지 않고, 좌표·반경도 그대로라 provider를 다시
부를 계기가 하나도 없다. 화면에 남아 있던 것은 **한국어 세션에서 받은 응답 본문**이다.

Discover(스와이프)만 `ref.watch(localeControllerProvider)`가 있어 정상 동작했다 —
그래서 화면마다 증상이 갈렸다.

### 고친 것

네 provider에 `ref.watch(localeControllerProvider)`를 넣었다(값은 쓰지 않고 재빌드
트리거로만 구독 — swipe_providers와 같은 규약):

| provider | 화면 |
|---|---|
| `nearbySpotsSection` | 홈 Near you |
| `popularSpotsSection` | 홈 Popular |
| `happeningNowEvents` | 홈 Happening Now |
| `likedSpotsController` | 좋아요 탭 |

**넣지 않은 곳:** 상세(`spotDetail`)는 라우트 push라 pop하면 사라지고, 검색은 질의별
family라 자연히 다시 조회된다. 커뮤니티 글은 사용자가 쓴 글이라 서버 번역 대상이 아니다.

회귀 테스트 두 개를 추가했고, **fix를 되돌리면 실제로 실패하는 것까지 확인했다**
(`git stash`로 검증). CLAUDE.md §8이 경고한 대로 locale watch가 기존 테스트에
`sharedPreferencesProvider` 오버라이드를 요구해서, 깨진 `liked_spots_controller_test`도
함께 고쳤다.

## 3-B. 별건: `searchSpots`가 category 인자를 무시한다 (서버 결함)

사용자가 "'올리브'로 검색하면 관광지·문화시설·축제행사 탭에도 결과가 나온다"고
지적해 확인했다. **클라이언트는 정상이고, 서버가 인자를 무시한다.**

### 클라이언트는 제대로 보낸다

전송 변수를 직접 찍어 확인했다:

```
{query: 올리브, latitude: 37.5665, longitude: 126.978, radiusMeters: 20000,
 category: TOURIST_SPOT, page: 0, size: 5}
```

`.graphql` 연산·repository·provider 모두 `category`를 싣고 있다.

### 서버가 무시한다

라이브 서버(localhost:8888)에 같은 질의를 카테고리만 바꿔 넣어보면 **네 번 모두
같은 결과**가 온다:

| 요청 | 결과 |
|---|---|
| `searchSpots("올리브")` | SHOPPING 5건 |
| `searchSpots("올리브", TOURIST_SPOT)` | **똑같은 SHOPPING 5건** |
| `searchSpots("올리브", CULTURAL_FACILITY)` | **똑같은 SHOPPING 5건** |
| `searchSpots("올리브", FESTIVAL_EVENT)` | **똑같은 SHOPPING 5건** |

"해당 카테고리에 결과가 없어서 폴백한 것"도 아니다. 여러 카테고리에 결과가 있는
질의(`"서울"`)로도 확인했는데, `TOURIST_SPOT`을 줘도 CULTURAL_FACILITY·LODGING·
FESTIVAL_EVENT가 섞인 **동일한 목록**이 온다.

**같은 서버의 `spots` 쿼리는 정상 필터링된다** — `category: TOURIST_SPOT`이면
TOURIST_SPOT만, `SHOPPING`이면 SHOPPING만 온다. 즉 스키마에는 두 쿼리 모두
`category` 인자가 선언돼 있는데(introspection 확인) **`searchSpots`의 구현만 그것을
where 절에 넣지 않고 있다.**

### 클라이언트 조치

**결과를 클라이언트에서 거르지 않는다.** POL-019가 정렬·필터를 서버 계약으로 두고
있어, 여기서 거르면 페이지 크기와 `hasNext`가 서버가 센 것과 어긋나 페이징이 깨진다
(5건 받아 3건을 버리면 "다음 페이지 있음"인데 화면엔 3건만 남는다).

대신 **클라이언트가 인자를 제대로 싣는다는 것을 테스트로 고정했다** — 서버가 고쳐질
때 클라이언트를 의심하지 않도록. 서버 수정이 곧 화면 수정이다.

**서버에 전달 필요:** `searchSpots`의 `category` 인자가 조회 조건에 반영되지 않음.
`spots`와 같은 방식으로 걸면 된다.

## 3-C. 별건: 축제 상세가 일본어에서 SPOT_NOT_FOUND (서버 결함)

### 축제 id는 catalogId가 맞다

`ongoingFestivals`는 **id를 인자로 받지 않는다**(좌표·반경·페이징만 받는다).
`node.id`로 내려주는 값을 그대로 쓰며, 그 값은 `Spot.id`와 같은 성격의 언어 무관
식별자다 — SPEC-0019 요청서가 말한 "필드 이름은 그대로, 값의 성격만 바뀐다"에
해당한다. **클라이언트가 축제 id로 따로 보낼 인자는 없다.**

실제로 언어를 바꿔 조회하면 **id가 동일**하다(197493·211957·197210·215150·197273).
제목만 번역되어 온다. 이 부분은 서버 작업이 의도대로 됐다.

### 목록은 일본어로 잘 온다 — 상세가 거부한다

`ongoingFestivals`를 `Accept-Language: ja`로 부르면 **일본어 제목 10건이 정상**으로
온다(`文化が流れるソウル広場` 등). 날짜도 한국어와 동일하고 non-null 계약을 어기는
필드도 없다. **즉 홈 목록 자체는 일본어에서 비어 있지 않아야 한다.**

문제는 그 다음이다. 목록이 준 id를 `spotDetail`에 넣으면 일본어에서만 거부된다:

| id | 목록(ja) | spotDetail(ko) | spotDetail(ja) |
|---|---|---|---|
| 197493 | 있음 | OK | **NOT_FOUND** |
| 211957 | 있음 | OK | OK |
| 197210 | 있음 | OK | **NOT_FOUND** |
| 215150 | 있음 | OK | **NOT_FOUND** |
| 197273 | 있음 | OK | **NOT_FOUND** |

5건 중 4건이 일본어 상세에서 `SpotDetailNotFoundException`이다.

**이것은 SPEC-0019 요청서가 말한 "정상 동작"이 아니다.** 요청서는 "목록에서 온 id는
그 언어에 존재하므로 이 문제를 만나지 않는다"고 명시했다. 그런데 197493은 일본어
`ongoingFestivals`에도, 일본어 `spots(category: FESTIVAL_EVENT)`에도 있는데
`spotDetail`만 없다고 한다 — **같은 서버 안에서 목록과 상세의 판정이 어긋난다.**

### 클라이언트 조치

없다. 목록은 정상적으로 받고 있고, 상세 실패는 이미 `SpotFailureKind.notFound`로
접혀 전용 오류 화면이 그려진다(3-A에서 확인). 클라이언트가 지어낼 수 있는 것이 없다.

**서버에 전달 필요:** `spotDetail`의 언어 해소가 `ongoingFestivals`·`spots`와 다르다.
목록이 그 언어에 존재한다고 준 id를 상세가 거부하면 사용자는 목록에서 누르는 족족
오류를 본다.

## 3. 언어 전환 — 재조회는 유지한다

`swipeControllerProvider`가 `localeControllerProvider`를 watch 해 언어가 바뀌면 세션을
다시 만든다. **이 동작은 그대로 둔다. 이유만 바뀐다.**

- 이전 이유: 카드의 id가 이전 언어의 것이라 상세·반응이 `SPOT_NOT_FOUND`로 거부된다
- 지금 이유: id는 이제 통하지만, **카드에 박힌 제목·주소가 이전 언어의 문장**이다

id 때문에 다시 받을 필요는 없어졌으나 화면 글자 때문에 여전히 다시 받아야 한다.
주석을 고쳐 다음 사람이 "이제 필요 없다"고 지우지 않게 했다(SPEC-0007 R-14).

## 4. `SPOT_NOT_FOUND` — 딥링크 경로 확인함

외국어에만 존재하는 장소가 4,196개 있어, 한국어로 그 id의 상세를 열면
`SPOT_NOT_FOUND`가 난다. **정상 동작이다.**

목록에서 온 id는 그 언어에 존재하므로 이 문제를 만나지 않는다. 문제는 딥링크·공유
링크다. 확인 결과 **이미 처리돼 있다**:

- 라우트 `/spot/:id`는 목록에서 온 진입과 **같은** `SpotDetailView`·같은 provider를 탄다
- `SpotFailure`가 `SPOT_NOT_FOUND`를 `SpotFailureKind.notFound`로 접는다
- `_ErrorState`가 `notFound`에 전용 문구를 그린다

경로가 갈라지지 않아 딥링크만 빠지는 구멍이 없다. 코드 변경 없음.

## 5. 좋아요 개수 증가 — 영향받는 UI 없음

좋아요가 언어별 합산이라 이전보다 커진다. 개수를 **기준선과 비교하는** UI(예: 인기
뱃지)가 있으면 임계값을 조정해야 하는데, 이 앱은 `likeCount`를 숫자로 표시만 하고
어떤 임계값과도 비교하지 않는다. 조정할 상수가 없다.

## 6. 검증

- `dart run build_runner build` — 연산이 갱신된 SDL에 대해 통과(codegen이 검증한다)
- `flutter analyze` — 이슈 없음
- `flutter test` — 1172개 전부 통과(언어 전환 회귀 테스트 2개 추가)
- `reactToSpot`의 전송 JSON을 직접 찍어 확인했다:
  `{input: {catalogId: "C123", reaction: LIKE}}` — 입력 객체라 grep에 안 잡혀 따로 봤다

기존 테스트가 깨진 곳은 고쳤다(CLAUDE.md §8의 "내가 깨뜨린 것 치우기"). 그중
`sentVariables['spotId']`를 보던 repository 테스트는 **전송 변수 이름을 직접 검사하던
것**이라, `catalogId`로 고치지 않으면 통과해도 의미가 없는 검사가 됐다.

## 7. 배포

**서버는 이전 `spotId` 인자를 받지 않는다.** 이 클라이언트도 `catalogId`만 보내므로
**동시 배포가 필요하다** — 서버가 먼저 나가면 구버전 앱의 글쓰기·좋아요·장소별 피드가
전부 깨진다.

## 참고

- 서버 PR: https://github.com/HwangJunha/ieuri/pull/76
