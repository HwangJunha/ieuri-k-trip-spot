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
- `flutter test` — 1170개 전부 통과

기존 테스트가 깨진 곳은 고쳤다(CLAUDE.md §8의 "내가 깨뜨린 것 치우기"). 그중
`sentVariables['spotId']`를 보던 repository 테스트는 **전송 변수 이름을 직접 검사하던
것**이라, `catalogId`로 고치지 않으면 통과해도 의미가 없는 검사가 됐다.

## 7. 배포

**서버는 이전 `spotId` 인자를 받지 않는다.** 이 클라이언트도 `catalogId`만 보내므로
**동시 배포가 필요하다** — 서버가 먼저 나가면 구버전 앱의 글쓰기·좋아요·장소별 피드가
전부 깨진다.

## 참고

- 서버 PR: https://github.com/HwangJunha/ieuri/pull/76
