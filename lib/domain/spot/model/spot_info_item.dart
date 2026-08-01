/// 이용안내 1건(detailInfo2). 카테고리별로 제각각인 반복 항목을 서버가 항목명/내용
/// 쌍으로 정규화해 내려준 값이다.
///
/// 순수 도메인 모델 — 위젯·GraphQL 의존 없음(POL-020).
///
/// 두 필드 모두 non-null이지만 **공백뿐인 값이 올 수 있다.** 그런 항목은 화면에
/// 빈 줄로 남으므로 [hasContent]가 false이고, 뷰는 이를 렌더하지 않는다.
class SpotInfoItem {
  const SpotInfoItem({required this.name, required this.text});

  /// 항목명(예: "입 장 료", "이용시간").
  final String name;

  /// 항목 내용.
  final String text;

  /// 표시용 항목명(앞뒤 공백 제거). 비어 있으면 그 줄을 그리지 않는다.
  String get displayName => name.trim();

  /// 표시용 내용(앞뒤 공백 제거). 비어 있으면 그 줄을 그리지 않는다.
  String get displayText => text.trim();

  /// 이 항목을 그릴지. 항목명·내용 중 하나라도 실제 값이 있어야 한다.
  bool get hasContent => displayName.isNotEmpty || displayText.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      other is SpotInfoItem && other.name == name && other.text == text;

  @override
  int get hashCode => Object.hash(name, text);
}
