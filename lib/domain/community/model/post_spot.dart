import 'target_category.dart';

/// 글에 붙은 장소(서버 `PostSpot`).
///
/// **글에 장소가 없을 수 있다** — `Post.spot`은 nullable이고 장소 없는 글이 허용된다
/// (가이드 §5). 그런 글은 좌표 반경 조회에 잡히지 않는다(§10).
///
/// [id]는 관광 도메인의 `spot.id`와 **같은 식별자 공간**이라 그대로 `/spot/:id`
/// 상세로 넘길 수 있다.
///
/// [title]·[thumbnailImageUrl]은 `Accept-Language`를 따른다(가이드 §9).
class PostSpot {
  const PostSpot({
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
    this.category,
  });

  final String id;
  final String title;
  final String thumbnailImageUrl;

  /// 그 장소의 카테고리. **컴포저에서 기본값 제안에 쓴다** — 장소를 고르면 그
  /// 카테고리를 카테고리 선택의 기본값으로 제시한다(가이드 §5).
  ///
  /// 서버가 아직 매핑되지 않은 값을 추가했으면 null이며, 그때는 제안을 하지 않을
  /// 뿐 글 전체가 실패하지 않는다.
  final TargetCategory? category;

  @override
  bool operator ==(Object other) =>
      other is PostSpot &&
      other.id == id &&
      other.title == title &&
      other.thumbnailImageUrl == thumbnailImageUrl &&
      other.category == category;

  @override
  int get hashCode => Object.hash(id, title, thumbnailImageUrl, category);
}
