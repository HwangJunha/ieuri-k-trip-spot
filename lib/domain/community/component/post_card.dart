import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/post.dart';
import '../model/post_author.dart';
import 'community_labels.dart';
import 'post_photo.dart';

/// 피드 항목 하나 — **당근 동네생활 카드 배치**를 따른다.
///
/// ```
/// ┌────────────────────────────────────────────────┐
/// │ (아바타) 닉네임 · 카테고리(저강조)         [⋮] │  ← 좌상단 작성자+카테고리
/// │ ┌────┐  제목 (굵게)                            │
/// │ │사진│  본문 2줄, 넘치면 ellipsis               │  ← 사진은 **좌측 1장만**
/// │ └────┘                                         │
/// │        장소명 · #태그 · 3시간 전  👁330 💬4 ♡12 │  ← 전부 우측 정렬
/// └────────────────────────────────────────────────┘
/// ```
///
/// 당근 카드는 **납작하다** — 그림자 있는 Material 카드가 아니라 얇은 구분선으로만
/// 나뉘고 세로 여백이 넉넉하다. 그래서 [Card]도 elevation도 쓰지 않고 구분선은
/// 목록 쪽이 그린다.
///
/// **사진은 첫 장 하나만 그리고, 없으면 영역 자체를 접는다** — 빈 상자를 자리
/// 잡아 두면 사진 있는 카드와 없는 카드의 텍스트 시작점이 어긋난다.
///
/// **작성자는 맨 윗줄에, 카테고리 앞에 둔다** — 당근이 닉네임을 카드 상단에 두는
/// 자리다. 프로필 이미지가 없거나 404여도 레이아웃이 흔들리지 않도록 첫 글자
/// 아바타로 떨어진다. 눌러도 가는 곳이 없으므로(프로필 화면 비범위) 링크로 만들지
/// 않는다.
///
/// **조회수는 서버 `Post.viewCount`를 그대로 쓴다** — 클라이언트가 세지 않는다.
/// 하단 행에서 댓글·좋아요보다 앞에 두는 이유는 그 셋 중 유일하게 누를 수 없는
/// 값이라, 누르는 것끼리 오른쪽에 모여 있는 편이 손가락이 헷갈리지 않는다.
///
/// [expanded]가 true면 상세용이다 — 본문을 자르지 않고 사진을 전부 보여준다.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.now,
    this.onTap,
    this.onLike,
    this.onSpotTap,
    this.onOptions,
    this.onPhotoTap,
    this.showSpot = true,
    this.expanded = false,
  });

  final Post post;

  /// 상대 시각 계산 기준. 인자로 받아 테스트가 시간을 고정할 수 있게 한다.
  final DateTime now;

  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onSpotTap;

  /// 우상단 오버플로 — 신고·차단(+내 글이면 수정·삭제) 메뉴를 연다. null이면 버튼을
  /// 그리지 않는다.
  final VoidCallback? onOptions;

  /// 사진 탭 — 전체 화면 뷰어를 연다. 인덱스를 넘겨 그 장부터 보여준다.
  final ValueChanged<int>? onPhotoTap;

  /// 장소 이름 표시 여부. 장소 상세 안의 피드에서는 false다 — 이미 그 장소의
  /// 화면이라 같은 이름을 두 번 보여줄 이유가 없다.
  final bool showSpot;

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 맨 위 줄: 좌측 작성자+카테고리(저강조), 우측 오버플로.
            Row(
              children: <Widget>[
                Expanded(
                  child: _AuthorLine(
                    author: post.author,
                    category: post.category == null
                        ? null
                        : targetCategoryLabel(l10n, post.category!),
                  ),
                ),
                if (onOptions != null)
                  _OptionsButton(
                    tooltip: l10n.communityPostOptions,
                    onPressed: onOptions!,
                  ),
              ],
            ),
            // 신고 누적으로 숨겨진 글은 **작성자 본인에게만** 내려온다. 배지가 없으면
            // 작성자는 왜 반응이 없는지 몰라 서버 장애로 오해한다(가이드 §6).
            if (post.hidden) ...<Widget>[
              const SizedBox(height: 6),
              _HiddenBadge(label: l10n.communityHiddenBadge),
            ],
            const SizedBox(height: 4),
            if (expanded)
              _ExpandedBody(post: post, onPhotoTap: onPhotoTap)
            else
              _CompactBody(post: post, onPhotoTap: onPhotoTap),
            const SizedBox(height: 10),
            _FooterRow(
              post: post,
              now: now,
              showSpot: showSpot,
              onSpotTap: onSpotTap,
              onLike: onLike,
              onComment: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

/// 목록 카드의 본문 — **좌측에 사진 1장, 우측에 제목+본문**이다.
///
/// 사진이 없으면 [Row] 대신 텍스트만 그린다. 빈 상자를 남겨 두면 사진 있는 카드와
/// 없는 카드의 제목 시작점이 어긋나 목록이 들쭉날쭉해진다.
class _CompactBody extends StatelessWidget {
  const _CompactBody({required this.post, required this.onPhotoTap});

  final Post post;
  final ValueChanged<int>? onPhotoTap;

  @override
  Widget build(BuildContext context) {
    final Widget text = _TitleAndBody(post: post, expanded: false);
    if (post.photoKeys.isEmpty) return text;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // **첫 장만 그린다** — 목록에서 여러 장을 늘어놓으면 카드 높이가 장수에 따라
        // 출렁이고, 훑어보는 흐름이 끊긴다.
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 84,
            height: 84,
            child: PostPhoto(
              photoKey: post.photoKeys.first,
              onTap: onPhotoTap == null ? null : () => onPhotoTap!(0),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: text),
      ],
    );
  }
}

