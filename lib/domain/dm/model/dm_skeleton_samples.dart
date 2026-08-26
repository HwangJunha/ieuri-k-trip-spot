/// 로딩 중 뼈대를 그리기 위한 더미 대화들. **화면에 값이 보이지는 않는다** —
/// `AppSkeleton`이 텍스트를 뼈대로 덮으므로 글자 수만 레이아웃에 남는다.
///
/// ## 왜 값이 이렇게 생겼는가
///
/// - `profileImageUrl`이 **null이다.** `AuthorAvatar`가 이니셜로 떨어져 뼈대가
///   네트워크 요청을 내지 않으면서 자리 크기는 그대로다. 가짜 URL을 넣으면 로딩
///   화면이 실패할 요청을 쏘아 댄다.
/// - `updatedAt`·`createdAt`이 **고정된 날짜다.** `DateTime.now()`를 쓰면 상대 시각
///   문구가 프레임마다 달라져 뼈대가 깜빡인다.
/// - 미리보기 길이와 미읽음 자릿수가 제각각이다. 전부 같으면 뼈대가 표처럼 보인다.
library;

import '../../../common/model/post_author.dart';
import 'conversation.dart';
import 'message.dart';

final DateTime _at = DateTime.utc(2026, 8, 1, 9);

Message _lastMessage(String id, String body) => Message(
  id: id,
  body: body,
  sender: const PostAuthor(id: '_skeleton_sender', nickname: 'Traveler'),
  createdAt: _at,
  ownedByViewer: false,
);

/// 대화 목록의 더미. 호출부는 `index % length`로 골라 길이가 제각각인 줄을 만든다.
final List<Conversation> conversationSkeletonSamples = <Conversation>[
  Conversation(
    id: '_skeleton_conversation_0',
    counterpart: const PostAuthor(id: '_skeleton_0', nickname: 'Seoul Walker'),
    updatedAt: _at,
    lastMessage: _lastMessage('_skeleton_message_0', '내일 오후에 광장시장 어때요?'),
    unreadCount: 2,
  ),
  Conversation(
    id: '_skeleton_conversation_1',
    counterpart: const PostAuthor(id: '_skeleton_1', nickname: 'Jun'),
    updatedAt: _at,
    lastMessage: _lastMessage('_skeleton_message_1', '고마워요!'),
  ),
  Conversation(
    id: '_skeleton_conversation_2',
    counterpart: const PostAuthor(
      id: '_skeleton_2',
      nickname: 'Night Market Fan',
    ),
    updatedAt: _at,
    lastMessage: _lastMessage(
      '_skeleton_message_2',
      '거기 야경은 해 지고 30분쯤이 제일 좋았어요.',
    ),
    unreadCount: 11,
  ),
];
