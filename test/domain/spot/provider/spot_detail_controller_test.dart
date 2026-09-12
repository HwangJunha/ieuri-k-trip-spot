// 관광지 상세 컨트롤러의 provider 테스트(재시도 상한 포함)를 한 파일에 모았다.
//
// **파일을 더 쪼개지 않는 이유는 속도다** — 파일마다 VM이 뜨므로 파일 수가 곧 실행
// 시간이다. 관심사는 group으로 가른다(CLAUDE.md §8).

import '../spot_test_doubles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/retry_exhausted.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/retry_counting.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_detail_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── spot_detail_controller ────────────────────────────────────
Future<(ProviderContainer, SpotDetail)> _load(FakeSpotRepository repo) async {
  final container = ProviderContainer(
    overrides: [spotRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  container.listen(
    spotDetailControllerProvider('c1'),
    (_, _) {},
    fireImmediately: true,
  );
  final SpotDetail detail = await container.read(
    spotDetailControllerProvider('c1').future,
  );
  return (container, detail);
}

// ─── spot_detail_controller (tail) ─────────────────────────────
/// 첫 `reactToSpot`은 인증 실패로 끝나고 재시도에서 성공하는 저장소(§4.4).
/// 링크 계층의 갱신·재시도를 provider 관점에서 관찰한 모습이다.
class _RetryOnceDetailRepository extends FakeSpotRepository {
  _RetryOnceDetailRepository({required super.detail});

  bool _refreshed = false;

  @override
  Future<void> reactToSpot(String spotId, SpotReaction reaction) async {
    if (!_refreshed) {
      _refreshed = true;
      return reactToSpot(spotId, reaction);
    }
    return super.reactToSpot(spotId, reaction);
  }
}

// ─── spot_detail_retry_cap ─────────────────────────────────────
ProviderContainer _container(FakeSpotRepository repo) {
  final container = ProviderContainer(
    overrides: [spotRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  container.listen(
    spotDetailControllerProvider('c1'),
    (_, _) {},
    fireImmediately: true,
  );
  return container;
}

Future<void> _settle(ProviderContainer container) async {
  for (int i = 0; i < 5; i++) {
    try {
      await container.read(spotDetailControllerProvider('c1').future);
      return;
    } on SpotFailure {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    } on RetryExhausted {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
  }
}

void main() {
  // ─── spot_detail_controller ──────────────────────────────────

  // SPEC-0007 테스트가 스와이프 세션을 함께 세우고, 그 세션이 locale을 watch한다.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('build loads the detail as data', () async {
    final repo = FakeSpotRepository(detail: detailSpot('c1', likeCount: 10));
    final (container, detail) = await _load(repo);

    expect(detail.id, 'c1');
    expect(detail.likeCount, 10);
  });

  // NOTE: 빌드 실패(fetch 실패)가 AsyncError로 노출되는 경로는 위젯 테스트
  // (spot_detail_view_test.dart의 'shows the not-found error state')가 실제 위젯
  // 라이프사이클로 검증한다. 여기 provider 단위 테스트는 낙관적/롤백 로직에 집중한다.

  test(
    'like optimistically increments likeCount and records the reaction',
    () async {
      final repo = FakeSpotRepository(detail: detailSpot('c1', likeCount: 10));
      final (container, _) = await _load(repo);

      await container
          .read(spotDetailControllerProvider('c1').notifier)
          .react(SpotReaction.like);

      expect(
        container.read(spotDetailControllerProvider('c1')).value!.likeCount,
        11,
      );
      expect(repo.recordedReactions, <(String, SpotReaction)>[
        ('c1', SpotReaction.like),
      ]);
    },
  );

  test('re-evaluating LIKE→DISLIKE overwrites: net −1', () async {
    final repo = FakeSpotRepository(detail: detailSpot('c1', likeCount: 10));
    final (container, _) = await _load(repo);
    final notifier = container.read(
      spotDetailControllerProvider('c1').notifier,
    );

    await notifier.react(SpotReaction.like); // 10 → 11
    await notifier.react(SpotReaction.dislike); // 이전 LIKE 취소 → 10

    expect(
      container.read(spotDetailControllerProvider('c1')).value!.likeCount,
      10,
    );
  });

  test('react rolls back likeCount and rethrows on failure (AC-30)', () async {
    final repo = FakeSpotRepository(
      detail: detailSpot('c1', likeCount: 10),
      reactShouldFail: true,
    );
    final (container, _) = await _load(repo);
    final notifier = container.read(
      spotDetailControllerProvider('c1').notifier,
    );

    await expectLater(
      () => notifier.react(SpotReaction.like),
      throwsA(isA<StateError>()),
    );
    // 낙관적 +1이 롤백돼 원래 값으로 복귀.
    expect(
      container.read(spotDetailControllerProvider('c1')).value!.likeCount,
      10,
    );
  });

  // §4.4 — 상세도 스와이프와 동일하게 링크 계층 재시도에 의존한다. 갱신이 성공하면
  // 요청이 성공하므로 **롤백이 발동하지 않는다**(AC-43). 별도의 재전송 장치는 없다.
  test(
    'a reaction that succeeds after a token refresh keeps the optimistic count',
    () async {
      final repo = _RetryOnceDetailRepository(
        detail: detailSpot('c1', likeCount: 10),
      );
      final (container, _) = await _load(repo);
      final notifier = container.read(
        spotDetailControllerProvider('c1').notifier,
      );

      // 인증 실패로 시작했지만 갱신 후 재시도가 성공하므로 예외가 나오지 않는다.
      await notifier.react(SpotReaction.like);

      // 낙관적 +1이 그대로 유지된다 — 롤백 없음.
      expect(
        container.read(spotDetailControllerProvider('c1')).value!.likeCount,
        11,
      );
    },
  );

  // --- SPEC-0007: 삭제된 축제를 상세에서 만난 경우 ---

  test('AC-44 reaction rejected with SPOT_NOT_FOUND rolls back and drops the '
      'card from the swipe session', () async {
    final repo = FakeSpotRepository(
      detail: detailSpot('c1', likeCount: 10),
      feed: <TouristSpot>[swipeSpot('c1'), swipeSpot('c2')],
      reactFailure: const SpotFailure(
        SpotFailureKind.userError,
        code: 'SPOT_NOT_FOUND',
      ),
    );
    // 스와이프 세션이 언어 전환에 반응하려고 locale을 watch하므로(SPEC-0007 §4.5)
    // 저장소도 덮어써야 컨테이너가 선다.
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
    await container.read(swipeControllerProvider(noCategories).future);

    final notifier = container.read(
      spotDetailControllerProvider('c1').notifier,
    );
    await container.read(spotDetailControllerProvider('c1').future);

    await expectLater(
      () => notifier.react(SpotReaction.like),
      throwsA(isA<SpotFailure>()),
    );

    // 낙관적 +1 롤백(AC-30 그대로).
    expect(
      container.read(spotDetailControllerProvider('c1')).value!.likeCount,
      10,
    );
    // 사라진 축제는 스와이프 스택에서도 빠진다(AC-44).
    expect(
      container
          .read(swipeControllerProvider(noCategories))
          .value!
          .cards
          .map((TouristSpot s) => s.id),
      <String>['c2'],
    );
  });

  // 상세의 **첫** 빌드가 던지는 경로는 provider 단위로 재현할 수 없다 —
  // AsyncNotifier가 로딩 상태에서 폐기돼 `.future`가 완결되지 않는다(구독을 미리
  // 걸어도 같다. SPEC-0007 코드를 전부 걷어내도 재현되는, 이 테스트 환경의 성질이다).
  // 그 경로는 spot_detail_view_test.dart가 실제 위젯 라이프사이클로 검증하고,
  // 여기서는 같은 실패를 [reload]로 유발해 스와이프 세션 전파만 본다.
  test('AC-43 detail failing with SPOT_NOT_FOUND drops the card from the swipe '
      'session without failing the session', () async {
    final repo = FakeSpotRepository(
      feed: <TouristSpot>[swipeSpot('c1'), swipeSpot('c2')],
      detail: detailSpot('c1'),
    );
    // 스와이프 세션이 언어 전환에 반응하려고 locale을 watch하므로(SPEC-0007 §4.5)
    // 저장소도 덮어써야 컨테이너가 선다.
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
    await container.read(swipeControllerProvider(noCategories).future);

    // 상세를 한 번 정상적으로 연 뒤, 그 사이 축제가 삭제된 상황을 만든다.
    container.listen(
      spotDetailControllerProvider('c1'),
      (_, _) {},
      fireImmediately: true,
    );
    await container.read(spotDetailControllerProvider('c1').future);

    repo.detailFailure = SpotFailure.notFound;
    await container.read(spotDetailControllerProvider('c1').notifier).reload();

    // 상세 자체는 오류 상태다(사용자가 연 화면이라 그대로 보여준다).
    expect(container.read(spotDetailControllerProvider('c1')).hasError, isTrue);

    final AsyncValue<SwipeQueue> session = container.read(
      swipeControllerProvider(noCategories),
    );
    // 세션은 살아 있고, 사라진 카드만 빠졌다.
    expect(session.hasError, isFalse);
    expect(session.value!.cards.map((TouristSpot s) => s.id), <String>['c2']);
  });

  // ─── spot_detail_retry_cap ───────────────────────────────────

  // 검증 대상은 재시도 횟수지 간격이 아니다(스위트 시간 낭비 방지).
  setUp(() => debugRetryDelay = const Duration(milliseconds: 1));
  tearDown(() => debugRetryDelay = null);

  test('상세 조회 실패도 자동 재시도 1회 뒤 총 2회에서 멈춘다 (AC-1·AC-2)', () async {
    final repo = FakeSpotRepository(detailFailure: SpotFailure.network);
    final container = _container(repo);

    await _settle(container);

    expect(repo.detailCallCount, 2);
    expect(
      container.read(spotDetailControllerProvider('c1')).error,
      isA<RetryExhausted>(),
    );
  });

  test('상한 소진 후 무효화를 반복해도 조회가 늘지 않는다 (AC-11·AC-12)', () async {
    final repo = FakeSpotRepository(detailFailure: SpotFailure.network);
    final container = _container(repo);

    await _settle(container);
    final int afterExhaustion = repo.detailCallCount;

    for (int i = 0; i < 3; i++) {
      container.invalidate(spotDetailControllerProvider('c1'));
      await _settle(container);
    }

    expect(repo.detailCallCount, afterExhaustion);
  });

  test('인증 실패는 계상되지 않아 자동 재시도가 붙지 않는다 (AC-14·AC-15)', () async {
    final repo = FakeSpotRepository(detailFailure: SpotFailure.unauthenticated);
    final container = _container(repo);

    await _settle(container);

    expect(repo.detailCallCount, 1);
    expect(
      container.read(spotDetailControllerProvider('c1')).error,
      isNot(isA<RetryExhausted>()),
    );
  });

  test('명시적 재시도가 성공하면 카운터가 초기화된다 (AC-9)', () async {
    final repo = FakeSpotRepository(detailFailure: SpotFailure.network)
      ..failDetailTimes = 2;
    final container = _container(repo);

    await _settle(container);
    expect(
      container.read(spotDetailControllerProvider('c1')).error,
      isA<RetryExhausted>(),
    );

    await container.read(spotDetailControllerProvider('c1').notifier).reload();

    expect(container.read(spotDetailControllerProvider('c1')).hasValue, isTrue);
  });

  test('본문 조회가 완료되면 응답의 썸네일이 최종 값이 된다 (AC-26)', () async {
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    final container = _container(repo);

    final SpotDetail detail = await container.read(
      spotDetailControllerProvider('c1').future,
    );

    // 라우트가 넘긴 값과 무관하게, 조회 결과의 thumbnailImageUrl이 최종 값이다.
    expect(detail.thumbnailImageUrl, 'https://img/c1.jpg');
  });
}
