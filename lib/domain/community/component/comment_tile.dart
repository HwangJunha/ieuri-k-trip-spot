import 'package:flutter/material.dart';

import '../../../common/network/media_cdn.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../common/model/comment.dart';
import 'community_labels.dart';

/// 댓글 한 줄: 아바타 · 닉네임 · 상대시각 · 본문 · [답글 달기] · [⋮].
///
/// **깊이 2단계다**(2차 가이드 §1). 답글은 [isReply]로 들여쓰고 아바타를 한 단계
/// 줄여 최상위와 구분한다.
///
/// **"답글 달기"는 최상위 댓글에만 붙는다.** 답글에 답글을 달아도 서버가 최상위
/// 부모로 눕혀 버려서, 버튼을 두면 "이 답글에 달았다"고 믿은 것과 실제 부모가
/// 어긋난다 — 그래서 [onReply]는 최상위에서만 전달된다.
class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.now,
    this.onOptions,
    this.onReply,
    this.isReply = false,
  });

  final Comment comment;

  /// 상대 시각 계산 기준(테스트가 시간을 고정할 수 있게 인자로 받는다).
  final DateTime now;

  /// 우측 오버플로 — 내 댓글이면 삭제, 남의 댓글이면 신고를 연다. null이면 그리지
  /// 않는다.
  final VoidCallback? onOptions;

  /// 답글 달기. **최상위 댓글에서만 전달한다** — null이면 버튼을 그리지 않는다.
  final VoidCallback? onReply;

  /// 답글이면 들여쓰고 아바타를 줄인다.
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 서버 값은 키일 수 있다 — 그대로 NetworkImage에 넘기면 페인트 중에 터진다.
    final String? avatar = MediaCdn.profileImage(
      comment.author.profileImageUrl,
    );
    return Padding(
      // 답글은 왼쪽을 한 단계(24) 더 들여 부모에 딸린 것으로 읽히게 한다.
      padding: EdgeInsets.fromLTRB(isReply ? 40 : 16, 10, 8, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: isReply ? 11 : 14,
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
                // **답글에는 이 버튼이 없다** — 눌러도 최상위에 달리므로 사용자가
                // 기대한 부모와 실제 부모가 어긋난다(2차 가이드 §1).
                if (onReply != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: onReply,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 28),
                        // 시각 높이는 28로 좁게 두되 터치 영역은 48dp를
                        // 확보한다 — shrinkWrap이면 손가락이 닿는 상자까지
                        // 28px로 줄어 접근성 최소 크기에 못 미친다.
                        tapTargetSize: MaterialTapTargetSize.padded,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        l10n.communityReplyAction,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (onOptions != null)
            IconButton(
              onPressed: onOptions,
              tooltip: l10n.communityPostOptions,
              visualDensity: VisualDensity.compact,
              iconSize: 18,
              color: theme.colorScheme.onSurfaceVariant,
              icon: const Icon(Icons.more_vert),
            ),
        ],
      ),
    );
  }
}
