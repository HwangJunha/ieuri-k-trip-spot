import '../../../common/model/list_equality.dart';
import 'tourist_spot.dart';

/// Discover 스와이프 카드 스택의 상태(spec §4). SwipeController가 노출하는 값으로,
/// 남은 카드 큐와 "더 부를 만한가"를 담는다. 순수 도메인.
///
/// **페이지가 없다**(SPEC-0035). 소스가 `recommendedSpots` 묶음 하나뿐이라 —
/// 서버가 이미 반응한 장소를 뺀 뒤 점수순 앞 `first`건을 주므로 "다음 페이지"라는
/// 개념이 없고, 보충은 같은 인자로 다시 부른다. 예전 오프셋 `spots` 소스의
/// `loadedPage`/`nextPage`는 그 소스와 함께 사라졌다(사용자 결정 2026-09-12).
///
/// [cards]의 첫 번째가 맨 위(사용자가 지금 보는) 카드이며, 스와이프 시 앞에서 제거한다.
class SwipeQueue {
  const SwipeQueue({required this.cards, required this.hasNextPage});

  /// 현재 스택. `cards.first`가 맨 위 카드.
  final List<TouristSpot> cards;

  /// 더 부를 만한가 — 직전 묶음이 가득 찼고(`first`건) 새 카드가 있었는가. false +
  /// 큐 소진이면 빈 상태로 넘어간다.
  final bool hasNextPage;

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

  SwipeQueue copyWith({List<TouristSpot>? cards, bool? hasNextPage}) =>
      SwipeQueue(
        cards: cards ?? this.cards,
        hasNextPage: hasNextPage ?? this.hasNextPage,
      );

  @override
  bool operator ==(Object other) =>
      other is SwipeQueue &&
      listEquals(other.cards, cards) &&
      other.hasNextPage == hasNextPage;

  @override
  int get hashCode => Object.hash(Object.hashAll(cards), hasNextPage);
}
