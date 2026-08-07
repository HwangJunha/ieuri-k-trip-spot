import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/nickname_validation.dart';

/// SPEC-0011 R5 — 형식만 본다. 중복은 서버 판정이라 여기 없다.
void main() {
  test('공백만 있으면 비어 있는 것으로 본다', () {
    expect(validateNickname('   '), NicknameValidation.empty);
  });

  test('앞뒤 공백을 제거한 값이 제출값이다', () {
    expect(normalizeNickname('  Traveler  '), 'Traveler');
  });

  test('최대 길이까지는 통과한다', () {
    expect(validateNickname('가' * nicknameMaxLength), NicknameValidation.ok);
  });

  test('최대 길이를 넘으면 거절한다', () {
    expect(
      validateNickname('가' * (nicknameMaxLength + 1)),
      NicknameValidation.tooLong,
    );
  });

  test('이모지는 한 글자로 센다', () {
    // UTF-16 코드 단위로 세면 2가 되어 카운터가 사용자가 보는 것과 어긋난다.
    expect(nicknameLength('😀'), 1);
  });
}
