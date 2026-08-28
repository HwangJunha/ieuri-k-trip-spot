> spec: SPEC-0033 · source: `Specs/SPEC-0033/spec.md` (Obsidian) · status: approved

# SPEC-0033 — 좋아요 목록 내 검색 (클라이언트 설계)

요구사항·수용 기준·계약 전문은 스펙 문서에 있습니다. 이 문서는 이 저장소에 한정된 설계 판단만 담습니다.

## 어디에 붙는가

`lib/domain/spot/view/liked_spots_screen.dart`의 `LikedSpotsScreen` 안, **카테고리 칩 바(`SpotCategoryBar`) 위**에 검색 입력을 둡니다.

**새 화면도, 새 라우트도, 새 진입점도 만들지 않습니다.** 진입 경로는 기존 그대로입니다 — 보관함 탭(`library`, SPEC-0030) → 상단 토글의 "좋아요" 쪽 → `LikedSpotsScreen`. 이 화면은 `LibraryScreen`이 `IndexedStack`으로 품고 있고 `showAppBar: false`로 임베드되므로, 검색 입력은 앱바가 아니라 **본문 상단**에 놓여야 합니다. 앱바에 넣으면 보관함 셸의 토글과 충돌합니다.

## `SearchScreen`을 재사용하지 않는 이유

`lib/domain/spot/view/search_screen.dart`가 이미 있지만 재사용하지 않습니다. 그 화면은 전체 코퍼스 대상 `searchSpots`를 위한 것이고, 이 기능과 규약이 셋 다 다릅니다.

| | `SearchScreen` (`searchSpots`) | 이 기능 (`likedSpots`) |
|---|---|---|
| 정렬 | 관련도 | `likedAt DESC` 고정 |
| 페이지네이션 | offset (`page`/`size`) | 커서 (`first`/`after`) |
| 오류 | `userErrors[]` | 최상위 `errors[]` |

상태와 화면은 공유하지 않습니다. 다만 입력 위젯의 **시각적 일관성은 맞춥니다** — 사용자에게 두 검색이 다른 물건으로 보일 이유는 없습니다. `SearchScreen`의 `TextField` 구성을 참고하되, 최근 검색어 패널(`_RecentPanel`)과 자동완성은 가져오지 않습니다(스펙 §3 비범위).

## 핵심 배선 — 프로바이더 패밀리 키

**이 작업에서 유일하게 틀리기 쉬운 지점입니다.**

`likedSpotsControllerProvider`는 `build(SpotCategorySelection selection)`로 선언된 **패밀리**입니다(`lib/domain/spot/provider/liked_spots_providers.dart:115`). 화면은 `ref.watch(likedSpotsControllerProvider(selection))`으로 구독하고, 키가 바뀌면 새 인스턴스가 만들어지면서 재조회가 일어납니다.

검색어가 이 키에 들어가지 않으면 **검색어를 바꿔도 재조회가 일어나지 않습니다.** 키를 검색어까지 포함하도록 확장하는 것이 이 작업의 본체입니다.

키 확장 방식(`SpotCategorySelection`을 감싸는 새 인자 타입을 만들지, 파라미터를 하나 더 받을지)은 이 저장소의 판단입니다. 어느 쪽이든 지켜야 할 것:

- **값 동등성이 성립해야 합니다.** 패밀리 키는 `==`/`hashCode`로 캐시를 가릅니다. 동등성이 깨지면 리빌드마다 새 인스턴스가 생겨 매 프레임 재조회가 일어납니다.
- `loadMore()`(139~145행 부근)가 다음 페이지를 요청할 때 **검색어를 함께 실어야 합니다.** 첫 페이지만 필터되고 다음 페이지가 필터되지 않는 것이 이 배선에서 가장 나오기 쉬운 버그입니다.
- 카테고리 선택과 검색어는 **함께** 적용됩니다(AND). 한쪽을 바꿀 때 다른 쪽이 초기화되면 안 됩니다.

`selectedLikedCategoryProvider`가 카테고리 선택을 들고 있는 것처럼, 검색어도 화면 상태가 아니라 프로바이더로 들고 가는 편이 `loadMore`·재시도·`invalidate` 경로에서 일관됩니다.

## 입력 처리

