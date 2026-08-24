import '../../../common/model/terms_code.dart';

/// 약관 하나의 현재 동의 상태(SPEC-0011 R9). 서버 `AgreementStatus`의 도메인 대응물이며
/// 순수 Dart다 — 생성 GraphQL 타입은 repository를 넘지 않는다(CLAUDE.md §3).
///
/// [agreedAt]은 서버가 준 ISO-8601 문자열 원문이고, 화면은 [agreedAtDate]로 파싱한
/// 값을 쓴다 — 형식은 l10n이 언어별로 정한다.
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

  /// 동의 시각. 서버가 준 ISO-8601 문자열 그대로이며 미동의면 null이다.
  /// 화면에 그대로 쓰지 않는다 — [agreedAtDate]를 쓴다.
  final String? agreedAt;

  final String version;

  /// 동의 시각을 **현지 시간대의 [DateTime]으로** 돌려준다. 없거나 형식이 어긋나면
  /// null이다.
  ///
  /// 서버 값은 `2026-08-07T18:42:30.024670Z` 같은 UTC 타임스탬프라, 그대로 그리면
  /// 사용자에게 기계 문자열이 보인다(실제로 그렇게 보였다). 여기서 값으로 바꾸고
  /// **표시 형식은 l10n이 언어별로 정한다** — 클라이언트가 형식을 문자열로 박으면
  /// 언어를 바꿔도 그대로 남는다.
  ///
  /// 파싱 실패를 null로 떨어뜨리는 이유는, 동의 일자 하나 때문에 약관 화면 전체가
  /// 사라지면 손해가 더 크기 때문이다 — 그때는 일자 없이 나머지를 그린다.
  DateTime? get agreedAtDate {
    final String? raw = agreedAt;
    if (raw == null) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

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
