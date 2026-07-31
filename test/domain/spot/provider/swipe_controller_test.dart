import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';

import '../spot_test_doubles.dart';

/// [category]로 SwipeController를 로드해 첫 큐를 반환한다.
Future<(ProviderContainer, SwipeQueue)> _load(
  FakeSpotRepository repo, {
  SpotCategory? category,
}) async {
  final container = ProviderContainer(
    overrides: [
      spotRepositoryProvider.overrideWithValue(repo),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
    ],
  );
  addTearDown(container.dispose);
  // autoDispose 프로바이더가 read 사이에 폐기되지 않도록 구독을 유지한다.
  container.listen(
    swipeControllerProvider(category),
    (_, _) {},
    fireImmediately: true,
  );
  final SwipeQueue queue = await container.read(
    swipeControllerProvider(category).future,
  );
  return (container, queue);
}

List<TouristSpot> _spots(int n) =>
    List<TouristSpot>.generate(n, (int i) => swipeSpot('s$i'));

void main() {
  test('build emits loading then the first page as data', () async {
    final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
    final container = ProviderContainer(
      overrides: [
        spotRepositoryProvider.overrideWithValue(repo),
        locationServiceProvider.overrideWithValue(FakeLocationService()),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(swipeControllerProvider(null)),
      const AsyncLoading<SwipeQueue>(),
    );

    final SwipeQueue queue = await container.read(
      swipeControllerProvider(null).future,
    );
    expect(queue.cards.length, 3);
    expect(queue.hasNextPage, isFalse);
  });

  test('swipe removes the top card optimistically', () async {
    final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
    final (container, queue) = await _load(repo);
    final String topId = queue.cards.first.id;

    container
        .read(swipeControllerProvider(null).notifier)
        .swipe(SpotReaction.like);

    final SwipeQueue after = container
        .read(swipeControllerProvider(null))
        .value!;
    expect(after.cards.length, 2);
    expect(after.cards.map((TouristSpot s) => s.id), isNot(contains(topId)));
  });

  test('swipe records the reaction for the swiped card', () async {
    final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
    final (container, queue) = await _load(repo);
    final String topId = queue.cards.first.id;

    container
        .read(swipeControllerProvider(null).notifier)
        .swipe(SpotReaction.dislike);
    await Future<void>.delayed(Duration.zero);

    expect(repo.recordedReactions, contains((topId, SpotReaction.dislike)));
  });

  test('react failure does not restore the card', () async {
    final repo = FakeSpotRepository(
      feed: _spots(3),
      pageSize: 5,
      reactShouldFail: true,
    );
    final (container, _) = await _load(repo);

    container
        .read(swipeControllerProvider(null).notifier)
        .swipe(SpotReaction.like);
    await Future<void>.delayed(Duration.zero);

    // 실패해도 큐는 2장으로 유지(복원 없음).
    expect(
      container.read(swipeControllerProvider(null)).value!.cards.length,
      2,
    );
  });

  test(
    'prefetch appends the next page when remaining hits the threshold',
    () async {
      // 페이지 3장, 전체 8장 → 첫 페이지 후 잔여가 임계값(<10)이라 스와이프 시 선제 조회.
      final repo = FakeSpotRepository(feed: _spots(8), pageSize: 3);
      final (container, queue) = await _load(repo);
      expect(queue.cards.length, 3);
      expect(queue.hasNextPage, isTrue);

      container
          .read(swipeControllerProvider(null).notifier)
          .swipe(SpotReaction.like);
      // 낙관적 제거로 2장, 이어서 선제 조회가 다음 페이지를 붙인다.
      await Future<void>.delayed(Duration.zero);

      final SwipeQueue after = container
          .read(swipeControllerProvider(null))
          .value!;
      expect(after.cards.length, greaterThan(2));
    },
  );

  test(
    'exhaustion: consuming the last card yields an exhausted queue',
    () async {
      final repo = FakeSpotRepository(feed: _spots(1), pageSize: 5);
      final (container, _) = await _load(repo);

      container
          .read(swipeControllerProvider(null).notifier)
          .swipe(SpotReaction.like);
      await Future<void>.delayed(Duration.zero);

      final SwipeQueue after = container
          .read(swipeControllerProvider(null))
          .value!;
      expect(after.cards, isEmpty);
      expect(after.isExhausted, isTrue);
    },
  );

  test('category families load independently', () async {
    final repo = FakeSpotRepository(
      feed: <TouristSpot>[
        swipeSpot('f1', category: SpotCategory.restaurant),
        swipeSpot('n1', category: SpotCategory.touristSpot),
      ],
      pageSize: 5,
    );
    final (container, _) = await _load(repo);

    final SwipeQueue food = await container.read(
      swipeControllerProvider(SpotCategory.restaurant).future,
    );
    expect(food.cards.single.id, 'f1');
  });
}
