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
