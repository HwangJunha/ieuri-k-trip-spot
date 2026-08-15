import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/retry_exhausted.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_detail_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/retry_counting.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';

import '../spot_test_doubles.dart';

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

/// 자동 재시도가 끝날 때까지 기다린다. 예상한 실패만 삼키고 그 밖은 다시 던진다 —
/// 전부 삼키면 회귀가 "아직 재시도 중"으로 보여 테스트가 통과해 버린다.
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
