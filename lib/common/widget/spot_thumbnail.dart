import 'package:flutter/material.dart';

import 'image_placeholder.dart';

/// 서버 썸네일 URL을 그리고, URL이 아니거나 로딩·실패면 색블록으로 폴백한다.
///
/// 같은 폴백 규칙(URL 판별 → 로딩 중 색블록 → 실패 시 색블록)이 스와이프 카드·홈
/// 카드·검색 결과에 반복되므로 `common/widget`에 둔다(CLAUDE.md §4). 폴백을 각자
/// 구현하면 한 화면만 흰 칸이 되는 식으로 어긋난다.
class SpotThumbnail extends StatelessWidget {
  const SpotThumbnail({
    super.key,
    required this.imageRef,
    this.fit = BoxFit.cover,
  });

  /// 서버가 준 썸네일 URL(http). 값이 URL이 아니면 색블록 플레이스홀더로 폴백한다.
  final String imageRef;

  final BoxFit fit;

  bool get _isUrl => imageRef.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (!_isUrl) return ImagePlaceholder(imageRef: imageRef);
    // **`width`/`height`에 `double.infinity`를 주지 않는다.** 그 값은 intrinsic
    // 크기 질의에 그대로 무한으로 답해, `IntrinsicHeight` 안에 놓이면
    // `height.isFinite` 단언이 깨진다(Popular 카드가 그 구조다 — 실제로 카드가
    // 렌더되지 않았다). `fit`만으로 부모가 준 제약을 채운다.
    return Image.network(
      imageRef,
      fit: fit,
      // 로딩 중에는 색블록을 보여준다(빈 흰 칸 방지).
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent? progress) =>
              progress == null ? child : ImagePlaceholder(imageRef: imageRef),
      // 깨진 URL·오프라인이어도 크래시 없이 폴백.
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) =>
          ImagePlaceholder(imageRef: imageRef),
    );
  }
}
