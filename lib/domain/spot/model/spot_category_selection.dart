import 'spot_category.dart';

/// 카테고리 다중 선택을 **Riverpod family 인자로 안전하게 실을 수 있는** 값 객체
/// (SPEC-0020 R2·R5).
///
/// **왜 `Set<SpotCategory>`를 그대로 family 인자로 쓰지 않는가.** Dart의 `Set`은
/// 값 동등성이 없다 — 원소가 같아도 `==`는 false다. family는 인자의 `==`/`hashCode`로
/// provider 인스턴스를 찾으므로, 집합을 그대로 넘기면 **선택이 바뀌지 않았는데도**
/// 매 빌드마다 새 인스턴스가 만들어져 피드를 처음부터 다시 받는다. keepAlive라
/// 버려지지도 않아 세션이 쌓이기만 한다.
///
/// 그래서 정렬된 코드 목록을 **하나의 문자열**로 접어 그것으로 동등성을 정의한다.
/// 정렬하는 이유는 선택 *순서*가 필터의 뜻을 바꾸지 않기 때문이다 — `{A, B}`와
/// `{B, A}`는 같은 조회이므로 같은 provider를 가리켜야 한다.
///
/// 라벨은 동등성에 넣지 않는다([SpotCategory]와 같은 이유) — 언어가 바뀌어도 같은
/// 필터는 같은 키여야 한다.
class SpotCategorySelection {
  /// [categories]를 코드 오름차순으로 정규화해 담는다.
  SpotCategorySelection(Iterable<SpotCategory> categories)
    : codes = List<String>.unmodifiable(
        categories.map((SpotCategory c) => c.code).toSet().toList()..sort(),
      );

  /// 선택 없음. 서버에는 인자를 **보내지 않는** 상태이며(빈 배열은 계약상 거절),
  /// 목록이 아직 오지 않은 최초 프레임에만 나타난다.
  static final SpotCategorySelection empty = SpotCategorySelection(
    const <SpotCategory>[],
  );

  /// 정렬된 코드. 그대로 `categories: [String!]` 변수가 된다(AC5.2 — 변환 없음).
  final List<String> codes;

  bool get isEmpty => codes.isEmpty;

  /// 서버로 보낼 값. **빈 집합은 null로 접는다** — 빈 배열은 서버가
  /// `EMPTY_CATEGORY_SET`으로 거절하므로 인자를 생략해 전체를 받는다(AC5.1).
  List<String>? get codesOrNull => codes.isEmpty ? null : codes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpotCategorySelection && other._key == _key);

  @override
  int get hashCode => _key.hashCode;

  /// 동등성·해시의 근거. 리스트는 값 동등성이 없어 문자열로 접는다.
  String get _key => codes.join(',');

  @override
  String toString() => 'SpotCategorySelection($_key)';
}
