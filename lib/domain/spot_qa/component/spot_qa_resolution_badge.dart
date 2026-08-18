import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 질문의 해결 여부 배지.
///
/// **미해결이 눈에 띄어야 한다.** 이 기능은 답이 달려야 성립하는데, 답을 기다리는
/// 질문이 해결된 것과 같은 톤이면 어느 것이 도움을 기다리는지 알 수 없다. 그래서
/// 미해결은 강조색(error)으로, 해결됨은 낮은 명도로 그린다 — 강조가 뒤집혀 있다.
///
/// 해결됨을 아예 숨기지는 않는다. 지난 질문의 답변도 다음 방문자에게 정보이고,
/// 자기 질문이 처리됐다는 것도 보여야 한다(설계 §질문 목록 화면).
class SpotQaResolutionBadge extends StatelessWidget {
  const SpotQaResolutionBadge({super.key, required this.resolved});

  final bool resolved;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    // 미해결은 채운 색으로 끌어올리고, 해결됨은 아이콘 + 흐린 글자로 가라앉힌다.
    if (!resolved) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          l10n.spotQaUnresolvedLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onErrorContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.check_circle_outline,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 3),
        Text(
          l10n.spotQaResolvedLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
