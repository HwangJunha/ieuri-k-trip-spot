/// 코드 검증이 통과하지 못한 이유(SPEC-0024 §6).
///
/// **이것은 오류가 아니라 결과다.** 서버의 `success`는 "요청이 정상 처리됐는가"이지
/// "코드가 맞았는가"가 아니라서, 코드가 틀려도 `success: true`에 `verified: false`와
/// `failureReason`이 온다. `userErrors`를 보면 비어 있다.
///
/// 이걸 뭉개면 사용자는 "알 수 없는 오류"만 보게 된다 — 만료된 코드와 오타는 사용자가
/// 해야 할 행동이 다르다(재발송 vs 다시 입력).
enum VerificationFailureReason {
  /// 코드가 만료됨 — 재발송이 필요하다.
  expired,

  /// 이미 사용된 코드 — 재발송이 필요하다.
  consumed,

  /// 시도 횟수 초과 — 재발송이 필요하다.
  maxAttemptsExceeded,

  /// 코드가 일치하지 않음 — 다시 입력하면 된다. 가장 흔한 경우다.
  codeMismatch,

  /// 무효하거나 만료됨(`resetPassword` 전용). 서버가 두 경우를 구분해 주지 않는다.
  invalidOrExpired,

  /// 서버가 스키마에 없는 값을 보냈거나 이유를 주지 않았다.
  unknown;

  /// 서버 문자열을 도메인 값으로 옮긴다. 모르는 값은 [unknown]이다 — 서버가 새
  /// 이유를 추가해도 앱이 깨지지 않아야 한다.
  static VerificationFailureReason fromRaw(String? raw) => switch (raw) {
    'EXPIRED' => expired,
    'CONSUMED' => consumed,
    'MAX_ATTEMPTS_EXCEEDED' => maxAttemptsExceeded,
    'CODE_MISMATCH' => codeMismatch,
    'INVALID_OR_EXPIRED' => invalidOrExpired,
    _ => unknown,
  };

  /// 새 코드를 받아야 풀리는 상태인지. 참이면 화면이 재발송을 권해야 하고, 거짓이면
  /// (오타) 그대로 다시 입력하면 된다.
  bool get needsNewCode => switch (this) {
    expired || consumed || maxAttemptsExceeded || invalidOrExpired => true,
    codeMismatch || unknown => false,
  };
}

/// 코드 검증이 통과하지 못했음을 호출자에게 알리는 예외.
///
/// `AuthFailure`와 **다른 타입**이다 — 그쪽은 요청 자체가 실패한 경우고, 이쪽은
/// 요청은 정상 처리됐는데 코드가 맞지 않은 경우다. 같은 타입으로 뭉치면 화면이
/// 둘을 구분할 수 없다.
class VerificationFailure implements Exception {
  const VerificationFailure(this.reason);

  final VerificationFailureReason reason;

  @override
  bool operator ==(Object other) =>
      other is VerificationFailure && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;

  @override
  String toString() => 'VerificationFailure(${reason.name})';
}
