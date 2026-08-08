import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/network/graphql_debug_log.dart';

/// [GraphqlDebugLog.request]가 실제로 찍은 내용을 모아 돌려준다.
String _capture(String operation, Map<String, dynamic> variables) {
  final StringBuffer captured = StringBuffer();
  final DebugPrintCallback original = debugPrint;
  debugPrint = (String? message, {int? wrapWidth}) =>
      captured.writeln(message ?? '');
  addTearDown(() => debugPrint = original);

  GraphqlDebugLog.request(operation, variables);
  return captured.toString();
}

void main() {
  test('masks the SNS authorization code', () {
    final String logged = _capture('loginSns', <String, dynamic>{
      'input': <String, dynamic>{
        'provider': 'GOOGLE',
        'authorizationCode': 'server-auth-code',
      },
    });

    // 이 값은 refresh token으로 교환 가능하다 — 콘솔에도 남으면 안 된다.
    expect(logged, isNot(contains('server-auth-code')));
    expect(logged, contains('***'));
  });

  test('keeps termsCode visible', () {
    final String logged = _capture('registerSnsMember', <String, dynamic>{
      'input': <String, dynamic>{
        'agreements': <dynamic>[
          <String, dynamic>{'termsCode': 'SERVICE', 'agreed': true},
        ],
      },
    });

    expect(logged, contains('SERVICE'));
  });
}
