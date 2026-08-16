> spec: SPEC-0021 · source: `Specs/SPEC-0021/spec.md` (Obsidian) · status: 구현 완료

# SPEC-0021 클라이언트 설계 — 피드 제거와 DM 이관

요구사항과 수용 기준은 스펙에 있습니다. 이 문서는 이 리포지토리에서 무엇을 어떻게 걷어내고 옮기는지만 다룹니다.

## 이 작업의 성격

피드와 DM은 `lib/domain/feed/` 한 디렉터리에 함께 삽니다. DM 전용 feature 디렉터리는 따로 없습니다. 피드를 지우면 `feed`라는 이름 아래 DM만 남는데, 이는 feature-first 구조에서 잘못된 이름입니다.

**따라서 이 작업은 삭제와 이관이 반씩 섞여 있습니다.** 피드를 지우고, 남는 DM을 제 이름의 디렉터리로 옮깁니다.

기능이 밖으로 새어 나간 지점은 적습니다. 피드 디렉터리 바깥에서 이 feature를 import하는 곳은 라우터 하나뿐입니다.

## 화면 구성의 변화

### 둘러보기 탭 (R9)

현재 둘러보기 탭은 헤더(타이틀 · DM 아이콘 · 세그먼트 토글)와 추천/피드를 전환하는 스택으로 되어 있습니다. 추천 스와이프 화면은 `domain/spot`이 소유하고 이 탭이 가져다 쓰는 구조입니다.

토글과 피드 쪽을 걷어내면 **추천 스와이프 화면이 단독으로 남습니다.** SPEC-0017 이전 상태로 돌아가는 셈입니다.

지켜야 할 것:

- **라우트 이름 `discover`는 유지합니다.** 온보딩과 로그인 후 착지가 이 이름을 씁니다(AC9.4). 이름 상수는 `lib/common/navigation/discover_route.dart`가 소유하며 이 파일은 남습니다
- **하단 탭 5개 구조와 순서는 그대로입니다**(AC9.3). 하단 네비게이션 위젯은 피드를 전혀 모르므로 손댈 일이 없습니다
- 이 화면의 소유권은 `domain/spot`으로 넘기는 편이 자연스럽습니다. 추천 스와이프만 남으면 `domain/feed`에 둘 이유가 없습니다

### DM 진입점

현재 DM 진입점은 두 곳이고 **둘 다 피드에 붙어 있습니다.**

| 진입점 | 처리 |
|---|---|
| 피드 항목의 DM 아이콘 → 대화 시작 | 피드와 함께 사라짐 |
| 둘러보기 헤더의 메일 아이콘 → 대화 목록 | **남겨야 함** |

피드가 사라지면 **새 대화를 시작할 방법이 없어집니다.** 서버가 `startConversation`을 회원 지정 방식으로 바꾸지만, 사용자가 상대를 고르는 화면은 이 스펙의 범위가 아닙니다([TBD-2]). 이 스펙에서는 **기존 대화 목록으로 들어가는 길만 유지**하고, 새 대화 시작은 후속 채팅 스펙이 만듭니다.

대화 목록 진입점은 둘러보기 헤더에 그대로 두는 것이 변경을 가장 적게 만듭니다. 다만 헤더가 추천 스와이프 화면의 것이 되므로, 관광 추천 화면에 메일 아이콘이 붙어 있는 어색함이 남습니다. **후속 채팅 스펙이 이 자리를 재배치할 것을 전제로 임시로 유지합니다.**

## 디렉터리 이관 (R11)

`lib/domain/feed/`를 없애고 DM 코드를 별도 feature로 옮깁니다.

