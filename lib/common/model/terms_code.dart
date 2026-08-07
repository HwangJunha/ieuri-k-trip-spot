/// 서버가 다루는 약관 종류(스키마 `TermsCode`). 생성된 GraphQL enum을 가져오지 않고도
/// 하나의 출처를 공유하기 위한 순수 도메인 enum이다.
///
/// **왜 `common/`에 있는가.** 가입 폼(`domain/auth`)과 약관 관리·게이트
/// (`domain/settings`) **둘 다** 쓴다(SPEC-0011 R9~R12). 기능 간 import는 금지되어
/// 있으므로(CLAUDE.md §3), 둘 이상이 쓰는 값은 여기로 올린다(§4).
enum TermsCode {
  service,
  privacy,
  location,
  marketing;

  /// The wire string the server expects (matches the schema `TermsCode` names).
  String get wireName => switch (this) {
    TermsCode.service => 'SERVICE',
    TermsCode.privacy => 'PRIVACY',
    TermsCode.location => 'LOCATION',
    TermsCode.marketing => 'MARKETING',
  };

  /// Whether consent is mandatory to register (spec §5.2): everything except
  /// MARKETING, which is optional.
  bool get isRequired => this != TermsCode.marketing;
}

/// A single consent decision sent with registration (schema `AgreementInput`).
/// Pure value type; the repository maps it to the generated input.
class Agreement {
  const Agreement({required this.termsCode, required this.agreed});

  final TermsCode termsCode;
  final bool agreed;

  @override
  bool operator ==(Object other) =>
      other is Agreement &&
      other.termsCode == termsCode &&
      other.agreed == agreed;

  @override
  int get hashCode => Object.hash(termsCode, agreed);
}
