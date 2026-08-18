import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 답변·답글 아래의 텍스트 액션 행(디자인 §2 — ⋮ 시트 대신 인라인으로 둔다).
///
/// 액션이 두셋뿐이라 시트로 감추면 한 단계만 늘어난다. **null인 콜백은 그리지
/// 않으므로** 내 답변에는 DM·신고가 아예 나타나지 않는다 — 자기 자신과 대화하거나
/// 자기 글을 신고할 이유가 없다.
///
/// **[onReply]는 답변에만 넘긴다.** 답글 타일은 이 값을 주지 않으며, 그것이 "답글에
/// 답글을 달 수 없다"(R7)의 화면 표현이다.
class SpotQaActionRow extends StatelessWidget {
  const SpotQaActionRow({
    super.key,
    this.onMessage,
    this.onReport,
    this.onReply,
  });

  final VoidCallback? onMessage;
  final VoidCallback? onReport;
  final VoidCallback? onReply;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<Widget> actions = <Widget>[
      if (onReply != null)
        _Action(label: l10n.spotQaReplyAction, onTap: onReply!),
      if (onMessage != null)
        _Action(label: l10n.spotQaDmAction, onTap: onMessage!),
      if (onReport != null)
        _Action(label: l10n.communityReportAction, onTap: onReport!),
    ];
    if (actions.isEmpty) return const SizedBox.shrink();
    return Row(children: actions);
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 28),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        child: Text(label, style: theme.textTheme.labelMedium),
      ),
    );
  }
}
