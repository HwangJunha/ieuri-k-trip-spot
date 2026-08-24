import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/email_format.dart';

/// 이메일 형식 검사. 가입·로그인·비밀번호 재설정과 이메일 변경(SPEC-0011 R7)이
/// 함께 쓰므로 `common/`이 소유한다 — 테스트도 클래스를 따라왔다.
void main() {
  test('accepts a normal address', () {
    expect(EmailFormat.isValid('user@example.com'), isTrue);
  });

  test('rejects an address without a domain dot', () {
    expect(EmailFormat.isValid('user@example'), isFalse);
  });
}
