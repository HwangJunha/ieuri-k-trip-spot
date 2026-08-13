import 'package:flutter/material.dart';

import '../../../common/network/media_cdn.dart';
import '../../../l10n/gen/app_localizations.dart';

/// 피드 한 장의 사진 페이저(1~5장). 배열 순서가 표시 순서다.
///
/// **가로 페이저다 — 세로는 다음 피드 항목이 쓴다**(디자인 §2). 두 제스처 축을
/// 분리해야 사진 넘기기와 다음 글 넘기기가 서로 삼키지 않는다.
///
/// **한 장이면 인디케이터를 아예 그리지 않는다** — 점 하나는 정보가 없고, 자리만
/// 차지해 사진을 가린다.
///
/// 커뮤니티의 `PostPhoto`와 같은 규칙을 따른다: 키는 URL이 아니라 [MediaCdn]이
/// 조합하고, 개발 환경 시드 키는 404가 정상이다. 여기서 `PostPhoto`를 직접 부르지
/// 않는 이유는 하나다 — 전면 스크롤은 `BoxFit.cover`로 화면을 채워야 하고 목록
/// 썸네일과 요구가 다르다.
///
/// **사진이 깨져도 밝은 빈 화면을 두지 않는다.** 이 화면의 글자는 전부 흰색이라
/// (스크림 위 오버레이) 배경이 밝은 회색으로 남으면 작성자 이름도 본문도 읽히지
/// 않는다 — 실제로 개발 시드 키가 404일 때 그렇게 보였다. 그래서 폴백이 세 단계다:
///
/// 1. 사진 키 → CDN
/// 2. 실패하면 **연결된 스팟 썸네일**([spotThumbnailUrl]) — 서버가 항상 준다
/// 3. 그것도 실패하면 **어두운** 자리채움 + 아이콘
class FeedPhotoPager extends StatefulWidget {
  const FeedPhotoPager({
    super.key,
    required this.photoKeys,
    this.spotThumbnailUrl,
  });

  final List<String> photoKeys;

  /// 연결된 스팟의 썸네일 URL. 사진이 깨졌을 때 대신 깐다 — 같은 장소의 사진이라
  /// 내용상으로도 어긋나지 않는다.
  final String? spotThumbnailUrl;

  @override
  State<FeedPhotoPager> createState() => _FeedPhotoPagerState();
}

class _FeedPhotoPagerState extends State<FeedPhotoPager> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> keys = widget.photoKeys;
    if (keys.isEmpty) {
      // 서버 계약상 1장 이상이지만(R2) 빈 배열이 와도 화면이 터지지 않게 둔다.
      // **투명이 아니라 스팟 썸네일·어두운 자리채움으로 떨어진다** — 투명하면 뒤에
      // 아무것도 없어 흰 글자가 그대로 사라진다.
      return _FeedPhoto(
        photoKey: null,
        spotThumbnailUrl: widget.spotThumbnailUrl,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        PageView.builder(
          controller: _controller,
          itemCount: keys.length,
          onPageChanged: (int next) => setState(() => _index = next),
          itemBuilder: (BuildContext context, int index) => _FeedPhoto(
            photoKey: keys[index],
            spotThumbnailUrl: widget.spotThumbnailUrl,
          ),
        ),
        if (keys.length > 1)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: _DotIndicator(count: keys.length, current: _index),
            ),
          ),
      ],
    );
  }
}

/// 사진 한 장 — **어떤 경우에도 어두운 배경이 남는다.**
///
/// 맨 아래에 어두운 자리채움을 깔고 그 위에 스팟 썸네일, 다시 그 위에 실제 사진을
/// 얹는다. 위쪽이 실패하면 아래가 그대로 드러나므로 실패해도 흰 화면이 되지 않고,
/// 오버레이 흰 글자가 계속 읽힌다.
class _FeedPhoto extends StatelessWidget {
  const _FeedPhoto({required this.photoKey, required this.spotThumbnailUrl});

  /// 사진 키. null이면 사진 자체가 없는 것이라 스팟 썸네일부터 시작한다.
  final String? photoKey;

  final String? spotThumbnailUrl;

  @override
  Widget build(BuildContext context) {
    final String? key = photoKey;
    final String? thumb = spotThumbnailUrl;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const _DarkPlaceholder(),
        // 2단계 폴백 — 서버가 스팟 썸네일은 항상 준다. 사진 키가 404여도 같은
        // 장소의 사진이 남으므로 화면이 비지 않는다.
        if (thumb != null && thumb.isNotEmpty)
          Image.network(
            thumb,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        if (key != null)
          Image.network(
            MediaCdn.urlFor(key),
            fit: BoxFit.cover,
            // **받는 동안 빈 화면을 두지 않는다.** 프레임이 null이면 아직
            // 디코드 전이라 아래 폴백이 보여야 하는데, 위젯을 그대로 두면
            // 투명 자리만 남아 아래가 가려진 것처럼 보인다.
            loadingBuilder:
                (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? progress,
                ) => progress == null ? child : const SizedBox.shrink(),
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
      ],
    );
  }
}

/// 사진이 없거나 다 실패했을 때 남는 바닥.
///
/// **밝은 표면색을 쓰지 않는다.** 이 위에 얹히는 글자가 전부 흰색이라 밝은 회색을
/// 깔면 글자가 사라진다 — 화면이 "비었다"가 아니라 "고장 났다"로 보이던 원인이다.
class _DarkPlaceholder extends StatelessWidget {
  const _DarkPlaceholder();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // 라이트 테마에서도 어두워야 하므로 표면색이 아니라 scrim 계열을 쓴다.
    final Color base = Color.lerp(
      theme.colorScheme.scrim,
      theme.colorScheme.surfaceContainerHighest,
      0.18,
    )!;
    return ColoredBox(
      color: base,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          // 배경이 어두우니 아이콘은 밝은 쪽에서 흐리게 — 존재는 알리되 시선을
          // 끌지 않는다.
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}

/// 사진 배열 안의 현재 위치를 알리는 점 줄.
///
/// **피드 항목의 총 개수와 무관하다**(설계 §2의 "N개 중 M번째 금지"는 피드 항목에
/// 대한 제약이다). 여기 점은 이 글에 붙은 사진 배열 안의 위치이며, 그 배열 길이는
/// 이미 클라이언트가 다 알고 있다.
class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.feedPhotoIndicatorLabel(current + 1, count),
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < count; i++)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // 사진 위라 대비가 필요하다 — 밝은 사진에서도 보이도록 현재
                    // 점만 불투명하게 둔다.
                    color: i == current
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onPrimary.withValues(alpha: 0.4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
