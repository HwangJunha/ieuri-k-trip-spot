import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/feed_item.dart';
import 'feed_author_bar.dart';
import 'feed_like_button.dart';
import 'feed_photo_pager.dart';
import 'feed_spot_chip.dart';

/// 피드 한 장 — **화면 전체를 채운다**(R4).
///
/// 목록·그리드가 아니라 한 번에 한 건이 화면을 채우는 세로 전면 스크롤의 한 페이지다.
/// Discover 스와이프의 `SwipeCard`와 시각 언어를 공유한다(전면 이미지 + 하단 스크림
/// 텍스트) — 다른 것은 제스처뿐으로, 저쪽은 좌우 스와이프고 이쪽은 세로 스크롤이다.
///
/// **"N개 중 M번째" 표현이 어디에도 없다**(설계 §2). 서버가 총 개수를 주지 않으므로
/// 클라이언트가 추정하지 않는다. 사진 페이저의 점 인디케이터는 사진 배열 안의
/// 위치라 이 제약과 무관하다.
class FeedItemPage extends StatefulWidget {
  const FeedItemPage({
    super.key,
    required this.item,
    required this.now,
    required this.onLike,
    required this.onSpotTap,
    this.onMessage,
    this.onOptions,
  });

  final FeedItem item;

  /// 상대 시각 계산 기준. 페이지마다 `DateTime.now()`를 부르면 같은 화면 안에서
  /// 기준이 어긋난다.
  final DateTime now;

  final VoidCallback onLike;
  final VoidCallback onSpotTap;

  /// 작성자에게 대화 걸기. **내 글이면 null이다**(AC7-4).
  final VoidCallback? onMessage;

  final VoidCallback? onOptions;

  @override
  State<FeedItemPage> createState() => _FeedItemPageState();
}

class _FeedItemPageState extends State<FeedItemPage> {
  /// 본문을 펼쳤는지. 본문은 최대 500자라 전면 스크롤 화면에서 다 펼치면 사진이
  /// 거의 가려진다 — **접힌 상태가 기본이고** 사용자가 펼치면 스크림이 늘어난다.
  bool _expanded = false;

  /// 접힌 상태에서 보여줄 줄 수. 3줄이면 하단 스크림이 화면의 1/4을 넘지 않으면서
  /// 대부분의 글이 요지를 드러낸다.
  static const int _collapsedLines = 3;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final FeedItem item = widget.item;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FeedPhotoPager(photoKeys: item.photoKeys),
        // 상단 오버레이 — 작성자·시각·DM·오버플로.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: FeedAuthorBar(
            author: item.author,
            createdAt: item.createdAt,
            now: widget.now,
            onMessage: widget.onMessage,
            onOptions: widget.onOptions,
          ),
        ),
        // 우측 세로 좋아요. 하단 스크림 위로 올라오지 않게 아래 여백을 넉넉히 둔다.
        Positioned(
          right: 4,
          bottom: 160,
          child: FeedLikeButton(
            liked: item.likedByViewer,
            likeCount: item.likeCount,
            onTap: widget.onLike,
          ),
        ),
        // 하단 스크림 — 본문과 스팟 칩.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: <Color>[
                  theme.colorScheme.scrim.withValues(alpha: 0.75),
                  theme.colorScheme.scrim.withValues(alpha: 0),
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 48, 72, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FeedSpotChip(
                        spot: item.spot,
                        onTap: widget.onSpotTap,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.body,
                      maxLines: _expanded ? null : _collapsedLines,
                      overflow: _expanded ? null : TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    // 접힌 상태에서만 펼치기를 제안한다. 짧은 글에도 링크가 뜨지만
                    // 눌러도 달라지지 않을 뿐이고, 줄 수를 재려면 레이아웃을 두 번
                    // 계산해야 해서 얻는 것보다 비용이 크다.
                    if (!_expanded)
                      TextButton(
                        onPressed: () => setState(() => _expanded = true),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(l10n.feedShowMore),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
