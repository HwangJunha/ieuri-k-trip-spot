import 'package:flutter/material.dart';

import '../../../common/widget/author_avatar.dart';
import '../../../common/widget/post_labels.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/conversation.dart';
import '../model/message.dart';

/// 대화 목록 한 줄 — 아바타·닉네임·미리보기·상대시각·미읽음 배지.
///
/// 커뮤니티 목록과 같은 **납작한 행**이다(그림자 없음, 얇은 구분선) — 채팅 목록은
/// Material 카드보다 이 앱의 기존 리스트 언어와 잘 맞는다.
///
/// **읽음 확인(✓✓)은 범위 밖이다** — 체크마크나 "읽음" 표시를 두지 않는다.
/// [Conversation.unreadCount]는 상대가 읽었는지가 아니라 **내가 안 읽은 수**다.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.now,
    required this.onTap,
  });

  final Conversation conversation;

  /// 상대 시각 계산 기준. 행마다 `DateTime.now()`를 부르면 목록 안에서 기준이
  /// 어긋난다.
  final DateTime now;

  final VoidCallback onTap;

  /// 두 자리를 넘는 미읽음은 접는다. 스펙에 상한 규정이 없어 관례를 따른다.
  static const int _badgeMax = 9;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool unread = conversation.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AuthorAvatar(author: conversation.counterpart),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          conversation.counterpart.nickname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            // 읽지 않은 행만 이름을 굵게 둔다.
                            fontWeight: unread
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        relativePostTime(l10n, conversation.updatedAt, now),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _preview(l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (unread) ...<Widget>[
                        const SizedBox(width: 8),
                        _UnreadBadge(count: conversation.unreadCount),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 마지막 메시지 한 줄.
  ///
  /// **본문이 비어도 메시지는 있다** — 사진이나 피드 인용만 보낸 경우가 그렇다.
  /// 그때 빈 줄을 그리면 대화가 비어 보이므로 첨부가 있다는 표시를 대신 둔다.
  /// 대화 자체가 비어 있는 경우(시작만 하고 아직 아무도 안 보냄)도 같은 자리다.
  String _preview(AppLocalizations l10n) {
    final Message? last = conversation.lastMessage;
    if (last == null) return l10n.dmConversationEmpty;
    if (last.hasBody) return last.body;
    return l10n.dmPhotoMessagePreview;
  }
}

/// 미읽음 수 배지. **0이면 이 위젯 자체가 그려지지 않는다**(호출부가 거른다).
class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.dmUnreadCountLabel(count),
      child: ExcludeSemantics(
        child: Container(
          constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: Text(
              count > ConversationTile._badgeMax
                  ? l10n.dmUnreadCountOverflow
                  : '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
