import 'package:flutter/material.dart';

import '../../../common/model/post.dart';
import '../../../common/network/media_cdn.dart';
import '../../../common/widget/image_placeholder.dart';
import '../../../common/widget/network_photo.dart';
import '../../../common/widget/post_labels.dart';
import '../../../l10n/gen/app_localizations.dart';

/// "내가 쓴 글" 목록의 행 하나(SPEC-0011 R3, 디자인 §7).
///
/// ```
/// ┌──────────────────────────────────────────┐
/// │ FOOD · GWANGJANG MARKET                  │  ← 저강조·대문자 한 줄
/// │ Best Bindaetteok in Seoul!         ┌───┐ │  ← 굵은 제목
/// │ You can't miss the mung bean...    │사진│ │  ← 본문 2줄
/// │ ♡ 12   💬 4   2 days ago           └───┘ │  ← 메타 한 줄
/// └──────────────────────────────────────────┘
/// ```
///
/// **커뮤니티 [PostCard]와 다른 위젯이다.** 같은 [Post]를 그리지만 배치가 다르다 —
/// 여기는 전부 내 글이라 작성자 줄이 없고(같은 닉네임이 스무 번 반복될 뿐이다),
/// 대신 카테고리·장소가 맨 윗줄로 올라온다. 커뮤니티 컴포넌트를 import하면 기능 간
/// 의존이 되고(CLAUDE.md §3), 옵션으로 두 배치를 다 넣으면 카드가 분기투성이가 된다.
///
/// **납작하다** — 그림자 있는 Material 카드가 아니라 얇은 구분선으로만 나뉜다.
/// 구분선은 목록 쪽이 그린다.
///
/// **썸네일은 첫 장만, 없으면 영역을 접는다** — 빈 상자를 남기면 사진 있는 행과 없는
/// 행의 텍스트 폭이 어긋나 목록이 들쭉날쭉해진다.
class MyPostRow extends StatelessWidget {
  const MyPostRow({
    super.key,
    required this.post,
    required this.now,
    this.onTap,
  });

  final Post post;

  /// 상대 시각 계산 기준. 인자로 받아 테스트가 시간을 고정할 수 있게 한다.
  final DateTime now;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? heading = _heading(l10n);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 카테고리·장소. 서버가 모르는 카테고리를 줬고 장소도 없으면 이
                  // 줄 자체를 그리지 않는다 — 빈 줄이 남으면 제목 위가 떠 보인다.
                  if (heading != null) ...<Widget>[
                    Text(
                      heading,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _MetaLine(post: post, now: now),
                ],
              ),
            ),
            if (post.photoKeys.isNotEmpty) ...<Widget>[
              const SizedBox(width: 12),
              _Thumbnail(photoKey: post.photoKeys.first),
            ],
          ],
        ),
      ),
    );
  }

  /// "CATEGORY · PLACE" 한 줄. 둘 다 없으면 null이다.
  ///
  /// 대문자로 만드는 것은 **표시 계층의 장식이지 데이터가 아니다** — 서버 값이나
  /// 번역문을 대문자로 저장하지 않는다.
  String? _heading(AppLocalizations l10n) {
    final List<String> parts = <String>[
      if (post.category != null)
        targetCategoryLabel(l10n, post.category!).toUpperCase(),
      if (post.spot != null) post.spot!.title.toUpperCase(),
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }
}

/// 좋아요·댓글 수와 상대 시각. **읽기 전용이다** — 내 글 목록에서 좋아요를 누를 일이
/// 없어 탭 대상으로 만들지 않는다(누를 수 있어 보이면 눌러 보게 된다).
class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.post, required this.now});

  final Post post;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextStyle? style = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Row(
      children: <Widget>[
        Icon(
          Icons.favorite_border,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text('${post.likeCount}', style: style),
        const SizedBox(width: 12),
        Icon(
          Icons.chat_bubble_outline_rounded,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text('${post.commentCount}', style: style),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            relativePostTime(l10n, post.createdAt, now),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

/// 우측 썸네일. **키는 URL이 아니다** — CDN 조합은 `common/network`의 [MediaCdn]이
/// 한 곳에서 한다. 개발 환경 시드 키는 404가 정상이라 항상 플레이스홀더를 깔고 그
/// 위에 그린다.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.photoKey});

  final String photoKey;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ImagePlaceholder(imageRef: photoKey),
          NetworkPhoto(
            url: MediaCdn.urlFor(photoKey),
            fit: BoxFit.cover,
            // 72px 자리에 그린다 — 원본 해상도로 디코딩할 이유가 없다.
            decodeWidth: 72,
            // 404여도 아래 플레이스홀더가 그대로 남는다.
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    ),
  );
}
