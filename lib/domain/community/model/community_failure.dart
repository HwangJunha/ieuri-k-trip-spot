import '../../../common/network/auth_error_codes.dart';

/// 커뮤니티 데이터 접근 실패(SPEC-0010). repository가 전송/도메인 오류를 이 값으로
/// 번역해 provider·UI에 넘긴다 — 서버 코드 문자열을 UI로 직접 흘리지 않는다. 순수 도메인.
///
/// 서버 오류는 **두 갈래다**(가이드 §7):
///  - 최상위 `errors[]` — **인증 실패만**. `UNAUTHENTICATED`는 `userErrors`에 담기지
///    않으며 토큰 자동 갱신은 링크 계층(SPEC-0005)이 처리한다. 갱신까지 실패해 원래
///    오류가 올라오면 [unauthenticated]가 된다.
///  - payload의 `userErrors[]` — 나머지 전부. `success`와 함께 오며 HTTP는 200이다.
///    [CommunityFailureKind.userError] + 서버 [code]로 번역된다.
///
/// 그 밖의 전송 오류(연결 실패, 정체불명 top-level errors)는 [network]다.
class CommunityFailure implements Exception, AuthAwareFailure {
  const CommunityFailure(this.kind, {this.code});

  /// 전송 오류(네트워크·서버 도달 불가·정체불명 top-level errors).
  static const CommunityFailure network = CommunityFailure(
    CommunityFailureKind.network,
  );

  /// 예상치 못한 응답(데이터 없음·형태 불일치).
  static const CommunityFailure unknown = CommunityFailure(
    CommunityFailureKind.unknown,
  );

  /// 인증 실패(UNAUTHENTICATED). SPEC-0005의 갱신·로그아웃 경로가 소관이며 여기서
  /// 재조회를 반복해도 해결되지 않는다.
  static const CommunityFailure unauthenticated = CommunityFailure(
    CommunityFailureKind.unauthenticated,
  );

  /// 뮤테이션 [userErrors]의 서버 코드로 만든 실패.
  factory CommunityFailure.userError(String code) =>
      CommunityFailure(CommunityFailureKind.userError, code: code);

  final CommunityFailureKind kind;

  /// 서버 `UserError.code`(있으면). 로깅·분기용이며 원문 message는 담지 않는다 —
  /// 서버 문자열에 PII가 실릴 수 있다(POL-013).
  final String? code;

  /// 최상위 `errors[]`의 코드/메시지를 번역한다. 인증 실패만 특정하고 나머지는
  /// [network]로 안전하게 떨어진다 — 가이드 §7이 최상위에 오는 것은 인증 실패뿐이라고
  /// 못 박았지만, 지금 서버는 커넥션 어댑터 예외 같은 내부 오류도 최상위로 올린다.
  static CommunityFailure fromQueryErrorCode(String? code) =>
      switch (code?.toUpperCase()) {
        'UNAUTHENTICATED' => CommunityFailure.unauthenticated,
        // 토큰 거부(2026-08-25). 갱신으로 회복되는 자리라 위와 같게 다룬다.
        'UNAUTHENTICATED_TOKEN_REJECTED' => CommunityFailure.unauthenticated,
        // 인증 저장소 일시 장애. **인증 실패로 접지 않는다** — 재로그인이
        // 아니라 잠시 후 재시도가 맞고, 재시도 예산에 계상돼야 정상
        // 백오프를 탄다.
        'AUTH_STORE_UNAVAILABLE' => CommunityFailure.network,
        _ => CommunityFailure.network,
      };

  /// 액세스 토큰이 만료·무효라 갱신이 필요하다.
  ///
  /// **공통 재시도 정책이 보는 이름이다**(`common/network/network_retry_policy.dart`).
  /// 도메인마다 실패 타입이 달라 공통 코드가 `kind`를 알 수 없으므로, 모든 failure가
  /// 같은 이름의 게터를 노출해 그쪽에서 하나로 판별한다 — 인증 실패에 자동 재시도를
  /// 하면 같은 토큰으로 같은 실패가 나 상한까지 헛돈다(2026-08-29 실기기).
  @override
  bool get isUnauthenticated => kind == CommunityFailureKind.unauthenticated;

  @override
  String toString() =>
      'CommunityFailure($kind${code == null ? '' : ', $code'})';
}

enum CommunityFailureKind { network, userError, unknown, unauthenticated }
