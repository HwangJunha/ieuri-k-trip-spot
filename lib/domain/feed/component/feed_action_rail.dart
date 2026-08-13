/// 피드 화면 우측 하단 버튼 줄(좋아요·작성)이 떠 있는 내비게이션 바 위로 얼마나
/// 올라오는지.
///
/// **한 곳에 둔다.** 좋아요는 `feed_item_page`, 작성 버튼은 `feed_scroll_view`에
/// 있어 각자 숫자를 들면 한쪽만 고쳐질 때 조용히 겹친다 — 실제로 겹쳤다.
///
/// 안전영역은 여기 포함하지 않는다. `FloatingBottomNavScaffold.barExtent`에도
/// 없어서 쓰는 쪽이 `MediaQuery.paddingOf(context).bottom`을 함께 더한다.
library;

const double feedActionRailLift = 20;

/// 둘러보기 헤더(타이틀 + 토글)가 차지하는 높이. 안전영역은 제외한 값이다.
///
/// **피드 항목의 작성자 줄이 이만큼 아래에서 시작해야 한다.** 헤더는 항목 위에
/// 겹쳐 그려지므로 작성자 줄을 화면 맨 위에 두면 헤더가 그 위를 덮고, `Stack`의
/// 히트 테스트는 위에 있는 것이 먼저 가져가므로 DM 아이콘 탭이 헤더에 삼켜진다 —
/// "화살표가 안 눌린다"의 원인이 이 겹침이었다.
///
/// 헤더는 `view/`에 있지만 값은 `component/`에 둔다 — 컴포넌트가 화면을 import하면
/// 계층 방향이 뒤집힌다(CLAUDE.md §3).
const double discoverHeaderExtent = 96;
