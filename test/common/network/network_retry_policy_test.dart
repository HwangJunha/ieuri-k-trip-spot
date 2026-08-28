import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/common/network/auth_error_codes.dart';
import 'package:ieuri_k_trip_spot/common/network/network_retry_policy.dart';
import 'package:ieuri_k_trip_spot/domain/event/model/event_failure.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_failure.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/national_map_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';

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

  // --- 인증 실패(2026-08-29) -------------------------------------------------

  /// 액세스 토큰이 거부된 상태에서 홈 화면의 세 쿼리가 0.5초 간격으로 끝없이
  /// 서버를 두드렸다(실기기). 재시도해도 같은 토큰으로 같은 실패가 나고, 홈 섹션은
  /// 위치를 watch해 의존성이 바뀔 때마다 Riverpod이 재시도 카운터를 리셋하므로
  /// 5회 상한마저 무의미했다.
  group('인증 실패는 재시도하지 않는다', () {
    test('갱신 가능한 인증 실패면 첫 재시도부터 막는다', () {
      expect(defaultNetworkRetry(0, SpotFailure.unauthenticated), isNull);
    });

    test('모든 도메인의 실패 타입이 함께 걸린다', () {
      // 도메인마다 실패 타입이 다르지만 공통 인터페이스 하나로 판별한다 —
      // 예전에는 이 판별이 없어 7개 도메인 37곳이 전부 폭주 경로였다.
      final List<Object> authFailures = <Object>[
        SpotFailure.unauthenticated,
        const MapFailure('UNAUTHENTICATED'),
        const EventFailure('UNAUTHENTICATED'),
        const NationalMapFailure('UNAUTHENTICATED'),
      ];
      for (final Object failure in authFailures) {
        expect(
          defaultNetworkRetry(0, failure),
          isNull,
          reason: '$failure 는 재시도하면 안 된다',
        );
      }
    });

    test('서버가 2026-08-25에 더한 토큰 거부 코드도 잡는다', () {
      // `UNAUTHENTICATED` 한 줄만 보던 시절 이 코드를 놓쳐 일반 실패로 재시도했다.
      for (final String code in <String>[
        'UNAUTHENTICATED_TOKEN_REJECTED',
        'INVALID_TOKEN',
      ]) {
        expect(defaultNetworkRetry(0, MapFailure(code)), isNull, reason: code);
        expect(
          defaultNetworkRetry(0, NationalMapFailure(code)),
          isNull,
          reason: code,
        );
      }
    });

    test('인증과 무관한 실패는 정상 백오프를 탄다', () {
      // 과잉 차단 방지 — 네트워크 실패는 재시도해야 회복된다.
      expect(defaultNetworkRetry(0, MapFailure.network), isNotNull);
      expect(defaultNetworkRetry(0, EventFailure.network), isNotNull);
      expect(
        defaultNetworkRetry(0, const MapFailure('BBOX_TOO_LARGE')),
        isNotNull,
      );
    });

    test('갱신으로 회복되지 않는 코드는 여기서 거르지 않는다', () {
      // `AUTH_STORE_UNAVAILABLE`은 토큰이 멀쩡한 일시 장애라 정상 백오프를 타야
      // 하고, `TOKEN_REUSE_DETECTED`는 재로그인 소관이라 갱신 판별에 넣지 않는다.
      expect(
        defaultNetworkRetry(0, const MapFailure('AUTH_STORE_UNAVAILABLE')),
        isNotNull,
      );
      expect(
        isRefreshableAuthErrorCode('TOKEN_REUSE_DETECTED'),
        isFalse,
      );
    });
  });
}
