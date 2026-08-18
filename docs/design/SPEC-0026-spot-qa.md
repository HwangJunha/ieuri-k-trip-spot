# 디자인 참조 — 장소 질문/답변 (SPEC-0026)

> 설계 문서: `problem/SPEC-0026-client.md` · 수용 기준: `Specs/SPEC-0026/spec.md` (R1~R16, AC-*)
> Stitch 프로젝트: `projects/8651053354437738829` (K-Trip Spot Design System)
> 디자인 시스템: `assets/073fee5b990e4b1eb2c918d7e9de2d8f`
> Stitch 화면 — **작성(정상)**: `screens/af479788e45e42658cd54ead6f7027ac`
> Stitch 화면 — **작성(자격 없음 오류)**: `screens/1270f80158114e4b8a4b846393959d6b`
> Stitch 화면 — **질문 목록 / 질문 상세**: **생성 대기(pending)** — 아래 §5 참조

이 문서는 **레이아웃·컴포넌트 분해 참조**다. 수용 기준과 어긋나면 스펙이 이긴다.
색·폰트·간격 값은 여기 적힌 것을 복사하지 말고 `Theme.of(context)`에서 읽는다(DESIGN.md §12).
**폰트 패밀리는 지정하지 않는다** — Stitch 디자인 시스템은 Plus Jakarta Sans / Be Vietnam
Pro를 쓰지만, 앱은 CJK를 커버하는 Noto Sans(+ 폴백)를 쓴다. `app_theme.dart`가 결정할 몫이며
이 문서는 타입 스케일(제목/본문/라벨 크기 위계)만 참고한다.

---

## 0. 화면 인벤토리 (3개)

| 화면 | 라우트(제안) | 진입 |
|---|---|---|
| 질문 목록 | `/spot/:spotId/qa` | 장소 상세의 「What's it like here right now?」 — 질문이 있을 때 |
| 질문 상세 | `/spot/:spotId/qa/:questionId` | 질문 목록 카드 탭 |
| 작성 | `/spot/:spotId/qa/compose` | 「What's it like here right now?」 — 질문이 없을 때, 또는 목록의 Ask FAB |

진입점 버튼은 장소 상세(`lib/domain/spot/view/spot_detail_view.dart`)의
`AttributionBlock` 아래, `DetailReactionBar` 사이 또는 바로 아래에 놓는다(스펙 §진입점).
**자격(좋아요) 없고 질문도 없으면 버튼 자체를 숨긴다** — `showSpotQaEntry()`
(`lib/domain/spot_qa/model/spot_qa_eligibility.dart`)가 그 판정이다.

---

## 1. 질문 목록 화면

**Stitch 목업 생성이 시간 내 완료되지 않았다** — 두 차례 요청 모두 "operation timed out"을
반환했고 이후 폴링(`get_project`)에서도 캔버스 인스턴스에 새 화면이 나타나지 않았다
(CLAUDE.md §11.6에 따라 재시도하지 않았다). 아래는 스펙·기존 커뮤니티 목록
(`docs/design/SPEC-0010-community-spot-talk.md` §1)의 검증된 패턴을 그대로 적용한
레이아웃 기술이다 — 손으로 그린 목업이 아니라 텍스트 명세다.

```
SafeArea
├── AppBar: 뒤로가기 + "Questions" 제목 + 장소명 서브타이틀(작게)
├── 목록 (얇은 구분선, 그림자 없음 — 당근 동네생활 스타일 그대로 계승)
│   ├── SpotQuestionCard × N
│   └── 커서 페이지네이션 (기본 20건, PaginationListView 재사용)
└── FAB "Ask" — 하단 내비 바 위, FloatingBottomNavScaffold.barExtent + 여백
    (SPEC-0010과 동일한 상수 참조 방식, 값을 화면에 복사하지 않는다)
```

### `SpotQuestionCard`

```
┌────────────────────────────────────────────┐
│ (avatar) 닉네임 · 2h ago                    │
│ 질문 본문 (2~3줄, ellipsis)                  │
│                         💬 3 answers  ✓Resolved │
└────────────────────────────────────────────┘
```

- 작성자 아바타(없으면 이니셜) + 닉네임 + 상대시각. 상대시각은 SPEC-0010과 같은
  `relativeTimeSince` 순수 함수 재사용을 제안한다(모델은 번역을 모른다).