/// 상세의 본문 — 본문을 자르지 않고 사진을 **전부** 가로로 보여준다.
class _ExpandedBody extends StatelessWidget {
  const _ExpandedBody({required this.post, required this.onPhotoTap});

  final Post post;
  final ValueChanged<int>? onPhotoTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _TitleAndBody(post: post, expanded: true),
      if (post.photoKeys.isNotEmpty) ...<Widget>[
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: post.photoKeys.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (BuildContext context, int index) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 200,
                child: PostPhoto(
                  photoKey: post.photoKeys[index],
                  onTap: onPhotoTap == null ? null : () => onPhotoTap!(index),
                ),
              ),
            ),
          ),
        ),
      ],
    ],
  );
}

/// 굵은 제목 한 줄과 그 아래 본문.
///
/// 목록에서는 **본문을 잘라 ellipsis를 붙인다** — 카드 높이가 글 길이에 따라
/// 달라지면 목록을 훑는 리듬이 깨진다. 상세에서는 자르지 않는다.
class _TitleAndBody extends StatelessWidget {
  const _TitleAndBody({required this.post, required this.expanded});

  final Post post;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Text(
                post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // 수정 이력은 보관하지 않으므로 "수정됨" 표시만 붙인다(가이드 §5).
            if (post.edited) ...<Widget>[
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  l10n.communityEditedBadge,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          post.body,
          maxLines: expanded ? null : 2,
          overflow: expanded ? null : TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// 카드 하단 한 줄. **전부 우측 정렬이다** — 좌측은 사진 폭에 맞춰 비워 둔다.
///
/// 순서는 장소명 · 태그 · 상대시각 / 좋아요 · 댓글이다. 장소가 없으면(가이드 §5)
/// **장소 자리를 아예 그리지 않는다.**
class _FooterRow extends StatelessWidget {
  const _FooterRow({
    required this.post,
    required this.now,
    required this.showSpot,
    required this.onSpotTap,
    required this.onLike,
    required this.onComment,
  });

  final Post post;
  final DateTime now;
  final bool showSpot;
  final VoidCallback? onSpotTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextStyle? meta = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final bool hasSpot = showSpot && post.spot != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // 장소·태그·시각. 넘치면 줄바꿈한다 — 태그 수가 사용자마다 다르다.
        Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          runSpacing: 2,
          children: <Widget>[
            if (hasSpot)
              // 이름만 눌러도 장소 상세로 간다. 카드 전체 탭(글 상세)과 겹치지
              // 않도록 InkWell을 이름에만 씌운다.
              InkWell(
                onTap: onSpotTap,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    post.spot!.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: meta?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            // 태그는 **번역하지 않는다** — 사용자가 입력한 원문 그대로다(가이드 §9).
            for (final String tag in post.tags) Text('#$tag', style: meta),
            Text(relativePostTime(l10n, post.createdAt, now), style: meta),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // 조회수는 서버 `viewCount` 그대로다. **누를 수 없다** — 누를 수 있는
            // 댓글·좋아요보다 앞에 두어 탭 대상이 오른쪽에 모이게 한다.
            _Count(
              icon: Icons.visibility_outlined,
              color: theme.colorScheme.onSurfaceVariant,
              count: post.viewCount,
              semanticLabel: l10n.communityViewCountLabel(post.viewCount),
              onTap: null,
            ),
            const SizedBox(width: 4),
            // 댓글 수는 서버 `commentCount` 그대로 쓴다 — 목록 길이로 계산하지
            // 않는다(가이드 §6).
            _Count(
              icon: Icons.chat_bubble_outline_rounded,
              color: theme.colorScheme.onSurfaceVariant,
              count: post.commentCount,
              onTap: onComment,
            ),
            const SizedBox(width: 4),
            _Count(
              icon: post.likedByViewer ? Icons.favorite : Icons.favorite_border,
              color: post.likedByViewer
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              count: post.likeCount,
              onTap: onLike,
            ),
          ],
        ),
      ],
    );
  }
}

