import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/agreement_status.dart';

import '../settings_test_doubles.dart';

/// 목록 판정(SPEC-0011 R11) — 게이트와 화면이 같은 규칙을 쓴다.

void main() {
  test('미동의 필수 약관이 있으면 충족이 아니다', () {
    final List<AgreementStatus> list = <AgreementStatus>[
      agreement(TermsCode.service, required: true, agreed: true),
      agreement(TermsCode.privacy, required: true),
    ];

    expect(list.requiredSatisfied, isFalse);
    expect(list.unmetRequired.single.termsCode, TermsCode.privacy);
  });

  test('선택 항목이 미동의여도 필수는 충족된다', () {
    final List<AgreementStatus> list = <AgreementStatus>[
      agreement(TermsCode.service, required: true, agreed: true),
      agreement(TermsCode.marketing),
    ];

    expect(list.requiredSatisfied, isTrue);
  });

  test('필수 여부는 서버 값을 따른다', () {
    // `TermsCode.isRequired`가 아니라 서버가 준 `required`를 본다 — 정책은 서버가
    // 바꿀 수 있고 클라이언트가 덮어쓰면 게이트가 실제와 어긋난다.
    final List<AgreementStatus> list = <AgreementStatus>[
      agreement(TermsCode.location, required: true),
    ];

    expect(list.requiredItems, hasLength(1));
    expect(list.requiredSatisfied, isFalse);
  });

  test('copyWith는 동의 여부만 바꾸고 나머지를 보존한다', () {
    final AgreementStatus original = agreement(
      TermsCode.marketing,
      agreedAt: '2026-01-12',
      version: 'v2',
    );

    final AgreementStatus toggled = original.copyWith(agreed: true);

    expect(toggled.agreed, isTrue);
    expect(toggled.agreedAt, '2026-01-12');
    expect(toggled.version, 'v2');
    expect(toggled.termsCode, TermsCode.marketing);
  });
}
