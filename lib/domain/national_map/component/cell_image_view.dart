import 'package:flutter/material.dart';

import '../model/cell_image.dart';

/// 칸 대표 이미지와 출처 표기(R23·R24).
///
/// **저작권 유형이 렌더링을 가른다.** TYPE1은 크롭해 꽉 채우고, TYPE3·UNSPECIFIED는
/// 원본 비율을 지킨다 — 공공누리 제3유형의 "변경금지"가 형식의 변경까지 포함한다고
/// 읽히기 때문이다. UI 취향이 아니라 법적 제약이다(POL-051).
///
/// `attributionText`는 유형과 무관하게 **항상** 노출한다.
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
            child: Image.network(
              image.imageUrl,
              // 여기가 R23이다. 잘라도 되는지는 모델이 정한다.
              fit: image.allowsCrop ? BoxFit.cover : BoxFit.contain,
              errorBuilder: (_, _, _) => Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              loadingBuilder: (_, Widget child, ImageChunkEvent? progress) =>
                  progress == null
                  ? child
                  : const Center(child: CircularProgressIndicator()),
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
        const SizedBox(height: 4),
        // 유형과 무관하게 항상 노출한다(R24).
        Text(
          image.attributionText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
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
