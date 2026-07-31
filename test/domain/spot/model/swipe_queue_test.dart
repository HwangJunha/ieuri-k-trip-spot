import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';

const TouristSpot _a = TouristSpot(
  id: 'a',
  name: 'A',
  imageRef: 'a',
  location: 'Seoul',
  congestion: CongestionLevel.low,
);

void main() {
  test('top returns the first card, null when empty', () {
    const SwipeQueue full = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 0,
      hasNextPage: false,
    );
    expect(full.top, _a);

    const SwipeQueue empty = SwipeQueue(
      cards: <TouristSpot>[],
      loadedPage: 0,
      hasNextPage: false,
    );
    expect(empty.top, isNull);
  });

  test('isExhausted only when empty and no next page', () {
    expect(
      const SwipeQueue(
        cards: <TouristSpot>[],
        loadedPage: 0,
        hasNextPage: false,
      ).isExhausted,
      isTrue,
    );
    expect(
      const SwipeQueue(
        cards: <TouristSpot>[],
        loadedPage: 0,
        hasNextPage: true,
      ).isExhausted,
      isFalse,
    );
    expect(
      const SwipeQueue(
        cards: <TouristSpot>[_a],
        loadedPage: 0,
        hasNextPage: false,
      ).isExhausted,
      isFalse,
    );
  });

  test('nextPage is the page after loadedPage, null when exhausted', () {
    const SwipeQueue more = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 2,
      hasNextPage: true,
    );
    expect(more.nextPage, 3);

    const SwipeQueue done = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 2,
      hasNextPage: false,
    );
    expect(done.nextPage, isNull);
  });

  test('copyWith replaces only given fields', () {
    const SwipeQueue q = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 1,
      hasNextPage: true,
    );
    final SwipeQueue next = q.copyWith(cards: const <TouristSpot>[]);
    expect(next.cards, isEmpty);
    expect(next.loadedPage, 1);
    expect(next.hasNextPage, isTrue);
  });
}
