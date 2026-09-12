import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category_selection.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// SwipeController의 추천 묶음(SPEC-0035 R10). 소스는 이것 하나다.
///
/// 컨트롤러는 좌표·반경·로그인 상태를 전이적으로 watch하므로 위치 서비스와
/// SharedPreferences까지 오버라이드해야 컨테이너가 선다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();
  });

  /// [selection] 세션을 구독한 컨테이너.
  Future<ProviderContainer> makeContainer(
    FakeSpotRepository repository, [
    SpotCategorySelection? selection,
  ]) async {
    final container = ProviderContainer(
      overrides: [
        spotRepositoryProvider.overrideWithValue(repository),
        locationServiceProvider.overrideWithValue(FakeLocationService()),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    // 컨트롤러가 로그인 상태를 watch하므로, 인증 판정이 loading에서 확정으로
    // 넘어가는 순간 build가 한 번 더 돈다. 호출 횟수를 세는 테스트라 먼저 확정시켜
    // 첫 조회가 정확히 1회가 되게 한다. 이 컨테이너엔 보안 저장소가 없어 판정은
    // **오류로** 확정된다(비인증과 같은 취급) — `.future`를 기다리면 그 오류가
    // 던져지므로 구독만 걸고 큐를 비운다.
    container.listen(authControllerProvider, (_, _) {}, fireImmediately: true);
    await pumpEventQueue();
    // 구독을 유지해야 컨트롤러가 watch하는 autoDispose 좌표 provider가 보충 조회
    // 도중 폐기되지 않는다(상세 컨트롤러 테스트와 같은 규약).
    container.listen(
      swipeControllerProvider(selection ?? noCategories),
      (_, _) {},
      fireImmediately: true,
    );
    return container;
  }

  List<TouristSpot> spots(int count, {String prefix = 's'}) =>
      List<TouristSpot>.generate(count, (int i) => swipeSpot('$prefix$i'));

  List<String> idsOf(Iterable<TouristSpot> cards) =>
      cards.map((TouristSpot s) => s.id).toList(growable: false);

  SwipeQueue queueOf(ProviderContainer c) =>
      c.read(swipeControllerProvider(noCategories)).requireValue;

  SwipeController notifierOf(ProviderContainer c) =>
      c.read(swipeControllerProvider(noCategories).notifier);

  group('첫 묶음 (AC-10.2)', () {
    test('first: 100으로 1회 부르고 받은 순서를 그대로 담는다', () async {
      // 100장이 꽉 차게 오면 더 부를 수 있다고 본다.
      final repository = FakeSpotRepository(feed: spots(100));
      final container = await makeContainer(repository);

      final SwipeQueue queue = await container.read(
        swipeControllerProvider(noCategories).future,
      );

      expect(repository.recommendedRequests, hasLength(1));
      expect(repository.recommendedRequests.single.first, 100);
      expect(repository.recommendedRequests.single.categoryCodes, isNull);
      // 서버 배열이 계약이라 섞지 않는다.
      expect(idsOf(queue.cards), idsOf(repository.feed));
      expect(queue.hasNextPage, isTrue);
    });

    test('first보다 적게 오면 소진 — 큐를 다 쓰면 빈 상태고 다시 부르지 않는다', () async {
      final repository = FakeSpotRepository(feed: spots(3));
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);

      for (int i = 0; i < 3; i++) {
        notifierOf(container).swipe(SpotReaction.like);
      }
      await pumpEventQueue();

      expect(queueOf(container).isExhausted, isTrue);
      expect(repository.recommendedCallCount, 1);
    });

    test('카테고리 칩은 묶음에 필터로 실린다', () async {
      final repository = FakeSpotRepository(
        feed: <TouristSpot>[
          swipeSpot('t1'),
          swipeSpot('r1', category: catRestaurant),
        ],
      );
      final SpotCategorySelection restaurants = selectionOf(<SpotCategory>[
        catRestaurant,
      ]);
      final container = await makeContainer(repository, restaurants);

      final SwipeQueue queue = await container.read(
        swipeControllerProvider(restaurants).future,
      );

      expect(repository.recommendedRequests.single.categoryCodes, <String>[
        'RESTAURANT',
      ]);
      expect(idsOf(queue.cards), <String>['r1']);
    });
  });

  group('보충 (AC-10.2)', () {
    test('큐가 10장 미만이면 같은 인자로 다시 부르고 겹치는 id를 걷어낸 뒤 붙인다', () async {
      final List<TouristSpot> first = spots(100);
      final repository = FakeSpotRepository(feed: first);
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);
      final SwipeController notifier = notifierOf(container);

      // 90장을 넘겨 10장을 남긴다(임계 미만이 아님). 보충이 나가면 안 된다.
      for (int i = 0; i < 90; i++) {
        notifier.swipe(SpotReaction.dislike);
      }
      await pumpEventQueue();
      expect(repository.recommendedCallCount, 1);

      // 다음 묶음: 방금 넘긴 카드 하나(반응 커밋 전 재요청), 큐에 남은 카드 하나,
      // 새 카드 98장.
      repository.feed = <TouristSpot>[
        first[0],
        first[95],
        ...spots(98, prefix: 'n'),
      ];
      notifier.swipe(SpotReaction.dislike);
      await pumpEventQueue();

      expect(repository.recommendedCallCount, 2);
      expect(repository.recommendedRequests.last.first, 100);
      final List<String> ids = idsOf(queueOf(container).cards);
      // 남아 있던 9장이 앞에 그대로, 새 카드 98장이 받은 순서로 뒤에.
      expect(ids.take(9).toList(), idsOf(first.sublist(91)));
      expect(ids.skip(9).toList(), idsOf(spots(98, prefix: 'n')));
      expect(ids.toSet().length, ids.length, reason: '겹치는 id가 없다');
      expect(ids, isNot(contains('s0')), reason: '넘긴 카드는 다시 오지 않는다');
      expect(queueOf(container).hasNextPage, isTrue);
    });

    test('걷어낸 뒤 새 카드가 0장이면 그 조건에서는 더 부르지 않는다', () async {
      final repository = FakeSpotRepository(feed: spots(100));
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);
      final SwipeController notifier = notifierOf(container);
      for (int i = 0; i < 90; i++) {
        notifier.swipe(SpotReaction.dislike);
      }
      await pumpEventQueue();

      // 서버가 같은 묶음을 그대로 다시 준다(반응이 아직 하나도 커밋되지 않은 경우).
      notifier.swipe(SpotReaction.dislike);
      await pumpEventQueue();
      expect(repository.recommendedCallCount, 2);
      expect(queueOf(container).hasNextPage, isFalse);

      // 이후 스와이프에서는 재요청하지 않는다 — 무한 재요청 방지.
      notifier.swipe(SpotReaction.dislike);
      await pumpEventQueue();
      expect(repository.recommendedCallCount, 2);
      expect(queueOf(container).cards, hasLength(8));
    });

    test('보충 실패는 큐를 유지하고 다음 스와이프에서 다시 시도한다', () async {
      final repository = FakeSpotRepository(feed: spots(100));
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);
      final SwipeController notifier = notifierOf(container);
      for (int i = 0; i < 90; i++) {
        notifier.swipe(SpotReaction.dislike);
      }
      await pumpEventQueue();

      repository
        ..recommendedFailure = SpotFailure.network
        ..failRecommendedTimes = 2; // 2번째 호출(첫 보충)만 실패.
      notifier.swipe(SpotReaction.dislike);
      await pumpEventQueue();

      final AsyncValue<SwipeQueue> state = container.read(
        swipeControllerProvider(noCategories),
      );
      expect(state.hasError, isFalse);
      expect(state.requireValue.cards, hasLength(9));

      repository.feed = spots(100, prefix: 'n');
      notifier.swipe(SpotReaction.dislike);
      await pumpEventQueue();
      expect(repository.recommendedCallCount, 3);
      expect(queueOf(container).cards.length, greaterThan(8));
    });
  });

  group('조건 변경은 새 세션 (AC-10.3)', () {
    test('좌표가 무효화되면 큐를 비우고 다시 부른다', () async {
      final repository = FakeSpotRepository(feed: spots(5));
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);
      notifierOf(container).swipe(SpotReaction.like);
      await pumpEventQueue();

      repository.feed = spots(4, prefix: 'n');
      container.invalidate(currentCoordinatesProvider);
      final SwipeQueue queue = await container.read(
        swipeControllerProvider(noCategories).future,
      );

      expect(repository.recommendedCallCount, 2);
      expect(idsOf(queue.cards), idsOf(repository.feed));
    });
  });
}
