import 'spot_category.dart';

/// 검색 자동완성 항목(SPEC-0013 R9).
///
/// 거리·주소를 담지 않는다 — 선택하면 검색이나 상세 조회로 이어지므로 그 시점에
/// 온전한 정보를 받는다(계약). 목록에 보이는 데 필요한 최소 형태다.
class SpotSuggestion {
  const SpotSuggestion({
    required this.id,
    required this.title,
    required this.category,
  });

  final String id;
  final String title;

  /// 매핑되지 않은 서버 enum이면 null. 표시 문구는 클라이언트가 붙인다(POL-023).
  final SpotCategory? category;

  @override
  bool operator ==(Object other) =>
      other is SpotSuggestion &&
      other.id == id &&
      other.title == title &&
      other.category == category;

  @override
  int get hashCode => Object.hash(id, title, category);
}
