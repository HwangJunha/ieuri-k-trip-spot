import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/common/network/network_retry_policy.dart';

/// 자동 재시도 정책(SPEC-0032 R17).
///
/// **서버에 WAF도 rate limit도 없다.** 이 수치가 조용히 바뀌면 그대로 부하가
/// 되므로, 값 자체를 고정해 둔다 — 바꾸려면 이 테스트를 함께 고쳐야 한다.
void main() {
  group('자동 재시도 정책', () {
    test('최초 시도 + 5회에서 멈춘다', () {
      final Object error = Exception('boom');
      // 0~4번째 재시도는 허용, 5번째는 없다.
      for (int i = 0; i < defaultMaxAutoRetries; i++) {
        expect(defaultNetworkRetry(i, error), isNotNull, reason: 'retry $i');
      }
      expect(defaultNetworkRetry(defaultMaxAutoRetries, error), isNull);
    });

    test('간격은 0.5초에서 두 배씩 늘어나되 3초에서 잘린다', () {
      // 서버가 잠깐 밀렸을 때 회복할 틈을 준다 — 고정 간격이면 같은 횟수로도
      // 몰아치게 된다(사용자 결정, 2026-08-26).
      expect(defaultRetryDelayOf(0), const Duration(milliseconds: 500));
      expect(defaultRetryDelayOf(1), const Duration(seconds: 1));
      expect(defaultRetryDelayOf(2), const Duration(seconds: 2));
      // 상한이 없으면 4초·8초가 되어 총 15.5초 — 그동안 화면은 로딩만 보여
      // 사용자는 멈춘 것으로 겪는다(실기기 지적, 2026-08-26).
      expect(defaultRetryDelayOf(3), maxRetryDelay);
      expect(defaultRetryDelayOf(4), maxRetryDelay);
    });

    test('다 써도 9.5초를 넘지 않는다', () {
      Duration total = Duration.zero;
      for (int i = 0; i < defaultMaxAutoRetries; i++) {
        total += defaultRetryDelayOf(i);
      }
      expect(total, const Duration(milliseconds: 9500));
    });

    test('위치 실패는 재시도하지 않는다', () {
      // 권한 거부나 GPS 꺼짐은 다시 물어도 같은 답이다 — SPEC-0001 안내 소관.
      expect(
        defaultNetworkRetry(
          0,
          const LocationUnavailable(LocationUnavailableReason.permissionDenied),
        ),
        isNull,
      );
    });
  });
}
