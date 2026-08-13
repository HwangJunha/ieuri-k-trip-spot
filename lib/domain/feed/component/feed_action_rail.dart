/// 피드 화면 우측 하단 버튼 줄(좋아요·작성)이 떠 있는 내비게이션 바 위로 얼마나
/// 올라오는지.
///
/// **한 곳에 둔다.** 좋아요는 `feed_item_page`, 작성 버튼은 `feed_scroll_view`에
/// 있어 각자 숫자를 들면 한쪽만 고쳐질 때 조용히 겹친다 — 실제로 겹쳤다.
///
/// 안전영역은 여기 포함하지 않는다. `FloatingBottomNavScaffold.barExtent`에도
/// 없어서 쓰는 쪽이 `MediaQuery.paddingOf(context).bottom`을 함께 더한다.
library;

const double feedActionRailLift = 24;
