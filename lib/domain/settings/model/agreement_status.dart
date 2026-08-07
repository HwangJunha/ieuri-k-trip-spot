import '../../../common/model/terms_code.dart';

/// 약관 하나의 현재 동의 상태(SPEC-0011 R9). 서버 `AgreementStatus`의 도메인 대응물이며
/// 순수 Dart다 — 생성 GraphQL 타입은 repository를 넘지 않는다(CLAUDE.md §3).
///
/// [agreedAt]은 서버가 정하는 문자열이라 **파싱하지 않는다.** 표시 전용이며 미동의면
/// null이다.
class AgreementStatus {
  const AgreementStatus({
    required this.termsCode,
    required this.required,
    required this.agreed,
    required this.version,
    this.agreedAt,
  });

  final TermsCode termsCode;

  /// 필수 약관인지. **[TermsCode.isRequired]가 아니라 서버 값을 쓴다** — 필수 여부는
  /// 정책이라 서버가 바꿀 수 있고, 클라이언트가 자기 판단을 덮어쓰면 게이트가 실제와
  /// 어긋난다.
  final bool required;

  final bool agreed;

  /// 동의 일자. 서버가 준 문자열 그대로이며 미동의면 null이다.
  final String? agreedAt;

  final String version;

  /// 낙관적 토글이 만드는 임시 상태(R10). 실패하면 원본으로 되돌린다.
  AgreementStatus copyWith({bool? agreed}) => AgreementStatus(
    termsCode: termsCode,
    required: required,
    agreed: agreed ?? this.agreed,
    agreedAt: agreedAt,
    version: version,
  );

  @override
  bool operator ==(Object other) =>
      other is AgreementStatus &&
      other.termsCode == termsCode &&
      other.required == required &&
      other.agreed == agreed &&
      other.agreedAt == agreedAt &&
      other.version == version;

  @override
  int get hashCode =>
      Object.hash(termsCode, required, agreed, agreedAt, version);

  @override
  String toString() =>
      'AgreementStatus(${termsCode.wireName}, required: $required, '
      'agreed: $agreed)';
}

/// 목록 전체에 대한 판정. 게이트(R11)와 동의 화면이 같은 규칙을 쓰도록 여기 모은다.
extension AgreementStatusList on List<AgreementStatus> {
  /// 아직 동의하지 않은 **필수** 약관들. 비어 있으면 게이트가 풀린다.
  List<AgreementStatus> get unmetRequired =>
      where((AgreementStatus a) => a.required && !a.agreed).toList();

  /// 필수 약관이 전부 충족됐는지(R11).
  bool get requiredSatisfied => unmetRequired.isEmpty;

  /// 화면에서 읽기 전용으로 그리는 필수 항목(디자인 참조 §5).
  List<AgreementStatus> get requiredItems =>
      where((AgreementStatus a) => a.required).toList();

  /// 토글 가능한 선택 항목(위치·마케팅).
  List<AgreementStatus> get optionalItems =>
      where((AgreementStatus a) => !a.required).toList();
}
