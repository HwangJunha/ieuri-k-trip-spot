# SPEC-0032 — 전체 유지보수 패스(디자인 버그 정리)

상태: 구현 완료(2026-08-24)

사용자가 실기기에서 발견한 디자인·동작 버그 11건을 한 번에 정리한다. 새 기능은
없고 서버 계약 변경도 없다 — `.graphql` 오퍼레이션은 하나도 손대지 않았으므로
§13 라이브 스윕 대상이 아니다.

## 처리한 항목

| # | 증상 | 원인 | 손댄 곳 |
|---|---|---|---|
| 1 | 앱 아이콘이 기본 Flutter 로고 | 브랜드 SVG(`asset/icon/app-icon.svg`)는 있었지만 런처 아이콘으로 렌더된 적이 없음 | iOS 15종 + Android 5종 재생성 |
| 2 | 카드 하단 정보가 탭 바에 붙음 | `_base` 하단 여백 36 | `swipe_card_metrics.dart` 36 → 52 |
| 3 | secondary(주황) 컬러가 섞여 보임 | 스킴의 secondary 역할이 주황 계열 | `app_theme.dart`/`app_colors.dart`에서 secondary 계열을 primary 톤으로 통일 |
| 4 | 글 등록 후 내가 쓴 글 목록이 안 바뀜 | 빈 상태의 "첫 글 쓰기"가 컴포저 결과를 안 받고 invalidate도 안 함 | `my_posts_screen.dart` |
| 5 | 좋아요·내 질문 목록에 당겨서 새로고침 없음 | 좋아요는 `onRefresh` 미전달, 내 질문은 await 누락으로 스피너가 즉시 걷힘 | `liked_spots_screen.dart`, `my_questions_screen.dart` |
| 6 | 좋아요/커뮤니티 토글이 자리를 많이 먹음 | 앱바 아래 폭 전체 세그먼트 버튼(48px) | `library_screen.dart` → 우측 상단 아이콘 버튼 |
| 7 | '보관함'이라는 이름이 안 맞음 | — | `navLibrary` 4개 로케일 → 내 활동/My Activity, 아이콘 북마크 → 사람 |
| 8 | 스와이프가 뻑뻑함, 상하 불가 | **애니메이션 컨트롤러가 아예 없었다** — 스프링백이 `_dragX = 0` 순간 이동 | `discover_swipe_view.dart`, `swipe_drag.dart`, `drag_feedback_overlay.dart` |
| 9 | 글 상세에서 하트가 안 눌림 | 상세가 `PostCard`에 `onLike`를 안 넘겨 `InkWell(onTap: null)` | `post_detail_providers.dart`, `post_detail_screen.dart` |
| 10 | 채팅에 프로필이 없음 | 데이터(`profileImageUrl`)는 이미 도착해 있었고 위젯만 없었음 | `common/widget/author_avatar.dart`(신규), 말풍선·앱바·목록 타일 |
| 11 | 신고 선택 동그라미가 안 눌림 | 동그라미가 `InkWell` 밖의 순수 `Icon` — 말풍선만 탭 대상이었음 | `message_bubble.dart` |

## 단독으로 정한 것

- **상하 스와이프는 기존 반응에 매핑한다.** 서버 `SpotReaction`은 `LIKE`/`DISLIKE`
  둘뿐이라(`spot_schema.graphql:23-26`) 세 번째 반응을 만들면 스키마를 바꿔야 한다.
  방향만 넷으로 늘리고 **위=LIKE, 아래=DISLIKE**로 보낸다. 슈퍼라이크 같은 별도
  의미가 필요해지면 그때 서버에 요청한다.
- **세로 확정 임계는 가로보다 작다**(높이의 18% vs 폭의 28%). 엄지를 위아래로 미는
  거리가 좌우보다 짧아, 같은 비율이면 세로가 훨씬 무겁게 느껴진다.
- **날아가기 240ms.** 이 시간이 끝나야 다음 카드가 올라오므로 길면 연속 스와이프가
  곧바로 굼떠진다. 반응(`swipe()`)은 모션이 끝난 뒤에 보낸다 — 먼저 보내면 큐가
  즉시 다음 장을 올려 **엉뚱한 카드가 날아간다**.
- **`postDetail`을 클래스 노티파이어로 바꿨다.** 함수형 provider는 상태를 밖에서
  못 바꿔 낙관적 갱신이 불가능하다. provider 이름·family 시그니처는 그대로라
  기존 호출부 8곳은 영향이 없다. 목록의 `FeedController.toggleLike`를 재사용하지
  않은 이유는 그쪽이 `items`에서 postId를 찾는 구조여서, 상세로 딥링크 진입하면
  `indexWhere`가 -1이라 조용히 아무 일도 하지 않기 때문이다.
- **'내 활동'을 탭 이름으로 골랐다.** 이 탭은 좋아요한 장소와 커뮤니티 활동을 함께
  묶으므로, '보관함'은 저장해 둔 것만 있는 것처럼 읽힌다.
- **DM 대화방(메시지 목록)에는 당겨서 새로고침을 넣지 않았다.** `reverse: true`라
  아래로 당기면 최신 방향이고 인디케이터가 화면 밑에서 나온다 — 채팅에서 관례가
  아니다. 대화 **목록**에는 이미 있다.
- **`score_breakdown`의 막대는 `primaryContainer`로 옮겼다.** secondary가 primary와
  같아지면서 원래 주석이 요구하던 "강점 라벨과 색을 나눈다"가 깨지기 때문이다.

## 확인하지 못한 것

- **실기기 육안 확인은 사용자 몫이다.** 하단 여백 52가 충분한지, 새 아이콘이 홈
  화면에서 어떻게 보이는지, 스와이프 손맛(스프링 강성 420/감쇠 26)이 원하는
  수준인지는 시뮬레이터 밖에서 봐야 한다.
- 다크 스킴의 secondary 톤은 시드 파생값을 그대로 primary 자리에 넣은 것이라
  라이트만큼 손으로 맞추지 않았다. Stitch 다크 톤이 나오면 함께 정리한다.
