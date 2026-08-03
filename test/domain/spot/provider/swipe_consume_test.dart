import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_queue.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// 카드 [n]장을 담은 SwipeController를 로드한다.
Future<(ProviderContainer, SwipeQueue)> _load(int n) async {
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
    swipeControllerProvider(null),
    (_, _) {},
    fireImmediately: true,
  );
  final SwipeQueue queue = await container.read(
    swipeControllerProvider(null).future,
  );
  return (container, queue);
}

List<String> _ids(ProviderContainer container) => container
    .read(swipeControllerProvider(null))
    .value!
    .cards
    .map((TouristSpot s) => s.id)
    .toList();

// 피드는 provider에서 한 번 섞이므로(SwipeController의 _shuffled) 카드 **순서**를
// 단언하지 않는다. 소비의 계약은 "그 id가 빠지고 나머지는 남는다"이지 순서가 아니다.
void main() {
  // locale watch가 기기 로케일을 읽으므로 바인딩이 필요하다(SPEC-0007 §4.5).
  TestWidgetsFlutterBinding.ensureInitialized();

  test('반응한 카드가 스택에서 제거된다 (AC-35·AC-36)', () async {
    final (container, queue) = await _load(3);
    expect(queue.cards.length, 3);

    container.read(swipeControllerProvider(null).notifier).consume('s0');

    expect(_ids(container), isNot(contains('s0')));
    expect(_ids(container), containsAll(<String>['s1', 's2']));
    expect(_ids(container), hasLength(2));
  });

  test('맨 위가 아닌 스택 중간 카드도 제거된다 (AC-36)', () async {
    final (container, _) = await _load(3);

    // 맨 위가 아닌 카드를 고른다 — 섞인 뒤라 어느 id가 맨 위인지는 그때그때 다르다.
    final String notTop = _ids(container)[1];
    container.read(swipeControllerProvider(null).notifier).consume(notTop);

    expect(_ids(container), isNot(contains(notTop)));
    expect(_ids(container), hasLength(2));
  });

  test('스택에 없는 id는 스택을 변경하지 않는다 (AC-37)', () async {
    final (container, _) = await _load(3);
    final List<String> before = _ids(container);

    container.read(swipeControllerProvider(null).notifier).consume('없는-id');

    expect(_ids(container), before);
  });

  test('복귀 시 다음 카드가 맨 위가 된다 (R12, AC-39)', () async {
    final (container, _) = await _load(3);
    final List<String> before = _ids(container);
    final String top = before.first;

    container.read(swipeControllerProvider(null).notifier).consume(top);

    final SwipeQueue after = container
        .read(swipeControllerProvider(null))
        .value!;
    // 소비한 카드가 아니라 그 다음 카드가 맨 위에 온다 — 복귀 순간 전진이 보인다.
    expect(after.top!.id, before[1]);
  });

  test('마지막 카드를 소비하면 소진 상태가 된다 (AC-40)', () async {
    final (container, _) = await _load(1);

    container.read(swipeControllerProvider(null).notifier).consume('s0');

    final SwipeQueue after = container
        .read(swipeControllerProvider(null))
        .value!;
    expect(after.isExhausted, isTrue);
  });
}
