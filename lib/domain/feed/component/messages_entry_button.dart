import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../provider/conversation_list_providers.dart';
import '../provider/viewer_providers.dart';

/// 둘러보기 헤더의 DM 재진입 아이콘(디자인 §1.5).
///
/// **피드 항목의 DM 아이콘만으로는 대화로 돌아갈 길이 없다** — 대화를 시작한 피드가
/// 스크롤로 지나가거나 삭제되면 접근 자체가 끊긴다. 그래서 헤더에 상시 진입점을 둔다.
/// 토글과 같은 헤더 영역이라 카드 드래그·세로 스크롤과 경합하지 않는다.
///
/// **배지는 숫자가 아니라 점이다.** 서버가 전체 대화의 미읽음 **합계**를 주지 않는다
/// (`Conversation.unreadCount`는 대화별이다). 첫 페이지 합으로 근사하면 20건을 넘는
/// 순간 조용히 틀린 값이 되므로, 서버가 주지 않는 값을 추정하는 대신 "있다/없다"만
/// 알린다(디자인 §1.5 권장).
///
/// **로그인하지 않았으면 아무것도 그리지 않는다** — 눌러도 갈 곳이 없다.
class MessagesEntryButton extends ConsumerWidget {
  const MessagesEntryButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (ref.watch(viewerAuthorProvider) == null) {
      return const SizedBox.shrink();
    }

    // 미읽음 유무만 본다. 목록 조회가 실패하거나 아직 오지 않았으면 점을 그리지
    // 않는다 — 배지는 알림이지 오류 표시가 아니다.
    final bool hasUnread =
        ref.watch(
          conversationListControllerProvider.select(
            (AsyncValue<ConversationListState> s) => s.value?.hasUnread,
          ),
        ) ??
        false;

    final Widget icon = const Icon(Icons.mail_outline);
    return IconButton(
      tooltip: l10n.dmMessagesAction,
      onPressed: onPressed,
      icon: hasUnread
          // 숫자가 없는 점이라 화면만 보고는 무엇인지 알 수 없다 — 스크린리더에
          // 뜻을 남긴다.
          ? Semantics(
              label: l10n.dmUnreadBadgeLabel,
              child: Badge(child: icon),
            )
          : icon,
    );
  }
}
