import '../../../common/model/list_equality.dart';
import '../../../common/model/post_author.dart';

/// 답변에 달린 답글(서버 `SpotAnswerReply`).
///
/// **답글에는 답글을 달 수 없다**(R7). 이 타입에 `replies`가 없는 것이 그 표현이며,
/// 그래서 답글 타일은 답글 액션을 노출하지 않는다 — 타입 수준에서 불가능하다.
///
/// 순수 도메인 모델.
class SpotAnswerReply {
  const SpotAnswerReply({
    required this.id,
    required this.answerId,
    required this.body,
    required this.author,
    required this.createdAt,
    this.photoKeys = const <String>[],
    this.ownedByViewer = false,
    this.hidden = false,
  });

  final String id;

  /// 이 답글이 달린 답변.
  final String answerId;

  /// 1~500자.
  final String body;
  final PostAuthor author;
  final List<String> photoKeys;
  final bool ownedByViewer;

  /// 신고 누적 자동 숨김 여부. 작성자 본인만 자기 답글에서 true를 본다.
  final bool hidden;

  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      other is SpotAnswerReply &&
      other.id == id &&
      other.answerId == answerId &&
      other.body == body &&
      other.author == author &&
      listEquals(other.photoKeys, photoKeys) &&
      other.ownedByViewer == ownedByViewer &&
      other.hidden == hidden &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    answerId,
    body,
    author,
    Object.hashAll(photoKeys),
    ownedByViewer,
    hidden,
    createdAt,
  );
}
