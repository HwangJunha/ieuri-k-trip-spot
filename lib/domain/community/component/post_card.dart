import 'package:flutter/material.dart';

import '../../../common/network/media_cdn.dart';
import '../../../common/widget/image_placeholder.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/post.dart';
import '../model/post_body_split.dart';
import '../model/post_topic.dart';
import 'post_topic_label.dart';

/// 피드 항목 하나 — **당근 동네생활 카드 배치**를 따른다.
///
/// ```
/// ┌──────────────────────────────────────────┐
/// │ 주제 태그(저강조)                  [⋮]  │  ← 태그가 맨 위, 우상단에 오버플로
/// │ 제목 줄 (굵게)                           │
/// │ 본문 2줄, 넘치면 ellipsis                │
/// │ [사진]                                   │
/// │ 스팟명 · 3시간 전        ♡ 12  💬 4      │  ← 좌: 위치+시각, 우: 좋아요·댓글
/// └──────────────────────────────────────────┘
/// ```
///
/// 당근 카드는 **납작하다** — 그림자 있는 Material 카드가 아니라 얇은 구분선으로만
/// 나뉘고 세로 여백이 넉넉하다. 그래서 [Card]도 [Material] elevation도 쓰지 않고
/// 구분선은 목록 쪽(`_FeedList`)이 그린다.
///
/// **제목은 서버 필드가 아니다.** `Post`에는 `body`만 있어 [splitPostBody]가 본문에서
/// 첫 문장을 떼어 제목 자리에 놓는다 — 서버에 `title`이 생기면 그 함수와 여기 두 줄만
/// 바꾸면 된다(자세한 내용은 `model/post_body_split.dart`).
///
/// **작성자를 눌러도 이동할 곳이 없다** — 프로필 화면이 비범위라 닉네임은 표시조차
/// 하지 않는다: 당근 카드도 목록에서 작성자를 보여주지 않는다(설계 §6).
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
    this.onOptions,
    this.showTarget = true,
    this.expanded = false,
  });

  final Post post;

  /// 상대 시각 계산 기준. 인자로 받아 테스트가 시간을 고정할 수 있게 한다.
  final DateTime now;

  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onTargetTap;

  /// 우상단 오버플로 — 차단·신고·삭제 시트를 연다. null이면 버튼을 그리지 않는다.
  ///
  /// **미인증이라고 해서 null로 넘기지 않는다**(가이드 §13, 디자인 §7). 감추면
  /// 기능이 없는 것처럼 보이므로, 눌렀을 때 로그인으로 유도하는 쪽을 택한다.
  final VoidCallback? onOptions;

  /// 대상 이름 표시 여부. spot 상세 안의 피드에서는 false다 — 이미 그 spot의
  /// 화면이라 같은 이름을 두 번 보여줄 이유가 없다(디자인 §2).
  final bool showTarget;

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 상세에서는 본문을 자르지 않으므로 제목/본문으로 가르지 않는다 — 원문 그대로
    // 읽히는 편이 낫다.
    final PostBodySplit split = expanded
        ? PostBodySplit(title: '', rest: post.body)
        : splitPostBody(post.body);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 맨 위 줄: 저강조 태그(당근의 "동네질문" 자리) + 우상단 오버플로.
            Row(
              children: <Widget>[
                if (post.topic != null)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _TopicTag(
                        label: postTopicLabel(l10n, post.topic!),
                      ),
                    ),
                  )
                else
                  const Spacer(),
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
            // 제목 줄. 본문에서 갈라낼 수 없으면 비어 있고, 그때는 본문만 그린다.
            if (split.title.isNotEmpty) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                split.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            if (split.rest.isNotEmpty) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                split.rest,
                maxLines: expanded ? null : 2,
                overflow: expanded ? null : TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            // 사진이 없으면 자리를 비워두지 않고 **영역 자체를 렌더하지 않는다**
            // (디자인 §1). 시드 키는 404가 정상이라 실패해도 레이아웃이 유지된다.
            if (post.photoKeys.isNotEmpty) ...<Widget>[
              const SizedBox(height: 10),
              _Photos(photoKeys: post.photoKeys, expanded: expanded),
            ],
            const SizedBox(height: 10),
            _FooterRow(
              post: post,
              now: now,
              showTarget: showTarget,
              onTargetTap: onTargetTap,
              onLike: onLike,
              onComment: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

/// 카드 하단 한 줄. **좌측은 장소 이름 + 상대 시각**(당근의 "신림동 · 3시간 전"
/// 자리에 spot 이름을 넣는다), **우측은 좋아요 수와 댓글 수**다.
class _FooterRow extends StatelessWidget {
  const _FooterRow({
    required this.post,
    required this.now,
    required this.showTarget,
    required this.onTargetTap,
    required this.onLike,
    required this.onComment,
  });

  final Post post;
  final DateTime now;
  final bool showTarget;
  final VoidCallback? onTargetTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextStyle? meta = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              if (showTarget) ...<Widget>[
                // 이름만 눌러도 대상 상세로 간다. 카드 전체 탭(글 상세)과 겹치지
                // 않도록 InkWell을 이름에만 씌운다.
                Flexible(
                  child: InkWell(
                    onTap: post.target.type == PostTargetType.spot
                        ? onTargetTap
                        : null,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        post.target.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: meta?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Text(' · ', style: meta),
              ],
              Text(relativePostTime(l10n, post.createdAt, now), style: meta),
            ],
          ),
        ),
        // 우측: 좋아요 수와 댓글 수. 댓글 수는 서버 `commentCount` 그대로 쓴다 —
        // 목록 길이로 계산하지 않는다(가이드 §6).
        _Count(
          icon: post.likedByViewer ? Icons.favorite : Icons.favorite_border,
          color: post.likedByViewer
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          count: post.likeCount,
          onTap: onLike,
        ),
        const SizedBox(width: 4),
        _Count(
          icon: Icons.chat_bubble_outline_rounded,
          color: theme.colorScheme.onSurfaceVariant,
          count: post.commentCount,
          onTap: onComment,
        ),
      ],
    );
  }
}

/// 하단 우측의 수 하나. 터치 영역 ≥48dp(디자인 §1).
///
/// **미인증이어도 감추지 않는다** — 눌렀을 때 로그인으로 유도한다(R17).
class _Count extends StatelessWidget {
  const _Count({
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
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
  }
}

/// 카드 우상단 오버플로. 차단·신고·삭제 시트를 연다.
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

/// 카드 맨 위의 주제 태그. **저강조다** — 당근이 게시판 이름을 작게 두는 자리라
/// 본문 위계를 가리면 안 된다.
class _TopicTag extends StatelessWidget {
  const _TopicTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
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
