import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 피드 우측 세로 배치의 좋아요 — 하트 + 카운트(R6).
///
/// **낙관적 갱신은 이 위젯이 하지 않는다.** 즉시 반영도 실패 시 롤백도 provider
/// 몫이고(설계 §3) 여기서는 넘어온 상태를 그리기만 한다 — 위젯이 자기 상태를
/// 들고 있으면 롤백이 두 곳에서 일어난다.
///
/// 사진 위에 얹히므로 채워지지 않은 상태의 색은 표면색이 아니라 스크림 대비색이다.
class FeedLikeButton extends StatelessWidget {
  const FeedLikeButton({
    super.key,
    required this.liked,
    required this.likeCount,
    required this.onTap,
  });

  final bool liked;
  final int likeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 채워지면 primary, 아니면 사진 위 대비색(`PostCard`의 좋아요 색 규칙과 같다).
    final Color color = liked
        ? theme.colorScheme.primary
        : theme.colorScheme.onPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          tooltip: l10n.feedLikeAction,
          onPressed: onTap,
          iconSize: 32,
          color: color,
          icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
        ),
        Text(
          '$likeCount',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
