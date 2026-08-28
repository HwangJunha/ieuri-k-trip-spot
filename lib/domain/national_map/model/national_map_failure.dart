import '../../../common/network/auth_error_codes.dart';

/// 전국 지도 데이터 접근 실패(SPEC-0030 §7).
///
/// 순수 도메인이다 — flutter/graphql에 의존하지 않는다.
class NationalMapFailure implements Exception, AuthAwareFailure {
  const NationalMapFailure(this.code);

  /// 네트워크·전송 실패. 서버가 코드를 주지 않은 경우다.
  static const NationalMapFailure network = NationalMapFailure(null);

  /// 서버가 실은 오류 코드(있으면). 로깅·분기용이며 UI에 그대로 노출하지 않는다.
  final String? code;

  /// 칸 id가 없다.
  bool get isCellMissing => code == 'MAP_CELL_NOT_FOUND';

  /// 공유 링크가 없거나 폐기됐다.
  ///
  /// **서버가 둘을 구분하지 않는다** — 구분하면 토큰을 넣어 보며 그 사람이
  /// 공유했었는지 알아낼 수 있다.
  bool get isShareLinkGone => code == 'SHARE_LINK_NOT_FOUND';

  /// 차단 관계라 볼 수 없다(POL-041).
  bool get isShareLinkBlocked => code == 'SHARE_LINK_BLOCKED';

  /// 인증이 필요하다. **항상 최상위 `errors[]`로 온다** — 토큰 자동 갱신이
  /// 최상위를 보기 때문이다.
  ///
  /// 예전에는 `code == 'UNAUTHENTICATED'` 한 줄이라 서버가 2026-08-25에 추가한
  /// `UNAUTHENTICATED_TOKEN_REJECTED`를 놓쳤다 — 토큰이 거부돼도 일반 실패로 보여
  /// 재시도 상한까지 서버를 두드렸다. 목록을 공용으로 옮겨 서버가 코드를 늘려도
  /// 한곳만 고치면 되게 했다.
  @override
  bool get isUnauthenticated => isRefreshableAuthErrorCode(code);

  @override
  String toString() => 'NationalMapFailure(${code ?? 'network'})';
}
