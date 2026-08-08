import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/email_change_failure_reason.dart';

/// SPEC-0011 R8 — 검증 실패 사유. 서버가 **enum이 아니라 String**으로 주므로
/// 매핑이 유일한 방어선이다.
void main() {
  test('서버 문자열을 사유로 옮긴다', () {
    expect(
      EmailChangeFailureReason.fromServer('CODE_MISMATCH'),
      EmailChangeFailureReason.codeMismatch,
    );
    expect(
      EmailChangeFailureReason.fromServer('EXPIRED'),
      EmailChangeFailureReason.expired,
    );
    expect(
      EmailChangeFailureReason.fromServer('MAX_ATTEMPTS_EXCEEDED'),
      EmailChangeFailureReason.maxAttemptsExceeded,
    );
  });

  // 서버가 새 사유를 추가해도 화면이 깨지지 않아야 한다.
  test('모르는 값과 null은 unknown이다', () {
    expect(
      EmailChangeFailureReason.fromServer('SOMETHING_NEW'),
      EmailChangeFailureReason.unknown,
    );
    expect(
      EmailChangeFailureReason.fromServer(null),
      EmailChangeFailureReason.unknown,
    );
    expect(
      EmailChangeFailureReason.fromServer(''),
      EmailChangeFailureReason.unknown,
    );
  });

  test('대소문자를 가리지 않는다', () {
    expect(
      EmailChangeFailureReason.fromServer('code_mismatch'),
      EmailChangeFailureReason.codeMismatch,
    );
  });

  // 이 값이 "코드 화면에 머무를지 주소부터 다시 할지"를 가른다.
  test('시도 초과만 이 자리에서 재시도할 수 없다', () {
    expect(EmailChangeFailureReason.codeMismatch.canRetryHere, isTrue);
    expect(EmailChangeFailureReason.expired.canRetryHere, isTrue);
    expect(EmailChangeFailureReason.unknown.canRetryHere, isTrue);
    expect(
      EmailChangeFailureReason.maxAttemptsExceeded.canRetryHere,
      isFalse,
      reason: '남은 시도가 없는 화면에 붙잡아 두면 무엇을 눌러도 같은 오류다',
    );
  });
}
