import 'post_topic.dart';

/// 글이 달린 대상(서버 `PostTarget`). 초안의 `PostSpot`을 대체한다 — 커뮤니티는
/// 관광지 전용이 아니라 플랫폼이고, [type]이 종류를 알려 준다(가이드 §1).
///
/// [type]이 [PostTargetType.spot]일 때 [id]는 기존 `spot.id`와 **같은 식별자 공간**이라
/// 그대로 `/spot/:id` 상세로 넘길 수 있다.
///
/// [type]이 null인 경우는 서버가 아직 매핑되지 않은 새 종류를 추가한 것이다. 그때
/// 대상 pill은 표시하되 탭해도 이동하지 않는다 — 어디로 보낼지 모르기 때문이다.
class PostTarget {
  const PostTarget({
    required this.type,
    required this.id,
    required this.title,
    required this.thumbnailImageUrl,
  });

  /// 대상 종류. 클라이언트가 모르는 값이면 null(글 전체를 실패시키지 않는다).
  final PostTargetType? type;
  final String id;
  final String title;
  final String thumbnailImageUrl;

  @override
  bool operator ==(Object other) =>
      other is PostTarget &&
      other.type == type &&
      other.id == id &&
      other.title == title &&
      other.thumbnailImageUrl == thumbnailImageUrl;

  @override
  int get hashCode => Object.hash(type, id, title, thumbnailImageUrl);
}
