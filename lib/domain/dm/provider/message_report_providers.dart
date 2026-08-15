import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/message.dart';
import '../model/message_report_selection.dart';
import '../repository/dm_repository.dart';
import 'dm_providers.dart';

part 'message_report_providers.g.dart';

/// DM 메시지 다중 선택 신고의 선택 상태(R15).
///
/// 대화별 family인 이유는 **한 신고가 한 대화에 대한 것이기 때문이다** — 화면 구조상
/// 대화 혼재(AC15-4)가 생기지 않게 선택 자체를 대화 안에 가둔다.
@riverpod
class MessageReportSelectionController
    extends _$MessageReportSelectionController {
  @override
  MessageReportSelection build(String conversationId) =>
      const MessageReportSelection();

  /// 선택 모드를 켠다. 길게 누른 메시지가 있으면 그것이 첫 선택이다.
  void start([Message? first]) => state = state.start(first);

  /// 한 건을 선택/해제한다. **자기 메시지는 무시된다**(AC15-5).
  void toggle(Message message) => state = state.toggle(message);

  void cancel() => state = state.cancel();

  /// 고른 메시지를 한 신고로 접수한다(AC15-1).
  ///
  /// **0건이면 보내지 않는다**(AC15-3) — 서버도 `INVALID_INPUT`으로 거부하지만
  /// 보낼 이유가 없는 요청이다.
  Future<DmMutationResult<void>> submit({
    required String reason,
    String? detail,
  }) async {
    if (!state.canReport) {
      return const DmMutationResult<void>.failure('INVALID_INPUT');
    }
    final DmMutationResult<void> result = await ref
        .read(dmRepositoryProvider)
        .reportMessages(
          messageIds: state.selectedIds.toList(),
          reason: reason,
          detail: detail,
        );
    // 접수됐으면 선택 모드를 닫는다 — 신고한 메시지가 선택된 채 남아 있으면
    // 같은 건을 다시 신고하려 들게 된다.
    if (result.succeeded) state = state.cancel();
    return result;
  }
}
