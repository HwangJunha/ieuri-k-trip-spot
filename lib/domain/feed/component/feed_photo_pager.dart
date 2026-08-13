import 'package:flutter/material.dart';

import '../../../common/network/media_cdn.dart';
import '../../../common/widget/image_placeholder.dart';
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
/// 조합하고, 개발 환경 시드 키는 404가 정상이라 항상 플레이스홀더를 깔고 그 위에
/// 이미지를 얹는다. 여기서 `PostPhoto`를 직접 부르지 않는 이유는 하나다 — 전면
/// 스크롤은 `BoxFit.cover`로 화면을 채워야 하고 목록 썸네일과 요구가 다르다.
class FeedPhotoPager extends StatefulWidget {
  const FeedPhotoPager({super.key, required this.photoKeys});

  final List<String> photoKeys;

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
      return const ColoredBox(color: Colors.transparent);
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        PageView.builder(
          controller: _controller,
          itemCount: keys.length,
          onPageChanged: (int next) => setState(() => _index = next),
          itemBuilder: (BuildContext context, int index) =>
              _FeedPhoto(photoKey: keys[index]),
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

/// 사진 한 장. 실패해도 아래 플레이스홀더가 남아 레이아웃이 무너지지 않는다.
class _FeedPhoto extends StatelessWidget {
  const _FeedPhoto({required this.photoKey});

  final String photoKey;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: <Widget>[
      ImagePlaceholder(imageRef: photoKey),
      Image.network(
        MediaCdn.urlFor(photoKey),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      ),
    ],
  );
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
