import '../../../common/model/post_author.dart';
import 'feed_item.dart';
import 'message.dart';

/// 1:1 대화 하나(서버 `Conversation`). 그룹 대화는 비범위다.
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음(POL-020).
class Conversation {
  const Conversation({
    required this.id,
    required this.counterpart,
    required this.updatedAt,
    this.originFeedItem,
    this.lastMessage,
    this.unreadCount = 0,
  });

  final String id;

  /// 상대방. 1:1이므로 단일 필드로 충분하다.
  final PostAuthor counterpart;

  /// 이 대화가 시작된 피드. **피드가 삭제되면 null이 되며 대화 자체는 남는다** —
  /// 출처가 사라졌다고 주고받은 대화를 지우지 않는다.
  final FeedItem? originFeedItem;

  /// 가장 최근 메시지. **대화 시작과 첫 전송이 별개 호출이라 빈 대화가 존재할 수
  /// 있어** nullable이다(계약 §DM).
  final Message? lastMessage;

  /// 내 기준 읽지 않은 메시지 수. 읽음 확인(상대가 읽었는지)은 비범위다 — 이 값은
  /// 배지 표시에만 쓴다.
  final int unreadCount;

  /// 정렬 기준. 최근 메시지 시각이며, 메시지가 없으면 대화 생성 시각이다.
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      other is Conversation &&
      other.id == id &&
      other.counterpart == counterpart &&
      other.originFeedItem == originFeedItem &&
      other.lastMessage == lastMessage &&
      other.unreadCount == unreadCount &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    counterpart,
    originFeedItem,
    lastMessage,
    unreadCount,
    updatedAt,
  );
}
