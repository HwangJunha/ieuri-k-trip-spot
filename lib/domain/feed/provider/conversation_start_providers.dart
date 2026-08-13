import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/feed_repository.dart';
import 'feed_providers.dart';

part 'conversation_start_providers.g.dart';

/// 피드 항목에서 대화를 연다(R7).
///
/// **입력이 회원 id가 아니라 피드 id다** — 그래서 커뮤니티 글 작성자는 구조적으로
/// 상대가 될 수 없다(설계 §6). 이미 대화가 있으면 서버가 새로 만들지 않고 기존
/// 대화를 돌려주므로(AC7-2) 클라이언트가 중복을 확인할 필요가 없다.
///
/// 상태를 들지 않는 한 번짜리 동작이라 notifier가 아니라 함수 provider다 — 화면은
/// 돌려받은 conversationId로 대화 화면을 열고, null이면 실패를 알린다.
@riverpod
ConversationStarter conversationStarter(Ref ref) =>
    ConversationStarter(ref.watch(feedRepositoryProvider));

/// 대화 시작 한 번. 실패는 **null로 돌려준다** — 도메인 거부(`BLOCKED` 등)와 전송
/// 실패를 화면이 똑같이 "대화를 시작하지 못했다"로 다루기 때문이다.
class ConversationStarter {
  const ConversationStarter(this._repository);

  final FeedRepository _repository;

  Future<String?> start(String feedItemId) async {
    try {
      final FeedMutationResult<String> result = await _repository
          .startConversation(feedItemId);
      if (!result.succeeded) {
        developer.log(
          'startConversation rejected: ${result.errorCode}',
          name: 'ConversationStarter',
        );
        return null;
      }
      return result.value;
    } on Object catch (error) {
      developer.log(
        'startConversation failed: ${error.runtimeType}',
        name: 'ConversationStarter',
      );
      return null;
    }
  }
}
