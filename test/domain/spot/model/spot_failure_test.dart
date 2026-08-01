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

  test('fromQueryErrorCode falls back to network for unknown/null', () {
    expect(
      SpotFailure.fromQueryErrorCode('WHATEVER').kind,
      SpotFailureKind.network,
    );
    expect(SpotFailure.fromQueryErrorCode(null).kind, SpotFailureKind.network);
  });
}