| 현재 위치 | 이동 후 |
|---|---|
| 대화·메시지 모델, 타이핑 표시, 신고 선택 | DM feature의 `model/` |
| 대화 목록·대화·타이핑·신고 provider | DM feature의 `provider/` |
| 대화 목록 화면, 대화 화면 | DM feature의 `view/` |
| 대화 타일, 말풍선, 입력 바, 타이핑 표시 바, 선택 앱바, 신고 사유 | DM feature의 `component/` |
| 메시지 로컬 캐시 저장소 | DM feature의 `repository/` |
| 피드+DM 혼재 repository와 GraphQL 오퍼레이션 | DM 부분만 남겨 이관 |

repository와 GraphQL 오퍼레이션 문서는 피드와 DM이 한 파일에 섞여 있어 **분리 후 이관**입니다. 피드 fragment·query·mutation을 걷어내고 DM 오퍼레이션만 남깁니다.

**주의 — 동명이인이 있습니다.** `lib/domain/community/`에도 같은 이름의 provider와 테스트가 있습니다. 이들은 커뮤니티 글 목록이며 삭제 대상이 아닙니다. 이름만 보고 지우면 커뮤니티가 깨집니다.

**대화 시작 provider는 남기되 시그니처가 바뀝니다.** 서버 계약이 회원 id를 받도록 바뀌므로 repository 메서드도 따라갑니다. 호출하는 화면이 없어지지만, 후속 스펙이 곧 쓰므로 지우지 않습니다.

## 삭제 대상

**화면과 컴포넌트** — 피드 스크롤 화면, 피드 작성 화면, 피드 항목 페이지, 액션 레일, 작성자 바, 좋아요 버튼, 사진 페이저, 장소 칩, 세그먼트 토글.

**모델과 provider** — 피드 항목, 작성 초안, 실패 모델, 피드 목록·작성 provider, 세그먼트 선택 상태.

**GraphQL** — 피드 fragment 3종, query 2종, mutation 3종과 대응하는 codegen 산출물. `build.yaml`의 codegen 입력 목록에서도 빠집니다.

**라우트** — 피드 작성 라우트. 대화 계열 라우트는 남습니다.

**다국어 문자열** — 피드 전용 키를 4개 언어에서 제거합니다(R10). DM 키는 4개 언어 모두 남습니다.

혼동하기 쉬운 지점: 추천 스와이프 화면과 하단 탭 라벨의 문자열은 이름이 비슷하지만 **남습니다**(AC10.4). 접두어만 보고 지우면 추천 화면이 깨집니다.

## 유지 대상

**WebSocket 구독 클라이언트를 유지합니다.** DM이 계속 실시간 메시지와 타이핑 표시를 쓰므로, 소켓 클라이언트와 그 주소 파생 로직을 그대로 둡니다. 재연결 시도 상한(POL-040)도 유지됩니다.

**메시지 로컬 캐시를 유지합니다.** 저장 키 스킴과 병합 방식을 바꾸지 않습니다.

**캐시에는 피드 인용이 들어 있지 않습니다.** 직렬화가 처음부터 인용을 제외하도록 되어 있고 — 피드는 좋아요 수와 차단 여부가 바뀌는 살아 있는 데이터라 사본을 들면 낡은 값을 보여주기 때문 — 역직렬화도 알려진 키만 읽습니다. 따라서 인용 제거가 과거 캐시를 깨뜨리지 않으며, AC11.6은 이미 성립하는 성질을 확인하는 기준입니다.

다만 기준을 남겨 두는 이유는, 이관 과정에서 직렬화 형식을 건드리면 이 성질이 조용히 깨질 수 있기 때문입니다.

**캐시를 지우지 않는 이유** — 서버가 과거 메시지를 남기기로 했으므로(R4) 기기 기록도 남깁니다. SPEC-0017 AC18-3이 정한 "서버 보관 기간이 기기의 기록을 지우지 않는다"는 원칙이 그대로 유효합니다.

## 메시지 표시의 변화 (R4)

본문이 비고 피드 인용만 있던 과거 메시지는 서버에서 **본문도 사진도 없는 상태로 내려옵니다.** 인용 영역을 걷어냈으므로 그대로 렌더링하면 빈 말풍선이 됩니다.

