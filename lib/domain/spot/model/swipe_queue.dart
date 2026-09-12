import '../../../common/model/list_equality.dart';
import 'tourist_spot.dart';

/// Discover 스와이프 카드 스택의 상태(spec §4). SwipeController가 노출하는 값으로,
/// 남은 카드 큐와 보충 진행 상태를 담는다. 순수 도메인.
///
/// 소스가 둘이다(SPEC-0035):
/// - **전체(`spots`)** — 오프셋 페이지네이션. [loadedPage]가 마지막으로 받은 페이지
///   번호(0-based)이고 다음 선제 조회는 [nextPage]를 넘긴다.
/// - **추천(`recommendedSpots`)** — 묶음. 페이지가 없어 [loadedPage]가 null이다.
///   보충은 같은 인자로 다시 부르고, [hasNextPage]는 "더 부를 만한가"(직전 묶음이
///   가득 찼고 새 카드가 있었는가)를 뜻한다.
///
/// 두 소스가 공유하는 것은 [cards]·[hasNextPage]·[isExhausted]뿐이라 한 타입으로
/// 두되, 페이지 번호는 nullable로 남겨 묶음 소스에서 의미 없는 값을 지어내지 않는다.
///
/// [cards]의 첫 번째가 맨 위(사용자가 지금 보는) 카드이며, 스와이프 시 앞에서 제거한다.
class SwipeQueue {
  const SwipeQueue({
    required this.cards,
    required this.loadedPage,
    required this.hasNextPage,
  });

  /// 현재 스택. `cards.first`가 맨 위 카드.
  final List<TouristSpot> cards;

  /// 지금까지 이어 붙인 마지막 페이지 번호(0-based). **추천 묶음 소스에서는 null**
  /// — 페이지라는 개념이 없다.
  final int? loadedPage;

  /// 더 받을 것이 있는지. false + 큐 소진이면 빈 상태로 넘어간다.
  final bool hasNextPage;

  /// 다음 선제 조회에 넘길 페이지 번호. 다음이 없거나 묶음 소스면 null.
  int? get nextPage {
    final int? page = loadedPage;
    return hasNextPage && page != null ? page + 1 : null;
  }

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

  /// 카드·다음 여부만 바꾼 큐. [loadedPage]는 그대로다 — 묶음 소스의 null을 `??`로
  /// 덮어쓸 일이 없도록 이 메서드는 페이지 번호를 받지 않는다(페이지를 진행할 때는
  /// 생성자로 새로 만든다).
  SwipeQueue copyWith({List<TouristSpot>? cards, bool? hasNextPage}) =>
      SwipeQueue(
        cards: cards ?? this.cards,
        loadedPage: loadedPage,
        hasNextPage: hasNextPage ?? this.hasNextPage,
      );

  @override
  bool operator ==(Object other) =>
      other is SwipeQueue &&
      listEquals(other.cards, cards) &&
      other.loadedPage == loadedPage &&
      other.hasNextPage == hasNextPage;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(cards), loadedPage, hasNextPage);
}
