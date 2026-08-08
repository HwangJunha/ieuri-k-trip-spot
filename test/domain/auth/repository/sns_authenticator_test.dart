import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/sns_authenticator.dart';

void main() {
  test('returns the code when the provider gives one', () async {
    expect(
      await optionalCode(() async => 'server-auth-code'),
      'server-auth-code',
    );
  });

  test('returns null when the provider gives none', () async {
    // 정상 경로다 — 구글은 최초 로그인에서만 code를 주는 플랫폼이 있다.
    expect(await optionalCode(() async => null), isNull);
  });

  test('swallows an Exception', () async {
    expect(
      await optionalCode(() async => throw const FormatException('bad')),
      isNull,
    );
  });

  test('swallows an Error', () async {
    // `on Exception`은 Error를 잡지 못한다. 플러그인 미초기화의 StateError가
    // 여기서 빠져나가면 code를 못 얻었다는 이유로 로그인 전체가 실패한다(R7).
    expect(
      await optionalCode(() async => throw StateError('not ready')),
      isNull,
    );
  });

  test('gives up when the provider never answers', () async {
    // 동의 화면에서 사용자가 응답하지 않는 경우 — 로그인을 붙잡아 두면 안 된다.
    final String? code = await optionalCode(
      () => Completer<String?>().future,
      timeout: const Duration(milliseconds: 10),
    );

    expect(code, isNull);
  });
}
