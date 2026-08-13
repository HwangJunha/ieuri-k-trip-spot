import 'package:flutter/material.dart';

import '../../../common/widget/card_metrics.dart';
import '../../../common/widget/spot_thumbnail.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/distance.dart';
import '../model/tourist_spot.dart';
import 'spot_display.dart';

/// "Near you" 가로 스크롤 카드: 이미지 + 제목 + 위치 + 거리. 가로 리스트에
/// 놓이므로 폭이 고정이다.
///
/// 혼잡도 뱃지는 SPEC-0013에서 제거했다 — 서버에 소스가 없어 항상 같은 값을
/// 보여주고 있었다(R15). 그 자리를 서버가 실제로 주는 거리가 대신한다.
class SpotCard extends StatelessWidget {
  const SpotCard({super.key, required this.spot, required this.onTap});

  final TouristSpot spot;

  /// 카드를 누르면 호출된다. 이동은 화면이 맡는다 — `component`는 `view`를
  /// import하지 않는다(CLAUDE.md §3).
  final VoidCallback onTap;

  static const double width = 240;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Distance? distance = spot.distance;

    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CardMetrics.radius),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: CardMetrics.coverHeight,
                child: SpotThumbnail(
                  imageRef: spot.thumbnailImageUrl ?? spot.imageRef,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(CardMetrics.contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      spot.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: CardMetrics.titleGap),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            spot.location,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // 거리는 서버가 계산해 준 값이라 없을 수 있다 — 없으면 줄 자체를
                    // 렌더하지 않는다(빈 자리를 남기지 않는다).
                    if (distance != null) ...<Widget>[
                      const SizedBox(height: CardMetrics.sectionGap),
                      Text(
                        distanceLabel(l10n, distance),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
