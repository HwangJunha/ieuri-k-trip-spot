import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_detail_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// [repo]로 SpotDetailController를 로드해 첫 상세를 반환한다.
Future<(ProviderContainer, SpotDetail)> _load(FakeSpotRepository repo) async {
  final container = ProviderContainer(
    overrides: [spotRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  container.listen(
    spotDetailControllerProvider('c1', SpotCategory.touristSpot),
    (_, _) {},
    fireImmediately: true,
  );
  final SpotDetail detail = await container.read(
    spotDetailControllerProvider('c1', SpotCategory.touristSpot).future,
  );
  return (container, detail);
}

void main() {
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
          .read(
            spotDetailControllerProvider(
              'c1',
              SpotCategory.touristSpot,
            ).notifier,
          )
          .react(SpotReaction.like);

      expect(
        container
            .read(spotDetailControllerProvider('c1', SpotCategory.touristSpot))
            .value!
            .likeCount,
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
      spotDetailControllerProvider('c1', SpotCategory.touristSpot).notifier,
    );

    await notifier.react(SpotReaction.like); // 10 → 11
    await notifier.react(SpotReaction.dislike); // 이전 LIKE 취소 → 10

    expect(
      container
          .read(spotDetailControllerProvider('c1', SpotCategory.touristSpot))
          .value!
          .likeCount,
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
      spotDetailControllerProvider('c1', SpotCategory.touristSpot).notifier,
    );

    await expectLater(
      () => notifier.react(SpotReaction.like),
      throwsA(isA<StateError>()),
    );
    // 낙관적 +1이 롤백돼 원래 값으로 복귀.
    expect(
      container
          .read(spotDetailControllerProvider('c1', SpotCategory.touristSpot))
          .value!
          .likeCount,
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
        spotDetailControllerProvider('c1', SpotCategory.touristSpot).notifier,
      );

      // 인증 실패로 시작했지만 갱신 후 재시도가 성공하므로 예외가 나오지 않는다.
      await notifier.react(SpotReaction.like);

      // 낙관적 +1이 그대로 유지된다 — 롤백 없음.
      expect(
        container
            .read(spotDetailControllerProvider('c1', SpotCategory.touristSpot))
            .value!
            .likeCount,
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
      pageSize: 5,
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
      swipeControllerProvider(null),
      (_, _) {},
      fireImmediately: true,
    );
    await container.read(swipeControllerProvider(null).future);

    final notifier = container.read(
      spotDetailControllerProvider('c1', SpotCategory.touristSpot).notifier,
    );
    await container.read(
      spotDetailControllerProvider('c1', SpotCategory.touristSpot).future,
    );

    await expectLater(
      () => notifier.react(SpotReaction.like),
      throwsA(isA<SpotFailure>()),
    );

    // 낙관적 +1 롤백(AC-30 그대로).
    expect(
      container
          .read(spotDetailControllerProvider('c1', SpotCategory.touristSpot))
          .value!
          .likeCount,
      10,
    );
    // 사라진 축제는 스와이프 스택에서도 빠진다(AC-44).
    expect(
      container
          .read(swipeControllerProvider(null))
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
      pageSize: 5,
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
      swipeControllerProvider(null),
      (_, _) {},
      fireImmediately: true,
    );
    await container.read(swipeControllerProvider(null).future);

    // 상세를 한 번 정상적으로 연 뒤, 그 사이 축제가 삭제된 상황을 만든다.
    container.listen(
      spotDetailControllerProvider('c1', SpotCategory.touristSpot),
      (_, _) {},
      fireImmediately: true,
    );
    await container.read(
      spotDetailControllerProvider('c1', SpotCategory.touristSpot).future,
    );

    repo.detailFailure = SpotFailure.notFound;
    await container
        .read(
          spotDetailControllerProvider('c1', SpotCategory.touristSpot).notifier,
        )
        .reload();

    // 상세 자체는 오류 상태다(사용자가 연 화면이라 그대로 보여준다).
    expect(
      container
          .read(spotDetailControllerProvider('c1', SpotCategory.touristSpot))
          .hasError,
      isTrue,
    );

    final AsyncValue<SwipeQueue> session = container.read(
      swipeControllerProvider(null),
    );
    // 세션은 살아 있고, 사라진 카드만 빠졌다.
    expect(session.hasError, isFalse);
    expect(session.value!.cards.map((TouristSpot s) => s.id), <String>['c2']);
  });
}

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
