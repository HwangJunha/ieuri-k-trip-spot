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

  test('애플 기기에서는 셋 다 쓴다', () {
    expect(snsProvidersFor(isApplePlatform: true), <SnsProvider>[
      SnsProvider.google,
      SnsProvider.apple,
      SnsProvider.kakao,
    ]);
  });

  test('안드로이드에서는 애플을 뺀다', () {
    // webAuthenticationOptions 없이는 무조건 예외가 나므로, 눌러도 실패만 하는
    // 버튼을 보여주지 않는다.
    expect(snsProvidersFor(isApplePlatform: false), <SnsProvider>[
      SnsProvider.google,
      SnsProvider.kakao,
    ]);
  });
}
