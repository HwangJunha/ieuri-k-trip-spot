import '../model/list_equality.dart';

/// 오프셋(페이지 번호) 기반 페이지 한 장. 서버가 커서를 지원하지 않아
/// `page`/`size`로 조회하는 목록·스택 화면이 재사용하는 순수 도메인 값이다
/// (CLAUDE.md §4 — 페이지네이션은 공용, 기능별로 새로 만들지 않는다).
///
/// 커서 커넥션용 [CursorPage](`page.dart`)와 짝을 이룬다. 서버 `SpotPage`처럼
/// `hasNext`로 다음 페이지 존재를 알리고, [page]는 **이번 페이지의 0-based 번호**다.
/// 다음 조회에 넘길 페이지 번호는 [nextPage]가 계산한다. 순수 Dart:
/// flutter/graphql/riverpod 미의존.
class OffsetPage<T> {
  const OffsetPage({
    required this.items,
    required this.page,
    required this.hasNext,
    this.totalCount,
  });

  /// 이 페이지의 항목들.
  final List<T> items;

  /// 이번 페이지의 0-based 번호(서버 `SpotPage.page`).
  final int page;

  /// 다음 페이지 존재 여부. `false`면 소진 상태로 취급한다.
  final bool hasNext;

  /// 전체 개수(서버가 알면 제공, 모르면 null).
  final int? totalCount;

  /// 다음 조회에 넘길 페이지 번호. 다음이 없으면 null.
  int? get nextPage => hasNext ? page + 1 : null;

  /// 빈 페이지(항목 0건, 다음 없음).
  static OffsetPage<T> empty<T>() =>
      OffsetPage<T>(items: const [], page: 0, hasNext: false);

  @override
  bool operator ==(Object other) =>
      other is OffsetPage<T> &&
      listEquals(other.items, items) &&
      other.page == page &&
      other.hasNext == hasNext &&
      other.totalCount == totalCount;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(items), page, hasNext, totalCount);
}
