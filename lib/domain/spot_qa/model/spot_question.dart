import '../../../common/model/list_equality.dart';
import '../../../common/model/post_author.dart';
import '../../../common/model/post_spot.dart';

/// 장소에 달린 질문 하나(서버 `SpotQuestion`).
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음(POL-020).
///
/// [spot]은 **non-null이다.** 글(`Post.spot`)과 달리 질문은 항상 장소에 종속되며,
/// 장소 없는 질문은 존재하지 않는다.
class SpotQuestion {
  const SpotQuestion({
    required this.id,
    required this.spot,
    required this.body,
    required this.author,
    required this.resolved,
    required this.answerCount,
    required this.createdAt,
    this.photoKeys = const <String>[],
    this.ownedByViewer = false,
    this.hidden = false,
  });

  final String id;
  final PostSpot spot;

  /// 1~500자. 서버가 앞뒤 공백을 제거한 뒤 판정한다.
  final String body;
  final PostAuthor author;

  /// 첨부 사진의 확정 오브젝트 키(최대 5, 첨부 순서). 서버에 업로드 뮤테이션이 없는
  /// 동안 작성은 항상 빈 목록을 보내지만, **읽기는 값이 올 수 있다** — 다른 클라이언트나
  /// 이후 서버 구현이 채운 질문을 그대로 표시해야 하므로 필드를 비워 두지 않는다.
  final List<String> photoKeys;

  /// 질문자가 해결됨으로 표시했는지. "이 답이 정답"이 아니라 "질문자가 충분히
  /// 알게 되었다"는 뜻이다 — 그래서 답변 채택이 따로 없다.
  ///
  /// 되돌리는 수단이 없다(서버에 뮤테이션 자체가 없다).
  final bool resolved;

  /// 이 질문에 달린 답변 수. 숨겨진 답변은 빠져 있으며 모든 호출자에게 같은 값이다.
  final int answerCount;

  final bool ownedByViewer;

  /// 신고 누적 자동 숨김 여부. **작성자 본인만 자기 질문에서 true를 본다** — 남의
  /// 숨겨진 질문은 애초에 목록에 오지 않으므로 이 값이 true인 항목은 항상 내 것이다.
  final bool hidden;

  final DateTime createdAt;

  /// 해결 표시 낙관적 갱신용. [resolved]만 바뀌며 나머지는 서버 응답을 기다린다.
  SpotQuestion copyWith({bool? resolved, int? answerCount}) => SpotQuestion(
    id: id,
    spot: spot,
    body: body,
    author: author,
    resolved: resolved ?? this.resolved,
    answerCount: answerCount ?? this.answerCount,
    createdAt: createdAt,
    photoKeys: photoKeys,
    ownedByViewer: ownedByViewer,
    hidden: hidden,
  );

  @override
  bool operator ==(Object other) =>
      other is SpotQuestion &&
      other.id == id &&
      other.spot == spot &&
      other.body == body &&
      other.author == author &&
      listEquals(other.photoKeys, photoKeys) &&
      other.resolved == resolved &&
      other.answerCount == answerCount &&
      other.ownedByViewer == ownedByViewer &&
      other.hidden == hidden &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    spot,
    body,
    author,
    Object.hashAll(photoKeys),
    resolved,
    answerCount,
    ownedByViewer,
    hidden,
    createdAt,
  );
}
