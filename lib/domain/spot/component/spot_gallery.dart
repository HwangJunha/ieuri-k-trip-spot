import 'package:flutter/material.dart';

import '../../../common/widget/image_placeholder.dart';
import '../model/spot_image.dart';

/// 상세 헤더 갤러리(SPEC-0003 §3). [images]를 가로 페이저로 보여준다.
///
/// 이미지 위에는 저작권 배지를 얹지 않는다 — 사진을 가려 거슬리는 데다, 저작권 표기는
/// 갤러리 아래 `AttributionBlock`이 전문으로 노출하므로 중복이다(AC-28 충족).
///
/// [images]가 비면(갤러리 빈 배열) [fallbackImageUrl](=thumbnailImageUrl)로 한 장짜리
/// 폴백을 렌더한다(AC-27).
///
/// 크롭 렌더링은 저작권 유형별 분기(`[TBD-1]`) 확정 전까지 SPEC-0002와 일관되게
/// [BoxFit.cover]로 둔다(§7).
class SpotGallery extends StatefulWidget {
  const SpotGallery({
    super.key,
    required this.images,
    required this.fallbackImageUrl,
  });

  final List<SpotImage> images;
  final String fallbackImageUrl;

  @override
  State<SpotGallery> createState() => _SpotGalleryState();
}

class _SpotGalleryState extends State<SpotGallery> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasGallery = widget.images.isNotEmpty;
    final int pageCount = hasGallery ? widget.images.length : 1;

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PageView.builder(
            controller: _controller,
            itemCount: pageCount,
            onPageChanged: (int i) => setState(() => _index = i),
            itemBuilder: (BuildContext context, int i) {
              if (!hasGallery) {
                return _GalleryImage(imageRef: widget.fallbackImageUrl);
              }
              // 이미지 위에는 아무것도 얹지 않는다 — 저작권 표기는 사진을 가리지 않게
              // 갤러리 아래 [AttributionBlock]이 전담한다(AC-28은 전문 노출이 요건이라
              // 배지 중복 없이 충족된다).
              return _GalleryImage(imageRef: widget.images[i].imageUrl);
            },
          ),
          // 페이지 인디케이터: 2장 이상일 때만.
          if (pageCount > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: _PageDots(count: pageCount, index: _index),
            ),
        ],
      ),
    );
  }
}

/// 갤러리 이미지 한 장. 네트워크 URL이면 [Image.network](로딩·실패 시 색블록 폴백),
/// 아니면 색블록 플레이스홀더를 렌더한다(스와이프 카드와 동일 규칙).
class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.imageRef});

  final String imageRef;

  bool get _isUrl => imageRef.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (!_isUrl) return ImagePlaceholder(imageRef: imageRef);
    return Image.network(
      imageRef,
      fit: BoxFit.cover,
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent? p) =>
              p == null ? child : ImagePlaceholder(imageRef: imageRef),
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) =>
          ImagePlaceholder(imageRef: imageRef),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (int i) {
        final bool active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 10 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white54,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
