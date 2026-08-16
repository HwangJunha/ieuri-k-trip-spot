// 스와이프 추천 컨트롤러의 provider 테스트를 한 파일에 모았다(consume·radius·
// retry cap 포함).
//
// **파일을 더 쪼개지 않는 이유는 속도다.** flutter test는 파일마다 격리된 VM을 띄우므로
// 파일 수가 곧 실행 시간이다 — 가벼운 파일 10개가 무거운 파일 1개와 맞먹는다. 같은
// 대상을 다루는 테스트는 group으로 나누면 충분하다(CLAUDE.md §8).

import '../spot_test_doubles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category_selection.dart';
import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/localization/locale_controller.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/search_radius_controller.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/retry_exhausted.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/retry_counting.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── swipe_controller ──────────────────────────────────────────
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


Future<(ProviderContainer, SwipeQueue)> _load(
  FakeSpotRepository repo, {
  SpotCategorySelection? selection,
}) async {
  final ProviderContainer container = await _container(repo);
  // autoDispose 프로바이더가 read 사이에 폐기되지 않도록 구독을 유지한다.
  container.listen(
    swipeControllerProvider(selection ?? noCategories),
    (_, _) {},
    fireImmediately: true,
  );
  final SwipeQueue queue = await container.read(
    swipeControllerProvider(selection ?? noCategories).future,
  );
  return (container, queue);
}

List<TouristSpot> _spots(int n) =>
    List<TouristSpot>.generate(n, (int i) => swipeSpot('s$i'));

// ─── swipe_controller (tail) ───────────────────────────────────
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

// ─── swipe_consume ─────────────────────────────────────────────
Future<(ProviderContainer, SwipeQueue)> _consumeLoad(int n) async {
  final repo = FakeSpotRepository(
    feed: List<TouristSpot>.generate(n, (int i) => swipeSpot('s$i')),
    pageSize: 100,
  );
  // SwipeController가 언어 전환 시 세션을 다시 만들려고 locale을 watch하므로
  // (SPEC-0007 §4.5) 그 저장소도 덮어써야 컨테이너가 선다.
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
  container.listen(
    swipeControllerProvider(noCategories),
    (_, _) {},
    fireImmediately: true,
  );
  final SwipeQueue queue = await container.read(
    swipeControllerProvider(noCategories).future,
  );
  return (container, queue);
}

List<String> _consumeIds(ProviderContainer container) => container
    .read(swipeControllerProvider(noCategories))
    .value!
    .cards
    .map((TouristSpot s) => s.id)
    .toList();

