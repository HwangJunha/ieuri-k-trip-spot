> spec: SPEC-0020 · 대상: 서버(ieuri) · 상태: 요청
> 작성일: 2026-08-14 · 클라이언트 확인: localhost:8888 라이브 introspection

# 요청: 조회 쿼리에 복수 카테고리 인자 추가

## 한 줄 요약

카테고리 필터가 단일 선택에서 **다중 선택**으로 바뀝니다(SPEC-0020 R1·R2). 현재 조회
쿼리들은 `category: SpotCategory` 하나만 받아 여러 카테고리를 동시에 보낼 수 없습니다.
`categories: [SpotCategory!]` 인자 추가를 요청합니다.

## 무엇이 막혔나

클라이언트는 선택 상태를 **비어 있을 수 없는 집합**으로 모델링합니다. 사용자가
"관광지 + 문화시설"을 켜면 그 둘을 함께 보내야 하는데, 보낼 통로가 없습니다.

라이브 서버에서 확인한 현재 시그니처 — 5개 쿼리 전부 단수입니다:

```
mapViewport   (bbox: MapBoundsInput!, zoom: Int!,                     category: SpotCategory)
spots         (latitude: Float!, longitude: Float!, radiusMeters: Int, category: SpotCategory, page: Int, size: Int)
likedSpots    (                                                       category: SpotCategory, first: Int, after: String)
searchSpots   (query: String!, latitude: Float!, longitude: Float!, radiusMeters: Int, category: SpotCategory, page: Int, size: Int)
popularSpots  (latitude: Float!, longitude: Float!, radiusMeters: Int, category: SpotCategory, first: Int, after: String)
```

이름을 불문하고 `[SpotCategory]` 형태의 리스트 인자는 **어느 쿼리에도 없습니다**
(Query 타입 전체 인자를 훑어 확인).

배열을 보내면 검증 단계에서 거절됩니다:

```graphql
query {
  mapViewport(bbox: {minLat:37.5,minLng:126.9,maxLat:37.6,maxLng:127.0},
              zoom: 14,
              category: [TOURIST_SPOT, CULTURAL_FACILITY]) { truncated }
}
```
```
Validation error (WrongType@[mapViewport]) : argument 'category' with value
'ArrayValue{values=[EnumValue{name='TOURIST_SPOT'}, EnumValue{name='CULTURAL_FACILITY'}]}'
is not a valid 'SpotCategory' - Expected an AST type of 'EnumValue' but it was a 'ArrayValue'
```

같은 쿼리에 카테고리 하나만 주면 정상 응답합니다 (`{"data":{"mapViewport":{"truncated":false}}}`).

## 요청 내용

아래 5개 쿼리에 `categories: [SpotCategory!]`를 추가해 주세요.

| 쿼리 | 용도 | 우선순위 |
|---|---|---|
| `spots` | Discover 스와이프 스택 | 높음 |
| `mapViewport` | 지도 마커 (SPEC-0020 신설 필터) | 높음 |
| `likedSpots` | 좋아요 목록 | 높음 |
| `searchSpots` | 검색 결과 | 중간 |
| `popularSpots` | 홈 인기 목록 | 낮음 (이번 스펙 미사용, 일관성 목적) |

### 의미 규약

- **OR 필터**입니다. `categories: [TOURIST_SPOT, CULTURAL_FACILITY]`는 둘 중 **하나라도**
  해당하는 항목을 돌려줍니다(교집합 아님).
- **빈 배열은 오류입니다.** 클라이언트는 집합이 비지 않도록 보장하지만(마지막 1개 해제
  불가), 방어적으로 `EMPTY_CATEGORY_SET` 오류 코드를 요청합니다. 빈 배열을 "전체"로
  해석하면 클라이언트 버그가 조용히 전체 조회로 둔갑합니다.
- **생략(null)은 전체**입니다 — 지금 `category`를 생략했을 때와 같은 동작입니다.

### 기존 `category` 인자

**이번에는 삭제하지 말아 주세요.** 클라이언트가 아직 쓰고 있고, 배포 시점이 어긋나면
앱이 깨집니다. 두 인자를 함께 두고, 클라이언트 전환이 끝난 뒤 별도 스펙으로 정리하는
쪽을 제안합니다.

둘 다 온 경우의 규약이 필요합니다. 제안: **`categories`가 우선**하고 `category`는
무시합니다. (거절도 무방하나, 그 경우 오류 코드를 알려주세요.)

## 왜 클라이언트에서 우회하지 않나

선택된 카테고리마다 따로 조회해 클라이언트에서 합치는 방법을 검토했고, 접었습니다.

- **지도**: 뷰포트가 움직일 때마다 선택 개수만큼 조회가 나갑니다. 9개를 다 켜면 이동
  한 번에 9배입니다.
- **스와이프 스택**: 서버가 거리순으로 100장씩 주는데, N개 응답을 클라이언트에서 합치면
  그 정렬이 무너집니다. 페이지 경계도 카테고리마다 달라 이어붙이기가 성립하지 않습니다.
- **좋아요·검색**: 커서 페이징이라 N개 커서를 동시에 관리해야 합니다.

## 확인 방법

추가 후 아래가 통과하면 클라이언트가 전환할 수 있습니다.

```graphql
# 1) 복수 선택이 OR로 동작
query { mapViewport(bbox: {minLat:37.5,minLng:126.9,maxLat:37.6,maxLng:127.0},
                    zoom: 14, categories: [TOURIST_SPOT, CULTURAL_FACILITY]) {
  spots { id category } truncated } }

# 2) 빈 배열은 EMPTY_CATEGORY_SET
query { mapViewport(bbox: {...}, zoom: 14, categories: []) { truncated } }

# 3) 생략은 전체 (기존과 동일)
query { mapViewport(bbox: {...}, zoom: 14) { truncated } }
```

## 참고: 이건 이미 잘 되고 있습니다

`availableSpotCategories`는 손댈 필요 없습니다. 언어별 가용 목록을 정확히 내려주고
있습니다 — KO는 `TRAVEL_COURSE` 포함·`TRANSPORT` 없음, EN은 그 반대. 확인 완료.

이 요청은 **목록을 읽는 쪽이 아니라, 고른 값을 보내는 쪽**에 대한 것입니다.
