import 'package:flutter/material.dart';

import '../../../common/model/post_author.dart';
import '../../../common/network/media_cdn.dart';
import '../../../common/widget/post_labels.dart';
import '../../../l10n/gen/app_localizations.dart';

/// 피드 한 장의 상단 오버레이 — 아바타·닉네임·상대시각·DM 아이콘.
///
/// **DM 아이콘은 피드에만 존재한다**(설계 §6, R7). 커뮤니티 `PostCard`에는 없고
/// 앞으로도 두지 않는다 — 커뮤니티 글 작성자에게는 대화를 걸 수 없어서, 진입점만
/// 보여주고 서버가 거부하면 사용자에게는 고장으로 보인다.
///
/// **내 글이면 DM 아이콘을 그리지 않는다**(AC7-4) — 자기 자신과의 대화는 만들 수
/// 없다. [onMessage]가 null이면 아이콘 자체가 사라진다.
///
/// 사진 위에 얹히므로 반투명 스크림을 깔아 가독성을 확보한다 — Discover 스와이프
/// 카드의 텍스트 오버레이와 같은 처리다.
class FeedAuthorBar extends StatelessWidget {
  const FeedAuthorBar({
    super.key,
    required this.author,
    required this.createdAt,
    required this.now,
    this.onMessage,
    this.onOptions,
  });

  final PostAuthor author;
  final DateTime createdAt;

  /// 상대 시각 계산 기준. 인자로 받아 한 화면 안의 모든 항목이 같은 기준을 쓰게 한다.
  final DateTime now;

  /// 대화 시작. null이면 아이콘을 그리지 않는다(내 글이거나 미로그인).
  final VoidCallback? onMessage;

  /// 우상단 오버플로 — 신고 시트를 연다.
  final VoidCallback? onOptions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 사진 위 텍스트라 표면색이 아니라 스크림 대비색을 쓴다.
    final Color foreground = theme.colorScheme.onPrimary;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            theme.colorScheme.scrim.withValues(alpha: 0.45),
            theme.colorScheme.scrim.withValues(alpha: 0),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 24),
          child: Row(
            children: <Widget>[
              _AuthorAvatar(author: author, foreground: foreground),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      author.nickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      relativePostTime(l10n, createdAt, now),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: foreground.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              if (onMessage != null)
                IconButton(
                  tooltip: l10n.feedMessageAuthorAction,
                  color: foreground,
                  onPressed: onMessage,
                  icon: const Icon(Icons.mail_outline),
                ),
              if (onOptions != null)
                IconButton(
                  tooltip: l10n.feedOptionsAction,
                  color: foreground,
                  onPressed: onOptions,
                  icon: const Icon(Icons.more_vert),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 작성자 아바타. 이미지가 없거나 404여도 자리 크기가 같다 — `PostCard`의
/// `_AuthorAvatar`와 같은 폴백이며, 실패가 레이아웃을 밀지 않는다.
class _AuthorAvatar extends StatelessWidget {
  const _AuthorAvatar({required this.author, required this.foreground});

  final PostAuthor author;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // 서버 값은 완전한 URL이 아니라 키일 수 있다 — 그대로 넘기면 페인트 중에 터진다.
    final String? url = MediaCdn.profileImage(author.profileImageUrl);
    return CircleAvatar(
      radius: 16,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      foregroundImage: (url == null || url.isEmpty) ? null : NetworkImage(url),
      child: Text(
        author.nickname.isEmpty ? '?' : author.nickname.characters.first,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
