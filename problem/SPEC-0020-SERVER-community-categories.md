> spec: SPEC-0020 후속 · 대상: 서버(ieuri) · 상태: 요청
> 작성일: 2026-08-16 · 클라이언트 확인: localhost:8888 라이브 introspection

# 요청: 커뮤니티 `posts`에 복수 카테고리 인자 추가

## 한 줄 요약

spot 쪽에 `categories: [String!]`를 넣어 주신 것(#74)과 **같은 작업을 커뮤니티에**
요청합니다. 카테고리 칩을 앱 전체에서 같은 체계로 맞추는 중인데, spot 화면은 다중
선택이 되고 커뮤니티만 단일 선택으로 남아 있습니다.

## 무엇이 막혔나

`posts`는 `category: TargetCategory` **단수**만 받습니다.

```
posts(
  catalogId: ID
  latitude: Float
  longitude: Float
  radiusMeters: Int
  category: TargetCategory     ← 단수
  tag: String
  sort: PostSortOrder
  hiddenByViewer: Boolean
  first: Int
  after: String
)
```

`TargetCategory`를 인자로 받는 필드는 **`posts.category` 하나뿐**이며, 이름을
불문하고 리스트 형태의 인자는 없습니다(Query 타입 전체 인자를 훑어 확인).

배열을 보내면 검증 단계에서 거절됩니다:

```graphql
query { posts(category: [TOURIST_SPOT, RESTAURANT], first: 1) { edges { cursor } } }
```
```
Validation error (WrongType@[posts]) : argument 'category' with value
'ArrayValue{values=[EnumValue{name='TOURIST_SPOT'}, EnumValue{name='RESTAURANT'}]}'
is not a valid 'TargetCategory' - Expected an AST type of 'EnumValue' but it was a 'ArrayValue'
```

spot에서 `categories` 추가 전에 받던 것과 **글자 그대로 같은 오류**입니다.

## 요청 내용

`posts`에 복수 카테고리 인자를 추가해 주세요.

### 형태 — spot과 맞출지, TargetCategory를 유지할지

spot은 `categories: [String!]`로 가셨습니다(`SpotCategory`가 객체가 되면서 `code`
문자열을 받는 형태). 커뮤니티의 `TargetCategory`는 **아직 enum**이라 두 갈래가 있습니다.

| 안 | 형태 | 비고 |
|---|---|---|
| A | `categories: [TargetCategory!]` | 현행 enum 유지. 클라이언트 변경 최소 |
| B | `categories: [String!]` | spot과 형태 통일. `TargetCategory`도 객체화한다면 이쪽 |

**클라이언트는 어느 쪽이든 대응합니다.** 서버가 `TargetCategory`를 spot처럼
`code`/`label` 객체로 바꿀 계획이 있다면 B가, 당분간 enum으로 둘 거라면 A가
자연스럽습니다. 계획을 알려주시면 그에 맞추겠습니다.

### 의미 규약 (spot과 동일하게)

- **OR 필터** — 둘 중 하나라도 해당하면 반환(교집합 아님).
- **생략(null)은 전체** — 지금 `category`를 생략했을 때와 같은 동작.
- **빈 배열은 오류** — 클라이언트는 빈 배열을 만들지 않지만 방어적으로 거절해
  주십시오. 빈 배열을 "전체"로 해석하면 클라이언트 버그가 조용히 전체 조회로
  둔갑합니다.

### 기존 `category` 인자

**이번에는 삭제하지 말아 주세요.** 클라이언트가 아직 쓰고 있어 배포 시점이 어긋나면
커뮤니티 피드가 통째로 깨집니다. 둘 다 온 경우는 `categories` 우선을 제안합니다.

> spot 때는 단수 인자가 **병행 없이 제거**되어 클라이언트가 전환할 때까지 조회가
> 전부 실패했습니다. 그때는 전환을 바로 붙여 넘어갔지만, 같은 방식이면 이번에도
> 배포 순서를 맞춰야 합니다.

## 함께 봐 주실 것 — `communityChips` 계약 변경 기록 누락

이번에 발견해 클라이언트를 고쳤습니다만, 서버 변경이 공유되지 않아 **커뮤니티 카테고리
줄이 한동안 화면에 아예 뜨지 않고 있었습니다.**

```
과거: communityChips: [CommunityChip!]!   (CommunityChip { category, position })
현재: communityChips: [TargetCategory!]!  (leaf)
```

클라이언트가 `communityChips { category position }`으로 하위 선택을 유지해
`SubselectionNotAllowed`로 매번 실패했고, 화면은 실패를 빈 위젯으로 처리해 조용히
사라졌습니다. 클라이언트 쪽 대응은 끝났습니다(하위 선택 제거, `position` 의존 제거,
정렬을 클라이언트가 담당).

**요청**: 이런 형태의 계약 변경은 배포 전에 알려 주시면 좋겠습니다. 특히
leaf/객체 전환은 필드 이름이 그대로라 클라이언트가 눈치채기 어렵고, 실패가
"화면이 비는" 형태로만 드러나 버그로 인지되기까지 오래 걸립니다.

## 확인 방법

추가 후 아래가 통과하면 클라이언트가 전환합니다(`posts`는 인증이 필요합니다).

```graphql
# 1) 복수 선택이 OR로 동작
query { posts(categories: [TOURIST_SPOT, RESTAURANT], first: 5) {
  edges { node { id category } } } }

# 2) 빈 배열은 오류
query { posts(categories: [], first: 5) { edges { cursor } } }

# 3) 생략은 전체 (기존과 동일)
query { posts(first: 5) { edges { cursor } } }
```
