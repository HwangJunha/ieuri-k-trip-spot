import '../../../common/model/list_equality.dart';
import 'tourist_spot.dart';

/// Discover 스와이프 카드 스택의 상태(spec §4). SwipeController가 노출하는 값으로,
/// 남은 카드 큐와 커서 페이지네이션 진행 상태(마지막 묶음의 `endCursor`·다음 묶음
/// 존재 여부)를 담는다. 순수 도메인.
///
/// SPEC-0035에서 오프셋(페이지 번호)에서 **커서**로 옮겼다. 이어 받기는 [endCursor]를
/// `after`로 넘기며, 커서는 첫 조회의 조건(좌표·반경·카테고리·언어)에 묶여 있다 —
/// 조건이 바뀌면 컨트롤러가 재빌드되어 커서 없는 첫 요청부터 다시 한다.
///
/// [cards]의 첫 번째가 맨 위(사용자가 지금 보는) 카드이며, 스와이프 시 앞에서 제거한다.
class SwipeQueue {
  const SwipeQueue({
    required this.cards,
    required this.hasNextPage,
    this.endCursor,
  });

  /// 현재 스택. `cards.first`가 맨 위 카드.
  final List<TouristSpot> cards;

  /// 다음 묶음 존재 여부. false + 큐 소진이면 빈 상태로 넘어간다.
  final bool hasNextPage;

  /// 마지막으로 받은 묶음의 `pageInfo.endCursor`. 다음 선제 조회의 `after`다.
  /// [hasNextPage]가 false면 보통 null이다.
  final String? endCursor;

  /// 이어 받을 수 있는지 — 다음 묶음이 있고 넘길 커서도 있을 때만이다.
  ///
  /// `hasNextPage: true`인데 커서가 없는 응답은 계약 위반이지만, 그 경우 `after: null`로
  /// 보내면 첫 묶음을 또 받아 같은 카드가 되풀이되므로 이어 받지 않는 쪽이 안전하다.
  bool get canLoadMore => hasNextPage && endCursor != null;

  /// 스택이 비었고 더 가져올 게 없는 소진 상태 여부(spec §4 — 자동 재조회 안 함).
  bool get isExhausted => cards.isEmpty && !hasNextPage;

  /// 맨 위 카드, 비었으면 null.
  TouristSpot? get top => cards.isEmpty ? null : cards.first;

  /// [spotId] 카드를 스택에서 제거한 큐(SPEC-0007 §4.2·§4.3). 서버에서 사라진
  /// 축제를 만났을 때 다시 나타나지 않게 하는 용도로, 없는 id면 그대로 돌려준다.
  SwipeQueue removeCard(String spotId) {
    final List<TouristSpot> remaining = cards
        .where((TouristSpot spot) => spot.id != spotId)
        .toList(growable: false);
    return remaining.length == cards.length ? this : copyWith(cards: remaining);
  }

  /// 카드만 바꾼 큐. 페이지 진행 상태(커서·다음 여부)는 그대로다 — 묶음을 이어 붙일
  /// 때는 커서가 null로 바뀔 수 있으므로 `copyWith`가 아니라 생성자로 새로 만든다.
  SwipeQueue copyWith({List<TouristSpot>? cards}) => SwipeQueue(
    cards: cards ?? this.cards,
    hasNextPage: hasNextPage,
    endCursor: endCursor,
  );

  @override
  bool operator ==(Object other) =>
      other is SwipeQueue &&
      listEquals(other.cards, cards) &&
      other.hasNextPage == hasNextPage &&
      other.endCursor == endCursor;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(cards), hasNextPage, endCursor);
}
