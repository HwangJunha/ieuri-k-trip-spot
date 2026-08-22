import 'map_cell.dart';

/// 칸 상세 — 칸 자체와 그 칸에 속한 장소 한 페이지(R11·R22).
class CellDetail {
  const CellDetail({
    required this.cell,
    required this.spots,
    required this.hasMore,
    this.endCursor,
  });

  final MapCell cell;

  /// 좋아요 수 내림차순. **거리순이 아니다.**
  final List<CellSpot> spots;

  final bool hasMore;
  final String? endCursor;

  CellDetail copyWithMore(CellDetail next) => CellDetail(
    cell: next.cell,
    spots: <CellSpot>[...spots, ...next.spots],
    hasMore: next.hasMore,
    endCursor: next.endCursor,
  );

  @override
  bool operator ==(Object other) =>
      other is CellDetail &&
      other.cell == cell &&
      other.hasMore == hasMore &&
      other.endCursor == endCursor &&
      other.spots.length == spots.length;

  @override
  int get hashCode => Object.hash(cell, hasMore, endCursor, spots.length);
}

/// 칸에 속한 장소 1건.
///
/// 기존 `Spot`과 다른 타입이다 — **거리 필드가 없다.** 칸 상세는 거리 정렬이
/// 아니라 좋아요 순이고, 기준점이 없어 거리를 낼 수 없다.
class CellSpot {
  const CellSpot({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    required this.categoryCode,
    required this.categoryLabel,
    required this.lat,
    required this.lng,
    required this.likeCount,
  });

  /// 장소 id. 기존 상세 화면에 그대로 넘긴다.
  final String id;

  final String title;
  final String thumbnailImageUrl;
  final String categoryCode;
  final String categoryLabel;
  final double lat;
  final double lng;

  /// 정렬 근거. 활성 언어 기준이다.
  final int likeCount;

  @override
  bool operator ==(Object other) => other is CellSpot && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
