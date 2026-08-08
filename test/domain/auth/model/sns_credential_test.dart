import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_credential.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';

void main() {
  test('carries the authorization code when the provider gave one', () {
    const SnsCredential credential = SnsCredential(
      provider: SnsProvider.apple,
      idToken: 'id-token',
      authorizationCode: 'apple-code',
    );

    expect(credential.authorizationCode, 'apple-code');
  });

  test('defaults the authorization code to null without throwing', () {
    // code를 노출하지 않는 provider(카카오)의 정상 경로 — 생성 자체가
    // 실패하면 안 된다(R7).
    const SnsCredential credential = SnsCredential(
      provider: SnsProvider.kakao,
      idToken: 'id-token',
    );

    expect(credential.authorizationCode, isNull);
  });

  test('the authorization code participates in equality', () {
    const SnsCredential withCode = SnsCredential(
      provider: SnsProvider.google,
      idToken: 'id-token',
      authorizationCode: 'code',
    );
    const SnsCredential withoutCode = SnsCredential(
      provider: SnsProvider.google,
      idToken: 'id-token',
    );

    expect(withCode, isNot(withoutCode));
    expect(
      withCode,
      const SnsCredential(
        provider: SnsProvider.google,
        idToken: 'id-token',
        authorizationCode: 'code',
      ),
    );
  });
}
