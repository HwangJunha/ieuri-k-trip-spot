import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/terms_code.dart';

void main() {
  test('every TermsCode maps to its schema wire name', () {
    expect(TermsCode.service.wireName, 'SERVICE');
    expect(TermsCode.privacy.wireName, 'PRIVACY');
    expect(TermsCode.location.wireName, 'LOCATION');
    expect(TermsCode.marketing.wireName, 'MARKETING');
  });

  test('only MARKETING is optional', () {
    expect(TermsCode.service.isRequired, isTrue);
    expect(TermsCode.privacy.isRequired, isTrue);
    expect(TermsCode.location.isRequired, isTrue);
    expect(TermsCode.marketing.isRequired, isFalse);
  });

  test('Agreement equality is by value', () {
    expect(
      const Agreement(termsCode: TermsCode.service, agreed: true),
      const Agreement(termsCode: TermsCode.service, agreed: true),
    );
  });
}
