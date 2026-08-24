import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/provider/region_recommendation_provider.dart';

/// 재시도 상한(R28 · POL-040).
///
/// **횟수 상한이지 시간 기반이 아니다**(§5.2). 상한을 넘겨 누를 수 있으면 해결되지
/// 않는 요청이 서버에 쌓인다.
void main() {
  RegionRecommendationRetryCount counterOf(ProviderContainer c) =>
      c.read(regionRecommendationRetryCountProvider.notifier);

  ProviderContainer container() {
    final ProviderContainer c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  test('처음에는 재시도할 수 있다', () {
    expect(counterOf(container()).canRetry, isTrue);
  });

  test('상한 횟수까지만 쓸 수 있다', () {
    final RegionRecommendationRetryCount counter = counterOf(container());

    // 상한보다 넉넉히 누른다.
    for (int i = 0; i < regionRecommendationRetryLimit + 3; i++) {
      counter.record();
    }

    expect(counter.canRetry, isFalse);
    // 상한을 넘겨 늘어나지 않는다 — 넘겨 세면 "남은 횟수"가 음수가 된다.
    expect(counter.remaining, 0);
  });

  test('상한 직전까지는 계속 재시도할 수 있다', () {
    final RegionRecommendationRetryCount counter = counterOf(container());

    for (int i = 0; i < regionRecommendationRetryLimit - 1; i++) {
      counter.record();
      expect(counter.canRetry, isTrue);
    }

    // 마지막 한 번을 쓰면 그때 막힌다.
    counter.record();
    expect(counter.canRetry, isFalse);
  });

  test('남은 횟수가 쓴 만큼 줄어든다', () {
    final RegionRecommendationRetryCount counter = counterOf(container());

    counter.record();

    expect(counter.remaining, regionRecommendationRetryLimit - 1);
  });

  test('다시 열면 상한이 초기화된다', () {
    final RegionRecommendationRetryCount counter = counterOf(container());
    for (int i = 0; i < regionRecommendationRetryLimit; i++) {
      counter.record();
    }

    counter.reset();

    expect(counter.canRetry, isTrue);
    expect(counter.remaining, regionRecommendationRetryLimit);
  });
}
