import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/password_policy.dart';

void main() {
  group('PasswordPolicy', () {
    test('accepts a letter+digit+special password of 8+ chars', () {
      expect(PasswordPolicy.isValid('abcd123!'), isTrue);
    });

    test('rejects a password shorter than 8', () {
      expect(PasswordPolicy.isValid('ab1!'), isFalse);
    });

    test('rejects a password missing a special character', () {
      expect(PasswordPolicy.isValid('abcd1234'), isFalse);
    });

    test('rejects a password missing a digit', () {
      expect(PasswordPolicy.isValid('abcdefg!'), isFalse);
    });
  });
}
