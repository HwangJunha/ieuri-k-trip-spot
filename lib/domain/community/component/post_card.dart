import 'package:flutter/material.dart';

import '../../../common/network/media_cdn.dart';
import '../../../common/widget/image_placeholder.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/post.dart';
import 'post_action_bar.dart';
import 'post_target_chip.dart';
import 'post_topic_label.dart';

/// 피드 항목 하나(디자인 §1의 PostCard 분해).
///
/// ```
/// 헤더 행    아바타 · 닉네임 · middot · 상대시각
/// PostTargetChip
/// 본문       목록에서는 3줄, 넘치면 ellipsis
/// 사진       0장이면 영역 자체를 미렌더 / 1장 와이드 / N장 썸네일 행
/// 주제 태그 pill  저강조
/// PostActionBar
/// ```
///
/// **작성자를 눌러도 이동할 곳이 없다** — 프로필 화면이 비범위라 닉네임과 프로필
/// 이미지는 표시만 한다(설계 §6).
///
/// [expanded]가 true면 상세용이다 — 본문을 자르지 않고 사진을 전부 보여준다(디자인 §4).
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.now,
    this.onTap,
    this.onLike,
    this.onTargetTap,
    this.showTarget = true,
    this.expanded = false,
  });

  final Post post;

  /// 상대 시각 계산 기준. 인자로 받아 테스트가 시간을 고정할 수 있게 한다.
  final DateTime now;

  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onTargetTap;

  /// 대상 pill 표시 여부. spot 상세 안의 피드에서는 false다 — 이미 그 spot의
  /// 화면이라 같은 이름을 두 번 보여줄 이유가 없다(디자인 §2).
  final bool showTarget;

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Header(post: post, now: now),
            // 신고 누적으로 숨겨진 글은 **작성자 본인에게만** 내려온다. 배지가 없으면
            // 작성자는 왜 반응이 없는지 몰라 서버 장애로 오해한다(가이드 §6).
            if (post.hidden) ...<Widget>[
              const SizedBox(height: 8),
              _HiddenBadge(label: l10n.communityHiddenBadge),
            ],
            if (showTarget) ...<Widget>[
              const SizedBox(height: 8),
              PostTargetChip(target: post.target, onTap: onTargetTap),
            ],
            const SizedBox(height: 8),
            Text(
              post.body,
              maxLines: expanded ? null : 3,
              overflow: expanded ? null : TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
            // 사진이 없으면 자리를 비워두지 않고 **영역 자체를 렌더하지 않는다**
            // (디자인 §1).
            if (post.photoKeys.isNotEmpty) ...<Widget>[
              const SizedBox(height: 10),
              _Photos(photoKeys: post.photoKeys, expanded: expanded),
            ],
            if (post.topic != null) ...<Widget>[
              const SizedBox(height: 10),
              _TopicPill(label: postTopicLabel(l10n, post.topic!)),
            ],
            const SizedBox(height: 4),
            PostActionBar(
              likeCount: post.likeCount,
              likedByViewer: post.likedByViewer,
              // 서버 commentCount 그대로 — 목록 길이로 계산하지 않는다(가이드 §6).
              commentCount: post.commentCount,
              onLike: onLike,
              onComment: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.post, required this.now});

  final Post post;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? avatar = post.author.profileImageUrl;
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          foregroundImage: avatar == null ? null : NetworkImage(avatar),
          child: Text(
            // 프로필 이미지가 없을 때의 이니셜. 닉네임이 비는 경우는 서버 계약상
            // 없지만, 그래도 빈 문자열에서 터지지 않게 한다.
            post.author.nickname.isEmpty
                ? '?'
                : post.author.nickname.characters.first,
            style: theme.textTheme.labelMedium,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            post.author.nickname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '·',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          relativePostTime(l10n, post.createdAt, now),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// 사진 표시. 1장이면 와이드, 여러 장이면 가로 스크롤 썸네일 행이다.
///
/// 배치(그리드 vs 가로 스크롤)는 목업의 제안일 뿐 확정이 아니라(디자인 §10) 가로
/// 스크롤을 택했다 — 개수가 1~5로 적고, 그리드는 장수에 따라 카드 높이가 크게
/// 출렁인다.
///
/// **개발 환경 시드의 키는 실제 오브젝트가 없어 404가 정상이다**(가이드 §3).
/// 그래서 항상 플레이스홀더를 깔고 그 위에 이미지를 그린다 — 실패해도 레이아웃이
/// 무너지지 않는다.
class _Photos extends StatelessWidget {
  const _Photos({required this.photoKeys, required this.expanded});

  final List<String> photoKeys;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    if (photoKeys.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: _Photo(photoKey: photoKeys.first),
        ),
      );
    }
    return SizedBox(
      height: expanded ? 200 : 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photoKeys.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: expanded ? 200 : 120,
            child: _Photo(photoKey: photoKeys[index]),
          ),
        ),
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.photoKey});

  final String photoKey;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: <Widget>[
      ImagePlaceholder(imageRef: photoKey),
      // 키 → URL 조합은 앱 설정의 CDN 베이스로 한다(가이드 §3). 위젯에 문자열을
      // 박지 않는다.
      Image.network(
        MediaCdn.urlFor(photoKey),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      ),
    ],
  );
}

class _TopicPill extends StatelessWidget {
  const _TopicPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _HiddenBadge extends StatelessWidget {
  const _HiddenBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.visibility_off_outlined,
              size: 14,
              color: theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
