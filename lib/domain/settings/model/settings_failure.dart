/// 설정 데이터 접근 실패(SPEC-0011). repository가 전송/도메인 오류를 이 값으로 번역해
/// provider·UI에 넘긴다 — 서버 문자열을 UI로 직접 흘리지 않는다(POL-013). 순수 도메인.
///
/// 서버 오류는 두 갈래다:
///  - 최상위 `errors[]` — 인증 실패 등 전송·시스템 계열. HTTP는 200이라도 실패다.
///  - payload의 `success`·`userErrors[]` — 도메인 거절.
class SettingsFailure implements Exception {
  const SettingsFailure(this.kind, {this.code});

  /// 전송 오류(네트워크·서버 도달 불가·정체불명 top-level errors).
  static const SettingsFailure network = SettingsFailure(
    SettingsFailureKind.network,
  );

  /// 예상치 못한 응답(데이터 없음·형태 불일치).
  static const SettingsFailure unknown = SettingsFailure(
    SettingsFailureKind.unknown,
  );

  /// 인증 실패. SPEC-0005의 갱신·로그아웃 경로가 소관이다.
  static const SettingsFailure unauthenticated = SettingsFailure(
    SettingsFailureKind.unauthenticated,
  );

  /// 뮤테이션 `userErrors`의 서버 코드로 만든 실패.
  factory SettingsFailure.userError(String code) =>
      SettingsFailure(SettingsFailureKind.userError, code: code);

  final SettingsFailureKind kind;

  /// 서버 `UserError.code`(있으면). 분기·로깅용이며 원문 message는 담지 않는다.
  final String? code;

  /// 최상위 `errors[]`의 코드를 번역한다. 인증 실패만 특정하고 나머지는 [network]로
  /// 안전하게 떨어진다.
  static SettingsFailure fromQueryErrorCode(String? code) =>
      switch (code?.toUpperCase()) {
        'UNAUTHENTICATED' => SettingsFailure.unauthenticated,
        // 토큰 거부(2026-08-25). 갱신으로 회복되는 자리라 위와 같게 다룬다.
        'UNAUTHENTICATED_TOKEN_REJECTED' => SettingsFailure.unauthenticated,
        // 인증 저장소 일시 장애. **인증 실패로 접지 않는다** — 재로그인이
        // 아니라 잠시 후 재시도가 맞고, 재시도 예산에 계상돼야 정상
        // 백오프를 탄다.
        'AUTH_STORE_UNAVAILABLE' => SettingsFailure.network,
        _ => SettingsFailure.network,
      };

  @override
  String toString() => 'SettingsFailure($kind${code == null ? '' : ', $code'})';
}

enum SettingsFailureKind { network, userError, unknown, unauthenticated }