// ─── swipe_radius ──────────────────────────────────────────────
Future<ProviderContainer> _radiusContainer(
  FakeSpotRepository repo, {
  double? radiusKm,
}) async {
  SharedPreferences.setMockInitialValues(
    radiusKm == null
        ? <String, Object>{}
        : <String, Object>{'search_radius_km': radiusKm},
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ProviderContainer container = ProviderContainer(
    overrides: [
      spotRepositoryProvider.overrideWithValue(repo),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _radiusLoad(ProviderContainer container) async {
  container.listen(
    swipeControllerProvider(noCategories),
    (_, _) {},
    fireImmediately: true,
  );
  await container.read(swipeControllerProvider(noCategories).future);
}

// ─── swipe_retry_cap ───────────────────────────────────────────
late final SharedPreferences _prefs;

ProviderContainer _capContainer(
  FakeSpotRepository repo, {
  SpotCategorySelection? selection,
}) {
  final container = ProviderContainer(
    overrides: [
      spotRepositoryProvider.overrideWithValue(repo),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
      sharedPreferencesProvider.overrideWithValue(_prefs),
    ],
  );
  addTearDown(container.dispose);
  container.listen(
    swipeControllerProvider(selection ?? noCategories),
    (_, _) {},
    fireImmediately: true,
  );
  return container;
}





Future<void> _capSettle(
  ProviderContainer container, {
  SpotCategorySelection? selection,
}) async {
  for (int i = 0; i < 5; i++) {
    try {
      await container.read(
        swipeControllerProvider(selection ?? noCategories).future,
      );
      return;
    } on SpotFailure {
      await Future<void>.delayed(_capSettleStep);
    } on RetryExhausted {
      await Future<void>.delayed(_capSettleStep);
    }
  }
}


const Duration _capSettleStep = Duration(milliseconds: 20);

void main() {
  // ─── swipe_controller ────────────────────────────────────────

  // SwipeController가 언어 전환을 감지하려고 locale을 watch하고, LocaleController는
  // 저장값이 없을 때 기기 로케일을 읽는다(SPEC-0007 §4.5).
  TestWidgetsFlutterBinding.ensureInitialized();

  test('build emits loading then the first page as data', () async {
    final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
    final ProviderContainer container = await _container(repo);

    expect(
      container.read(swipeControllerProvider(noCategories)),
      const AsyncLoading<SwipeQueue>(),
    );

    final SwipeQueue queue = await container.read(
      swipeControllerProvider(noCategories).future,
    );
    expect(queue.cards.length, 3);
    expect(queue.hasNextPage, isFalse);
  });

  test('swipe removes the top card optimistically', () async {
    final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
    final (container, queue) = await _load(repo);
    final String topId = queue.cards.first.id;

    container
        .read(swipeControllerProvider(noCategories).notifier)
        .swipe(SpotReaction.like);

    final SwipeQueue after = container
        .read(swipeControllerProvider(noCategories))
        .value!;
    expect(after.cards.length, 2);
    expect(after.cards.map((TouristSpot s) => s.id), isNot(contains(topId)));
  });

  test('swipe records the reaction for the swiped card', () async {
    final repo = FakeSpotRepository(feed: _spots(3), pageSize: 5);
    final (container, queue) = await _load(repo);
    final String topId = queue.cards.first.id;

    container
        .read(swipeControllerProvider(noCategories).notifier)
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
        .read(swipeControllerProvider(noCategories).notifier)
        .swipe(SpotReaction.like);
    await Future<void>.delayed(Duration.zero);

    // 실패해도 큐는 2장으로 유지(복원 없음).
    expect(
      container.read(swipeControllerProvider(noCategories)).value!.cards.length,
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
        .read(swipeControllerProvider(noCategories).notifier)
        .swipe(SpotReaction.like);
    await Future<void>.delayed(Duration.zero);

    // 재전송이 성공해 반응이 기록된다.
    expect(repo.recordedReactions, contains((topId, SpotReaction.like)));
    // 그리고 큐는 정상 상태 — 오류로 인한 부작용이 없다(오류 미노출).
    expect(
      container.read(swipeControllerProvider(noCategories)).hasError,
      isFalse,
    );
    expect(
      container.read(swipeControllerProvider(noCategories)).value!.cards.length,
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
          .read(swipeControllerProvider(noCategories).notifier)
          .swipe(SpotReaction.like);
      // 낙관적 제거로 2장, 이어서 선제 조회가 다음 페이지를 붙인다.
      await Future<void>.delayed(Duration.zero);

      final SwipeQueue after = container
          .read(swipeControllerProvider(noCategories))
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
          .read(swipeControllerProvider(noCategories).notifier)
          .swipe(SpotReaction.like);
      await Future<void>.delayed(Duration.zero);

      final SwipeQueue after = container
          .read(swipeControllerProvider(noCategories))
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
          .read(swipeControllerProvider(noCategories).notifier)
          .swipe(SpotReaction.like);
      await Future<void>.delayed(Duration.zero);

      final SwipeQueue after = container
          .read(swipeControllerProvider(noCategories))
          .value!;
      // 반응한 카드가 사라졌고, 나머지는 남는다.
      expect(
        after.cards.map((TouristSpot s) => s.id),
        isNot(contains(reacted)),
      );
      expect(after.cards.length, 2);
      // 세션은 계속된다 — 오류 상태로 넘어가지 않는다.
      expect(
        container.read(swipeControllerProvider(noCategories)).hasError,
        isFalse,
      );
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
          .read(swipeControllerProvider(noCategories).notifier)
          .dropMissingCard('gone');

      final AsyncValue<SwipeQueue> state = container.read(
        swipeControllerProvider(noCategories),
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
        selection: selectionOf(const <SpotCategory>[catFestivalEvent]),
      );

      expect(
        container
            .read(
              swipeControllerProvider(
                selectionOf(const <SpotCategory>[catFestivalEvent]),
              ),
            )
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
          .read(swipeControllerProvider(noCategories).notifier)
          .swipe(SpotReaction.like);
      await Future<void>.delayed(Duration.zero);
      expect(
        container
            .read(swipeControllerProvider(noCategories))
            .value!
            .cards
            .length,
        2,
      );

      await container
          .read(localeControllerProvider.notifier)
          .select(AppLanguage.korean);

      final SwipeQueue rebuilt = await container.read(
        swipeControllerProvider(noCategories).future,
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
        .read(swipeControllerProvider(noCategories).notifier)
        .swipe(SpotReaction.like);
    await Future<void>.delayed(Duration.zero);

    // 낙관적으로 빠진 맨 위 카드만 사라지고, 나머지는 그대로다 — SPOT_NOT_FOUND가
    // 아니므로 큐에서 추가로 걷어내지 않는다.
    final SwipeQueue after = container
        .read(swipeControllerProvider(noCategories))
        .value!;
    expect(after.cards.map((TouristSpot s) => s.id), isNot(contains(reacted)));
    expect(after.cards.length, 1);
  });

  test('category families load independently', () async {
    final repo = FakeSpotRepository(
      feed: <TouristSpot>[
        swipeSpot('f1', category: catRestaurant),
        swipeSpot('n1', category: catTouristSpot),
      ],
      pageSize: 5,
    );
    final (container, _) = await _load(repo);

    final SwipeQueue food = await container.read(
      swipeControllerProvider(
        selectionOf(const <SpotCategory>[catRestaurant]),
      ).future,
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

      container
          .read(swipeControllerProvider(noCategories).notifier)
          .consume(topId);
      await Future<void>.delayed(Duration.zero);

      final SwipeQueue after = container
          .read(swipeControllerProvider(noCategories))
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

      container
          .read(swipeControllerProvider(noCategories).notifier)
          .consume(middleId);

      final SwipeQueue after = container
          .read(swipeControllerProvider(noCategories))
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

      container
          .read(swipeControllerProvider(noCategories).notifier)
          .consume('nope');

      expect(
        container.read(swipeControllerProvider(noCategories)).value,
        before,
      );
    });
  });

  // SPEC-0019 — 원문을 먼저 다 보여주고, 소진하면 번역본으로 이어간다. 두 집합은
  // 겹치지 않고 각자 페이지를 0부터 세므로 전환 시 페이지가 되감긴다.
  group('원문 → 번역본 전환', () {
    test('첫 조회는 원문만 요청한다', () async {
      // 원문이 넉넉해 첫 페이지에서 끝나지 않는 상황.
      final repo = FakeSpotRepository(feed: _spots(10), pageSize: 5);
      await _load(repo);

      expect(repo.requestedHasOrigin, <bool?>[true]);
    });

    test('원문이 첫 페이지에서 끝나면 번역본을 이어 받는다', () async {
      final repo = FakeSpotRepository(
        feed: <TouristSpot>[swipeSpot('o1')],
        translatedFeed: <TouristSpot>[swipeSpot('t1'), swipeSpot('t2')],
        pageSize: 5,
      );

      final (_, queue) = await _load(repo);

      // 원문 1건 + 번역본 2건이 한 큐에 담긴다 — 첫 화면이 비지 않는다.
      expect(queue.cards.map((TouristSpot s) => s.id), hasLength(3));
      expect(repo.requestedHasOrigin, <bool?>[true, false]);
      expect(queue.originExhausted, isTrue);
    });

    test('원문도 번역본도 없으면 소진 상태다', () async {
      final repo = FakeSpotRepository(feed: const <TouristSpot>[], pageSize: 5);

      final (_, queue) = await _load(repo);

      // 빈 상태 문구가 뜨려면 isExhausted가 서야 한다 — 원문만 비어서는 안 된다.
      expect(queue.isExhausted, isTrue);
      expect(repo.requestedHasOrigin, <bool?>[true, false]);
    });
  });

  // ─── swipe_consume ───────────────────────────────────────────

  // locale watch가 기기 로케일을 읽으므로 바인딩이 필요하다(SPEC-0007 §4.5).
  TestWidgetsFlutterBinding.ensureInitialized();

  test('반응한 카드가 스택에서 제거된다 (AC-35·AC-36)', () async {
    final (container, queue) = await _consumeLoad(3);
    expect(queue.cards.length, 3);

    container
        .read(swipeControllerProvider(noCategories).notifier)
        .consume('s0');

    expect(_consumeIds(container), isNot(contains('s0')));
    expect(_consumeIds(container), containsAll(<String>['s1', 's2']));
    expect(_consumeIds(container), hasLength(2));
  });

  test('맨 위가 아닌 스택 중간 카드도 제거된다 (AC-36)', () async {
    final (container, _) = await _consumeLoad(3);

    // 맨 위가 아닌 카드를 고른다 — 섞인 뒤라 어느 id가 맨 위인지는 그때그때 다르다.
    final String notTop = _consumeIds(container)[1];
    container
        .read(swipeControllerProvider(noCategories).notifier)
        .consume(notTop);

    expect(_consumeIds(container), isNot(contains(notTop)));
    expect(_consumeIds(container), hasLength(2));
  });

  test('스택에 없는 id는 스택을 변경하지 않는다 (AC-37)', () async {
    final (container, _) = await _consumeLoad(3);
    final List<String> before = _consumeIds(container);

    container
        .read(swipeControllerProvider(noCategories).notifier)
        .consume('없는-id');

    expect(_consumeIds(container), before);
  });

  test('복귀 시 다음 카드가 맨 위가 된다 (R12, AC-39)', () async {
    final (container, _) = await _consumeLoad(3);
    final List<String> before = _consumeIds(container);
    final String top = before.first;

    container.read(swipeControllerProvider(noCategories).notifier).consume(top);

    final SwipeQueue after = container
        .read(swipeControllerProvider(noCategories))
        .value!;
    // 소비한 카드가 아니라 그 다음 카드가 맨 위에 온다 — 복귀 순간 전진이 보인다.
    expect(after.top!.id, before[1]);
  });

  test('마지막 카드를 소비하면 소진 상태가 된다 (AC-40)', () async {
    final (container, _) = await _consumeLoad(1);

    container
        .read(swipeControllerProvider(noCategories).notifier)
        .consume('s0');

    final SwipeQueue after = container
        .read(swipeControllerProvider(noCategories))
        .value!;
    expect(after.isExhausted, isTrue);
  });

  // ─── swipe_radius ────────────────────────────────────────────

  TestWidgetsFlutterBinding.ensureInitialized();

  // 피드가 비어 있으면 원문 조회 뒤 번역본 보충이 한 번 더 나간다(SPEC-0019).
  // 반경은 **모든 조회**에 같은 값으로 실려야 한다.
  test('설정한 반경이 미터로 조회에 실린다', () async {
    final FakeSpotRepository repo = FakeSpotRepository();
    final ProviderContainer container = await _radiusContainer(repo, radiusKm: 1);

    await _radiusLoad(container);

    expect(repo.requestedRadiiMeters, everyElement(1000));
  });

  test('저장한 적 없으면 기본 20km가 실린다', () async {
    final FakeSpotRepository repo = FakeSpotRepository();
    final ProviderContainer container = await _radiusContainer(repo);

    await _radiusLoad(container);

    expect(repo.requestedRadiiMeters, everyElement(20000));
  });

  // 0km는 "현재 위치만"을 뜻하지 **빈 결과**가 아니다(R13 네 번째 기준). 반경 0인
  // 원을 보내면 아무것도 안 걸리므로 인자를 빼고 서버 기본값·거리순에 맡긴다.
  test('0km는 반경 인자를 보내지 않는다', () async {
    final FakeSpotRepository repo = FakeSpotRepository();
    final ProviderContainer container = await _radiusContainer(repo, radiusKm: 0);

    await _radiusLoad(container);

    expect(repo.requestedRadiiMeters, everyElement(null));
  });

  // 사용자가 보고한 증상: 반경을 바꿔도 Discover에 새 데이터가 안 들어왔다.
  // 값을 watch하지 않으면 재빌드 계기가 없어 옛 카드가 그대로 남는다.
  test('반경을 바꾸면 피드를 다시 받는다', () async {
    final FakeSpotRepository repo = FakeSpotRepository();
    final ProviderContainer container = await _radiusContainer(repo, radiusKm: 50);
    await _radiusLoad(container);
    expect(repo.requestedRadiiMeters, everyElement(50000));

    await container.read(searchRadiusControllerProvider.notifier).select(1);
    await container.read(swipeControllerProvider(noCategories).future);

    // 빈 피드라 원문 조회마다 번역본 보충이 뒤따른다(SPEC-0019) — 요지는 반경이
    // 바뀐 뒤의 조회가 **새 반경**으로 나갔는지다.
    expect(repo.requestedRadiiMeters.first, 50000);
    expect(repo.requestedRadiiMeters.last, 1000, reason: '새 반경으로 다시 조회해야 한다');
  });

  test('반경 단위 변환은 km→m다', () {
    expect(radiusMetersOf(1), 1000);
    expect(radiusMetersOf(20), 20000);
    expect(radiusMetersOf(100), 100000);
    expect(radiusMetersOf(0), isNull);
  });

  // ─── swipe_retry_cap ─────────────────────────────────────────

  // locale watch가 기기 로케일을 읽으므로 바인딩이 필요하다(SPEC-0007 §4.5).
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    _prefs = await SharedPreferences.getInstance();
  });

  // 검증 대상은 재시도 횟수지 간격이 아니다. 실제 400ms를 재우면 이 파일 하나가
  // 스위트 전체 시간을 지배한다.
  setUp(() => debugRetryDelay = const Duration(milliseconds: 1));
  tearDown(() => debugRetryDelay = null);

  test('실패하면 자동 재시도가 정확히 1회 더 발생하고 총 2회에서 멈춘다 (AC-1·AC-2)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.network);
    final container = _capContainer(repo);

    await _capSettle(container);

    expect(repo.spotPageCallCount, 2);
  });

  test('최초 조회가 성공하면 재시도가 발생하지 않는다 (AC-3)', () async {
    final repo = FakeSpotRepository(
      feed: <TouristSpot>[swipeSpot('s1')],
      pageSize: 5,
    );
    final container = _capContainer(repo);

    await container.read(swipeControllerProvider(noCategories).future);
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // 원문 1건이 첫 페이지에서 끝나 번역본 보충이 뒤따르므로 2회다(SPEC-0019).
    // **재시도가 없었다는 것**이 이 테스트의 요지 — 재시도라면 같은 원문 조회가
    // 두 번 나가지만, 여기서는 원문 1회 + 번역본 1회로 형태가 다르다.
    expect(repo.requestedHasOrigin, <bool?>[true, false]);
  });

  test('상한 소진 후 무효화가 반복돼도 repository 호출이 늘지 않는다 (AC-11·AC-12)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.network);
    final container = _capContainer(repo);

    await _capSettle(container);
    final int afterExhaustion = repo.spotPageCallCount;

    // 폭주의 경로였던 재빌드를 반복해도 조회가 늘지 않아야 한다.
    for (int i = 0; i < 3; i++) {
      container.invalidate(swipeControllerProvider(noCategories));
      await _capSettle(container);
    }

    expect(repo.spotPageCallCount, afterExhaustion);
  });

  test('상한 도달 상태는 일반 오류와 구분되는 값으로 노출된다 (AC-5·AC-6)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.network);
    final container = _capContainer(repo);

    await _capSettle(container);

    final AsyncValue<SwipeQueue> state = container.read(
      swipeControllerProvider(noCategories),
    );
    expect(state.hasError, isTrue);
    expect(state.error, isA<RetryExhausted>());
  });

  test('상한 소진 상태에서 명시적 재시도는 조회를 발생시킨다 (AC-13)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.network);
    final container = _capContainer(repo);

    await _capSettle(container);
    final int afterExhaustion = repo.spotPageCallCount;

    await container
        .read(swipeControllerProvider(noCategories).notifier)
        .reload();

    expect(repo.spotPageCallCount, greaterThan(afterExhaustion));
  });

  test('명시적 재시도가 성공하면 카운터가 초기화되어 다시 자동 재시도가 가능해진다 (AC-9)', () async {
    // 앞의 2회(최초+자동재시도)만 실패시키고 이후는 성공시킨다.
    final repo = FakeSpotRepository(
      feed: <TouristSpot>[swipeSpot('s1')],
      pageSize: 5,
      pageFailure: SpotFailure.network,
      failPageTimes: 2,
    );
    final container = _capContainer(repo);

    await _capSettle(container);
    expect(
      container.read(swipeControllerProvider(noCategories)).error,
      isA<RetryExhausted>(),
    );

    // 명시적 재시도 → 성공.
    await container
        .read(swipeControllerProvider(noCategories).notifier)
        .reload();
    expect(
      container.read(swipeControllerProvider(noCategories)).hasValue,
      isTrue,
    );

    // 카운터가 초기화됐으므로 소진 상태가 아니다 — 이후 실패에 다시 자동 재시도가 붙는다.
    expect(
      container.read(swipeControllerProvider(noCategories)).error,
      isNot(isA<RetryExhausted>()),
    );
  });

  test('명시적 재시도가 실패하면 종료 상태가 유지된다 (AC-10)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.network);
    final container = _capContainer(repo);

    await _capSettle(container);
    await container
        .read(swipeControllerProvider(noCategories).notifier)
        .reload();

    expect(
      container.read(swipeControllerProvider(noCategories)).error,
      isA<RetryExhausted>(),
    );
  });

  test('인증 실패는 시도 횟수에 계상되지 않아 자동 재시도가 붙지 않는다 (AC-14·AC-15)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.unauthenticated);
    final container = _capContainer(repo);

    await _capSettle(container);

    // 최초 1회만 호출되고, 자동 재시도는 일어나지 않는다 — SPEC-0005 갱신 경로 소관이다.
    expect(repo.spotPageCallCount, 1);
    // 종료 상태로 승격되지도 않는다(계상되지 않았으므로 상한을 쓰지 않았다).
    expect(
      container.read(swipeControllerProvider(noCategories)).error,
      isNot(isA<RetryExhausted>()),
    );
  });

  test('인증 외 실패는 계상되어 상한에 도달한다 (AC-16)', () async {
    final repo = FakeSpotRepository(
      pageFailure: SpotFailure.upstreamUnavailable,
    );
    final container = _capContainer(repo);

    await _capSettle(container);

    expect(repo.spotPageCallCount, 2);
    expect(
      container.read(swipeControllerProvider(noCategories)).error,
      isA<RetryExhausted>(),
    );
  });

  test('카테고리를 바꾸면 상한이 독립적으로 새로 시작된다 (AC-4)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.network);
    final container = _capContainer(repo);

    await _capSettle(container);
    expect(repo.spotPageCallCount, 2);

    // 다른 카테고리는 자기 상한을 새로 쓴다 — 우회가 아니라 확정된 정상 동작이다.
    container.listen(
      swipeControllerProvider(selectionOf(const <SpotCategory>[catLodging])),
      (_, _) {},
      fireImmediately: true,
    );
    await _capSettle(
      container,
      selection: selectionOf(const <SpotCategory>[catLodging]),
    );

    expect(repo.spotPageCallCount, 4);
  });

}
