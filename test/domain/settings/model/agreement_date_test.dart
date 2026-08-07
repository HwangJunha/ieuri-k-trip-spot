import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/agreement_status.dart';

/// 동의 시각 파싱. 서버는 `2026-08-07T18:42:30.024670Z` 같은 UTC 타임스탬프를 주는데,
/// 그대로 그리면 사용자에게 기계 문자열이 보인다(실제로 그렇게 보였다).

AgreementStatus _at(String? raw) => AgreementStatus(
  termsCode: TermsCode.service,
  required: true,
  agreed: true,
  version: 'v1',
  agreedAt: raw,
);

void main() {
  test('ISO 타임스탬프를 DateTime으로 바꾼다', () {
    final DateTime? parsed = _at('2026-08-07T18:42:30.024670Z').agreedAtDate;

    expect(parsed, isNotNull);
    expect(parsed!.toUtc().year, 2026);
    expect(parsed.toUtc().month, 8);
    expect(parsed.toUtc().day, 7);
  });

  test('UTC를 현지 시간대로 옮긴다', () {
    final DateTime? parsed = _at('2026-08-07T18:42:30.024670Z').agreedAtDate;

    expect(parsed!.isUtc, isFalse, reason: '표시는 사용자의 시간대를 따른다');
  });

  test('날짜만 있는 값도 받는다', () {
    expect(_at('2026-01-12').agreedAtDate, isNotNull);
  });

  test('미동의(null)는 null이다', () {
    expect(_at(null).agreedAtDate, isNull);
  });

  // 일자 하나 때문에 약관 화면 전체가 사라지면 손해가 더 크다.
  test('형식이 어긋나면 null로 떨어뜨린다', () {
    expect(_at('nonsense').agreedAtDate, isNull);
    expect(_at('').agreedAtDate, isNull);
  });
}
