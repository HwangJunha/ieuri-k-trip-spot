import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/localization/locale_controller.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// 스와이프 세션이 필요로 하는 최소 컨테이너. SwipeController가 언어 전환 시
/// 세션을 다시 만들려고 locale을 watch하므로(SPEC-0007 §4.5) 저장소도 덮어쓴다.
Future<ProviderContainer> _container(FakeSpotRepository repo) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      spotRepositoryProvider.overrideWithValue(repo),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// [category]로 SwipeController를 로드해 첫 큐를 반환한다.
Future<(ProviderContainer, SwipeQueue)> _load(
  FakeSpotRepository repo, {
  SpotCategory? category,
}) async {
  final ProviderContainer container = await _container(repo);
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
  // SwipeController가 언어 전환을 감지하려고 locale을 watch하고, LocaleController는
  // 저장값이 없을 때 기기 로케일을 읽는다(SPEC-0007 §4.5).
  TestWidgetsFlutterBinding.ensureInitialized();

  test('build emits loading then the first page as data', () async {
    final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
    final ProviderContainer container = await _container(repo);

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

  // 갱신 자체가 실패해 재전송이 불가능하면(R9 세션 종료 / R10 세션 유지) 반응은
  // 유실되고 카드는 복원하지 않는다(SPEC-0005 R16, AC-44). 되돌리면 사용자가 방금
  // 넘긴 카드가 다시 나타나므로 — 분명히 반응한 카드를 되묻는 셈이라 하지 않는다.
  // 유실 허용은 의도된 선택이다(좋아요/싫어요는 비치명적).
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

  // AC-43 — 인증 실패 후 갱신에 성공하면 반응은 재전송되어 기록되고, 사용자에게는
  // 오류가 노출되지 않는다. 재전송은 링크 계층의 기존 재시도가 수행하므로
  // (SPEC-0005 §4.1) provider에는 별도의 재전송 큐가 없다 — repository 호출이
  // 성공으로 끝나는 것으로 관찰된다. 카드가 이미 넘어간 것과 요청 재시도는 서로
  // 독립적이다.
  test('a reaction that succeeds after a token refresh is recorded', () async {
    // 첫 호출은 인증 실패로 끝나고, 갱신 후의 재시도에서 성공하는 저장소 —
    // 링크 계층의 재시도를 provider 관점에서 관찰한 모습이다.
    final repo = _RetryOnceSpotRepository(feed: _spots(3));
    final (container, queue) = await _load(repo);
    final String topId = queue.cards.first.id;

    container
        .read(swipeControllerProvider(null).notifier)
        .swipe(SpotReaction.like);
    await Future<void>.delayed(Duration.zero);

    // 재전송이 성공해 반응이 기록된다.
    expect(repo.recordedReactions, contains((topId, SpotReaction.like)));
    // 그리고 큐는 정상 상태 — 오류로 인한 부작용이 없다(오류 미노출).
    expect(container.read(swipeControllerProvider(null)).hasError, isFalse);
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

  // --- SPEC-0007: 서버가 종료 축제를 삭제해 카드 id가 세션 도중 무효가 되는 경우 ---

  test(
    'AC-44 reaction rejected with SPOT_NOT_FOUND drops the card from the queue',
    () async {
      final repo = FakeSpotRepository(
        feed: <TouristSpot>[swipeSpot('a'), swipeSpot('b'), swipeSpot('c')],
        pageSize: 5,
        reactFailure: const SpotFailure(
          SpotFailureKind.userError,
          code: 'SPOT_NOT_FOUND',
        ),
      );
      final (container, initial) = await _load(repo);
      // 피드는 provider에서 섞이므로(SPEC-0006 _shuffled) 맨 위가 무엇인지 읽어서 쓴다.
      final String reacted = initial.top!.id;

      container
          .read(swipeControllerProvider(null).notifier)
          .swipe(SpotReaction.like);
      await Future<void>.delayed(Duration.zero);

      final SwipeQueue after = container
          .read(swipeControllerProvider(null))
          .value!;
      // 반응한 카드가 사라졌고, 나머지는 남는다.
      expect(
        after.cards.map((TouristSpot s) => s.id),
        isNot(contains(reacted)),
      );
      expect(after.cards.length, 2);
      // 세션은 계속된다 — 오류 상태로 넘어가지 않는다.
      expect(container.read(swipeControllerProvider(null)).hasError, isFalse);
    },
  );

  test(
    'AC-43 dropMissingCard removes the card and keeps the session alive',
    () async {
      final repo = FakeSpotRepository(
        feed: <TouristSpot>[swipeSpot('gone'), swipeSpot('alive')],
        pageSize: 5,
      );
      final (container, _) = await _load(repo);

      container
          .read(swipeControllerProvider(null).notifier)
          .dropMissingCard('gone');

      final AsyncValue<SwipeQueue> state = container.read(
        swipeControllerProvider(null),
      );
      expect(state.hasError, isFalse);
      expect(state.value!.cards.map((TouristSpot s) => s.id), <String>[
        'alive',
      ]);
    },
  );

  test(
    // AC-42의 요구는 "이전보다 적게 온 목록을 실패로 해석하지 말 것"인데, 그렇게
    // 해석하는 로직은 애초에 없다(§4.1 — 제거할 것이 없음). 관찰 가능한 사실은
    // 진행 중인 축제가 0건인 시기에 오류가 아니라 빈 상태가 된다는 것이다.
    'AC-42 an empty festival page is an empty state, not an error',
    () async {
      final repo = FakeSpotRepository(feed: const <TouristSpot>[], pageSize: 5);
      final (container, queue) = await _load(
        repo,
        category: SpotCategory.festivalEvent,
      );

      expect(
        container
            .read(swipeControllerProvider(SpotCategory.festivalEvent))
            .hasError,
        isFalse,
      );
      expect(queue.isExhausted, isTrue);
    },
  );

  test(
    'R-14 switching language rebuilds the session from the first page',
    () async {
      // spot.id는 언어별이라, 언어를 바꾸면 쌓아둔 카드의 id가 전부 무효가 된다
      // (SPEC-0007 §4.5). 세션은 처음부터 다시 서야 한다.
      final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
      final (container, _) = await _load(repo);

      // 카드 하나를 소비해 세션이 처음 상태가 아니게 만든다.
      container
          .read(swipeControllerProvider(null).notifier)
          .swipe(SpotReaction.like);
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(swipeControllerProvider(null)).value!.cards.length,
        2,
      );

      await container
          .read(localeControllerProvider.notifier)
          .select(AppLanguage.korean);

      final SwipeQueue rebuilt = await container.read(
        swipeControllerProvider(null).future,
      );
      expect(rebuilt.cards.length, 3);
      expect(rebuilt.loadedPage, 0);
    },
  );

  test('reaction failure other than SPOT_NOT_FOUND keeps the queue', () async {
    final repo = FakeSpotRepository(
      feed: <TouristSpot>[swipeSpot('a'), swipeSpot('b')],
      pageSize: 5,
      reactShouldFail: true,
    );
    final (container, initial) = await _load(repo);
    final String reacted = initial.top!.id;

    container
        .read(swipeControllerProvider(null).notifier)
        .swipe(SpotReaction.like);
    await Future<void>.delayed(Duration.zero);

    // 낙관적으로 빠진 맨 위 카드만 사라지고, 나머지는 그대로다 — SPOT_NOT_FOUND가
    // 아니므로 큐에서 추가로 걷어내지 않는다.
    final SwipeQueue after = container
        .read(swipeControllerProvider(null))
        .value!;
    expect(after.cards.map((TouristSpot s) => s.id), isNot(contains(reacted)));
    expect(after.cards.length, 1);
  });

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

  // 서버는 같은 좌표·카테고리에 같은 순서를 돌려주므로, 한 카페에 있는 사용자들이
  // 전부 같은 카드를 같은 순서로 보게 된다. 클라이언트에서 한 번 더 섞어 갈라놓는다.
  test(
    'the first page is shuffled so concurrent users see different orders',
    () async {
      // 같은 피드를 두 번 로드해 순서가 갈리는지 본다. 50장이면 우연히 같은 순서가
      // 나올 확률은 사실상 0이다.
      final List<TouristSpot> feed = _spots(50);

      final (c1, q1) = await _load(
        FakeSpotRepository(feed: feed, pageSize: 100),
      );
      final (c2, q2) = await _load(
        FakeSpotRepository(feed: feed, pageSize: 100),
      );

      final List<String> order1 = q1.cards
          .map((TouristSpot s) => s.id)
          .toList();
      final List<String> order2 = q2.cards
          .map((TouristSpot s) => s.id)
          .toList();

      expect(order1, isNot(order2), reason: '두 사용자가 다른 순서를 본다');
      // 섞기만 할 뿐 잃거나 더하지 않는다.
      expect(order1..sort(), order2..sort());
      expect(q1.cards.length, 50);
      c1.dispose();
      c2.dispose();
    },
  );

  // 상세에서 반응한 카드는 Discover로 돌아왔을 때 스택에 남아 있으면 안 된다.
  group('consume', () {
    test('removes the card without sending a reaction', () async {
      final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
      final (container, queue) = await _load(repo);
      final String topId = queue.cards.first.id;

      container.read(swipeControllerProvider(null).notifier).consume(topId);
      await Future<void>.delayed(Duration.zero);

      final SwipeQueue after = container
          .read(swipeControllerProvider(null))
          .value!;
      expect(after.cards.map((TouristSpot s) => s.id), isNot(contains(topId)));
      expect(after.cards.length, 2);
      // 반응은 상세가 이미 보냈다 — 여기서 또 보내면 중복이다.
      expect(repo.recordedReactions, isEmpty);
    });

    test('removes a card that is not on top', () async {
      // 상세는 스택 중간의 카드에서도 열릴 수 있다.
      final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
      final (container, queue) = await _load(repo);
      final String middleId = queue.cards[1].id;
      final String topId = queue.cards.first.id;

      container.read(swipeControllerProvider(null).notifier).consume(middleId);

      final SwipeQueue after = container
          .read(swipeControllerProvider(null))
          .value!;
      expect(
        after.cards.map((TouristSpot s) => s.id),
        isNot(contains(middleId)),
      );
      expect(after.cards.first.id, topId, reason: '맨 위는 그대로다');
    });

    test('an unknown id leaves the stack untouched', () async {
      // 스와이프를 거치지 않은 경로로 들어온 상세.
      final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
      final (container, before) = await _load(repo);

      container.read(swipeControllerProvider(null).notifier).consume('nope');

      expect(container.read(swipeControllerProvider(null)).value, before);
    });
  });
}

/// 첫 `reactToSpot`은 인증 실패로 끝나고 재시도에서 성공하는 저장소.
///
/// 실제로는 링크 계층이 갱신 후 원 요청을 재시도하므로 provider는 한 번만 호출하고
/// 성공을 받는다(SPEC-0005 §4.1). 여기서는 그 재시도를 저장소 수준에서 재현해,
/// "인증 실패로 시작한 반응이 결국 기록된다"는 AC-43의 관찰 가능한 결과를 만든다.
class _RetryOnceSpotRepository extends FakeSpotRepository {
  _RetryOnceSpotRepository({required super.feed}) : super(pageSize: 5);

  bool _refreshed = false;

  @override
  Future<void> reactToSpot(String spotId, SpotReaction reaction) async {
    if (!_refreshed) {
      // 첫 시도는 인증 실패 — 링크가 갱신하고 같은 요청을 다시 태운다.
      _refreshed = true;
      return reactToSpot(spotId, reaction);
    }
    return super.reactToSpot(spotId, reaction);
  }
}
