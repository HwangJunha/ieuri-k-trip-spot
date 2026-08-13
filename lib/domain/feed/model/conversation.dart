import '../../../common/model/post_author.dart';
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
  });

  final String id;

  /// 상대방. 1:1이므로 단일 필드로 충분하다.
  final PostAuthor counterpart;

  /// 가장 최근 메시지. **대화 시작과 첫 전송이 별개 호출이라 빈 대화가 존재할 수
  /// 있어** nullable이다(계약 §DM).
  ///
  /// **인용된 피드는 여기가 아니라 [Message.feedItem]에 있다.** 대화에 피드를
  /// 고정하는 필드는 서버에 없다 — 방 하나에 여러 피드가 인용될 수 있어서다.
  final Message? lastMessage;

  /// 내 기준 읽지 않은 메시지 수. **실제로 센다** — 조회만으로는 줄지 않고
  /// `markConversationRead`를 불러야 줄어든다. 읽음 확인(상대가 읽었는지)은
  /// 비범위이며 이 값은 내 배지 표시용이다.
  final int unreadCount;

  /// 정렬 기준. 최근 메시지 시각이며, 메시지가 없으면 대화 생성 시각이다.
  final DateTime updatedAt;

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
  );

  @override
  bool operator ==(Object other) =>
      other is Conversation &&
      other.id == id &&
      other.counterpart == counterpart &&
      other.lastMessage == lastMessage &&
      other.unreadCount == unreadCount &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      Object.hash(id, counterpart, lastMessage, unreadCount, updatedAt);
}