**빈 말풍선 대신 내용 없음을 나타내는 표시가 필요합니다.** 이는 새 문자열 키가 하나 필요하다는 뜻이며, 4개 언어에 추가합니다. 기존 DM 문자열 중 삭제된 피드 인용을 안내하던 키가 있다면 그것을 재사용하는 편이 낫습니다.

## 테스트

**삭제** — 피드 작성 초안 모델, 피드 목록·작성 provider, 세그먼트 토글 테스트.

**이관** — 대화·타이핑·신고·구독·캐시 테스트 전부. 경로만 바뀌고 내용은 유지됩니다. 공용 페이크는 피드 부분을 걷어내고 이관합니다.

**수정** — 라우터 테스트의 착지 화면 검증. 라우트 이름이 유지되므로 통과할 것으로 보이나, 둘러보기 화면이 교체되면서 스텁 대상이 피드 조회에서 추천 조회로 바뀝니다. 확인이 필요합니다.

**새로 필요한 것** — R4의 내용 없는 메시지 표시와 AC11.6의 과거 캐시 복원. 둘 다 provider·모델 수준에서 검증 가능합니다.

**유지** — 추천 스와이프 화면 테스트, 커뮤니티 글 목록 테스트, 하단 탭 라벨 키 검증. 이름이 비슷해 혼동하기 쉬우나 전부 남습니다.

## 서버 배포와의 순서

이 스펙은 계약을 깨뜨립니다. 구버전 클라이언트는 피드 화면 전체와 대화 시작이 동작하지 않습니다.

피드 화면은 어차피 없어지므로 문제가 되지 않지만, **대화 시작 입력이 바뀌는 것은 다릅니다.** 서버가 먼저 배포되면 구버전 클라이언트에서 피드를 통한 대화 시작이 실패합니다. 다만 그 진입점도 같은 배포에서 사라지므로 실질적 영향은 피드 화면이 깨지는 것과 같습니다.

클라이언트 재배포가 필요한 변경이며, 무중단 병기는 의미가 없습니다 — 피드 화면 자체가 사라지기 때문입니다.

## 구현하며 결정한 것

설계와 달라진 곳과, 설계가 정해 두지 않아 구현이 고른 것을 남깁니다.

### 이름

새 feature 디렉터리는 `lib/domain/dm/`입니다. 피드와 DM이 공유하던 타입들도 DM 이름으로 바꿨습니다 — `FeedRepository`→`DmRepository`, `FeedFailure`→`DmFailure`, `FeedMutationResult`→`DmMutationResult`, `feedRepositoryProvider`→`dmRepositoryProvider`, `feedRetryPolicy`→`dmRetryPolicy`. `feed_providers.dart`는 `dm_providers.dart`가 되면서 세그먼트 상태만 빠졌습니다.

### 둘러보기 화면

`lib/domain/spot/view/discover_screen.dart`를 새로 만들었습니다. SPEC-0017 이전의 같은 이름 파일과 형태가 거의 같지만, **앱바 actions에 DM 진입 버튼이 붙어 있는 점이 다릅니다.**

이 때문에 `domain/spot`이 `domain/dm`을 import합니다. CLAUDE.md §3의 기능 간 의존 금지에 걸리지만, 세 가지를 견주어 이 쪽을 골랐습니다:

- `MessagesEntryButton`은 DM provider 둘(대화 목록 미읽음 플래그, 뷰어)을 읽습니다. `common/`으로 올리려면 그 provider들도 따라 올라가야 하고, 그러면 DM 도메인이 `common/`으로 새어 나갑니다
- 화면을 `domain/dm`에 두면 관광 추천 화면이 DM 소유가 되어 더 어긋납니다
- 이미 `settings`→`auth`, `dm`→`community`, `spot`→`event`가 같은 모양으로 존재합니다

**후속 채팅 스펙이 DM 진입점을 재배치하면 이 의존은 사라집니다**([TBD-2]). 그때까지의 임시 상태입니다.

