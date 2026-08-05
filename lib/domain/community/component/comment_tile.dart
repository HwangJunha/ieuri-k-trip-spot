import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/comment.dart';
import 'post_topic_label.dart';

/// 댓글 한 줄(디자인 §4): 아바타 · 닉네임 · 상대시각 · 본문.
///
/// **대댓글 입력 수단이 없다** — 답글 버튼도 들여쓰기도 두지 않는다. 서버 `Comment`에
/// 부모 필드가 아예 없고 대댓글은 비범위다(가이드 §15, 설계 §3).
class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment, required this.now});

  final Comment comment;

  /// 상대 시각 계산 기준(테스트가 시간을 고정할 수 있게 인자로 받는다).
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? avatar = comment.author.profileImageUrl;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 14,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            foregroundImage: avatar == null ? null : NetworkImage(avatar),
            child: Text(
              comment.author.nickname.isEmpty
                  ? '?'
                  : comment.author.nickname.characters.first,
              style: theme.textTheme.labelSmall,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        comment.author.nickname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      relativePostTime(l10n, comment.createdAt, now),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(comment.body, style: theme.textTheme.bodyMedium),
                // 숨김 댓글은 작성자 본인에게만 내려온다(가이드 §6).
                if (comment.hidden) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    l10n.communityHiddenBadge,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