/// 하단의 수 하나. 터치 영역 ≥48dp.
class _Count extends StatelessWidget {
  const _Count({
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
    this.semanticLabel,
  });

  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback? onTap;

  /// 화면에는 숫자만 보이므로 스크린리더가 무엇의 수인지 알 수 있도록 붙인다.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget content = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                '$count',
                style: theme.textTheme.labelMedium?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
    return semanticLabel == null
        ? content
        : Semantics(
            label: semanticLabel,
            child: ExcludeSemantics(child: content),
          );
  }
}

/// 카드 우상단 오버플로. 신고·차단·수정·삭제 메뉴를 연다.
class _OptionsButton extends StatelessWidget {
  const _OptionsButton({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    visualDensity: VisualDensity.compact,
    iconSize: 20,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    icon: const Icon(Icons.more_vert),
  );
}

/// 카드 좌상단의 작성자와 카테고리. **둘 다 저강조다** — 당근이 닉네임과 게시판
/// 이름을 작게 두는 자리라 제목의 위계를 가리면 안 된다.
///
/// 닉네임이 길면 잘리고 카테고리는 그대로 남는다 — 카테고리는 폭이 정해진 값이지만
/// 닉네임은 사용자가 정하므로, 줄이 넘칠 때 양보해야 하는 쪽은 닉네임이다.
class _AuthorLine extends StatelessWidget {
  const _AuthorLine({required this.author, required this.category});

  final PostAuthor author;

  /// 이미 번역된 카테고리 문구. 서버가 모르는 값을 추가했으면 null이고, 그때는
  /// 닉네임만 남는다.
  final String? category;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? style = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _AuthorAvatar(author: author),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            author.nickname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        if (category != null) ...<Widget>[
          Text(' · ', style: style),
          Text(
            category!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ],
      ],
    );
  }
}

/// 작성자 아바타. **이미지가 없거나 실패해도 자리 크기가 같다** — 프로필 이미지는
/// nullable이고 개발 환경에서는 404가 정상이라(가이드 §4), 실패가 레이아웃을 밀면
/// 목록 전체가 들쭉날쭉해진다. [CircleAvatar]의 `foregroundImage`는 실패 시 child로
/// 떨어지므로 첫 글자가 그대로 남는다.
class _AuthorAvatar extends StatelessWidget {
  const _AuthorAvatar({required this.author});

  final PostAuthor author;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? url = author.profileImageUrl;
    return CircleAvatar(
      radius: 9,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      foregroundImage: (url == null || url.isEmpty) ? null : NetworkImage(url),
      child: Text(
        author.nickname.isEmpty ? '?' : author.nickname.characters.first,
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: 9,
          color: theme.colorScheme.onSurfaceVariant,
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