- **입력이 멎은 뒤 조회합니다.** 타자 한 글자마다 요청을 던지지 않습니다. 대기 시간은 이 저장소가 정합니다.
- **입력 단계에서 100자 상한과 앞뒤 공백 트림을 적용합니다.** `EMPTY_QUERY`·`QUERY_TOO_LONG`은 방어선이지 정상 경로가 아닙니다 — 입력에서 막으면 서버까지 가지 않습니다.
- 검색어가 비면 `query` 인자를 **보내지 않습니다**(AC8.2). 빈 문자열을 보내면 `EMPTY_QUERY`가 됩니다. 계약에서 "생략 = 필터 없음"과 "빈 문자열 = 오류"가 다릅니다.
- 검색어를 지우는 수단(clear 버튼 등)을 둡니다. 결과 없음 상태에서 특히 필요합니다.
- 탭을 떠나면 검색어를 버립니다 — 다음 진입은 빈 입력으로 시작합니다. 상세로 갔다 돌아오는 것은 이탈이 아니므로 검색어와 스크롤 위치를 유지합니다.

## 두 개의 빈 상태를 구분한다

`_LikedList`의 빈 상태가 지금은 하나지만 이제 둘입니다. 사용자가 할 일이 다르므로 문구도 달라야 합니다.

| 상태 | 문구의 방향 |
|---|---|
| 좋아요 0건 | 기존 문구 유지 — "장소를 좋아요해 보세요" |
| 좋아요 있음 + 검색 결과 0건 | "결과 없음" — 검색어를 지우거나 바꾸도록 |

**좋아요가 0건이면 검색어가 입력돼 있어도 좋아요 0건 상태가 우선합니다**(AC8.4). 저장한 게 하나도 없는 사람에게 "검색 결과가 없습니다"는 할 일을 알려주지 못합니다.

문구는 EN/KO/JA/ZH 네 언어 모두 필요합니다(POL-022). UI는 영어 우선입니다.

## 오류 처리

`EMPTY_QUERY`·`QUERY_TOO_LONG`은 **최상위 `errors[]`로 옵니다.** `searchSpots`와 코드 이름이 같지만 `likedSpots`에는 payload 래퍼가 없어서 통로가 다릅니다 — `SearchScreen`의 `userErrors[]` 분기를 그대로 가져다 쓸 수 없습니다.

정상 경로에서는 입력 검증이 막으므로 이 둘이 실제로 올 일은 없어야 합니다. 오면 기존 `_ErrorBody` 경로로 흘려보내면 충분합니다 — 코드별 전용 문구를 만들 필요는 없습니다.

`UNAUTHENTICATED`는 SPEC-0032가 정한 기존 처리를 그대로 따릅니다. 이 스펙이 새로 정의하지 않습니다.

조회 실패 후 재시도는 **검색어를 유지한 채** 같은 질의를 다시 던집니다. 기존 `ref.invalidate(likedSpotsControllerProvider(selection))` 경로가 확장된 키를 쓰도록만 맞추면 됩니다.

## 계약과 생성 타입

설계 시점의 제안은 아래였습니다.

```graphql
likedSpots(categories: [String!], query: String, first: Int = 20, after: String): LikedSpotConnection!
```

**서버가 낸 실물은 다릅니다**(라이브 확인 2026-08-29). `likedSpots`는 그대로 두고 검색용 쿼리를 따로 냈으며, `query`가 **non-null 필수**입니다.

```graphql
likedSpots(categories: [String!], first: Int, after: String): LikedSpotConnection!
searchLikedSpots(query: String!, categories: [String!], first: Int, after: String): LikedSpotConnection!
```

이 차이가 구현에 주는 영향은 아래 "구현하며 정한 것 §두 쿼리로 갈라진다"에 적었습니다.

응답 타입은 바뀌지 않습니다 — `LikedSpot`·`LikedSpotEdge`·`LikedSpotConnection` 그대로이고 두 쿼리가 같은 것을 돌려줍니다.

`graphql_codegen` 생성 타입은 **repository 계층을 넘지 않습니다**(POL-020). repository가 도메인 모델로 변환합니다 — 기존 좋아요 목록 repository의 변환 경로를 그대로 씁니다.

화면당 1회 왕복입니다. 초기 목록과 검색 결과가 같은 필드이므로 검색을 켜도 왕복이 늘지 않습니다.

## 테스트가 붙는 단위

provider·도메인 모델 로직의 단위 테스트만 작성합니다. 위젯 테스트·통합 테스트는 범위 밖입니다.

| 단위 | 검증 대상 |
|---|---|
| 좋아요 목록 컨트롤러(provider) | 검색어 변경 시 재조회 트리거(AC8.1), 빈 검색어일 때 `query` 미포함(AC8.2), `loadMore`가 검색어를 유지하는지 |
| 패밀리 키 타입 | 값 동등성 — 같은 값이면 같은 키, 다른 값이면 다른 키 |
| 빈 상태 판정 로직 | 결과 없음과 좋아요 0건의 구분, 좋아요 0건 우선(AC8.3~8.4) |

