# 디자인 참조 — 피드와 다이렉트 메시지 (SPEC-0017)

> 설계 문서: `problem/SPEC-0017-client.md` · 수용 기준: `Specs/SPEC-0017/spec.md` (R1~R18)
> Stitch 프로젝트: `projects/8651053354437738829` (K-Trip Spot Design System)
> 디자인 시스템: `assets/073fee5b990e4b1eb2c918d7e9de2d8f`
> **Stitch 목업: 피드 스크롤 + 대화 목록(§0에 스크린 id) · 나머지 DM 화면은 직접 그린 목업**
> DM 보조 목업: [`spec-0017-dm-mockups.html`](./spec-0017-dm-mockups.html)

이 문서는 **레이아웃·컴포넌트 분해 참조**다. 수용 기준과 어긋나면 스펙이 이긴다.
색·폰트·간격 값은 여기 적힌 것을 복사하지 말고 `Theme.of(context)`에서 읽는다(DESIGN.md §12,
CLAUDE.md §9). 폰트는 Stitch가 이름한 Plus Jakarta Sans / Be Vietnam Pro가 아니라 앱이 쓰는
**Noto Sans**(+CJK 폴백) — `lib/common/theme/app_theme.dart`가 그대로 유지한다. 이 문서는 타입
*스케일*(제목/본문/라벨 크기 관계)만 참고한다.

---

## 0. Stitch 화면

| 화면 | Stitch 스크린 id | 비고 |
|---|---|---|
| 피드 스크롤 (`Discover Feed`) | `fd6c666908c94da388f967966b7b66a9` | 헤더 토글("For You │ Feed")·작성자 DM 아이콘·스팟 칩 + **헤더 우측 메시지 아이콘(§1.5)** |
| 피드 스크롤 (대안) | `3f51c367a49543c5ba5c9d85598f93e3` | 같은 화면의 두 번째 안 |
| **대화 목록** (`Messages — Conversation List`) | `927d8a7e1ace4220a7b08130c6557129` | 미읽음 배지(2·12)·미리보기·상대시각·실제 5탭 |
| 피드 컴포저 | `Post Composer`(`b51fa99f…`)로 대용 | 커뮤니티 컴포저 목업 참조 — 피드 전용은 없음 |
| 대화 화면 · 선택 모드 | 없음 | 아래 HTML 목업이 기준 |

**타임아웃은 실패가 아니다(CLAUDE.md §11.6).** 대화 목록 생성 호출은 매번 타임아웃했고 직후
`list_screens`에도 안 잡혀 한때 "생성 실패"로 적었으나, **실제로는 모두 성공해 나중에
올라왔다.** 네 번 재시도한 탓에 유사 화면이 네 개 생겨 사용자가 가장 나은 하나만 남기고
지웠다. 다음부터는 재시도하지 말고 시간을 두고 `list_screens`로 다시 조회한다.

피드 화면 헤더의 메시지 아이콘(§1.5)은 `edit_screens`로 추가했다. **긴 프롬프트는 타임아웃했고
짧은 프롬프트는 즉시 성공했다** — 편집 프롬프트는 바꿀 것 하나만 짧게 쓰는 편이 낫다. 편집이
반영된 뒤에도 MCP가 돌려주는 `htmlCode`/`screenshot` id는 한동안 예전 것을 가리키니, 화면이
안 바뀐 것처럼 보여도 다시 편집하지 말 것.

아직 Stitch 목업이 없는 화면(대화 화면·타이핑 표시·전송 실패·다중 선택 신고)은 앱의 디자인
시스템 토큰으로 직접 그린 [`spec-0017-dm-mockups.html`](./spec-0017-dm-mockups.html)을 참조한다.
색·타입·간격이 전부 DESIGN.md 토큰이라 구현 시 `Theme.of(context)`로 그대로 옮겨진다.

**slice-builder에게**: 대화 목록은 **Stitch 화면이 기준**이고, 나머지 DM 화면은 위 HTML이
배치 참조다. 세부 규칙은 이 문서 §4~§6이며, 어긋나면 이 문서가 이긴다.

이 문서가 근거로 삼은 것:
- `problem/SPEC-0017-client.md`(클라이언트 설계 §1~§9), `Specs/SPEC-0017/spec.md` R1~R18
- 이미 구현된 커뮤니티 컴포넌트(`lib/domain/community/component/`) — `PostCard`,
  `post_moderation_sheet.dart`(`showReportSheet`), `spot_picker_sheet.dart`
  (`showSpotPickerSheet`)의 실제 레이아웃·상호작용 패턴. 이 스펙이 명시적으로 재사용을
  지시하는 대상이다(설계 §4·§8)
- 이미 구현된 공용 모델 `lib/common/model/post_author.dart`(`PostAuthor`),
  `lib/common/model/post_spot.dart`(`PostSpot`) — 피드도 같은 작성자·장소 표현을 쓴다
- `docs/design/SPEC-0010-community-spot-talk.md`(커뮤니티 카드·컴포저·신고 시트의 톤과
  컴포넌트 명명 기준), `docs/design/SPEC-0002-discover-swipe.md`(추천 스와이프 화면 구조 —
  토글의 한쪽 축)
- `lib/common/widget/floating_bottom_nav_scaffold.dart`(`barExtent` 상수, `extendBody: true`)
- `lib/domain/spot/view/discover_screen.dart` / `discover_swipe_view.dart`(토글 반대편 화면의
  현재 구조 — 그대로 유지, 재설계하지 않음)

**slice-builder에게**: Stitch 화면이 나중에 생성되면 이 문서 상단에 스크린 id를 채우고, 레이아웃이
크게 어긋나면 이 문서를 갱신한다. 그 전까지 이 문서가 유일한 참조다.

---

## 1. 둘러보기 탭 헤더 + 세그먼트 토글