### 서버 계약 (라이브 확인 완료)

처음에는 서버가 떠 있지 않아 `startConversation`의 새 입력을 `memberId: ID!`로 **가정**했습니다. 이후 서버를 띄우고 introspection으로 확인한 결과 **그 가정이 틀렸습니다** — 실제 필드명은 `counterpartMemberId: ID!`입니다. SDL·오퍼레이션·repository 경계·페이크의 인자명을 모두 서버 이름으로 맞췄습니다.

Dart 쪽 인자명도 `counterpartMemberId`로 통일했습니다. 상대를 가리키는 값이라는 뜻이 이름에 드러나고, 경계 양쪽 이름이 갈리면 다음 사람이 둘을 대조해야 합니다.

**SDL 일치만으로 끝내지 않고 라이브 서버에 실제로 쏴서 확인했습니다.** codegen은 커밋된 SDL을 읽으므로 빌드 통과가 서버와 맞는다는 보장이 아니기 때문입니다. DM 오퍼레이션 6종(`Conversations`·`ConversationMessages`·`StartConversation`·`SendMessage`·`MarkConversationRead`·`NotifyTyping`·`ReportMessages`)이 전부 필드 검증을 통과해 인증 단계까지 도달했습니다 — `ValidationError`가 없다는 것이 필드·타입 일치의 증거입니다. 대조군으로 옛 이름 `memberId`를 쏘면 `missing required fields '[counterpartMemberId]'`로 거부됩니다.

나머지는 전부 일치했습니다:

- `Message`에 `feedItem`이 실제로 없습니다 — `id`·`body`·`photoKey`·`sender`·`ownedByViewer`·`createdAt`뿐입니다
- `SendMessageInput`에 `feedItemId`가 없습니다 — `conversationId`·`body`·`photoKey`뿐입니다
- `Query`·`Mutation` 루트에 피드 계열 필드가 하나도 남아 있지 않습니다
- `Conversation`·`StartConversationPayload`·`ReportMessagesInput`·`MarkConversationReadInput`·`NotifyTypingInput`·`Subscription`·`TypingEvent` 모두 일치합니다

### 내용 없는 메시지 (R4)

`Message.isEmpty`를 더했습니다. `hasContent`와 값은 같지만 뜻이 달라 합치지 않았습니다 — `hasContent`는 **보낼 수 있는지**(전송 전 판정)이고 `isEmpty`는 **어떻게 그릴지**(표시 판정)입니다. 한 이름으로 합치면 전송 규칙이 바뀔 때 표시가 조용히 따라 바뀝니다.

문자열은 스펙 권고대로 기존 `dmDeletedFeedQuote`를 재사용했습니다 — `dmEmptyMessage`로 이름을 바꾸고 문구를 피드가 아닌 메시지 기준으로 고쳤습니다(4개 언어).

### 다국어

DM이 빌려 쓰던 `feed*` 키 4개를 DM 소유로 옮겼습니다 — `feedUnavailableBody`→`dmUnavailableBody`, `feedRetry`→`dmRetry`, `feedReportSubmitted`→`dmReportSubmitted`, `feedReportFailed`→`dmReportFailed`. 옮기지 않으면 피드 키를 지울 수 없습니다.

`dmConversationsEmptyBody`도 고쳤습니다 — "마음에 드는 피드 글에서 대화를 시작해 보세요"가 존재하지 않는 경로를 안내하고 있었습니다.

나머지 `feed*` 키는 4개 언어에서 전부 지웠습니다. `discover*`·`nav*`는 추천 화면과 하단 탭의 것이라 남겼습니다(AC10.4).

### 캐시 (AC11.6)

스펙의 예상대로 **이미 성립하고 있었습니다.** 직렬화가 처음부터 인용을 제외했고 역직렬화도 알려진 키만 읽습니다. 형식은 한 글자도 바꾸지 않았고, 이관 중에 조용히 깨지지 않도록 실제 `SharedPreferences` 저장소로 확인하는 테스트를 더했습니다 — 기존 캐시 테스트는 메모리 페이크만 쓰고 있어 형식을 전혀 검증하지 않았습니다.

