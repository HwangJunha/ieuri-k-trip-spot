import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';

void main() {
  test('fromQueryErrorCode maps known codes to kinds', () {
    expect(
      SpotFailure.fromQueryErrorCode('SPOT_NOT_FOUND').kind,
      SpotFailureKind.notFound,
    );
    expect(
      SpotFailure.fromQueryErrorCode('UPSTREAM_RATE_LIMITED').kind,
      SpotFailureKind.rateLimited,
    );
    expect(
      SpotFailure.fromQueryErrorCode('UPSTREAM_UNAVAILABLE').kind,
      SpotFailureKind.upstreamUnavailable,
    );
  });

  test('fromQueryErrorCode is case-insensitive', () {
    expect(
      SpotFailure.fromQueryErrorCode('spot_not_found').kind,
      SpotFailureKind.notFound,
    );
  });

  test('isSpotMissing covers both the query and the mutation shape', () {
    // 상세 조회: 최상위 errors[] → notFound로 번역된 형태.
    expect(SpotFailure.notFound.isSpotMissing, isTrue);
    // 반응 전송: payload userErrors[] → userError + 코드 형태(대소문자 무관).
    expect(
      const SpotFailure(
        SpotFailureKind.userError,
        code: 'spot_not_found',
      ).isSpotMissing,
      isTrue,
    );
    expect(SpotFailure.rateLimited.isSpotMissing, isFalse);
  });

  test('fromQueryErrorCode falls back to network for unknown/null', () {
    expect(
      SpotFailure.fromQueryErrorCode('WHATEVER').kind,
      SpotFailureKind.network,
    );
    expect(SpotFailure.fromQueryErrorCode(null).kind, SpotFailureKind.network);
  });
}