**핵심 제약(설계 §1, R5)**: 토글은 제스처 표면 위 오버레이가 아니라 **별도 헤더**다. 추천은
스와이프 카드, 피드는 세로 스크롤 — 둘 다 화면 전체를 제스처 표면으로 쓰므로, 토글을 그 위에
겹치면 토글 탭과 드래그·스크롤 시작 제스처가 같은 영역에서 경합한다. 헤더로 분리해 경합 자체를
없앤다.

```
DiscoverTabScreen (신규, lib/domain/feed/view/discover_tab_screen.dart)
└─ Scaffold
   ├─ AppBar (기존 DiscoverScreen의 AppBar를 대체 — title: "Discover")
   │   ├─ actions: MessagesEntryButton  ← DM 재진입점(§1.5)
   │   └─ 바로 아래(AppBar 영역 내 또는 AppBar 바로 아래 별도 줄):
   │       DiscoverModeToggle — "For You" | "Feed" 세그먼트
   └─ body: 선택된 모드에 따라 분기
       ├─ DiscoverSwipeView   (기존, 재설계하지 않음 — SPEC-0002/0006 그대로)
       └─ FeedScrollView      (신규, §2)
```

- **`DiscoverModeToggle`** (`lib/domain/feed/component/discover_mode_toggle.dart`): pill형
  `SegmentedButton<DiscoverMode>` 2개 세그먼트. 커뮤니티의 `FeedSortToggle`
  (`lib/domain/community/component/feed_sort_toggle.dart`)과 같은 시각 언어(선택 세그먼트
  = `primary` 채움)를 쓰되, **이 토글은 정렬이 아니라 화면 자체를 바꾸므로** 폭을 더 넓게
  잡고(전체 너비 또는 그에 가깝게) AppBar 영역에 확실히 자리를 차지한다 — 정렬 토글처럼
  작게 접어두면 두 화면이 있다는 사실 자체가 눈에 덜 띈다.
