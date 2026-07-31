import '../model/list_equality.dart';

/// 커서 기반 페이지 한 장. GraphQL Relay 커넥션(edges + pageInfo)이나 목 데이터를
/// 도메인으로 매핑한 결과를 담는, 순수 도메인 값이다.
///
/// 리스트/스택 화면은 이 타입을 재사용한다(CLAUDE.md §4 — 페이지네이션은 공용,
/// 기능별로 새로 만들지 않는다). 순수 Dart: flutter/graphql/riverpod 미의존.
class CursorPage<T> {
  const CursorPage({
    required this.items,
    required this.hasNextPage,
    this.endCursor,
  });

  /// 이 페이지의 항목들.
  final List<T> items;

  /// 다음 페이지 존재 여부. `false`면 소진 상태로 취급한다.
  final bool hasNextPage;

  /// 다음 조회에 넘길 `after` 커서. [hasNextPage]가 false면 보통 `null`.
  final String? endCursor;

  /// 빈 페이지(항목 0건, 다음 없음).
  static CursorPage<T> empty<T>() =>
      CursorPage<T>(items: const [], hasNextPage: false);

  @override
  bool operator ==(Object other) =>
      other is CursorPage<T> &&
      listEquals(other.items, items) &&
      other.hasNextPage == hasNextPage &&
      other.endCursor == endCursor;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(items), hasNextPage, endCursor);
}
