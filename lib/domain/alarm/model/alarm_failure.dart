/// 알림 데이터 접근 실패(SPEC-0028). repository가 전송/도메인 오류를 이 값으로 번역해
/// provider에 넘긴다 — 서버 문자열을 UI로 직접 흘리지 않는다(POL-013). 순수 도메인.
///
/// **토큰 등록 실패는 사용자에게 노출되지 않는다.** 등록·해제 경로는 이 실패를 잡아
/// 로그만 남긴다(R12·AC12.3). 그럼에도 예외 타입을 두는 이유는 설정 토글(R19)이
/// 실패를 사용자에게 보여야 하기 때문이다 — 두 경로가 같은 repository를 쓴다.
class AlarmFailure implements Exception {
  const AlarmFailure(this.kind, {this.code});

  /// 전송 오류(네트워크·서버 도달 불가·정체불명 top-level errors).
  static const AlarmFailure network = AlarmFailure(AlarmFailureKind.network);

  /// 예상치 못한 응답(데이터 없음·형태 불일치).
  static const AlarmFailure unknown = AlarmFailure(AlarmFailureKind.unknown);

  /// 인증 실패. SPEC-0005의 갱신·로그아웃 경로가 소관이다.
  static const AlarmFailure unauthenticated = AlarmFailure(
    AlarmFailureKind.unauthenticated,
  );

  /// 뮤테이션 `userErrors`의 서버 코드로 만든 실패.
  factory AlarmFailure.userError(String code) =>
      AlarmFailure(AlarmFailureKind.userError, code: code);

  final AlarmFailureKind kind;

  /// 서버 `UserError.code`(있으면). 분기·로깅용이며 원문 message는 담지 않는다.
  final String? code;

  /// 최상위 `errors[]`의 코드를 번역한다. 인증 실패만 특정하고 나머지는 [network]로
  /// 안전하게 떨어진다.
  static AlarmFailure fromQueryErrorCode(String? code) =>
      switch (code?.toUpperCase()) {
        'UNAUTHENTICATED' => AlarmFailure.unauthenticated,
        // 토큰 거부(2026-08-25). 갱신으로 회복되는 자리라 위와 같게 다룬다.
        'UNAUTHENTICATED_TOKEN_REJECTED' => AlarmFailure.unauthenticated,
        // 인증 저장소 일시 장애. **인증 실패로 접지 않는다** — 재로그인이
        // 아니라 잠시 후 재시도가 맞고, 재시도 예산에 계상돼야 정상
        // 백오프를 탄다.
        'AUTH_STORE_UNAVAILABLE' => AlarmFailure.network,
        _ => AlarmFailure.network,
      };

  @override
  String toString() => 'AlarmFailure($kind${code == null ? '' : ', $code'})';
}

enum AlarmFailureKind { network, userError, unknown, unauthenticated }
