import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/retry_budget.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/retry_exhausted.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/retry_counting.dart';

void main() {
  group('RetryBudget', () {
    test('기본 상한은 최초 1회 + 자동 재시도 1회 = 총 2회다 (AC-2)', () {
      const RetryBudget budget = RetryBudget();
      expect(budget.isExhausted, isFalse);
      expect(budget.countFailure(SpotFailure.network).isExhausted, isFalse);
      expect(
        budget
            .countFailure(SpotFailure.network)
            .countFailure(SpotFailure.network)
            .isExhausted,
        isTrue,
      );
    });

    test('상한을 넘겨 카운터가 계속 커지지 않는다', () {
      RetryBudget budget = const RetryBudget();
      for (int i = 0; i < 5; i++) {
        budget = budget.countFailure(SpotFailure.network);
      }
      expect(budget.attempts, RetryBudget.defaultMaxAttempts);
    });

    test('소진시킨 실패를 보존해 원인을 지어내지 않는다', () {
      final RetryBudget exhausted = const RetryBudget()
          .countFailure(SpotFailure.network)
          .countFailure(SpotFailure.upstreamUnavailable);
      expect(exhausted.isExhausted, isTrue);
      expect(exhausted.lastFailure, SpotFailure.upstreamUnavailable);
    });

    test('reset은 카운터를 0으로 되돌린다 (AC-9)', () {
      final RetryBudget exhausted = const RetryBudget()
          .countFailure(SpotFailure.network)
          .countFailure(SpotFailure.network);
      expect(exhausted.isExhausted, isTrue);
      expect(exhausted.reset().isExhausted, isFalse);
      expect(exhausted.reset().attempts, 0);
    });

    test('자동 재시도 허용 횟수는 상한에서 파생되어 어긋나지 않는다', () {
      expect(maxAutoRetries, RetryBudget.defaultMaxAttempts - 1);
    });
  });

  group('countsTowardRetryBudget', () {
    test('인증 실패는 계상하지 않는다 (AC-14)', () {
      expect(countsTowardRetryBudget(SpotFailure.unauthenticated), isFalse);
    });

    test('위치 실패는 계상하지 않는다', () {
      expect(
        countsTowardRetryBudget(
          const LocationUnavailable(LocationUnavailableReason.permissionDenied),
        ),
        isFalse,
      );
    });

    test('네트워크·업스트림 실패는 계상한다 (AC-16)', () {
      expect(countsTowardRetryBudget(SpotFailure.network), isTrue);
      expect(countsTowardRetryBudget(SpotFailure.upstreamUnavailable), isTrue);
      expect(countsTowardRetryBudget(SpotFailure.notFound), isTrue);
    });
  });

  group('spotRetryPolicy', () {
    test('자동 재시도를 1회만 허용한다 (AC-1·AC-2)', () {
      expect(spotRetryPolicy(0, SpotFailure.network), isNotNull);
      expect(spotRetryPolicy(1, SpotFailure.network), isNull);
    });

    test('계상하지 않는 실패에는 자동 재시도를 붙이지 않는다 (AC-15)', () {
      expect(spotRetryPolicy(0, SpotFailure.unauthenticated), isNull);
    });
  });

  test('RetryExhausted는 원인을 보존한다', () {
    const RetryExhausted exhausted = RetryExhausted(SpotFailure.network);
    expect(exhausted.cause, SpotFailure.network);
  });
}
