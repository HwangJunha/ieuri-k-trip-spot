import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/liked_spot.dart';
import 'copyright_badge.dart';
import 'spot_display.dart';

/// 좋아요 목록의 항목 한 장(SPEC-0008 R-18).
///
/// 가로형 카드다 — 왼쪽 썸네일, 오른쪽에 제목·카테고리·주소. 스와이프 카드처럼
/// 전면 이미지로 만들지 않는 이유는 이 화면의 목적이 "훑어보고 고르는 것"이라
/// 한 화면에 여러 장이 보여야 하기 때문이다.
///
/// 이미지는 저작권 유형과 무관하게 [BoxFit.cover]다(스와이프 카드와 같은 규칙),
/// 저작권 표기는 [CopyrightBadge]로 최소 출처를 밝힌다.
class LikedSpotCard extends StatelessWidget {
  const LikedSpotCard({super.key, required this.spot, required this.onTap});

  final LikedSpot spot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Thumbnail(spot: spot),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    spot.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spotCategoryLabel(l10n, spot.category),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  // 주소는 값이 있을 때만 — 빈 라벨을 그리지 않는다.
                  if (spot.address != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      spot.address!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 카드 썸네일. 이미지 위에 최소 출처 배지를 얹는다.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.spot});

  final LikedSpot spot;

  bool get _isUrl => spot.thumbnailImageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 104,
        height: 104,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (_isUrl)
              Image.network(
                spot.thumbnailImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
              )
            else
              ColoredBox(color: theme.colorScheme.surfaceContainerHighest),
            Positioned(
              left: 4,
              right: 4,
              bottom: 4,
              child: CopyrightBadge(attributionText: spot.attributionText),
            ),
          ],
        ),
      ),
    );
  }
}
