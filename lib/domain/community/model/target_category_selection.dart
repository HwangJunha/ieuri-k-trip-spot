import '../../../common/model/target_category.dart';

/// 커뮤니티 카테고리 다중 선택을 **Riverpod family 인자로 안전하게 실을 수 있는**
/// 값 객체(SPEC-0020, 서버 #77).
///
/// **왜 `Set<TargetCategory>`를 그대로 family 인자로 쓰지 않는가.** Dart의 `Set`은
/// 값 동등성이 없다 — 원소가 같아도 `==`는 false다. family는 인자의 `==`/`hashCode`로
/// provider 인스턴스를 찾으므로, 집합을 그대로 넘기면 **선택이 바뀌지 않았는데도**
/// 매 빌드마다 새 인스턴스가 만들어져 피드를 처음부터 다시 받는다.
///
/// 그래서 정렬된 코드 목록을 하나의 문자열로 접어 그것으로 동등성을 정의한다.
/// 정렬하는 이유는 선택 *순서*가 필터의 뜻을 바꾸지 않기 때문이다 — `{A, B}`와
/// `{B, A}`는 같은 조회이므로 같은 provider를 가리켜야 한다.
///
/// **spot의 `SpotCategorySelection`을 재사용하지 않는 이유.** 그쪽은
/// `SpotCategory`(`code`를 가진 값 객체)에 묶여 있고 여기는 `TargetCategory`(enum)다.
/// 공용 mixin·값 객체를 제네릭으로 열려면 `common/`이 "코드 뽑는 함수"를 인자로
/// 받아야 해서, 호출부 네 곳을 고쳐 얻는 것이 이 파일 하나를 아끼는 것뿐이다
/// (CLAUDE.md §1.3 — 경계가 요구하지 않는 구조는 복잡도다). 대신 `common/`이
/// `TargetCategory`를 알게 되지 않는다는 §4의 선이 그대로 지켜진다.
class TargetCategorySelection {
  /// [categories]를 코드 오름차순으로 정규화해 담는다.
  TargetCategorySelection(Iterable<TargetCategory> categories)
    : categories = List<TargetCategory>.unmodifiable(
        categories.toSet().toList()..sort(
          (TargetCategory a, TargetCategory b) => a.code.compareTo(b.code),
        ),
      );

  /// 선택 없음 — 바의 "전체" 칩이 켜진 상태다.
  static final TargetCategorySelection empty = TargetCategorySelection(
    const <TargetCategory>[],
  );

  /// 정렬된 선택. 비어 있으면 "전체"다.
  final List<TargetCategory> categories;

  bool get isEmpty => categories.isEmpty;

  bool contains(TargetCategory category) => categories.contains(category);

  /// 선택 판정·표시 순서가 쓰는 코드 집합.
  Set<String> get codes => categories.map((TargetCategory c) => c.code).toSet();

  /// 서버로 보낼 값. **빈 집합은 null로 접는다** — 빈 배열은 서버가
  /// `EmptyCategorySetException`으로 거절하므로 인자를 생략해 전체를 받는다.
  List<TargetCategory>? get valuesOrNull =>
      categories.isEmpty ? null : categories;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TargetCategorySelection && other._key == _key);

  @override
  int get hashCode => _key.hashCode;

  /// 동등성·해시의 근거. 리스트는 값 동등성이 없어 문자열로 접는다.
  String get _key => categories.map((TargetCategory c) => c.code).join(',');

  @override
  String toString() => 'TargetCategorySelection($_key)';
}
