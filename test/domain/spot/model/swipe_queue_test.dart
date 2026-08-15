import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';

const TouristSpot _a = TouristSpot(
  id: 'a',
  name: 'A',
  imageRef: 'a',
  location: 'Seoul',
);

const TouristSpot _b = TouristSpot(
  id: 'b',
  name: 'B',
  imageRef: 'b',
  location: 'Seoul',
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
      // 번역본까지 다 받았을 때만 소진이다(SPEC-0019) — 원문이 끝난 것은 절반이다.
      const SwipeQueue(
        cards: <TouristSpot>[],
        loadedPage: 0,
        hasNextPage: false,
        originExhausted: true,
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
      originExhausted: true,
    );
    expect(done.nextPage, isNull);
  });

  // SPEC-0019 — 원문 구간이 끝나면 번역본 구간으로 넘어간다. 번역본은 별개의 결과
  // 집합이라 페이지를 0부터 다시 센다.
  test('원문이 끝나면 번역본 0페이지로 넘어간다', () {
    const SwipeQueue originDone = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 3,
      hasNextPage: false,
    );

    expect(originDone.nextPage, 0, reason: '번역본은 처음부터 센다');
    expect(originDone.nextHasOrigin, isFalse, reason: '다음 조회는 번역본이다');
    expect(originDone.isExhausted, isFalse, reason: '아직 번역본이 남았다');
  });

  test('원문 구간에서는 nextHasOrigin이 true다', () {
    const SwipeQueue inOrigin = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 1,
      hasNextPage: true,
    );

    expect(inOrigin.nextHasOrigin, isTrue);
    expect(inOrigin.nextPage, 2);
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

  test('removeCard drops every occurrence of the id', () {
    const SwipeQueue q = SwipeQueue(
      cards: <TouristSpot>[_a, _b, _a],
      loadedPage: 0,
      hasNextPage: false,
    );

    final SwipeQueue next = q.removeCard(_a.id);

    expect(next.cards.map((TouristSpot s) => s.id), <String>[_b.id]);
  });

  test('removeCard returns the same queue when the id is absent', () {
    const SwipeQueue q = SwipeQueue(
      cards: <TouristSpot>[_a],
      loadedPage: 0,
      hasNextPage: false,
    );

    expect(identical(q.removeCard('missing'), q), isTrue);
  });
}
