import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/terms_code.dart';

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

  test('게시된 약관 전문 주소를 가리킨다', () {
    expect(
      TermsCode.service.documentUrl.toString(),
      'https://www.ieuri.co.kr/terms',
    );
    expect(
      TermsCode.privacy.documentUrl.toString(),
      'https://www.ieuri.co.kr/privacy',
    );
    expect(
      TermsCode.location.documentUrl.toString(),
      'https://www.ieuri.co.kr/location-terms',
    );
  });

  test('마케팅 수신 동의는 별도 문서가 없다', () {
    // 서비스 약관 안에 포함된다 — null이어야 "전문 보기"가 그려지지 않는다.
    expect(TermsCode.marketing.documentUrl, isNull);
  });

  test('전문 주소는 모두 https다', () {
    // 평문 http로 약관을 띄우면 iOS ATS가 로드를 막는다.
    for (final TermsCode code in TermsCode.values) {
      final Uri? url = code.documentUrl;
      if (url == null) continue;
      expect(url.scheme, 'https', reason: '$code');
    }
  });

  test('Agreement equality is by value', () {
    expect(
      const Agreement(termsCode: TermsCode.service, agreed: true),
      const Agreement(termsCode: TermsCode.service, agreed: true),
    );
  });
}
