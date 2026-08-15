import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 다중 선택 신고 모드의 앱바(R15).
///
/// 평소 앱바(상대 닉네임 + 아바타 + ⋮)와 **구조적으로 다른 컴포넌트다** — 상대
/// 정보 대신 선택 개수를 보여주고, 메뉴 대신 취소/신고 액션을 둔다. Material의
/// 표준 contextual action bar 관례를 따라 배경색까지 바꿔 모드가 다름을 알린다.
///
/// **0건 선택이면 신고 버튼이 비활성이다**(AC15-3) — 서버가 `INVALID_INPUT`으로
/// 다시 거부하지만, 보낼 이유가 없는 요청은 화면에서 먼저 막는다.
class ConversationSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ConversationSelectionAppBar({
    super.key,
    required this.selectedCount,
    required this.onCancel,
    required this.onReport,
  });

  final int selectedCount;
  final VoidCallback onCancel;

  /// 신고 시트를 연다. **0건이면 호출부가 null을 넘기지 않고 이 위젯이 버튼을
  /// 비활성화한다** — 활성 여부 판단이 한 곳에 모인다.
  final VoidCallback onReport;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.secondaryContainer,
      foregroundColor: theme.colorScheme.onSecondaryContainer,
      leading: IconButton(
        tooltip: l10n.dmSelectionCancel,
        onPressed: onCancel,
        icon: const Icon(Icons.close),
      ),
      title: Text(l10n.dmSelectionCount(selectedCount)),
      actions: <Widget>[
        TextButton(
          onPressed: selectedCount > 0 ? onReport : null,
          child: Text(l10n.dmReportSelectedAction),
        ),
      ],
    );
  }
}
