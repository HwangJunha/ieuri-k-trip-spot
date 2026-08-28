import '../../../common/network/auth_error_codes.dart';

/// 축제 조회 실패(SPEC-0013 R17). repository가 전송/응답 오류를 이 값으로 번역해
/// provider·UI에 넘긴다 — 서버 코드 문자열을 UI로 직접 흘리지 않는다(POL-016 대비).
///
/// **유형을 하나로 둔다.** Happening Now는 홈의 한 섹션이고 화면이 할 수 있는 일은
/// "다시 시도" 하나뿐이라(R20), 실패를 세분해도 분기할 곳이 없다. 구분이 필요해지면
/// 그때 나눈다.
///
/// 순수 도메인: flutter/graphql 미의존.
class EventFailure implements Exception, AuthAwareFailure {
  const EventFailure(this.code);

  /// 조회에 실패했다(네트워크·서버 도달 불가·형태 불일치).
  static const EventFailure network = EventFailure(null);

  /// 서버가 실은 오류 코드(있으면). 로깅용이며 UI엔 노출하지 않는다.
  final String? code;

  /// 액세스 토큰이 만료·무효라 갱신이 필요하다(2026-08-29 신설).
  ///
  /// **유형을 하나로 둔다는 위 방침의 예외다.** 화면이 할 수 있는 일은 여전히 "다시
  /// 시도" 하나지만, 이 값은 UI 분기가 아니라 **재시도 정책**이 본다 — 인증 실패에
  /// 재시도하면 같은 토큰으로 같은 실패가 나므로 상한까지 헛돈다(2026-08-29 실기기).
  @override
  bool get isUnauthenticated => isRefreshableAuthErrorCode(code);

  @override
  String toString() => 'EventFailure(${code ?? 'network'})';
}