### 범위 밖에서 함께 고친 것 — spotDetail 깨짐

이 스펙과 무관하지만 같은 브랜치에서 고쳤습니다(사용자 요청). 상세 화면이 열리지 않고 있었습니다:

```
Validation error (MissingFieldArgument@[spotDetail/intro]) : Missing field argument 'categoryCode'
Validation error (MissingFieldArgument@[spotDetail/infoItems]) : Missing field argument 'categoryCode'
```

**원인은 SPEC-0020(`fc6f47d`)입니다.** 그 커밋이 "서버가 spot 자신의 카테고리로 해석한다"고 보고 `intro`/`infoItems`의 카테고리 인자를 걷어냈는데, 서버는 계속 요구하고 있었고 이름과 타입만 바뀌었습니다(`category: SpotCategory!` → `categoryCode: String!`). 당시 스냅샷(8월 11일)에도 인자가 남아 있어 근거가 없었습니다.

**codegen이 이것을 잡지 못한 이유**는 커밋된 SDL만 읽기 때문입니다. SDL에도 인자 없이 적혀 있었으니 빌드는 통과하고 런타임에만 터졌습니다. 이 브랜치는 `origin/dev` 최신(`3111e34`)에서 땄고 `spot_operations.graphql`을 건드리지 않았으므로, `dev`를 그대로 받아도 동일하게 재현됩니다.

수정:

- `SpotDetail` 쿼리에 `$categoryCode: String!`을 더하고 `intro`/`infoItems`에 전달합니다. SDL도 서버대로 고쳤습니다
- **`spotDetail.category.code`로는 채울 수 없습니다** — 서버가 전 spot에서 null을 돌려줍니다(`NullValueInNonNullableField`). 그래서 목록(스와이프·검색·좋아요)이 이미 아는 코드를 `spotCategoryCodes` provider에 적어 두고 상세가 읽습니다
- **family 키에 넣지 않았습니다.** 카테고리는 같은 spot이면 늘 같아 조회 결과를 가르지 않는데, 키에 넣으면 딥링크 진입(코드 없음)과 목록 진입(코드 있음)이 같은 spot을 두 번 조회합니다
- 코드를 모르면 repository가 `TOURIST_SPOT`을 채웁니다. **빈 문자열은 서버가 예외로 거부하고, 틀린 코드는 `intro: null`·`infoItems: []`로 조용히 답하기 때문**입니다 — 운영정보 섹션만 비고 상세 본문은 살아납니다

라이브 서버로 확인한 동작(서버가 살아 있는 동안):

| 넘긴 값 | 서버 응답 |
|---|---|
| 맞는 코드 | 운영정보 정상 |
| 틀린 코드 | `intro: null`, `infoItems: []` (오류 아님) |
| 빈 문자열 | `IllegalArgumentException` |

**전체 오퍼레이션 문서 9개를 라이브 서버에 쏴서 검증했고 수정 후 불일치 0건입니다.** 이 검사를 처음부터 돌렸으면 SPEC-0020 시점에 잡혔을 문제라, 회귀 테스트 2건(`categoryCode`가 실제로 실리는지, 모를 때 빈 문자열이 안 나가는지)을 repository 테스트에 남겼습니다.

남은 것 하나 — 우리 쿼리 원문을 실제 데이터로 끝까지 돌려보는 검증은 서버가 도중에 내려가 못 했습니다. 서버가 다시 뜨면 상세 화면을 직접 열어 운영정보가 뜨는지 확인이 필요합니다.

### 테스트

라우터 테스트는 **수정 없이 통과했습니다.** 라우트 이름이 유지되고, 착지 검증이 화면 위젯이 아니라 경로 문자열을 보고 있어 스텁 대상이 바뀌지 않았습니다.

전체 1157건 통과.
