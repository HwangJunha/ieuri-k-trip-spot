/// The consent categories the server accepts on registration (schema
/// `TermsCode`). Pure domain enum so the sign-up form and repository share one
/// source of truth without importing the generated GraphQL enum.
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
