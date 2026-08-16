import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/dm_repository.dart';
import 'dm_providers.dart';

part 'conversation_start_providers.g.dart';

/// 지정한 회원과 대화를 연다(SPEC-0021 R11).
///
/// **입력이 피드 id에서 회원 id로 바뀌었다** — 피드가 사라지면서 "이 글의 작성자와
/// 대화"라는 간접 지정이 성립하지 않는다. 이미 대화가 있으면 서버가 새로 만들지 않고
/// 기존 대화를 돌려주므로(AC7-2) 클라이언트가 중복을 확인할 필요가 없다.
///
/// **지금 이것을 부르는 화면이 없다.** 상대를 고르는 화면은 이 스펙의 범위 밖이고
/// ([TBD-2]) 후속 채팅 스펙이 만든다 — 그때 쓰려고 남겨 둔다.
///
/// 상태를 들지 않는 한 번짜리 동작이라 notifier가 아니라 함수 provider다 — 화면은
/// 돌려받은 conversationId로 대화 화면을 열고, null이면 실패를 알린다.
@riverpod
ConversationStarter conversationStarter(Ref ref) =>
    ConversationStarter(ref.watch(dmRepositoryProvider));

/// 대화 시작 한 번. 실패는 **null로 돌려준다** — 도메인 거부(`BLOCKED` 등)와 전송
/// 실패를 화면이 똑같이 "대화를 시작하지 못했다"로 다루기 때문이다.
class ConversationStarter {
  const ConversationStarter(this._repository);

  final DmRepository _repository;

  Future<String?> start(String counterpartMemberId) async {
    try {
      final DmMutationResult<String> result = await _repository
          .startConversation(counterpartMemberId);
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
