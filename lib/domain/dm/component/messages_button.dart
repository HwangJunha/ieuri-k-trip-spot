import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/dm_routes.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../provider/conversation_list_providers.dart';

/// 홈 상단바의 메시지 진입점.
///
/// **DM이 왔다는 것을 알 수 있는 유일한 자리다.** 예전에는 설정 안에서만 대화 목록에
/// 들어갈 수 있어, 메시지가 와도 설정을 열어 봐야 알았다 — 그건 알림이 아니다.
///
/// 안 읽은 대화가 있으면 아이콘에 점을 찍는다. 개수를 숫자로 쓰지 않는 이유는 대화
/// 수와 메시지 수 중 무엇을 세는지가 애매하고, 여기서 필요한 정보는 "왔다/안 왔다"
/// 하나이기 때문이다. 정확한 수는 대화 목록이 대화별로 보여준다.
///
/// **비로그인이면 점이 안 뜬다** — 조회가 실패하고 provider가 false로 접는다. 버튼
/// 자체는 남아 있어 눌러서 로그인 흐름으로 갈 수 있다.
class MessagesButton extends ConsumerWidget {
  const MessagesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool hasUnread = ref.watch(hasUnreadConversationsProvider);

    return IconButton(
      tooltip: l10n.spotQaDmEntry,
      onPressed: () => context.pushNamed(conversationsRouteName),
      icon: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          const Icon(Icons.mail_outline),
          if (hasUnread)
            PositionedDirectional(
              top: -1,
              end: -1,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  shape: BoxShape.circle,
                  // 아이콘 선과 점이 붙어 보이지 않게 배경색으로 테를 두른다.
                  border: Border.all(color: theme.colorScheme.surface, width: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
