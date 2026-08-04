import 'copyright_type.dart';
import 'spot_category.dart';

/// 좋아요 목록의 항목 하나(SPEC-0008 R-18).
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음. repository가 생성 타입
/// (`Query$LikedSpots$likedSpots$edges$node`)에서 이 모델로 매핑하고, 생성 타입은
/// repository 밖으로 나가지 않는다(POL-020, §5.2).
///
/// [SpotDetail]과 별개인 목록 전용 read shape다 — 목록은 카드에 필요한 값만 담고,
/// 항목을 선택하면 [id]를 그대로 `spotDetail(id:)`에 넘겨 기존 `/spot/:id`로
/// 진입한다(§5.1). 상세 화면을 새로 만들지 않는다.
///
/// 엣지의 `likedAt`은 담지 않는다. 요구사항에 좋아요 시각 표시 요건이 없어
/// **표시하지 않는 것이 기본**이고, 정렬은 서버가 보장하므로 클라이언트가 재정렬하지
/// 않는다(§5.2). 표시가 필요해지면 그때 필드를 더한다 — 미리 들고 있지 않는다.
class LikedSpot {
  const LikedSpot({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    required this.category,
    required this.copyright,
    required this.attributionText,
    this.address,
  });

  /// contentId — [TouristSpot.id]·[SpotDetail.id]와 동일 식별자 공간.
  /// 그대로 상세 조회에 쓰인다(§5.1).
  final String id;
  final String title;

  /// 목록 카드 썸네일(항상 존재).
  final String thumbnailImageUrl;

  /// 주소. 없으면 주소 행을 그리지 않는다(빈 라벨 금지).
  final String? address;

  final SpotCategory category;

  /// 이미지 저작권 유형 — 카드의 BoxFit 분기를 정한다(스와이프 카드와 동일 규칙).
  final CopyrightType copyright;

  /// 카드마다 노출하는 저작권 표준 문구.
  final String attributionText;

  @override
  bool operator ==(Object other) =>
      other is LikedSpot &&
      other.id == id &&
      other.title == title &&
      other.thumbnailImageUrl == thumbnailImageUrl &&
      other.address == address &&
      other.category == category &&
      other.copyright == copyright &&
      other.attributionText == attributionText;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    thumbnailImageUrl,
    address,
    category,
    copyright,
    attributionText,
  );
}
