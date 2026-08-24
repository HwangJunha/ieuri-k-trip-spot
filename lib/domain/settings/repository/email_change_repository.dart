import '../model/email_change_confirmation.dart';
import '../model/email_change_request.dart';

/// 이메일 변경(SPEC-0011 R7·R8)의 데이터 접근 경계. 구현은 GraphQL이고 생성 타입은
/// 이 인터페이스를 넘지 않는다(CLAUDE.md §3).
///
/// **`ProfileRepository`와 따로 둔다** — 이메일 변경은 2단계 상태 기계라 프로필
/// 저장 폼과 실패 방식도 다르고, 합치면 프로필 화면 테스트가 여기 3개 메서드까지
/// 전부 스텁해야 한다(약관과 프로필을 나눈 것과 같은 판단).
///
/// 전송·인증 실패와 `userErrors`는 `SettingsFailure`를 던진다. 코드 불일치 같은
/// **검증 판정은 예외가 아니라** [EmailChangeConfirmation]의 값으로 온다.
abstract interface class EmailChangeRepository {
  /// 1단계 — 새 주소로 인증 코드 발송을 요청한다(R7).
  ///
  /// **성공해도 프로필 이메일은 그대로다.** 2단계가 끝나야 바뀐다.
  Future<EmailChangeRequest> requestEmailChange(String newEmail);

  /// 2단계 — 코드를 검증한다(R8). 성공하면 확정된 새 이메일이 실려 온다.
  Future<EmailChangeConfirmation> confirmEmailChange({
    required String verificationId,
    required String code,
  });

  /// 코드 재발송(R8). 서버가 새 `verificationId`를 줄 수 있으므로 돌려받은 값으로
  /// 갈아끼운다.
  Future<EmailChangeRequest> resendEmailChange(String verificationId);
}
