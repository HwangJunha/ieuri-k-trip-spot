import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category_selection.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/retry_budget.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/retry_budget_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// SwipeController의 커서 페이징(SPEC-0035 R27·R28·R29).
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

  Future<ProviderContainer> makeContainer(FakeSpotRepository repository) async {
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
    // 구독을 유지해야 컨트롤러가 watch하는 autoDispose 좌표 provider가 이어 받기
    // 도중 폐기되지 않는다 — 구독이 없으면 `.future`가 완결되지 않고 30초에 매달린다
    // (상세 컨트롤러 테스트와 같은 규약).
    container.listen(
      swipeControllerProvider(noCategories),
      (_, _) {},
      fireImmediately: true,
    );
    return container;
  }

  List<TouristSpot> spots(int count, {String prefix = 's'}) =>
      List<TouristSpot>.generate(count, (int i) => swipeSpot('$prefix$i'));

  Set<String> idsOf(Iterable<TouristSpot> cards) =>
      cards.map((TouristSpot s) => s.id).toSet();

  SwipeQueue queueOf(ProviderContainer container) =>
      container.read(swipeControllerProvider(noCategories)).requireValue;

  group('첫 빌드 (R27)', () {
    test('AC-27.1 · first: 100, after: null로 한 번 부르고 받은 묶음을 섞어 담는다', () async {
      final repository = FakeSpotRepository(feed: spots(5), pageSize: 5);
      final container = await makeContainer(repository);

      final SwipeQueue queue = await container.read(
        swipeControllerProvider(noCategories).future,
      );

      expect(repository.recommendedRequests, hasLength(1));
      expect(repository.recommendedRequests.single.first, 100);
      expect(repository.recommendedRequests.single.after, isNull);
      // 순서는 섞이지만 구성은 받은 묶음 그대로다.
      expect(idsOf(queue.cards), idsOf(repository.feed));
      expect(queue.hasNextPage, isFalse);
    });

    test('AC-27.3 · 다음이 없고 큐를 다 쓰면 소진 상태다', () async {
      final repository = FakeSpotRepository(feed: spots(3), pageSize: 5);
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);
      final SwipeController notifier = container.read(
        swipeControllerProvider(noCategories).notifier,
      );

      for (int i = 0; i < 3; i++) {
        notifier.swipe(SpotReaction.like);
      }
      await pumpEventQueue();

      expect(queueOf(container).isExhausted, isTrue);
      // hasNextPage가 false라 이어 받기는 시도조차 하지 않는다.
      expect(repository.recommendedRequests, hasLength(1));
    });
  });

  group('이어 받기 (R27)', () {
    test('AC-27.2 · 큐가 10장 미만이면 after: endCursor로 한 번 이어 붙인다', () async {
      // 첫 묶음 8장(<10) → 첫 스와이프에서 선제 조회가 나간다.
      final repository = FakeSpotRepository(feed: spots(12), pageSize: 8);
      final container = await makeContainer(repository);
      final SwipeQueue first = await container.read(
        swipeControllerProvider(noCategories).future,
      );
      expect(first.endCursor, '8');

      container
          .read(swipeControllerProvider(noCategories).notifier)
          .swipe(SpotReaction.like);
      await pumpEventQueue();

      expect(repository.recommendedRequests, hasLength(2));
      expect(repository.recommendedRequests.last.after, '8');
      expect(repository.recommendedRequests.last.first, 100);
      final SwipeQueue queue = queueOf(container);
      // 남은 7장이 앞에 그대로 있고, 새 묶음 4장은 뒤에 붙는다(묶음 경계를 넘어 섞지
      // 않는다).
      expect(queue.cards.take(7).toList(), first.cards.sublist(1));
      expect(idsOf(queue.cards.skip(7)), idsOf(repository.feed.sublist(8)));
      expect(queue.hasNextPage, isFalse);
    });

    test('큐가 10장 이상이면 이어 받지 않는다', () async {
      final repository = FakeSpotRepository(feed: spots(30), pageSize: 12);
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);

      container
          .read(swipeControllerProvider(noCategories).notifier)
          .swipe(SpotReaction.like);
      await pumpEventQueue();

      expect(repository.recommendedRequests, hasLength(1));
    });

    test('AC-27.4 · 이어 받기가 실패해도 큐는 유지되고 다음 스와이프에서 다시 시도한다', () async {
      final repository = FakeSpotRepository(feed: spots(12), pageSize: 8)
        ..continuationFailure = SpotFailure.network;
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);
      final SwipeController notifier = container.read(
        swipeControllerProvider(noCategories).notifier,
      );

      notifier.swipe(SpotReaction.like);
      await pumpEventQueue();

      final AsyncValue<SwipeQueue> state = container.read(
        swipeControllerProvider(noCategories),
      );
      expect(state.hasError, isFalse);
      expect(state.requireValue.cards, hasLength(7));
      expect(repository.recommendedRequests, hasLength(2));

      notifier.swipe(SpotReaction.like);
      await pumpEventQueue();

      // 다음 스와이프에서 다시 시도한다 — 자동 재시도 상한과 무관한 기존 규칙이다.
      expect(repository.recommendedRequests, hasLength(3));
      expect(repository.recommendedRequests.last.after, '8');
    });
  });

  group('커서 오류 (R28)', () {
    test('AC-28.1 · 커서가 만료되면 큐를 비우지 않고 커서 없이 첫 요청을 다시 보낸다', () async {
      final repository = FakeSpotRepository(feed: spots(12), pageSize: 8)
        ..continuationFailure = SpotFailure.cursorInvalid;
      final container = await makeContainer(repository);
      final SwipeQueue first = await container.read(
        swipeControllerProvider(noCategories).future,
      );

      container
          .read(swipeControllerProvider(noCategories).notifier)
          .swipe(SpotReaction.like);
      await pumpEventQueue();

      expect(
        repository.recommendedRequests.map((RecommendedRequest r) => r.after),
        <String?>[null, '8', null],
      );
      final SwipeQueue queue = queueOf(container);
      expect(queue.cards.take(7).toList(), first.cards.sublist(1));
      expect(
        container.read(swipeControllerProvider(noCategories)).hasError,
        isFalse,
      );
    });

    test('AC-28.2 · 새 묶음에서 큐에 이미 있는 id는 걷어내고 붙인다', () async {
      final List<TouristSpot> original = spots(8);
      final repository = FakeSpotRepository(
        feed: <TouristSpot>[
          ...original,
          ...spots(4, prefix: 'more'),
        ],
        pageSize: 8,
      )..continuationFailure = SpotFailure.cursorInvalid;
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);

      // 새 세션의 첫 묶음: 큐에 남아 있는 카드 둘 + 새 카드 둘.
      repository.feed = <TouristSpot>[
        original[1],
        original[2],
        swipeSpot('fresh1'),
        swipeSpot('fresh2'),
      ];
      container
          .read(swipeControllerProvider(noCategories).notifier)
          .swipe(SpotReaction.like);
      await pumpEventQueue();

      final List<String> ids = queueOf(
        container,
      ).cards.map((TouristSpot s) => s.id).toList();
      expect(ids.toSet().length, ids.length, reason: '중복 id가 없다');
      expect(ids, hasLength(7 + 2));
      expect(ids, containsAll(<String>['fresh1', 'fresh2']));
    });

    test('AC-28.3 · 커서 손상도 같다 — 재시도 예산은 쓰지 않는다', () async {
      // repository는 CURSOR_EXPIRED·INVALID_CURSOR를 같은 cursorInvalid로 접으므로
      // 컨트롤러 수준에서는 한 경로다. 여기서는 예산이 움직이지 않는 것을 본다.
      final repository = FakeSpotRepository(feed: spots(12), pageSize: 8)
        ..continuationFailure = SpotFailure.cursorInvalid;
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);

      container
          .read(swipeControllerProvider(noCategories).notifier)
          .swipe(SpotReaction.like);
      await pumpEventQueue();

      final RetryBudget budget = container.read(
        spotRetryBudgetProvider(swipeRetryScope('')),
      );
      expect(budget.lastFailure, isNull);
      expect(budget.isExhausted, isFalse);
      expect(repository.recommendedRequests.last.after, isNull);
    });
  });

  group('조건 변경은 새 세션 (R29)', () {
    test('AC-29.1 · 좌표가 무효화되면 커서 없이 첫 요청부터 다시 한다', () async {
      final repository = FakeSpotRepository(feed: spots(12), pageSize: 8);
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);

      container.invalidate(currentCoordinatesProvider);
      await container.read(swipeControllerProvider(noCategories).future);

      expect(repository.recommendedRequests, hasLength(2));
      expect(repository.recommendedRequests.last.after, isNull);
    });

    test('AC-29.2 · 카테고리 선택이 바뀌면 새 선택 키의 세션이 커서 없이 시작된다', () async {
      final repository = FakeSpotRepository(
        feed: <TouristSpot>[
          swipeSpot('t1'),
          swipeSpot('r1', category: catRestaurant),
        ],
        pageSize: 8,
      );
      final container = await makeContainer(repository);
      await container.read(swipeControllerProvider(noCategories).future);

      final SpotCategorySelection restaurants = selectionOf(<SpotCategory>[
        catRestaurant,
      ]);
      container.listen(
        swipeControllerProvider(restaurants),
        (_, _) {},
        fireImmediately: true,
      );
      final SwipeQueue queue = await container.read(
        swipeControllerProvider(restaurants).future,
      );

      expect(repository.recommendedRequests, hasLength(2));
      expect(repository.recommendedRequests.last.after, isNull);
      expect(repository.recommendedRequests.last.categoryCodes, <String>[
        'RESTAURANT',
      ]);
      expect(idsOf(queue.cards), <String>{'r1'});
    });
  });
}