- **선택 상태는 헤더가 쥔다.** `DiscoverModeToggle`의 선택 값은 화면 레벨 provider
  (`feed/provider/discover_mode_provider.dart`, `keepAlive`)가 보관한다 — 탭을 벗어났다
  돌아와도 마지막으로 보던 쪽이 유지된다(AC5-2, 설계 §1 "기존 스와이프 추천 화면은
  제거하지 않는다").
- **두 화면은 서로 다른 provider를 쓴다.** `DiscoverSwipeView`가 이미 쓰는
  `swipeControllerProvider`와, 피드가 쓰는 `feedControllerProvider`(§2)는 완전히
  독립이다 — 한쪽이 오류여도 다른 쪽 상태가 무너지지 않는다(AC5-3). 이 화면(래퍼)은 둘 중
  선택된 쪽만 빌드하고 상대 쪽 트리는 `IndexedStack` 등으로 유지해, 토글을 오갈 때 다시
  로딩하지 않는다.
- **기존 `DiscoverScreen`을 이 화면이 대체한다.** `router/routes.dart`의 discover 라우트가
  가리키는 위젯이 바뀐다 — `DiscoverScreen`(현재: AppBar + `DiscoverSwipeView` 단독)은
  `DiscoverTabScreen`(AppBar + 토글 + 분기 body)으로 승격되고, 기존 AppBar의 `l10n.navDiscover`
  타이틀은 유지한다. **`DiscoverSwipeView` 내부는 손대지 않는다** — `CategoryBar` +
  카드 스택 구조 그대로.

### `DiscoverMode` (모델, `lib/domain/feed/model/discover_mode.dart`)

```dart
enum DiscoverMode { forYou, feed }
```

---

## 1.5 DM 재진입점 (`MessagesEntryButton`)

**대화는 다시 들어갈 수 있어야 한다.** 피드 항목의 DM 아이콘(§2)은 *새 대화를 시작하는* 입구일
뿐이라, 그것만 있으면 이미 나눈 대화로 **돌아갈 길이 없다** — 대화를 시작한 피드가 스크롤로
지나가거나 삭제되면(그때도 대화 자체는 남는다) 접근 자체가 끊긴다.

**둘러보기 탭 AppBar 우측에 메시지 아이콘을 둔다.** 누르면 대화 목록(§4)으로 간다.

```
┌──────────────────────────────────────────────┐
│  Discover                          [✉ ③]     │  ← AppBar actions
│         ( For You │ ▓Feed▓ )                 │  ← DiscoverModeToggle
└──────────────────────────────────────────────┘
```

- **위치**: `AppBar.actions`. 토글과 **같은 헤더 영역**이므로 §1의 핵심 제약(제스처 표면 위에
  겹치지 않는다)을 그대로 지킨다 — 아이콘이 카드 드래그·세로 스크롤과 경합하지 않는다.
- **아이콘**: `Icons.mail_outline`(대화함 = **장소**). DESIGN.md §6에 따라 Material 기본
  아이콘만 쓴다.
  - **피드 작성자의 DM 아이콘(§2)과 반드시 달라야 한다.** 둘 다 `mail_outline`이던 때는
    같은 아이콘이 화면에 나란히 두 개 떠 "새 대화 걸기"와 "대화함 열기"가 구분되지
    않았다(사용자 보고). 작성자 쪽을 `Icons.send_outlined`(**행동**)로 바꿔, 봉투는
    장소·보내기는 행동으로 뜻을 갈랐다.
  - **문구도 "메시지"가 아니라 "DM"이다**(사용자 결정) — ko/en/ja/zh 네 ARB의
    `dmMessagesAction`·`dmConversationsTitle`·`feedMessageAuthorAction` 등 DM 계열 값이
    이 표기를 따른다. 키는 그대로다.
- **읽지 않음 배지**: 아이콘 우상단에 `Badge`. **전체 대화의 `unreadCount` 합계**이며 0이면
  배지를 아예 그리지 않는다. 두 자리를 넘으면 접는다(§4의 `ConversationTile` 배지와 같은 규칙).
- **왜 하단 탭이 아닌가**: 현재 5탭(홈·지도·둘러보기·좋아요·커뮤니티)이 이미 꽉 차 있어 DM을
  넣으려면 기존 탭 하나를 빼야 한다. **DM은 피드에서만 생기는 기능이므로**(R7, 설계 §6)
  피드가 있는 탭의 헤더가 맥락상 맞는 자리다. 탭 구조를 바꾸는 것은 이 스펙의 범위를 넘는다.
  - 참고: Stitch 목업(그리고 DESIGN.md §8의 원안)에는 `Events`·`Chat` 탭이 그려져 있으나
    **실제 구현된 탭은 좋아요·커뮤니티다.** 목업의 탭 구성을 따라가지 않는다 — 구현이 기준이다.
- **커뮤니티 탭에는 두지 않는다.** 커뮤니티 글 작성자에게 DM을 보낼 수 없으므로(설계 §6)
  그쪽에 진입점이 있으면 없는 기능을 암시하게 된다.
- **미인증 상태**: 로그인하지 않았으면 아이콘을 그리지 않는다 — 눌러도 갈 곳이 없다.

### 진입 경로 요약

```
[새 대화]  피드 항목의 DM 아이콘 ──startConversation──▶ ConversationScreen (§5)
[재진입]   AppBar 메시지 아이콘 ──▶ ConversationListScreen (§4) ──탭──▶ ConversationScreen (§5)
```

두 경로 모두 같은 `ConversationScreen`에 도착한다. 라우트는 `conversationId`만 넘긴다
(CLAUDE.md §6 — 모델 객체를 라우트로 넘기지 않는다).

**갭으로 기록**: 전체 미읽음 합계를 주는 서버 필드가 계약에 없다(`Conversation.unreadCount`는
대화별이다). 첫 페이지 합계로 근사하거나, 배지를 숫자 없는 점(dot)으로 두는 선택지가 있다 —
**이 문서는 점(dot)을 권장한다.** 첫 페이지 합계는 20건을 넘는 순간 조용히 틀린 값이 되고,
서버가 주지 않는 값을 추정하지 않는다는 설계 §2의 원칙과도 어긋난다.

---

## 2. 피드 전면 스크롤 화면 (`FeedScrollView`)

**핵심 제약(설계 §2, R4)**: 목록·그리드가 아니라 **한 번에 한 건이 화면을 채우는 세로 전면
스크롤**이다. `PageView`(`scrollDirection: Axis.vertical`) + 스냅 물리(`PageScrollPhysics` 또는
동등한 페이지 단위 스냅)로 구현한다 — `ListView`가 아니다.

```
FeedScrollView (lib/domain/feed/view/feed_scroll_view.dart)
└─ 상태별 분기 (§2.5)
   └─ 정상: PageView.builder (vertical)
       └─ FeedItemPage  ← 한 페이지 = FeedItem 하나, 화면 전체를 채움
           ├─ FeedPhotoPager       배경, 1~5장 페이저 + 인디케이터
           ├─ FeedAuthorBar        상단 오버레이 — 아바타·닉네임·상대시각·DM 아이콘
           ├─ FeedOptionsButton    우상단 오버레이 — 신고 등 오버플로
           ├─ 하단 그라데이션 스크림
           │   ├─ 본문 텍스트 (1~500자, 길면 "더보기"로 펼침)
           │   └─ FeedSpotChip     탭 가능 — 스팟 상세로 이동
           └─ FeedLikeButton       우측 세로 배치 — 하트 + 카운트
```

### `FeedItemPage` — 화면 한 장

Discover 스와이프의 `SwipeCard`(전면 이미지 + 하단 스크림 텍스트 오버레이, 저작권 뱃지 자리에
UI 요소를 배치하는 방식)와 시각적 언어를 공유하되, **스와이프 제스처가 아니라 세로 스크롤로
전환한다는 점만 다르다** — 사진이 여러 장이면 그 안에서는 **가로** 페이저(탭 또는 좌우 스와이프)
로 넘기고, 세로 방향 스와이프는 다음 피드 항목으로 넘어간다. 두 제스처 축을 분리해야 사진
넘기기와 다음 글 넘기기가 서로 삼키지 않는다.

- **`FeedPhotoPager`** (`component/feed_photo_pager.dart`): `photoKeys`(1~5장, 배열 순서 =
  표시 순서) 기반 가로 `PageView`. 여러 장일 때만 **점 인디케이터**(현재 위치)를 상단에
  작게 표시 — 1장이면 인디케이터 자체를 그리지 않는다. `PostPhoto`
  (`lib/domain/community/component/post_photo.dart`)와 같은 CDN 키→URL 변환 및 404 견딤
  패턴을 재사용한다(새 이미지 위젯을 만들지 않는다).
  - **사진이 깨져도 밝은 빈 화면을 두지 않는다**(구현 시 추가). 이 화면의 글자는 전부
    흰색이라 배경이 밝은 회색으로 남으면 작성자 이름도 본문도 읽히지 않는다 — 개발
    시드 `photoKeys`가 404일 때 실제로 그렇게 보였다(사용자 보고). 폴백은 세 단계다:
    사진 키 → 실패하면 **연결된 스팟 썸네일**(`PostSpot.thumbnailImageUrl`, 서버가 항상
    준다) → 그것도 실패하면 **어두운** 자리채움 + 아이콘. 받는 동안에도 빈 화면이
    되지 않게 `loadingBuilder`를 둔다.
  - **"N개 중 M번째" 같은 카운터 문구는 절대 두지 않는다**(설계 §2, 핵심 제약) — 이것은
    사진 페이저의 위치(예: 1/3)에 대한 것이 아니라 **피드 항목 자체의 총 개수**에 대한
    제약이다. `pageInfo.hasNextPage`만으로 다음 페이지 여부를 판정하고, "총 N개 중 M번째
    글" 같은 문구를 어디에도 넣지 않는다. 사진 페이저의 점 인디케이터(현재 사진 위치)는
    사진 배열 안의 위치이므로 이 제약과 무관하며 그대로 둔다.
- **`FeedAuthorBar`** (`component/feed_author_bar.dart`): 좌측 원형 아바타(`PostAuthor.
  profileImageUrl`, 실패 시 이니셜로 폴백 — `PostCard`의 `_AuthorAvatar` 패턴 재사용) +
  닉네임 + 상대 시각("3m ago", §2.6) + **DM 진입 아이콘 버튼**(`Icons.mail_outline` 또는
  `Icons.chat_bubble_outline`). **DM 아이콘은 피드에만 존재한다**(설계 §6, R7) — 커뮤니티의
  `PostCard`/`_AuthorLine`에는 이 버튼이 없고, 이후에도 추가하지 않는다. 반투명 스크림
  배경 위에 얹혀 가독성을 확보한다(Discover 스와이프의 텍스트 오버레이 스크림과 같은 처리).
- **`FeedOptionsButton`**: 우상단, `Icons.more_vert`. 눌리면 신고 시트(§2.7)를 연다.
- **본문**: 하단 스크림 위, 최대 3~4줄 후 "더보기"로 펼침(500자까지 허용되므로 전면
  스크롤 화면에서 다 펼치면 사진이 거의 가려진다 — 접힌 상태를 기본으로 하고 사용자가
  펼치면 스크림 영역이 늘어나는 방식을 권장, 최종 줄 수는 slice-builder가 실기기로 조정
  — 갭으로 기록).
- **`FeedSpotChip`** (`component/feed_spot_chip.dart`): `PostSpot.title` + 썸네일(작게, 원형
  또는 소형 사각) + 위치 핀 아이콘. 탭하면 `PostSpot.id`로 스팟 상세 이동(R13, 기존
  `/spot/:id` 라우트 재사용 — 커뮤니티의 `_FooterRow`가 `onSpotTap`을 넘기는 것과 같은
  패턴). 스크림 위에 반투명 배경의 pill로 얹는다.
- **`FeedLikeButton`** (`component/feed_like_button.dart`): 우측 세로 정렬, 하트 아이콘(채움
  = `likedByViewer`, `PostCard`의 `_Count`가 좋아요에 쓰는 색 규칙과 동일 — 채워지면
  `primary`, 아니면 `onSurfaceVariant`/역 스크림 대비색) + 카운트. **탭 즉시 낙관적으로
  토글**하고 실패 시 롤백한다(설계 §3, R6) — 커뮤니티 좋아요와 같은 낙관적 갱신 패턴,
  provider가 롤백을 맡는다(view는 상태만 그린다).

### 페이지네이션 (설계 §2)

- `pageInfo.hasNextPage`로만 다음 페이지 여부를 판정한다. **총 개수 필드가 없으므로**
  진행률·카운터 UI를 만들지 않는다.
- 프리페치는 **현재 항목 기준 앞쪽 일부만** — 사진이 페이지당 최대 5장이라 과도한 선반입은
  메모리·대역폭을 함께 소모한다(설계 §2). `PageView.builder`의 기본 지연 빌드에 더해,
  provider가 "현재 인덱스 + N" 범위만 미리 조회하는 방식을 쓴다(정확한 N은 slice-builder가
  실측 — 커뮤니티 `PaginationListView`의 임계값 방식과 다르게, 이 화면은 목록이 아니라
  단일 페이지 스크롤이라 공용 `PaginationListView`를 그대로 쓸 수 없다 — 페이지 전환
  콜백에서 다음 커서를 미리 당겨오는 자체 로직이 필요하다. 갭으로 기록: 공용
  `PaginationListView`와의 관계는 이 화면에 적용되지 않는다는 점을 명시).

### 2.5 상태

| 상태 | 화면 |
|---|---|
| 초기 로딩 | 중앙 스피너 또는 첫 페이지 스켈레톤(사진 영역 회색 블록 + 하단 스크림 자리) |
| 정상 | `PageView`로 `FeedItemPage` 세로 스크롤 |
| 빈 결과(글이 아직 없음) | 중앙 정렬 안내 — 아이콘(`Icons.dynamic_feed_outlined` 등, muted) + "No posts yet." 류 문구. 재시도 버튼 없음(빈 것은 오류가 아니다) |
| 소진(`hasNextPage=false`, 더 내릴 페이지 없음) | 마지막 페이지에서 자연스럽게 스크롤이 멈춘다. 별도 "끝" 화면을 추가하지 않는다 — Discover 스와이프가 소진 시 빈 상태로 전환하는 것과 달리, 피드는 이미 화면을 채운 마지막 글이 계속 보이는 것이 자연스럽다(스펙에 소진 시 별도 문구 요구 없음, 갭으로 기록) |
| 오류(네트워크 등) | **추천(For You) 쪽을 막지 않는다**(AC5-3) — 피드 쪽 body 영역에만 재시도 배너/중앙 오류 문구를 그린다. 토글은 계속 조작 가능해야 한다 |

### 2.6 상대 시각

SPEC-0010이 이미 정의한 `relativeTimeSince` 순수 함수 + l10n 매핑 규칙을 그대로 재사용한다
(방금 / N분 / N시간 / N일 / N개월 / N년, 미래 시각은 "방금"으로 접음) — 새 포맷터를 만들지
않는다.

### 2.7 신고 (설계 §8)

`FeedOptionsButton` → 커뮤니티의 `showReportSheet`(`lib/domain/community/component/
post_moderation_sheet.dart`)를 **그대로 재사용**, 대상 타입만 `ReportTargetType.FEED_ITEM`
(신규 열거값)으로 넓힌다. 새 신고 시트를 만들지 않는다.

**`ReportTargetType`을 default 없이 전수 분기하는 `switch`가 있으면 이 신규 열거값 추가
시점에 컴파일이 깨진다**(설계 §8 핵심 제약) — 기존 신고 관련 분기 코드를 점검해 미지 값에
대한 기본 동작(예: `OTHER`로 폴백하거나 버튼을 숨김)을 두어야 한다. slice-builder 작업
항목으로 남긴다.

---

### 2.8 작성 진입점 (구현 시 확정)

**피드 화면 우측에 떠 있는 작성 버튼**(FAB)이다(사용자 결정). `feed_scroll_view.dart`가
상태 분기 **바깥**에 얹으므로 정상·빈 상태·오류 어디서나 같은 자리에 있다 — 빈 상태에서
특히 필요한데, 글이 하나도 없을 때가 곧 첫 글을 쓸 때이기 때문이다. 빈 상태에는 안내
문구 아래에 같은 곳으로 가는 버튼을 하나 더 둔다(문구가 "첫 글을 남겨보세요"라고 권하는데
수단이 구석의 아이콘뿐이면 권유가 막다른 길이 된다).

떠 있는 내비게이션 바가 아래를 지나가므로 `FloatingBottomNavScaffold.barExtent`만큼
띄운다 — 셸이 `extendBody: true`라 보정하지 않으면 버튼이 바 뒤로 숨어 눌리지 않는다.
미로그인이면 그리지 않는다.

---

## 3. 피드 작성 화면 (`FeedComposerScreen`)

커뮤니티 컴포저(`lib/domain/community/view/post_composer_screen.dart`, "화면을 가득 쓰는
배치"로 재설계된 바 있음 — SPEC-0010 §2)와 **같은 톤**을 쓰되 요구 필드가 다르다.

```
FeedComposerScreen (lib/domain/feed/view/feed_composer_screen.dart)
└─ Scaffold
   ├─ AppBar: ✕(닫기) · "New Post" · [Post] 버튼(우측)
   ├─ FeedPhotoPicker   가로 스크롤 썸네일 스트립, 1~5장, 추가/제거
   ├─ FeedSpotField     선택된 스팟 1곳 표시 + 변경/추가 버튼 → 스팟 피커 시트
   └─ 본문 입력          테두리 없음, 남은 공간 확장(expands: true), 1~500자
```

- **제출 버튼은 spot 1곳 + 사진 ≥1장이 갖춰지기 전엔 비활성이다**(설계 §4, R1·R2, 핵심
  제약). 본문 글자 수 제약(1~500)도 폼 상태에 포함하되, 서버가 같은 규칙을 다시 판정하므로
  이 클라이언트 판정은 UX 미러링이다.
- **`FeedSpotField`**: 커뮤니티의 `showSpotPickerSheet`(`spot_picker_sheet.dart`)를
  **그대로 재사용**한다(설계 §4, "새로 만들면 검색 동작이 두 벌이 된다"). 다만 이 화면은
  스팟이 **필수 1곳**이라 커뮤니티 컴포저와 달리 "장소 없음" 상태에서 시작하며, 고르지
  않으면 제출이 막힌다. 이미 고른 스팟을 뗄 수단(지우기 아이콘)도 필요 — 스팟 피커 시트
  자체에는 "선택 해제" 항목을 넣지 않는다는 기존 규칙(`SpotPickerResult` 문서 주석)을
  그대로 따른다.
- **`FeedPhotoPicker`**: 커뮤니티 컴포저의 "고를 때는 로컬 미리보기만, 제출할 때 올린다"
  원칙(SPEC-0010 §2 "사진 — 등록을 누를 때 올린다")을 그대로 따른다 — 글을 쓰지 않고
  나간 사용자의 사진이 스토리지에 고아로 남지 않게 한다. 5장 상한.
  - 사전 서명 URL로 직접 PUT하고 확정 키만 제출(POL-042).
  - **업로드 실패는 어느 장이 실패했는지 특정해서 알린다**(설계 §4, 핵심 제약) — "Upload
    failed" 같은 뭉뚱그린 문구가 아니라 **"Photo 3 of 5 failed to upload"** 류로, 실패한
    썸네일 위에 오류 아이콘 오버레이 + 재시도 버튼을 개별로 붙인다. 커뮤니티는 "1장
    실패해도 나머지로 글을 올린다"는 정책이지만, **이 피드 화면은 사진 1~5장이 필수
    항목의 일부이므로** 실패한 장이 있으면(재시도로 해결되지 않는 한) 제출을 막는 쪽이
    맞다 — 정확히는 스펙이 "실패 시 어느 장인지 알려야 한다"까지만 규정하고 "실패해도
    올릴지"는 규정하지 않는다(**갭으로 기록** — slice-builder가 실패한 장을 빼고 제출할지
    막을지 정한다. 이 문서는 "실패 사진이 남아있는 동안 제출 비활성"을 권장한다 — 필수
    사진 개수 요건과 충돌하지 않는 가장 단순한 규칙이기 때문).
- **본문**: 커뮤니티 컴포저처럼 `expands: true`로 남은 공간을 채우고, 카운터는 한계 90%부터
  드러나며 코드포인트 단위로 센다(SPEC-0010 §2 규칙 재사용). 길이 초과 시 입력을 자르지
  않고 제출만 막는다.

### 3.5 상태

| 상태 | 화면 |
|---|---|
| 초기 | 스팟 미선택 + 사진 0장, 제출 버튼 비활성 |
| 업로드 중 | 제출 버튼에 진행 스피너, 재탭 방지 |
| 사진 업로드 실패(장별) | 실패한 썸네일에 오류 표시 + 재시도(§3 참조) |
| 제출 실패(서버 검증 등) | 스낵바 또는 인라인 오류, 입력값은 보존(다시 쓰지 않게) |
| 제출 성공 | 피드 화면으로 복귀, 새 글이 최상단(또는 최신 위치)에 반영 |

---

## 4. 대화 목록 화면 (`ConversationListScreen`)

```
ConversationListScreen (lib/domain/feed/view/conversation_list_screen.dart)
└─ Scaffold
   ├─ AppBar: "Messages"
   └─ body: 상태별 분기
       ├─ 정상: ConversationTile 목록 (공용 PaginationListView 재사용)
       ├─ 빈 상태: 안내 문구, 재시도 없음
       └─ 오류: 재시도
```

### `ConversationTile`

당근 동네생활 스타일 커뮤니티 목록(SPEC-0010 §0)과 같은 **납작한 목록**(그림자 없음, 얇은
구분선) 원칙을 따른다 — 채팅 목록은 Material 카드보다 이 앱의 기존 리스트 언어와 더
잘 맞는다.

```
┌────────────────────────────────────────────────┐
│ (아바타)  상대 닉네임              12m ago     │
│           마지막 메시지 미리보기 (1줄, ellipsis) [●3]│  ← unreadCount 뱃지
└────────────────────────────────────────────────┘
```

- 좌측 원형 아바타(counterpart) — `PostAuthor` 아바타 패턴 재사용(실패 시 이니셜).
- 닉네임 + 우측에 `updatedAt` 상대 시각(§2.6과 같은 포맷터 재사용).
- 마지막 메시지 미리보기 1줄, ellipsis.
- **`unreadCount` 뱃지** — 0이면 그리지 않는다. 1 이상이면 우측 원형 배지(`primary` 배경 +
  `onPrimary` 텍스트), 숫자가 두 자리를 넘으면 "9+" 류로 접는다(관례 — 스펙에 상한 규정
  없음, 갭으로 기록).
- **읽음 확인(✓✓)은 범위 밖이다**(spec §4 명시) — 체크마크·"읽음" 표시를 두지 않는다.
- 정렬: `updatedAt` 최근순(서버가 이미 이 순서로 내려준다고 가정 — 클라이언트가 재정렬하지
  않는다, 갭으로 기록: 정렬 보장이 명시적으로 서버 계약에 있는지는 repository 구현 시
  확인 필요).
- 탭하면 `ConversationScreen`(§5)으로 이동.

### 상태

| 상태 | 화면 |
|---|---|
| 로딩 | 스피너 또는 스켈레톤 행 3~4개 |
| 정상 | `ConversationTile` 목록 |
| 빈 목록(대화 없음) | 중앙 정렬 안내 — "No conversations yet. Start one from a feed post." 류. 오류가 아니다 |
| 오류 | 재시도 버튼 |

---

## 5. 대화 화면 (`ConversationScreen`)

```
ConversationScreen (lib/domain/feed/view/conversation_screen.dart)
└─ Scaffold
   ├─ AppBar (일반 모드)      상대 닉네임 + 아바타, [⋮] 메뉴(→ 선택 모드 진입, §6)
   │   또는
   ├─ AppBar (선택 모드, §6)  다중 선택 시 전환
   ├─ body: MessageList (역방향 스크롤, 위로 스크롤 시 과거 메시지 이어받기)
   │   └─ MessageBubble        발신(ownedByViewer) 우측 정렬 / 수신 좌측 정렬
   ├─ TypingIndicator          transient, 대화 상대가 입력 중일 때만
   └─ MessageInputBar          텍스트 입력(최대 1000자) + 전송 버튼
```

### `MessageBubble`

DESIGN.md의 기존 채팅 규칙("발신 primary, 수신 surface")을 그대로 따른다.

- `ownedByViewer == true` → 우측 정렬, `primary` 배경 + `onPrimary` 텍스트.
- `ownedByViewer == false` → 좌측 정렬, `surfaceContainer`(또는 `surfaceContainerHigh`) 배경
  + `onSurface` 텍스트.
- **텍스트 전용** — 사진·파일 첨부 UI를 만들지 않는다(범위 밖, 설계 §5 명시).
- **수정·삭제 UI 없음** — 길게 눌러도 메시지 수정/삭제 메뉴가 뜨지 않는다. 대신 선택 모드
  (§6)만 연다.

### 전송 상태 (설계 §3, R9)

낙관적 전송 — 누르는 즉시 말풍선을 그리고, 상태에 따라 시각적으로 구분한다.

| 상태 | 표시 |
|---|---|
| 전송 중(sending) | 말풍선 옆/아래 작은 스피너 또는 반투명 처리 |
| 성공 | 일반 말풍선(스피너 제거) |
| 실패(failed) | **말풍선이 사라지지 않는다.** 옅은 붉은 테두리 또는 `errorContainer` 톤 + 오류 아이콘(`Icons.error_outline`, `error` 색) + **명시적 재시도 아이콘 버튼**(탭하면 재전송). 재시도 횟수는 상한이 있다(POL-040) — 상한 도달 시 재시도 버튼을 비활성화하고 "여러 번 시도했지만 실패했습니다" 류로 전환(SPEC-0015 §5의 재시도 상한 UI 패턴과 동일한 원칙) |

### `TypingIndicator` (설계 §5, R10 — 이 스펙에서 가장 틀리기 쉬운 지점)

- 대화 상단(입력창 바로 위) 또는 메시지 리스트 하단에 작은 텍스트 + 점 3개 애니메이션(또는
  간단한 텍스트 "○○ is typing…")으로 표시.
- **표시/해제는 타임아웃 기반이다** — 마지막 `TypingEvent` 수신 시각 + N초 안에 새 이벤트가
  없으면 자동으로 사라진다. 이벤트가 유실될 수 있어(전달 보장 없음), 이벤트만으로 켜고
  끄면 마지막 이벤트가 유실된 순간 영원히 "입력 중"에 갇힌다(설계 §5 핵심 제약). **UI
  컴포넌트 자체는 단순히 "보이거나 안 보이거나"만 그리고, 타임아웃 판정은 provider/notifier
  가 진다** — 이 문서는 시각 표현만 규정한다.
- `TypingIndicator`는 항상 공간을 예약하지 않는다 — 나타났다 사라질 때 레이아웃이 크게
  튀지 않도록 고정 높이 슬롯(빈 상태에서는 투명)을 권장.

### 메시지 입력 (`MessageInputBar`)

- 텍스트 필드 + 전송 아이콘 버튼. **최대 1000자** — 카운터는 커뮤니티 컴포저와 같은 90%
  임계값 표시 관례를 따르되, 이 화면은 짧은 메시지가 대부분이라 상시 카운터 없이 근접했을
  때만 노출해도 무방(갭으로 기록 — slice-builder 재량).
- 사진/파일 첨부 버튼 없음(범위 밖).

### 과거 메시지 이어받기

- 메시지는 **서버에서 최신순으로, 커서 페이징**으로 온다. 화면은 이를 뒤집어 아래(최신)가
  하단에 오도록 그리고, **위로 스크롤할 때** 다음 커서로 과거 메시지를 이어받는다(일반
  메신저 UX와 동일 — 커뮤니티의 `PaginationListView`가 아래로 스크롤할 때 로드하는 것과
  방향이 반대이므로, 이 화면은 리스트를 `reverse: true`로 두거나 별도의 "위로 스크롤 시
  로드" 트리거를 둔다 — 공용 `PaginationListView`를 그대로 쓸 수 없다, 갭으로 기록).

### 로컬 캐시 우선 표시 (설계 §7, R18)

- 대화를 열면 **로컬 캐시를 즉시 그리고**, 그 뒤에 서버 조회 결과를 얹는다 — 빈 화면을
  거치지 않는다(AC18-1). 이는 provider/repository 레벨 동작이며, 화면은 캐시 유무에 따라
  다른 스켈레톤을 그리지 않는다 — **캐시가 있으면 로딩 상태 자체가 거의 보이지 않는다**는
  것이 이 요구사항의 요지다.
- 캐시가 비어 있어도 서버 폴백으로 정상 동작(AC18-4) — 그때는 통상적인 로딩 스피너.
- 서버의 6개월 보관 정책이 로컬 기록을 지우지 않는다(AC18-3) — 화면은 "서버에 없는 메시지"
  구분 UI를 별도로 두지 않는다(사용자에게는 그냥 메시지로 보인다).

### 5.5 상태

| 상태 | 화면 |
|---|---|
| 최초 진입, 캐시 있음 | 캐시 즉시 표시, 서버 동기화는 배경에서(가시적 로딩 없음) |
| 최초 진입, 캐시 없음 | 표준 로딩 스피너 → 서버 결과 |
| 과거 메시지 이어받기 중 | 리스트 상단(과거 방향)에 작은 인라인 스피너 |
| 메시지 전송 중/실패 | §5 전송 상태 표 |
| 조회 실패(서버 동기화 실패, 캐시는 있음) | 캐시 내용은 그대로 유지하고 조용한 배너(예: "Couldn't refresh") — 화면을 비우지 않는다 |
| 대화 자체 조회 실패(캐시도 없음) | 중앙 오류 + 재시도 |

---

## 6. DM 메시지 다중 선택 신고 모드 (설계 §8, R15)

이 스펙에서 새로 설계가 필요한 화면이다 — 기존 단건 신고 시트로 표현되지 않는다.

```
ConversationScreen — 선택 모드 전환
└─ 진입: 메시지 롱프레스 또는 AppBar [⋮] 메뉴의 "Select messages"
└─ SelectionAppBar (일반 AppBar를 대체)
   ├─ 좌측: ✕(선택 모드 취소, 선택 내역 초기화)
   ├─ 중앙: "N selected"
   └─ 우측: [Report] 버튼 — 0건 선택 시 비활성
└─ MessageList (선택 모드 렌더)
   └─ MessageBubble + 체크박스/원형 선택 인디케이터
       └─ **자기 메시지는 선택 대상에서 제외** — 체크박스를 그리지 않거나
          탭해도 반응하지 않고 시각적으로 흐리게(선택 불가임을 알림)
```

- **선택 0건 → `[Report]` 버튼 비활성**(AC15-3, 핵심 제약) — 서버가 재차 거부하기 전에
  UX에서 막는다.
- **자기 메시지는 선택 불가**(AC15-5) — `MessageBubble`이 선택 모드에서 `ownedByViewer`를
  보고 체크박스 자체를 렌더하지 않거나 비활성 상태로 그린다. 롱프레스로 선택 모드를
  진입시키는 트리거도 자기 메시지에서는 동작하지 않게(또는 진입은 되지만 그 메시지는
  선택되지 않게) 한다.
- **대화 혼재는 화면 구조상 발생하지 않는다**(AC15-4) — 선택 모드가 `ConversationScreen`
  내부 상태이므로 다른 대화로 이동하면 선택 모드가 자동 해제된다(별도 방지 로직 불필요,
  화면을 벗어나며 provider가 폐기되는 것으로 충분).
- **선택된 메시지 시각 표시**: 배경색 강조(`primaryContainer` 톤) 또는 좌측 체크 아이콘.
  선택 모드에서는 말풍선을 탭해도 대화 액션(복사 등, 애초에 없음)이 아니라 선택 토글만
  일어난다.
- **`[Report]` 탭 → 커뮤니티의 `showReportSheet`(§2.7과 동일 컴포넌트) 재사용** — 사유
  하나를 골라 선택된 메시지 전체에 한 번에 적용한다(설계 §8 "여러 건을 골라 한 번에
  신고한다"). 새 신고 시트를 만들지 않는다.
- 제출 성공 후 선택 모드를 해제하고 일반 `AppBar`로 복귀, 완료 안내(스낵바).

### `SelectionAppBar` (`component/conversation_selection_app_bar.dart`)

일반 `ConversationScreen`의 `AppBar`(상대 닉네임 + 아바타 + `[⋮]`)와 **구조적으로 다른
컴포넌트**다 — 상대방 정보 대신 선택 개수를 보여주고, 메뉴 대신 취소/확인 액션을 둔다.
커뮤니티에는 선례가 없는 신규 패턴이므로, Material의 표준 "contextual action bar"
관례(선택 시 `AppBar`가 다른 배경색·다른 액션 세트로 전환)를 따른다.

---

## 7. 컴포넌트 요약 (`lib/domain/feed/component/`)

| 컴포넌트 | 역할 | 관련 절 |
|---|---|---|
| `discover_mode_toggle.dart` | 추천 ↔ 피드 세그먼트 토글, 헤더 전용(제스처 표면과 분리) | §1 |
| `messages_entry_button.dart` | 헤더의 DM 재진입 아이콘 + 미읽음 점 배지 | §1.5 |
| `feed_photo_pager.dart` | 1~5장 사진 가로 페이저 + 조건부 점 인디케이터 | §2 |
| `feed_author_bar.dart` | 아바타·닉네임·상대시각·DM 아이콘(피드 전용) | §2 |
| `feed_spot_chip.dart` | 연결된 스팟 — 탭 시 스팟 상세 이동 | §2 |
| `feed_like_button.dart` | 낙관적 좋아요 토글 + 카운트 | §2 |
| `feed_photo_picker.dart` | 컴포저의 사진 선택 스트립, 장별 업로드 실패 표시 | §3 |
| `feed_spot_field.dart` | 컴포저의 스팟 선택 표시 + 변경(스팟 피커 시트 재사용) | §3 |
| `conversation_tile.dart` | 대화 목록 한 줄 — 아바타·닉네임·미리보기·unreadCount·시각 | §4 |
| `message_bubble.dart` | 발신/수신 정렬, 전송중/실패/재시도 상태 표시 | §5 |
| `typing_indicator.dart` | transient 표시, 타임아웃 자동 해제(로직은 notifier) | §5 |
| `message_input_bar.dart` | 텍스트 입력(최대 1000자) + 전송 | §5 |
| `conversation_selection_app_bar.dart` | 다중 선택 모드 전용 앱바 — 개수·취소·신고 | §6 |

재사용(신규 컴포넌트를 만들지 않는 것): `showReportSheet`·`showSpotPickerSheet`
(`lib/domain/community/component/`), `PostPhoto`(CDN 키 변환), `relativeTimeSince`+l10n
매핑, `PaginationListView`(대화 목록 한정 — 대화 화면 자체의 "위로 스크롤 시 과거 이어받기"는
방향이 달라 별도 구현 필요, §5 갭 참조).

| 화면 | 라우트(제안) |
|---|---|
| 둘러보기 탭(토글 포함) | `/discover` (기존 라우트 유지, 위젯만 교체) |
| 피드 컴포저 | `/feed-composer` |
| 대화 목록 | `/conversations` |
| 대화 | `/conversations/:id` |

---

## 8. 다국어 (POL-022)

- UI 문구는 EN 우선 EN/KO/JA/ZH. `PostAuthor.nickname`·`PostSpot.title` 등 데이터 고유명사는
  서버가 `Accept-Language`에 맞춰 내려준다(POL-039) — 클라이언트 번역 파일에 넣지 않는다.
- **상대 시간("3m ago")은 클라이언트가 만든다** — 서버는 ISO-8601만 준다. §2.6의
  `relativeTimeSince` 재사용 규칙이 이 화면들 전체(피드·대화 목록·대화)에 적용된다.
- 신고 사유 라벨은 커뮤니티가 이미 쓰는 `ReportReason` l10n 매핑(`community_labels.dart`)을
  그대로 재사용 — 피드/DM 전용 사유 라벨 테이블을 새로 만들지 않는다.

---

## 갭 / 미확정

- ~~**피드 컴포저에서 업로드 실패한 사진이 있을 때 제출 가능 여부**~~ — **닫힘.**
  `feedComposerProvider.submit()`이 이미 규칙을 쥐고 있어 화면은 그 결과만 그린다:
  한 장이라도 올라가면 그 장들로 등록하고 실패한 장을 **이름으로** 알리며
  (`FeedComposerSucceeded.failedPhotoNames`), 한 장도 못 올리면 등록 자체를 하지 않고
  (`FeedComposerPhotosFailed`) **화면을 닫지 않아 입력이 보존된다**. 사진이 필수라는
  요건(R2)과 어긋나지 않으면서 사용자가 쓴 글을 버리지 않는 쪽이다.
- ~~**본문 접기/펼치기 줄 수**~~ — **닫힘.** 3줄 유지. 다만 "접힌 상태면 항상 더보기"를
  걷어내고 `TextPainter.didExceedMaxLines`로 **실제로 넘칠 때만** 그린다 — 한 줄짜리
  글에도 눌러도 아무 일이 없는 "더보기"가 뜨던 문제(사용자 보고)를 고쳤다. 펼친 뒤에는
  "접기"로 되돌아간다.
- **대화 화면의 과거 메시지 이어받기**를 공용 `PaginationListView`로 감쌀지, 역방향 전용
  구현을 별도로 둘지 — 방향이 기존 공용 컴포넌트와 반대라 그대로 못 쓴다(§5).
- **피드 소진 시 별도 안내 문구 유무** — 스펙에 요구 없음, 이 문서는 "마지막 페이지가
  계속 보이는 것"을 기본으로 권장(§2.5).
- **unreadCount 두 자리 초과 시 "9+" 표기 여부** — 스펙에 상한 규정 없음, 관례로 제안(§4).
- **프리페치 개수(N)** — 3으로 두었으나 실기기 확인은 남아 있다(§2).
- **`ReportTargetType` 전수 분기 지점 점검** — 기존 코드베이스에서 `switch`로 이 열거값을
  다루는 곳을 찾아 `FEED_ITEM` 추가에 대비한 기본 분기를 두는 작업이 필요(§2.7, 설계 §8).
  이 문서는 위치를 지정하지 않았다 — slice-builder가 grep으로 확인.
- **Stitch 목업 부재** — §0 참조. 서비스 복구 시 생성해 이 문서와 대조하고 스크린 id를 채운다.
