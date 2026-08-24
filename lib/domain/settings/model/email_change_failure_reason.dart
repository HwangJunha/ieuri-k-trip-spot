/// 2단계 검증이 실패한 이유(SPEC-0011 R8, 디자인 §4).
///
/// **서버는 이것을 enum이 아니라 `String`으로 준다.** 그래서 매핑은 여기 한 곳에서만
/// 하고, 모르는 값은 [unknown]으로 떨어뜨린다 — 서버가 새 사유를 추가해도 화면이
/// 깨지지 않고 일반 실패 문구로 안내된다.
///
/// 셋을 한 문구로 묶지 않는 이유: 사용자가 다음에 무엇을 해야 하는지가 서로 다르다
/// (재입력 / 재발송 / 처음부터).
enum EmailChangeFailureReason {
  /// 코드가 틀렸다. 같은 검증 건에 **다시 입력**하면 된다.
  codeMismatch,

  /// 코드가 만료됐다. 같은 검증 건에 **재발송**을 요청해야 한다.
  expired,

  /// 시도 횟수를 다 썼다. 이 검증 건은 죽었으므로 **주소 입력부터** 다시 한다.
  maxAttemptsExceeded,

  /// 서버가 준 사유를 모른다. 일반 실패로 안내한다.
  unknown;

  /// 서버 문자열 → 사유. 대소문자를 가리지 않는다.
  static EmailChangeFailureReason fromServer(String? raw) =>
      switch (raw?.toUpperCase()) {
        'CODE_MISMATCH' => EmailChangeFailureReason.codeMismatch,
        'EXPIRED' => EmailChangeFailureReason.expired,
        'MAX_ATTEMPTS_EXCEEDED' => EmailChangeFailureReason.maxAttemptsExceeded,
        _ => EmailChangeFailureReason.unknown,
      };

  /// 같은 검증 건으로 재시도할 수 있는지. [maxAttemptsExceeded]만 주소 입력 단계로
  /// 되돌려야 한다 — 남은 시도가 없는 화면에 사용자를 붙잡아 두면 무엇을 눌러도
  /// 같은 오류만 난다.
  bool get canRetryHere => this != EmailChangeFailureReason.maxAttemptsExceeded;
}
