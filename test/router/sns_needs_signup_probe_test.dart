import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/router/route_gate.dart';

void main() {
  test('SNS 가입 화면이 게이트를 통과하는가 (상태별)', () {
    for (final auth in AuthGateState.values) {
      final String? r = resolveGate(
        location: '/sns-sign-up',
        languageChosen: true,
        auth: auth,
        terms: TermsGateState.satisfied,
      );
      // ignore: avoid_print
      print('auth=${auth.name.padRight(28)} → ${r ?? "통과"}');
    }
  });
}
