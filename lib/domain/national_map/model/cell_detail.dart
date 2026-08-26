import 'map_cell.dart';

/// 칸 상세 — 칸 자체와 그 칸에 속한 장소 목록(R11·R22).
///
/// **페이지네이션이 없다**(2026-08-25). 서버가 `spots`를 커서 연결에서 배열로
/// 바꾸면서 이어 읽을 수단이 사라졌다 — `first`는 상한 50으로 잘리고 그게 전부다.
/// 한 칸에 50곳이면 훑어보기에 충분하다는 서버 판단이다.
class CellDetail {
  const CellDetail({required this.cell, required this.spots});

  final MapCell cell;

  /// 좋아요 수 내림차순. **거리순이 아니다.**
  final List<CellSpot> spots;

  @override
  bool operator ==(Object other) =>
      other is CellDetail &&
      other.cell == cell &&
      other.spots.length == spots.length;

  @override
  int get hashCode => Object.hash(cell, spots.length);
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
