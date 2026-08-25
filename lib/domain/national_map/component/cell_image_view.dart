import 'package:flutter/material.dart';

import '../../../common/widget/image_placeholder.dart';
import '../../../common/widget/network_photo.dart';
import '../model/cell_image.dart';

/// 칸 대표 이미지와 출처 표기(R23·R24).
///
/// **저작권 유형이 렌더링을 가른다.** TYPE1은 크롭해 꽉 채우고, TYPE3·UNSPECIFIED는
/// 원본 비율을 지킨다 — 공공누리 제3유형의 "변경금지"가 형식의 변경까지 포함한다고
/// 읽히기 때문이다. UI 취향이 아니라 법적 제약이다(POL-051).
///
/// 출처는 **확인된 것만** 노출한다 — UNSPECIFIED 이거나 값이 비어 있으면
/// 표기하지 않는다([CellImage.showsAttribution]).
class CellImageView extends StatelessWidget {
  const CellImageView({required this.image, this.height = 200, super.key});

  final CellImage image;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: height,
            width: double.infinity,
            color: theme.colorScheme.surfaceContainerHighest,
            child: NetworkPhoto(
              url: image.imageUrl,
              // 여기가 R23이다. 잘라도 되는지는 모델이 정한다.
              fit: image.allowsCrop ? BoxFit.cover : BoxFit.contain,
              errorBuilder: (_, _, _) => Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              // **스피너가 아니라 색블록이다.** 앱의 다른 모든 이미지가
              // `ImagePlaceholder`로 폴백하는데 여기만 스피너였다 — 사진 자리에
              // 스피너가 돌면 로딩 모양이 화면마다 달라 보인다.
              loadingBuilder: (_, Widget child, ImageChunkEvent? progress) =>
                  progress == null
                  ? child
                  : ImagePlaceholder(imageRef: image.imageUrl),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            _KindBadge(kind: image.kind),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                image.caption,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        // 출처는 **확인된 것만** 적는다 — 판단은 모델이 한다
        // ([CellImage.showsAttribution]). 빈 Text 를 그리면 아래 여백만
        // 남아 레이아웃이 어긋나므로 줄 자체를 두지 않는다.
        if (image.showsAttribution) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            image.attributionText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _KindBadge extends StatelessWidget {
  const _KindBadge({required this.kind});

  final CellImageKind kind;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool landmark = kind == CellImageKind.landmark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: landmark
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Icon(
        landmark ? Icons.account_balance_outlined : Icons.local_florist_outlined,
        size: 14,
        color: landmark
            ? theme.colorScheme.onSecondaryContainer
            : theme.colorScheme.onTertiaryContainer,
      ),
    );
  }
}
