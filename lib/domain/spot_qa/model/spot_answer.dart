import '../../../common/model/list_equality.dart';
import '../../../common/model/post_author.dart';
import 'spot_answer_reply.dart';

/// 질문에 달린 답변(서버 `SpotAnswer`).
///
/// 답글은 [replies]로 함께 내려온다 — 깊이가 2단계뿐이라 페이지네이션이 없다.
///
/// 순수 도메인 모델.
class SpotAnswer {
  const SpotAnswer({
    required this.id,
    required this.questionId,
    required this.body,
    required this.author,
    required this.createdAt,
    this.photoKeys = const <String>[],
    this.replies = const <SpotAnswerReply>[],
    this.ownedByViewer = false,
    this.hidden = false,
  });

  final String id;
  final String questionId;

  /// 1~500자.
  final String body;
  final PostAuthor author;
  final List<String> photoKeys;
  final bool ownedByViewer;

  /// **이 답변 자체가** 숨겨졌는지. 질문이 숨겨져 답변이 함께 가려지는 경우 이 값은
  /// 바뀌지 않는다 — 질문이 복구되면 답변도 함께 돌아와야 하기 때문이다.
  ///
  /// 그래서 노출 여부를 이 필드로 판단하지 않는다. 가려진 답변은 애초에 목록에 없다.
  final bool hidden;

  final DateTime createdAt;

  /// 오래된 순. 답글에 답글이 없어 한 단계로 끝난다(R7).
  final List<SpotAnswerReply> replies;

  /// 답글 작성 성공 후 목록 갱신용.
  SpotAnswer copyWith({List<SpotAnswerReply>? replies}) => SpotAnswer(
    id: id,
    questionId: questionId,
    body: body,
    author: author,
    createdAt: createdAt,
    photoKeys: photoKeys,
    replies: replies ?? this.replies,
    ownedByViewer: ownedByViewer,
    hidden: hidden,
  );

  @override
  bool operator ==(Object other) =>
      other is SpotAnswer &&
      other.id == id &&
      other.questionId == questionId &&
      other.body == body &&
      other.author == author &&
      listEquals(other.photoKeys, photoKeys) &&
      other.ownedByViewer == ownedByViewer &&
      other.hidden == hidden &&
      other.createdAt == createdAt &&
      listEquals(other.replies, replies);

  @override
  int get hashCode => Object.hash(
    id,
    questionId,
    body,
    author,
    Object.hashAll(photoKeys),
    ownedByViewer,
    hidden,
    createdAt,
    Object.hashAll(replies),
  );
}
