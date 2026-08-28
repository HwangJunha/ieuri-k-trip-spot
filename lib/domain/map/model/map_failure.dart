import '../../../common/network/auth_error_codes.dart';

/// 지도 조회 실패(R4·R5·R6). repository가 전송·응답 오류를 이 값으로 번역해
/// provider·UI에 넘긴다 — 서버 코드 문자열을 UI로 직접 흘리지 않는다(POL-016 대비).
///
/// **혼잡도 업스트림 장애는 여기 없다.** 그건 오류가 아니라 응답 안의 `degraded`
/// 표식이며(spec §7.6), 오류로 다루면 지도 전체가 실패한 것처럼 보인다(R11·R29).
///
/// 순수 도메인: flutter/graphql 미의존.
class MapFailure implements Exception, AuthAwareFailure {
  const MapFailure(this.code);

  /// 조회에 실패했다(네트워크·서버 도달 불가·형태 불일치).
  static const MapFailure network = MapFailure(null);

  /// 서버가 실은 오류 코드(있으면). 로깅·분기용이며 UI엔 그대로 노출하지 않는다.
  ///
  /// 관측되는 값: `INVALID_BBOX` · `BBOX_TOO_LARGE` · `INVALID_ZOOM` ·
  /// `AREA_FILTER_REQUIRED` · `CONGESTION_AREA_NOT_FOUND` · `TOO_MANY_AREA_IDS`.
  final String? code;

  /// 액세스 토큰이 만료·무효라 갱신이 필요하다(2026-08-29 신설).
  ///
  /// **이 판별이 없어서 무한 재시도가 났다.** 토큰이 거부돼도 일반 실패로 보여
  /// 재시도 정책이 상한까지 서버를 두드렸고, 회복은 갱신 링크가 해야 하는데 그동안
  /// 같은 토큰으로 같은 요청만 반복됐다. 재시도 정책이 이 값을 보고 멈춘다.
  @override
  bool get isUnauthenticated => isRefreshableAuthErrorCode(code);

  @override
  String toString() => 'MapFailure(${code ?? 'network'})';
}
