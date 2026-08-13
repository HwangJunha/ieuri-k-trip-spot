import 'package:flutter/material.dart';

import '../../../common/widget/card_metrics.dart';
import '../../../common/widget/spot_thumbnail.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/liked_spot.dart';
import 'spot_display.dart';

/// 좋아요 목록의 항목 한 장(SPEC-0008 R-18).
///
/// 가로형 카드다 — 왼쪽 썸네일, 오른쪽에 제목·카테고리·주소. 스와이프 카드처럼
/// 전면 이미지로 만들지 않는 이유는 이 화면의 목적이 "훑어보고 고르는 것"이라
/// 한 화면에 여러 장이 보여야 하기 때문이다.
///
/// 이미지는 저작권 유형과 무관하게 [BoxFit.cover]다(스와이프 카드와 같은 규칙).
///
/// **썸네일에 출처 배지를 얹지 않는다.** 배지는 이미지에 박힌 것이 아니라 우리가
/// 오버레이한 위젯이었고, 목록은 훑어보는 화면이라 작은 썸네일마다 출처 문구가
/// 붙으면 제목·주소를 가린다. 출처는 카드를 눌러 들어간 상세 화면의
/// `AttributionBlock`이 전문으로 밝힌다.
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
      borderRadius: BorderRadius.circular(CardMetrics.radius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: CardMetrics.contentPadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Thumbnail(spot: spot),
            const SizedBox(width: CardMetrics.thumbnailGap),
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
                  const SizedBox(height: CardMetrics.titleGap),
                  Text(
                    spotCategoryLabel(l10n, spot.category),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  // 주소는 값이 있을 때만 — 빈 라벨을 그리지 않는다.
                  if (spot.address != null) ...<Widget>[
                    const SizedBox(height: CardMetrics.titleGap),
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

/// 카드 썸네일.
///
/// **공통 [SpotThumbnail]을 경유한다**(SPEC-0020 AC9.1·AC9.2). 예전에는 여기서
/// `Image.network`를 직접 부르고 실패하면 빈 색블록으로 떨어졌다 — 로딩 중에는
/// `loadingBuilder`가 없어 흰 칸이 번쩍였고, 실패 표현도 다른 카드와 달랐다.
/// 로딩·실패 표현은 공통 위젯 한 곳에서 정의한다.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.spot});

  final LikedSpot spot;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(CardMetrics.thumbnailRadius),
      child: SizedBox(
        width: CardMetrics.thumbnailSize,
        height: CardMetrics.thumbnailSize,
        child: SpotThumbnail(imageRef: spot.thumbnailImageUrl),
      ),
    );
  }
}
