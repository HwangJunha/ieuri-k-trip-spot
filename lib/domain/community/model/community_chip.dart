import '../../../common/model/target_category.dart';

/// 커뮤니티 상단 칩 하나(서버 `CommunityChip`).
///
/// **표시 문구는 서버가 주지 않는다** — enum 값과 순서만 온다(가이드 §2).
/// `RESTAURANT` → "맛집"/"Food" 매핑은 앱이 한다.
///
/// [position] 오름차순으로 **이미 정렬돼 온다.** 클라이언트가 다시 정렬할 필요가
/// 없고, 그 값을 보유하는 이유는 서버가 정렬을 보장한다는 계약을 모델이 드러내기
/// 위해서다.
///
/// **구성이 없는 앱이면 빈 목록이고 그것이 정상이다** — 오류가 아니므로 칩 영역이
/// 비는 레이아웃을 허용해야 한다.
class CommunityChip {
  const CommunityChip({required this.category, required this.position});

  final TargetCategory category;
  final int position;

  @override
  bool operator ==(Object other) =>
      other is CommunityChip &&
      other.category == category &&
      other.position == position;

  @override
  int get hashCode => Object.hash(category, position);
}
