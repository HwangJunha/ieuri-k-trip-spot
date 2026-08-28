import '../../../common/category/spot_category_selection.dart';

/// 좋아요 목록 조회를 가리키는 키(SPEC-0033 §핵심 배선).
///
/// 카테고리 선택과 검색어를 **한 값으로 묶는다.** 컨트롤러가
/// `build(SpotCategorySelection)` 패밀리였을 때 검색어를 키에 넣지 않으면 검색어를
/// 바꿔도 같은 provider 인스턴스를 가리켜 재조회가 일어나지 않는다.
///
/// [SpotCategorySelection]과 같은 이유로 동등성을 손으로 정의한다 — family는 인자의
/// `==`/`hashCode`로 인스턴스를 찾으므로, 동등성이 깨지면 값이 그대로인데도 매
/// 빌드마다 새 인스턴스가 생겨 프레임마다 재조회한다.
///
/// 둘은 **함께**(AND) 적용된다. 한쪽만 바꾸면 다른 쪽은 그대로 실려 간다 — 키가
/// 두 값을 다 들고 있으므로 이것이 저절로 성립한다.
class LikedSpotsQuery {
  /// [query]는 앞뒤 공백을 털어 담는다 — `"seoul"`과 `"seoul "`은 같은 조회이므로
  /// 같은 키를 가리켜야 한다. 상한(100자)은 입력에서 막으므로 여기서는 자르지
  /// 않는다(§입력 처리).
  LikedSpotsQuery({
    required this.selection,
    String query = '',
  }) : query = query.trim();

  /// 필터도 검색어도 없는 상태. 목록 최초 진입이 이 키다.
  static final LikedSpotsQuery none = LikedSpotsQuery(
    selection: SpotCategorySelection.empty,
  );

  /// 카테고리 선택(빈 선택 = 전체).
  final SpotCategorySelection selection;

  /// 트림된 검색어. 빈 문자열은 "검색어 없음"이다.
  final String query;

  /// 검색이 걸려 있는지 — 빈 상태 문구를 가르는 근거다(§두 개의 빈 상태).
  bool get hasQuery => query.isNotEmpty;

  /// 서버로 보낼 값. **빈 검색어는 null로 접는다** — null이면 repository가 검색
  /// 오퍼레이션(`searchLikedSpots`) 대신 전체 목록(`likedSpots`)을 부른다. 그쪽
  /// `query`가 non-null 필수라 빈 문자열로는 "전체"를 표현할 수 없다(AC8.2).
  String? get queryOrNull => query.isEmpty ? null : query;

  /// 검색어만 바꾼 키. 카테고리 선택은 그대로 실려 간다.
  LikedSpotsQuery withQuery(String next) =>
      LikedSpotsQuery(selection: selection, query: next);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LikedSpotsQuery &&
          other.selection == selection &&
          other.query == query);

  @override
  int get hashCode => Object.hash(selection, query);

  @override
  String toString() => 'LikedSpotsQuery($selection, query: "$query")';
}
