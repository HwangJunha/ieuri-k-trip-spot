import '../../../common/model/list_equality.dart';
import 'tourist_spot.dart';

/// Discover 스와이프 카드 스택의 상태(spec §4). SwipeController가 노출하는 값으로,
/// 남은 카드 큐와 오프셋 페이지네이션 진행 상태(마지막으로 받은 페이지 번호·다음
/// 페이지 존재 여부)를 담는다. 순수 도메인.
///
/// 서버가 커서를 지원하지 않아 페이지 번호(0-based)로 이어 조회한다. [cards]의
/// 첫 번째가 맨 위(사용자가 지금 보는) 카드이며, 스와이프 시 앞에서 제거한다.
class SwipeQueue {
  const SwipeQueue({
    required this.cards,
    required this.loadedPage,
    required this.hasNextPage,
    this.originExhausted = false,
  });

  /// 원문(`hasOrigin: true`) 구간을 다 받았는지(SPEC-0019).
  ///
  /// 서버가 원문과 번역본을 갈라 주며 두 집합은 겹치지 않는다. 원문을 먼저 소진한 뒤
  /// 번역본으로 넘어가는데, **각 구간이 자기 페이지 번호를 가진다** — 번역본으로
  /// 전환할 때 페이지를 0부터 다시 세어야 앞쪽을 건너뛰지 않는다.
  ///
  /// false면 다음 조회는 원문, true면 번역본이다.
  final bool originExhausted;

  /// 현재 스택. `cards.first`가 맨 위 카드.
  final List<TouristSpot> cards;

  /// 지금까지 이어 붙인 마지막 페이지 번호(0-based). 다음 선제 조회는
  /// [nextPage]를 넘긴다.
  final int loadedPage;

  /// 다음 페이지 존재 여부. false + 큐 소진이면 빈 상태로 넘어간다.
  final bool hasNextPage;

  /// 다음 선제 조회에 넘길 페이지 번호. 다음이 없으면 null.
  ///
  /// **원문을 다 받았고 아직 번역본으로 넘어가기 전이면 0이다** — 번역본은 별개의
  /// 결과 집합이라 페이지를 처음부터 센다(SPEC-0019).
  int? get nextPage {
    if (hasNextPage) return loadedPage + 1;
    return originExhausted ? null : 0;
  }

  /// 다음 조회에 넘길 `hasOrigin`. 원문 구간이면 true, 번역본 구간이면 false다.
  ///
  /// 원문의 마지막 페이지를 받은 직후([hasNextPage]가 false이고 아직
  /// [originExhausted]가 아닌 상태)에는 **다음이 번역본**이므로 false가 된다.
  bool get nextHasOrigin => hasNextPage ? !originExhausted : false;

  /// 스택이 비었고 더 가져올 게 없는 소진 상태 여부(spec §4 — 자동 재조회 안 함).
  ///
  /// **번역본까지 다 받았을 때만 소진이다** — 원문이 끝난 것은 절반일 뿐이다.
  bool get isExhausted => cards.isEmpty && !hasNextPage && originExhausted;

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

  SwipeQueue copyWith({
    List<TouristSpot>? cards,
    int? loadedPage,
    bool? hasNextPage,
    bool? originExhausted,
  }) => SwipeQueue(
    cards: cards ?? this.cards,
    loadedPage: loadedPage ?? this.loadedPage,
    hasNextPage: hasNextPage ?? this.hasNextPage,
    originExhausted: originExhausted ?? this.originExhausted,
  );

  @override
  bool operator ==(Object other) =>
      other is SwipeQueue &&
      listEquals(other.cards, cards) &&
      other.loadedPage == loadedPage &&
      other.hasNextPage == hasNextPage &&
      other.originExhausted == originExhausted;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(cards),
    loadedPage,
    hasNextPage,
    originExhausted,
  );
}
