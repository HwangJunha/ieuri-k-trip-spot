import '../../../common/model/post_author.dart';
import '../../../common/model/spot_qa_origin.dart';
import 'message.dart';

/// 1:1 대화 하나(서버 `Conversation`). 그룹 대화는 비범위다.
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음(POL-020).
class Conversation {
  const Conversation({
    required this.id,
    required this.counterpart,
    required this.updatedAt,
    this.lastMessage,
    this.unreadCount = 0,
    this.spotQaOrigin,
  });

  final String id;

  /// 상대방. 1:1이므로 단일 필드로 충분하다.
  final PostAuthor counterpart;

  /// 가장 최근 메시지. **대화 시작과 첫 전송이 별개 호출이라 빈 대화가 존재할 수
  /// 있어** nullable이다(계약 §DM).
  ///
  /// **미리보기는 여기가 아니라 [Message]에 있다.** 대화에 본문을
  /// 고정하는 필드는 서버에 없다 — 방 하나에 여러 피드가 인용될 수 있어서다.
  final Message? lastMessage;

  /// 내 기준 읽지 않은 메시지 수. **실제로 센다** — 조회만으로는 줄지 않고
  /// `markConversationRead`를 불러야 줄어든다. 읽음 확인(상대가 읽었는지)은
  /// 비범위이며 이 값은 내 배지 표시용이다.
  final int unreadCount;

  /// 정렬 기준. 최근 메시지 시각이며, 메시지가 없으면 대화 생성 시각이다.
  final DateTime updatedAt;

  /// 질문/답변에서 시작된 대화면 그 출처 스냅샷, 일반 DM이면 null(SPEC-0026 R13·R14).
  ///
  /// **기존 대화는 전부 null이다.** non-null로 가정하는 코드를 쓰면 지금 있는 대화가
  /// 전부 깨진다 — 이 필드가 없어도 대화 화면은 지금과 똑같이 동작해야 한다.
  ///
  /// 대화 생성 시점에 고정된다. 이후 원본이 삭제되거나 장소명이 바뀌어도 값은 그대로다.
  final SpotQaOrigin? spotQaOrigin;

  Conversation copyWith({
    Message? lastMessage,
    int? unreadCount,
    DateTime? updatedAt,
  }) => Conversation(
    id: id,
    counterpart: counterpart,
    updatedAt: updatedAt ?? this.updatedAt,
    lastMessage: lastMessage ?? this.lastMessage,
    unreadCount: unreadCount ?? this.unreadCount,
    // 출처는 대화 생성 시점에 고정이라 copyWith로 바꾸지 않는다.
    spotQaOrigin: spotQaOrigin,
  );

  @override
  bool operator ==(Object other) =>
      other is Conversation &&
      other.id == id &&
      other.counterpart == counterpart &&
      other.lastMessage == lastMessage &&
      other.unreadCount == unreadCount &&
      other.updatedAt == updatedAt &&
      other.spotQaOrigin == spotQaOrigin;

  @override
  int get hashCode => Object.hash(
    id,
    counterpart,
    lastMessage,
    unreadCount,
    updatedAt,
    spotQaOrigin,
  );
}