- 본문은 `SpotQuestion.body` 2~3줄 truncate.
- 답변 수 pill: `SpotQuestion.answerCount` + 말풍선 아이콘.
- `resolved`일 때만 체크 아이콘 + "Resolved" 배지.
- **`resolved == true`인 카드는 낮은 명도로 구분한다** — opacity 완화 또는 `on-surface-variant`
  톤 사용. 숨기지 않는다(스펙 결정 §7). 비활성처럼 보일 정도로 낮추지 않는다 — 여전히
  탭 가능하고 정보 가치가 있다.
- `SpotQuestion.hidden == true`는 작성자 본인에게만 오고(§작성자만 본다), 그 경우 "Hidden by
  report" 배지를 얹는다(커뮤니티의 `Post.hidden` 배지와 동일한 취급).

### 정렬 UI 없음

서버가 미해결 우선·최신순으로 고정한다(스펙 결정 §6). 정렬 토글·드롭다운을 두지 않는다 —
SPEC-0010의 `FeedSortToggle`과 달리 이 화면에는 그 자리 자체가 없다.

### 상태

| 상태 | 화면 |
|---|---|
| 로딩 | 목록 자리에 스켈레톤/스피너 |
| 빈 목록 | 일러스트 + "No questions yet — be the first to ask" + "Ask a question" 버튼(바로 작성 이동) |
| 오류 | 재시도 가능한 오류 상태(네트워크/알 수 없음). 목록이 비었다고 오인하지 않도록 별도 화면 |
| 다음 페이지 로딩 | 목록 하단 인라인 스피너 |
| 다음 페이지 오류 | 하단에 "Retry" 인라인 — 이미 로드된 페이지는 유지 |

읽기는 비로그인 포함 누구에게나 열려 있다(AC-1.4) — 이 화면 전체에 로그인 게이트를 걸지 않는다.

---

## 2. 질문 상세 화면

**이 화면도 Stitch 생성이 시간 내 완료되지 않았다** (§1과 동일 사유, pending). 아래는
스펙 R7과 커뮤니티 글 상세(`docs/design/SPEC-0010-community-spot-talk.md` §3)의 댓글/대댓글
패턴을 그대로 옮긴 레이아웃 기술이다.

```
SafeArea
├── AppBar: 뒤로가기 + "Question" + 우측 ⋮ (질문 신고)
├── 질문 블록
│   ├── avatar + 닉네임 + 상대시각
│   ├── 본문 전문 (truncate 없음)
│   ├── "Resolved" 배지(resolved일 때, 낮은 명도)
│   └── "Mark as resolved" 텍스트 버튼 — SpotQuestion.ownedByViewer && !resolved 일 때만
├── 구분선
├── "Answers · N" 섹션 헤더 (N = answerCount 또는 로드된 답변 수)
├── SpotAnswerTile 목록 (커서 페이지네이션)
│   └── 답변마다 들여쓰기된 SpotAnswerReplyTile 목록 (답변에 동봉되어 옴, 페이지네이션 없음)
├── "Load more answers" (다음 커서 있을 때만)
└── 하단 고정 컴포저: 둥근 텍스트 입력 "Write an answer..." + 전송 버튼
```

### `SpotAnswerTile`

```
┌──────────────────────────────────────────┐
│ (avatar) 닉네임 · 1h ago              [⋮] │
│ 답변 본문 전문                              │
│ [Message]  [Report]                       │
│    └ SpotAnswerReplyTile (들여쓰기 32~40px)│
│    └ SpotAnswerReplyTile                  │
│ [Reply]                                   │
└──────────────────────────────────────────┘
```

- `Message`: 답변 작성자에게 DM 시작(`lib/domain/dm/provider/conversation_start_providers.dart`
  기존 provider 재사용, `sourceAnswerId`를 함께 전달). 자기 자신의 답변에는 노출하지 않는다
  (`ownedByViewer`).
- `Report`: 기존 `showReportSheet`/`ReportReason` 재사용, 대상 타입만 `SPOT_ANSWER`.
- `⋮`(overflow) 대신 Message/Report/Reply를 텍스트 액션 행으로 노출해도 된다 — 커뮤니티의
  ⋮ 시트 패턴과 달리 이 화면은 답변 아래 액션이 이미 소수(2~3개)라 인라인이 자연스럽다.
  단, 본인 답변엔 "Delete"가 필요하면 ⋮로 분리해도 무방하다(스펙에 명시 없음 — 갭, §6 참조).
- `Reply` 버튼은 **답변에만** 있다. 눌러 인라인 입력을 열고, 제출하면 그 답변의 `replies`에 붙는다.

