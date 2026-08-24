import 'email_change_failure_reason.dart';

/// 2단계 검증의 결과(SPEC-0011 R8).
///
/// **실패를 예외로 던지지 않는다.** `failureReason`은 전송 오류가 아니라 정상 응답이
/// 담은 도메인 판정이고, 화면은 그 값마다 **다른 안내와 다른 다음 행동**을 보여줘야
/// 한다(디자인 §4). 예외로 만들면 그 분기가 catch 블록으로 흩어진다.
///
/// 전송 실패·인증 실패·`userErrors`는 지금처럼 `SettingsFailure`로 던진다.
class EmailChangeConfirmation {
  const EmailChangeConfirmation.success(String this.email) : reason = null;

  const EmailChangeConfirmation.failure(EmailChangeFailureReason this.reason)
    : email = null;

  /// 성공했을 때 서버가 확정한 새 이메일.
  final String? email;

  /// 실패했을 때의 사유. 성공이면 null이다.
  final EmailChangeFailureReason? reason;

  bool get succeeded => reason == null;
}
