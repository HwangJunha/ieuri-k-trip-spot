import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';

void main() {
  test('maps known codes to the matching failure kind', () {
    expect(
      AuthFailure.fromCode('INVALID_CREDENTIALS').kind,
      AuthFailureKind.invalidCredentials,
    );
    expect(
      AuthFailure.fromCode('EMAIL_TAKEN').kind,
      AuthFailureKind.emailAlreadyInUse,
    );
    // 서버가 실제로 주는 코드다(실측). unknown으로 떨어지면 사용자는
    // "문제가 발생했습니다"만 보고 만료가 원인인 줄 알 수 없다.
    expect(
      AuthFailure.fromCode('SNS_VERIFICATION_FAILED').kind,
      AuthFailureKind.snsVerificationFailed,
    );
  });

  test('maps an unknown code to unknown, preserving the field', () {
    final AuthFailure failure = AuthFailure.fromCode(
      'WHATEVER',
      field: 'email',
    );
    expect(failure.kind, AuthFailureKind.unknown);
    expect(failure.field, 'email');
  });
}
