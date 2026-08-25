import 'package:flutter/material.dart';

import '../../../common/widget/image_placeholder.dart';
import '../../../common/widget/network_photo.dart';
import '../model/copyright_type.dart';
import '../model/spot_image.dart';
import '../model/swipe_card_display.dart';
import 'blur_backdrop.dart';

/// 상세 헤더 갤러리(SPEC-0003 §3). [images]를 가로 페이저로 보여준다.
///
/// 이미지 위에는 저작권 배지를 얹지 않는다 — 사진을 가려 거슬리는 데다, 저작권 표기는
/// 갤러리 아래 `AttributionBlock`이 전문으로 노출하므로 중복이다(AC-28 충족).
///
/// [images]가 비면(갤러리 빈 배열) [fallbackImageUrl](=thumbnailImageUrl)로 한 장짜리
/// 폴백을 렌더한다(AC-27).
///
/// **첫 장은 언제나 [fallbackImageUrl](=리스트에서 보던 썸네일)이다**(SPEC-0006 R8).
/// 갤러리에 그 URL이 없으면 맨 앞에 끼워 넣는다 — 그러지 않으면 조회가 끝나는 순간
/// 첫 이미지가 `gallery[0]`으로 바뀌며 깜빡이고, 갤러리 보유 여부가 카테고리마다
/// 달라 "전체보기에서만 자연스럽다"는 불일치로 드러난다.
///
/// **크롭 렌더링은 저작권 유형이 가른다**(SPEC-0025 R13). 오래 `[TBD-1]` 확정 전까지
/// [BoxFit.cover]로 두었으나, 그 분기가 확정되면서 스와이프 카드와 같은 규칙을 쓴다 —
/// TYPE1만 채우고 TYPE3·미지정은 잘리지 않게 넣는다.
///
/// 실제로 행사 포스터의 제목이 위쪽에서 잘려 나갔다(사용자 지적 2026-08-18). 포스터는
/// 세로로 길고 글자가 가장자리까지 차 있어 크롭에 가장 취약하다.
class SpotGallery extends StatefulWidget {
  const SpotGallery({
    super.key,
    required this.images,
    required this.fallbackImageUrl,
    this.fallbackCopyright,
  });

  final List<SpotImage> images;
  final String fallbackImageUrl;

  /// 첫 장([fallbackImageUrl])의 저작권 유형.
  ///
  /// 그 URL은 리스트에서 넘어온 썸네일이라 [images] 안에 없을 수 있고, 그때는 이
  /// 값이 유일한 근거다. 모르면 **크롭하지 않는다** — 변형해도 되는지 모르는 이미지를
  /// 자르는 것보다 여백을 남기는 편이 안전하다.
  final CopyrightType? fallbackCopyright;

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

  /// 실제로 그릴 이미지 목록. 첫 장은 항상 리스트에서 보던 썸네일이고, 서버
  /// 갤러리가 같은 URL을 이미 갖고 있으면 중복으로 넣지 않는다(순서만 앞으로 당긴다).
  ///
  /// **URL만 나르면 저작권 유형이 소실된다** — 맞춤 방식이 그것에 달렸으므로 함께
  /// 들고 다닌다.
  List<_GalleryEntry> get _entries {
    final String first = widget.fallbackImageUrl;

    // 첫 장의 저작권은 갤러리에 같은 URL이 있으면 그쪽을, 없으면 호출부가 준 값을
    // 쓴다. 둘 다 없으면 안전하게 크롭하지 않는다.
    final CopyrightType? firstCopyright = widget.images
        .where((SpotImage image) => image.imageUrl == first)
        .map((SpotImage image) => image.copyright)
        .firstOrNull;

    return <_GalleryEntry>[
      _GalleryEntry(
        imageRef: first,
        copyright: firstCopyright ?? widget.fallbackCopyright,
      ),
      for (final SpotImage image in widget.images)
        if (image.imageUrl != first)
          _GalleryEntry(
            imageRef: image.imageUrl,
            copyright: image.copyright,
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<_GalleryEntry> entries = _entries;
    final int pageCount = entries.length;

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PageView.builder(
            controller: _controller,
            itemCount: pageCount,
            onPageChanged: (int i) => setState(() => _index = i),
            // 이미지 위에는 아무것도 얹지 않는다 — 저작권 표기는 사진을 가리지 않게
            // 갤러리 아래 [AttributionBlock]이 전담한다(AC-28은 전문 노출이 요건이라
            // 배지 중복 없이 충족된다).
            itemBuilder: (BuildContext context, int i) =>
                _GalleryImage(entry: entries[i]),
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

/// 갤러리에 그릴 이미지 한 장의 명세 — URL과 그 이미지의 저작권 유형.
class _GalleryEntry {
  const _GalleryEntry({required this.imageRef, required this.copyright});

  final String imageRef;

  /// 이미지별 저작권 유형. 모르면 null이고, 그때는 크롭하지 않는다.
  final CopyrightType? copyright;

  /// 이 이미지를 어떻게 맞출 것인가. **스와이프 카드와 같은 규칙을 쓴다**(R13) —
  /// 같은 사진이 화면에 따라 다르게 잘리면 안 된다.
  SwipeCardFit get fit => SwipeCardDisplay.fitFor(copyright);
}

/// 갤러리 이미지 한 장. 네트워크 URL이면 [Image.network](로딩·실패 시 색블록 폴백),
/// 아니면 색블록 플레이스홀더를 렌더한다(스와이프 카드와 동일 규칙).
class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.entry});

  final _GalleryEntry entry;

  bool get _isUrl => entry.imageRef.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (!_isUrl) return ImagePlaceholder(imageRef: entry.imageRef);

    final Widget image = NetworkPhoto(
      url: entry.imageRef,
      // TYPE1만 채운다. 나머지는 잘리지 않게 넣는다(R13) — 포스터 제목이 위에서
      // 잘려 나가던 자리다.
      fit: entry.fit == SwipeCardFit.cover ? BoxFit.cover : BoxFit.contain,
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent? p) =>
              p == null ? child : ImagePlaceholder(imageRef: entry.imageRef),
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) =>
          ImagePlaceholder(imageRef: entry.imageRef),
    );

    if (!entry.fit.needsBlurBackdrop) return image;

    // 잘리지 않게 넣으면 여백이 생긴다. 스와이프 카드와 같이 **같은 사진의 블러본**으로
    // 채운다 — 원본은 위에 온전히 얹히므로 변형이 아니다(SPEC-0002 §4.7).
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BlurBackdrop(imageRef: entry.imageRef),
        image,
      ],
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
