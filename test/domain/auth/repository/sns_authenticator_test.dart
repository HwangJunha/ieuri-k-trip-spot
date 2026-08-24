import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/sns_authenticator.dart';

void main() {
  group('codeSilentlyOrPrompt', () {
    test('조용히 얻으면 동의 창을 띄우지 않는다', () async {
      // iOS가 이 경로다 — 로그인 때 받은 code가 캐시돼 있다. 여기서 창을
      // 띄우면 로그인 한 번에 동의 창이 두 번 뜬다(실기기에서 관측된 버그).
      bool prompted = false;

      final String? code = await codeSilentlyOrPrompt(
        silently: () async => 'cached-code',
        withPrompt: () async {
          prompted = true;
          return 'prompted-code';
        },
      );

      expect(code, 'cached-code');
      expect(prompted, isFalse);
    });

    test('조용히 못 얻으면 동의 창으로 넘어간다', () async {
      // 안드로이드의 첫 로그인이 이 경로다.
      final String? code = await codeSilentlyOrPrompt(
        silently: () async => null,
        withPrompt: () async => 'prompted-code',
      );

      expect(code, 'prompted-code');
    });

    test('빈 문자열은 값이 아니라 없음으로 본다', () async {
      final String? code = await codeSilentlyOrPrompt(
        silently: () async => '',
        withPrompt: () async => 'prompted-code',
      );

      expect(code, 'prompted-code');
    });

    test('둘 다 빈손이면 null이다', () async {
      // code가 없다고 로그인이 막히면 안 된다(R7) — 판단은 optionalCode가 한다.
      final String? code = await codeSilentlyOrPrompt(
        silently: () async => null,
        withPrompt: () async => null,
      );

      expect(code, isNull);
    });
  });

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
