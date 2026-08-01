import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_registration_result.dart';

void main() {
  test('needsVerification is false when the email is already verified', () {
    const SnsRegistrationResult result = SnsRegistrationResult(
      emailVerified: true,
    );
    expect(result.needsVerification, isFalse);
  });

  test('needsVerification is true when unverified and a handle is present', () {
    const SnsRegistrationResult result = SnsRegistrationResult(
      emailVerified: false,
      verificationId: 'v-1',
    );
    expect(result.needsVerification, isTrue);
  });

  test('needsVerification is false when unverified but no handle', () {
    const SnsRegistrationResult result = SnsRegistrationResult(
      emailVerified: false,
    );
    expect(result.needsVerification, isFalse);
  });
}