### `SpotAnswerReplyTile`

```
   └ (작은 avatar) 닉네임 · 30m ago
     답글 본문
     [Message]  [Report]
```

- **Reply 액션이 없다** — `SpotAnswerReply`에 `replies` 필드가 없어 타입 수준에서도 답글에
  답글을 달 수 없다(모델 주석과 일치). 타일에 그 버튼 자체를 그리지 않는다.
- Message/Report는 답변과 동일하게 제공한다(스펙 §DM 연결, §신고·차단).
- 삭제된 부모 답변에 달린 답글도 그대로 그린다(SPEC-0010의 "삭제된 부모의 답글도 그린다"와
  같은 원칙 — 이 스펙에 답변 삭제가 명시되진 않았으나 향후 갭으로 남긴다, §6).

### 낙관적 갱신 — "Mark as resolved"만

탭 즉시 `resolved: true`로 반영하고, 실패 시 되돌리지 않는다(스펙: "되돌리기가 없고 실패
확률이 낮다"). 버튼은 성공 후 사라진다(다시 해제할 수단이 없다 — 서버에 뮤테이션 자체가 없음).

### 답변/답글 작성은 낙관적 갱신 없음

전송 버튼 탭 후 서버 응답을 기다린 뒤 목록에 반영한다. 자격 없음(`NOT_ELIGIBLE_TO_ANSWER`)
거부 시 컴포저를 닫지 않고 인라인 안내를 띄운다(§4 참조, 작성 화면과 동일한 원칙을 답변
컴포저에도 적용).

### 상태

| 상태 | 화면 |
|---|---|
| 로딩 | 질문 블록 스켈레톤 |
| 답변 목록만 실패 | 질문 본문은 그대로 두고 답변 영역에만 재시도 (댓글과 글이 다른 provider인
  SPEC-0010 원칙과 동일 — 이 스펙에서도 질문 조회와 답변 페이지는 분리해 둔다) |
| 답변 없음 | "No answers yet" 안내, 컴포저는 그대로 노출(첫 답변을 유도) |
| 질문 자체 조회 실패 | 재시도 가능한 오류 화면 |

읽기(질문 본문 + 답변 + 답글)는 로그인 여부와 무관하게 전부 보인다. **쓰기만** 게이트된다 —
비로그인 상태에서 답변/답글 컴포저를 탭하면 로그인 유도로 분기한다(질문 작성과 동일한 취급).

---

## 3. 작성 화면 ("Ask a Question")

**Stitch 생성 완료.** 정상 상태 `screens/af479788e45e42658cd54ead6f7027ac`,
자격 없음 오류 상태 `screens/1270f80158114e4b8a4b846393959d6b`.

```
SafeArea
├── 상단 바: ✕ 닫기 (좌) · "New Question" (중앙) · "Post" 텍스트 버튼 (우, primary,
│            본문 비어 있으면 비활성)
├── 컨텍스트 칩(읽기 전용): "Asking about: <spot 썸네일 아이콘> <spot 이름>"
├── (자격 거부 시에만) 인라인 배너: "You need to like this spot to ask a question here"
│   — warning 톤, 배너가 나타나도 아래 입력창의 텍스트는 그대로 유지된다
├── 테두리 없는 멀티라인 텍스트 영역 (expands: true, 남은 공간 전부)
│   placeholder: "What do you want to know about this place right now?
│                 (e.g. crowd level, weather, parking)"
└── 하단 우측: 글자수 카운터 — 90% 근접부터 노출 (예: "480/500")
```

- **사진 첨부 UI 없음.** 카메라·갤러리 아이콘, 사진 그리드 어느 것도 그리지 않는다 — 서버에
  업로드 뮤테이션이 없다(스펙 §사진 첨부). 작성 뮤테이션에는 `photoKeys: []`를 보낸다(구현
  세부, 이 문서의 관심사 아님).
- 컴포저 스타일은 SPEC-0010의 글 작성 화면(§2 "화면을 가득 쓰는 배치")과 동일한 원칙 —
  테두리 있는 짧은 입력칸을 쓰지 않는다.
- **글자 수는 코드포인트 기준**(SPEC-0010과 동일 원칙 — UTF-16 length로 세면 이모지 포함
  본문에서 서버와 어긋난다). 본문 상한은 `SpotQuestion.body`의 1~500자 제약을 따른다.
- 길이를 넘겨도 입력을 자르지 않는다 — Post가 막히고 초과분이 카운터에 드러난다.

### 자격 거부 처리 (핵심 — 스펙 §11)

**서버가 `NOT_ELIGIBLE_TO_ASK`로 거부해도 화면을 닫지 않는다.** 배너를 텍스트 영역 위에
띄우고, 사용자가 입력한 본문은 그대로 남긴다. 진입 시점엔 이미 자격 있는 사용자만
이 화면에 왔겠지만(진입점 자체가 숨겨짐), 다른 기기에서 좋아요가 풀린 경우를 반드시
처리한다(스펙: "이것은 UX이지 방어가 아니다").

배너 문구는 다음 행동을 알려준다 — "좋아요하면 질문할 수 있다"는 것을 명시한다(단순 오류
코드 노출 금지).

### 상태

| 상태 | 화면 |
|---|---|
| 초기 | 빈 텍스트 영역, Post 버튼 비활성 |
| 입력 중 | Post 버튼 활성(비공백), 카운터는 90% 전엔 숨김 |
| 제출 중 | Post 버튼에 인라인 스피너 또는 비활성 처리(중복 제출 방지) |
| 자격 거부 | 인라인 배너 노출, 입력 보존, 화면 유지 |
| 비로그인 진입 | 애초에 진입점이 숨겨지므로 이 화면에 정상 진입할 경로가 없다 — 그래도
  직접 라우팅될 경우 로그인 유도로 분기 |
| 네트워크 오류 | 스낵바 "다시 시도" + 입력 보존 |

---

## 4. 답변/답글 인라인 컴포저 (질문 상세 화면 내부)

별도 화면이 아니라 §2의 하단 고정 바 / Reply 인라인 입력이다. 작성 화면과 같은 원칙을 따른다:

- 사진 첨부 없음(텍스트만).
- `NOT_ELIGIBLE_TO_ANSWER` 거부 시 입력을 지우지 않고 인라인 안내(작은 배너 또는 스낵바)만
  띄운다 — 컴포저를 접지 않는다.
- 낙관적 갱신 없음 — 응답 확인 후 목록에 반영.

---

## 5. Stitch 생성 미완료 화면에 대한 기록

2026-08-18 세션에서 질문 목록·질문 상세 두 화면을 `generate_screen_from_text`로 각 1회
요청했다(재시도하지 않음, CLAUDE.md §11.6). 두 요청 모두 "The operation timed out"을
반환했고, 응답에 screen id가 포함되지 않아 이후 `get_screen`으로 추적할 수 없었다. 같은
세션에서 `get_project`를 두 차례(요청 직후, 약 1시간 간격) 재조회했으나 `screenInstances`
목록에 새 화면이 나타나지 않았다 — 작성 화면(동일 배치에서 성공한 두 번째 요청)은 정상
등록된 것과 대비된다.

**타임아웃이 실패를 의미하지 않는다는 원칙은 유지한다** — 다음 세션에서 프로젝트 id
`8651053354437738829`로 `get_project`를 다시 확인하면 두 화면이 뒤늦게 나타날 수 있다.
그때까지 §1·§2의 텍스트 레이아웃 명세가 `slice-builder`의 근거이며, 손으로 그린 목업으로
대체하지 않았다.

---

## 6. 갭 / 미확정

- **답변/답글 삭제 UI가 스펙에 없다.** `ownedByViewer`가 모델에 있지만 삭제 뮤테이션·액션이
  스펙 R1~R16에 언급되지 않는다. 이번 설계는 삭제 버튼을 그리지 않는다 — 필요해지면 커뮤니티의
  `confirmDeletePost` 패턴을 그대로 재사용할 수 있다.
- **질문 삭제 UI도 스펙에 없다.** 마찬가지로 미포함.
- **사진 첨부는 서버 미구현으로 전체 보류**(스펙 §사진 첨부) — 첨부 피커·사진 그리드
  컴포넌트는 이 설계에 존재하지 않는다. 서버가 3종 업로드 뮤테이션을 구현하면 스펙과 이 문서를
  함께 갱신한다.
- **질문 목록·질문 상세의 Stitch 목업이 아직 없다**(§5). 텍스트 레이아웃 명세로 대체했다.
- **답변 컴포저의 "자격 거부" 표시 위치**(인라인 배너 vs 스낵바)는 스펙에 규정이 없어 이
  문서가 임의로 제안했다 — `slice-builder` 구현 시 질문 작성 화면과 시각적으로 통일한다.
