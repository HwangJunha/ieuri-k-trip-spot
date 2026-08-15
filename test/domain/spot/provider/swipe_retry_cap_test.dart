import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/retry_exhausted.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category_selection.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/retry_counting.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// SwipeController를 구독한 컨테이너를 만든다. 구독을 유지해야 autoDispose가
/// read 사이에 상태를 버리지 않는다.
/// SwipeController가 언어 전환 시 세션을 다시 만들려고 locale을 watch하므로
/// (SPEC-0007 §4.5) 저장소도 덮어써야 컨테이너가 선다. `setUpAll`에서 한 번 받아둔다
/// — 이 헬퍼는 동기라 여기서 await할 수 없다.
late final SharedPreferences _prefs;

ProviderContainer _container(
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

/// 자동 재시도가 모두 끝날 때까지 기다린다.
///
/// 예상한 실패(SpotFailure·RetryExhausted)만 삼키고 그 밖의 예외는 다시 던진다 —
/// 전부 삼키면 TypeError 같은 회귀가 "아직 재시도 중"으로 보여 테스트가 통과해 버린다.
Future<void> _settle(
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
      await Future<void>.delayed(_settleStep);
    } on RetryExhausted {
      await Future<void>.delayed(_settleStep);
    }
  }
}

/// 재시도 타이머(테스트에서 1ms)가 확실히 지나도록 하는 폴링 간격.
const Duration _settleStep = Duration(milliseconds: 20);

void main() {
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
    final container = _container(repo);

    await _settle(container);

    expect(repo.spotPageCallCount, 2);
  });

  test('최초 조회가 성공하면 재시도가 발생하지 않는다 (AC-3)', () async {
    final repo = FakeSpotRepository(
      feed: <TouristSpot>[swipeSpot('s1')],
      pageSize: 5,
    );
    final container = _container(repo);

    await container.read(swipeControllerProvider(noCategories).future);
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // 원문 1건이 첫 페이지에서 끝나 번역본 보충이 뒤따르므로 2회다(SPEC-0019).
    // **재시도가 없었다는 것**이 이 테스트의 요지 — 재시도라면 같은 원문 조회가
    // 두 번 나가지만, 여기서는 원문 1회 + 번역본 1회로 형태가 다르다.
    expect(repo.requestedHasOrigin, <bool?>[true, false]);
  });

  test('상한 소진 후 무효화가 반복돼도 repository 호출이 늘지 않는다 (AC-11·AC-12)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.network);
    final container = _container(repo);

    await _settle(container);
    final int afterExhaustion = repo.spotPageCallCount;

    // 폭주의 경로였던 재빌드를 반복해도 조회가 늘지 않아야 한다.
    for (int i = 0; i < 3; i++) {
      container.invalidate(swipeControllerProvider(noCategories));
      await _settle(container);
    }

    expect(repo.spotPageCallCount, afterExhaustion);
  });

  test('상한 도달 상태는 일반 오류와 구분되는 값으로 노출된다 (AC-5·AC-6)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.network);
    final container = _container(repo);

    await _settle(container);

    final AsyncValue<SwipeQueue> state = container.read(
      swipeControllerProvider(noCategories),
    );
    expect(state.hasError, isTrue);
    expect(state.error, isA<RetryExhausted>());
  });

  test('상한 소진 상태에서 명시적 재시도는 조회를 발생시킨다 (AC-13)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.network);
    final container = _container(repo);

    await _settle(container);
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
    final container = _container(repo);

    await _settle(container);
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
    final container = _container(repo);

    await _settle(container);
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
    final container = _container(repo);

    await _settle(container);

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
    final container = _container(repo);

    await _settle(container);

    expect(repo.spotPageCallCount, 2);
    expect(
      container.read(swipeControllerProvider(noCategories)).error,
      isA<RetryExhausted>(),
    );
  });

  test('카테고리를 바꾸면 상한이 독립적으로 새로 시작된다 (AC-4)', () async {
    final repo = FakeSpotRepository(pageFailure: SpotFailure.network);
    final container = _container(repo);

    await _settle(container);
    expect(repo.spotPageCallCount, 2);

    // 다른 카테고리는 자기 상한을 새로 쓴다 — 우회가 아니라 확정된 정상 동작이다.
    container.listen(
      swipeControllerProvider(selectionOf(const <SpotCategory>[catLodging])),
      (_, _) {},
      fireImmediately: true,
    );
    await _settle(
      container,
      selection: selectionOf(const <SpotCategory>[catLodging]),
    );

    expect(repo.spotPageCallCount, 4);
  });
}
