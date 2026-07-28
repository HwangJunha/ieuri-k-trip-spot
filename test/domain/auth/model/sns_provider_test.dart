import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';

void main() {
  test('wireName matches the server Provider enum names', () {
    expect(SnsProvider.google.wireName, 'GOOGLE');
    expect(SnsProvider.apple.wireName, 'APPLE');
    expect(SnsProvider.kakao.wireName, 'KAKAO');
  });

  test('covers exactly the three supported providers', () {
    expect(SnsProvider.values, <SnsProvider>[
      SnsProvider.google,
      SnsProvider.apple,
      SnsProvider.kakao,
    ]);
  });
}
