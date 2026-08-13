import '../../../common/model/list_equality.dart';
import '../../../common/model/post_author.dart';
import '../../../common/model/post_spot.dart';

/// 피드 항목 하나(서버 `FeedItem`).
///
/// **`Post`와 별개 타입이다.** 피드는 spot 정확히 1곳과 사진 1장 이상을 요구하는 반면
/// `Post`는 둘 다 선택이라, 같은 타입에 이 제약을 얹으면 기존 글이 전부 깨진다
/// (계약 §피드). 모양이 비슷하다고 합치면 안 되는 이유가 이것이다.
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음. repository가 생성 타입에서
/// 매핑하고 생성 타입은 밖으로 나가지 않는다(POL-020).
class FeedItem {
  const FeedItem({
    required this.id,
    required this.body,
    required this.spot,
    required this.photoKeys,
    required this.author,
    required this.createdAt,
    this.likeCount = 0,
    this.likedByViewer = false,
    this.ownedByViewer = false,
  });

  final String id;

  /// 본문(1~500자).
  final String body;

  /// 붙은 장소. **`Post.spot`과 달리 non-null이다** — 피드는 항상 정확히 1곳을
  /// 가진다(R1). 여기서 spot 상세로 넘어가는 것이 피드의 목적이다(R13).
  final PostSpot spot;

  /// 사진 **키** 배열(URL 아님). 1~5개이며 **비어 있을 수 없다**(R2). 순서가 표시
  /// 순서다. CDN 베이스와 조합하는 것은 표시 계층의 몫이다.
  final List<String> photoKeys;

  final PostAuthor author;

  /// 작성 시각(UTC). 서버 ISO-8601 문자열을 파싱한 값이며 피드의 정렬 기준이다.
  final DateTime createdAt;

  final int likeCount;

  /// 내가 좋아요했는지.
  final bool likedByViewer;

  /// 내 피드인지. **DM 진입점 노출 여부를 가른다** — 자기 자신과의 대화는 만들 수
  /// 없으므로(AC7-4) true면 대화 시작 수단을 그리지 않는다.
  final bool ownedByViewer;

  /// 좋아요 낙관적 갱신용 사본(설계 §3). 실패 시 이전 값으로 되돌리고, 성공하면
  /// **서버가 돌려준 likeCount로 되맞춘다** — 서버 값이 정본이다.
  FeedItem copyWith({bool? likedByViewer, int? likeCount}) => FeedItem(
    id: id,
    body: body,
    spot: spot,
    photoKeys: photoKeys,
    author: author,
    createdAt: createdAt,
    likeCount: likeCount ?? this.likeCount,
    likedByViewer: likedByViewer ?? this.likedByViewer,
    ownedByViewer: ownedByViewer,
  );

  @override
  bool operator ==(Object other) =>
      other is FeedItem &&
      other.id == id &&
      other.body == body &&
      other.spot == spot &&
      listEquals(other.photoKeys, photoKeys) &&
      other.author == author &&
      other.createdAt == createdAt &&
      other.likeCount == likeCount &&
      other.likedByViewer == likedByViewer &&
      other.ownedByViewer == ownedByViewer;

  @override
  int get hashCode => Object.hash(
    id,
    body,
    spot,
    Object.hashAll(photoKeys),
    author,
    createdAt,
    likeCount,
    likedByViewer,
    ownedByViewer,
  );
}