빈 상태 판정을 위젯 `build` 안에 인라인으로 두면 단위 테스트로 검증할 수 없습니다. 상태 판정이 테스트 가능한 위치에 있도록 두세요.

## 선행

**서버(#121)가 먼저 나갑니다.** `query` 인자가 선택적이라 서버 배포가 기존 클라이언트를 깨지 않으며, 배포 후에는 실제로 필터링되는 필드에 대고 배선할 수 있습니다. 이 슬라이스가 끝나면 기능이 사용자에게 도달합니다.

## 구현하며 정한 것 (2026-08-28)

이 절은 위 설계가 저장소 판단에 맡긴 자리에서 실제로 고른 값과, 구현 중에 드러난 것을 적는다.

### 패밀리 키 — `LikedSpotsQuery`

`SpotCategorySelection`을 감싸는 새 값 객체를 만들었다(`model/liked_spots_query.dart`). 파라미터를
하나 더 받는 쪽이 아니라 이쪽을 고른 이유는 동등성을 **한 곳에서** 정의할 수 있어서다 —
Riverpod family는 인자 전체의 `==`/`hashCode`로 캐시를 가르므로, 값이 둘로 흩어지면 동등성이
깨지는 자리도 둘이 된다.

- 생성자에서 검색어를 **트림해 담는다.** `"seoul"`과 `"seoul "`은 같은 조회이므로 같은 키여야 한다.
- `queryOrNull`이 빈 문자열을 null로 접는다 — `codesOrNull`과 같은 규약이다.
- `LikedSpotsController.build`가 `SpotCategorySelection` 대신 이 타입을 받는다. `loadMore`도 같은
  `query`에서 검색어를 꺼내므로 첫 페이지와 다음 페이지가 어긋날 자리가 없다.

### 검색어 보관 — `likedSpotsSearchQueryProvider`

화면 `State`가 아니라 provider가 든다(설계 §핵심 배선의 권고 그대로). `set()`이 트림과 100자
자르기를 하고, 화면은 디바운스된 확정 값만 넘긴다. **입력창의 타이핑 중 문자열과는 다른 값이다.**

- **디바운스 300ms.** 자동완성(`suggestionDebounce` 250ms)보다 길게 잡았다 — 이쪽은 제안 목록이
  아니라 목록 전체를 갈아 끼우는 재조회라 250ms에서 깜빡임이 눈에 띈다.
- **지우기는 디바운스하지 않는다.** 빈 입력은 "필터 없음"이라 결과 없음 화면에서 곧바로 목록이
  돌아와야 한다.

### 탭 이탈 감지 — `TickerMode`

검색어를 버릴 계기가 필요한데 **`autoDispose`로는 안 된다.** 좋아요 탭은
`StatefulShellRoute.indexedStack`의 브랜치라 다른 탭에 가도 계속 mount되어 provider가 버려지지
않는다.

go_router가 비활성 브랜치를 `TickerMode(enabled: false)`로 감싸는 것을 신호로 썼다(go_router
14.8.1 `lib/src/route.dart:1538`에서 확인). 보관함 안의 좋아요↔커뮤니티 토글은 `IndexedStack`만
쓰고 `TickerMode`를 새로 씌우지 않으며, 상세로 push하는 것도 브랜치를 비활성으로 만들지 않는다 —
둘 다 이탈이 아니라는 스펙의 규정과 정확히 맞는다.

### 빈 상태 — 관측한 값으로 가른다

`likedSpotsEmptyReason()`을 위젯 밖 순수 함수로 두어 단위 테스트가 붙게 했다(설계 §테스트가 붙는
단위의 요구).

문제는 `hasAnyLikes`의 출처였다. **서버가 필터 없는 총량을 주지 않는다** — 커밋된 SDL에는
`LikedSpotConnection.totalCount`가 있지만 **라이브 서버에는 없다**(아래 확인 절). 왕복을 늘리지
않기 위해, 필터도 검색어도 없는 조회는 그 자체가 전체 목록이라는 점을 이용해 그때 받은 결과를
`likedSpotsPresenceProvider`에 관측해 둔다.

**여기서 버그를 하나 잡았다.** 이 provider를 다른 세션 종속 provider처럼 `ref.watchSignedIn()`으로
썼더니, 인증 판정이 `loading`→`data`로 자리잡는 것만으로 build가 다시 돌아 **관측값이 지워졌다**.
로그인 직후 첫 목록이 그 타이밍에 걸리면 좋아요가 있는데도 "아직 좋아요한 여행지가 없어요"가 뜬다.
그래서 `session_scope.dart`에 `listenSignedOut()`을 더해 **로그아웃이라는 사건에만** 반응하게 했다 —
관측해 쌓아 두는 provider가 앞으로도 쓸 수 있는 자리다.

### 두 쿼리로 갈라진다 (2026-08-29, 서버 배포 후 수정)

서버가 배포되며 **설계의 전제가 하나 틀린 것으로 드러났다.** `likedSpots`에 `query` 인자가 붙은
것이 아니라 `searchLikedSpots`가 **별개의 쿼리**로 나왔고, 그쪽 `query`는 **non-null 필수**다.

그래서 "인자를 하나 더 보낸다"가 성립하지 않는다 — 빈 검색어로 전체를 받는 호출 자체가 없다.
**repository가 검색어 유무로 두 오퍼레이션을 가른다.**

- 검색어 있음 → `searchLikedSpots(query: String!, categories, first, after)`
- 검색어 없음 → `likedSpots(categories, first, after)` (원래대로)

**갈림은 repository 안에서 끝난다.** `fetchLikedSpots({query})` 시그니처는 그대로라 provider·화면·
테스트는 한 줄도 바뀌지 않았다 — 호출부에는 여전히 인자 하나로 보인다. 이것이 계약 변화를 흡수하는
repository 계층의 값어치다.

두 쿼리의 선택 집합은 **`LikedSpotPage` 프래그먼트로 묶었다.** 반환 타입이 같은데 선택을 두 벌
적으면 한쪽만 고쳐 어긋난다. 부수 효과로 생성 타입도 `Fragment$LikedSpotPage` 하나로 합쳐져
매핑 함수(`_likedFromNode`)와 `CursorPage` 조립을 양쪽이 공유한다.

`queryOrNull`이 빈 검색어를 null로 접는 규약은 그대로 살아 있다. 뜻만 바뀌었다 — 예전에는
"인자를 생략한다"였고 지금은 "검색 쿼리를 부르지 않는다"다.

### 폐기된 판단 — `variables.remove('query')`

`likedSpots(query:)`를 전제로, 명시적 null이 `"query": null`로 직렬화되는 것을 피하려 repository가
변수 키를 직접 지웠었다(graphql_codegen 3.0.2 `lib/src/printer/base/input.dart:295-330`). 쿼리가
갈라지면서 **필요가 없어져 걷어냈다** — 빈 검색어는 이제 그 쿼리를 아예 부르지 않는다.

관찰 자체는 유효하니 남겨 둔다: 이 코드베이스에서 선택 인자에 명시적 null을 넘기면 생략이 아니라
null 전송이다. 다른 오퍼레이션에서 "생략"이 필요하면 같은 함정이 있다.

## 확인한 것 (2026-08-29)

**계약 검증 완료.** 이전 커밋에서 미검증으로 남긴 부분이 해소됐다.

- 두 오퍼레이션 문서를 라이브 서버(`localhost:8888`)에 직접 발사 → 둘 다 `UNAUTHENTICATED`.
  §13 기준으로 **형태가 통과했다는 뜻이다**(`ValidationError`가 아니다).
- 전체 오퍼레이션 스윕 → **불일치 0건**. 직전 커밋에 남아 있던
  `UnknownArgument@[likedSpots]`가 사라졌다.

**미검증으로 남는 것 하나:** `EMPTY_QUERY`·`QUERY_TOO_LONG`의 실제 응답 형태는 확인하지 못했다.
빈 문자열과 150자를 쏘아도 **`UNAUTHENTICATED`가 먼저 걸려** 입력 검증까지 도달하지 않는다.
정상 경로에서는 입력 단계가 막으므로(§입력 처리) 영향은 없고, 오면 기존 `_ErrorBody`로 흘러간다 —
설계가 정한 그대로다.

### 곁가지로 고친 SDL 드리프트

커밋된 SDL의 `LikedSpotConnection.totalCount`가 **라이브 서버에 없다**(`FieldUndefined`).
지난 커밋에서는 범위 밖이라 두었으나, 이번에 같은 타입을 손대며 걷어냈다. 조회하는 오퍼레이션이
없어 동작에는 영향이 없다 — 다만 없는 필드를 SDL에 적어 두면 다음 사람이 그것을 근거로 배선한다
(실제로 이 작업에서 빈 상태 판정의 후보로 검토했다가 라이브에 없는 것을 확인하고 접었다).

## 관련

- 이슈: #88 · 서버 대응: `ieuri-server` #121
- 브랜치: `feature/SPEC-0033-liked-spots-search` (`dev`에서 분기)
- 선행: SPEC-0008(좋아요 목록 화면 신설 — §3에서 검색을 유보), SPEC-0020(카테고리 필터·`SpotCategoryBar`), SPEC-0030(보관함 탭 셸), SPEC-0032(인증 처리)
