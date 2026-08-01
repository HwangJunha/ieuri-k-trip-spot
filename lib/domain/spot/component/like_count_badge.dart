import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 좋아요 개수 배지(SPEC-0003 §4). 현재 언어의 실시간 LIKE 수를 하트 아이콘과 함께
/// 보여준다. 개수는 [SpotDetailController]가 낙관적으로 갱신하는 값이라, 이 위젯은
/// 표시만 담당한다.
class LikeCountBadge extends StatelessWidget {
  const LikeCountBadge({super.key, required this.likeCount});

  final int likeCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.favorite, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          l10n.spotDetailLikeCount(likeCount),
          style: theme.textTheme.labelLarge,
        ),
      ],
    );
  }
}
