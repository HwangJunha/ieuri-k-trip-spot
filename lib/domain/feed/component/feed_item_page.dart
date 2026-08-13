import 'package:flutter/material.dart';

import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/feed_item.dart';
import 'feed_action_rail.dart';
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

  /// 좋아요 버튼을 하단 스크림 텍스트 위로 얼마나 띄울지.
  ///
  /// 스크림 안의 스팟 칩·본문과 겹치지 않을 만큼 올린다. 아래로는 떠 있는
  /// 내비게이션 바가 지나가므로([FloatingBottomNavScaffold.barExtent]) 그 높이도
  /// 함께 피한다 — 셸이 `extendBody: true`라 이 화면의 body가 바 **아래까지**
  /// 그려지고, 보정하지 않으면 버튼이 바 뒤로 숨어 눌리지 않는다.
  ///
  /// **작성 버튼(FAB)보다 위에 온다.** 둘 다 우측 하단이라 이만큼 띄우지 않으면
  /// 서로 겹친다 — FAB(56) + 여백을 더한 값이다.
  ///
  /// 값이 [feedActionRailLift]에 있는 이유는 작성 버튼이 다른 파일에 있어서다 —
  /// 두 곳이 각자 숫자를 들면 한쪽만 고쳐질 때 조용히 겹친다.
  static const double _likeButtonLift = feedActionRailLift + 68;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final FeedItem item = widget.item;

    final TextStyle bodyStyle =
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          height: 1.35,
          shadows: overlayTextShadow,
        ) ??
        const TextStyle();

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FeedPhotoPager(
          photoKeys: item.photoKeys,
          // 사진 키가 404여도 같은 장소의 썸네일이 남는다 — 서버가 항상 준다.
          spotThumbnailUrl: item.spot.thumbnailImageUrl,
        ),
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
        // 하단 스크림 — 본문과 스팟 칩.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              // **약한 스크림이 본문을 못 읽게 하던 자리다.** 위쪽으로 곧장 0까지
              // 떨어지면 본문 첫 줄이 이미 밝은 사진 위에 놓인다. 바닥을 더
              // 진하게 잡고 중간 정지점을 둬 글자가 있는 구간까지 어둠을 끌고
              // 올라온다(디자인 §2).
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const <double>[0, 0.5, 1],
                colors: <Color>[
                  theme.colorScheme.scrim.withValues(alpha: 0.88),
                  theme.colorScheme.scrim.withValues(alpha: 0.5),
                  theme.colorScheme.scrim.withValues(alpha: 0),
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                // 우측 여백(72)은 세로로 선 좋아요 버튼 자리다.
                // 하단 여백은 떠 있는 내비 바를 피한다 — 없으면 본문 마지막 줄이
                // 바 뒤로 들어간다.
                padding: const EdgeInsets.fromLTRB(
                  16,
                  48,
                  72,
                  FloatingBottomNavScaffold.barExtent,
                ),
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
                    // **본문이 실제로 넘칠 때만 더보기를 그린다.** 예전에는 접혀
                    // 있기만 하면 항상 그려서, 한 줄짜리 글에도 눌러도 아무 일이
                    // 없는 "더보기"가 떴다. 폭을 알아야 줄 수를 셀 수 있으므로
                    // LayoutBuilder 안에서 TextPainter로 실측한다.
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints c) {
                        final bool overflows = _exceedsCollapsedLines(
                          text: item.body,
                          style: bodyStyle,
                          maxWidth: c.maxWidth,
                          textScaler: MediaQuery.textScalerOf(context),
                          direction: Directionality.of(context),
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              item.body,
                              maxLines: _expanded ? null : _collapsedLines,
                              overflow: _expanded
                                  ? null
                                  : TextOverflow.ellipsis,
                              style: bodyStyle,
                            ),
                            // 넘치지 않는 글에는 아예 그리지 않는다. 넘치는
                            // 글에서는 펼친 뒤 **접기로 되돌아갈 수 있다** —
                            // 한 번 펼치면 못 접던 것도 고친다.
                            if (overflows)
                              TextButton(
                                onPressed: () =>
                                    setState(() => _expanded = !_expanded),
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 32),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  _expanded
                                      ? l10n.feedShowLess
                                      : l10n.feedShowMore,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // **스크림보다 나중에 그린다.** 앞서는 스크림이 뒤에 칠해져 좋아요 버튼을
        // 덮었고, `Stack`의 히트 테스트는 위에 있는 것이 먼저 가져가므로 탭이
        // 전부 스크림에 삼켜졌다 — 버튼이 "동작하지 않는" 것처럼 보이던 원인이
        // provider가 아니라 이 순서였다.
        Positioned(
          right: 8,
          bottom:
              FloatingBottomNavScaffold.barExtent +
              MediaQuery.paddingOf(context).bottom +
              _likeButtonLift,
          child: FeedLikeButton(
            liked: item.likedByViewer,
            likeCount: item.likeCount,
            onTap: widget.onLike,
          ),
        ),
      ],
    );
  }

  /// 접힌 줄 수를 실제로 넘는지 [TextPainter]로 재 본다.
  ///
  /// 화면에 그리는 것과 **같은 style·폭·배율**로 재야 판정이 어긋나지 않는다 —
  /// 기본값으로 재면 큰 글씨 설정을 쓰는 사용자에게서 틀린다.
  bool _exceedsCollapsedLines({
    required String text,
    required TextStyle style,
    required double maxWidth,
    required TextScaler textScaler,
    required TextDirection direction,
  }) {
    if (maxWidth <= 0 || maxWidth == double.infinity) return false;
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: _collapsedLines,
      textDirection: direction,
      textScaler: textScaler,
    )..layout(maxWidth: maxWidth);
    final bool exceeded = painter.didExceedMaxLines;
    // TextPainter는 네이티브 자원을 쥔다 — 매 빌드마다 만들므로 반드시 놓아준다.
    painter.dispose();
    return exceeded;
  }
}
