import 'package:flutter/material.dart';

import '../../../common/widget/spot_thumbnail.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/distance.dart';
import '../model/popular_spot.dart';
import '../model/tourist_spot.dart';
import 'spot_display.dart';

/// "Popular" 세로 리스트 행: 이미지 + 제목 + 위치 + 거리.
///
/// [SpotCard]와 배치가 다르다 — 이쪽은 가로로 긴 행이고 저쪽은 가로 스크롤용 고정
/// 폭 카드다. 하나로 합치지 않은 이유가 여기서 드러난다: **이 행만 랭킹 근거
/// (`likeCount`)를 보여준다**(R18). 순위를 매긴 목록에서 "왜 이 순서인가"가 보이지
/// 않으면 사용자는 근거를 알 수 없다.
///
/// 별점과 혼잡도는 SPEC-0013에서 제거했다 — 서버에 소스가 없는 값이었다(R15).
class PopularSpotCard extends StatelessWidget {
  const PopularSpotCard({
    super.key,
    required this.popular,
    required this.onTap,
  });

  final PopularSpot popular;

  /// 카드를 누르면 호출된다. 이동은 화면이 맡는다 — `component`는 `view`를
  /// import하지 않는다(CLAUDE.md §3).
  final VoidCallback onTap;

  TouristSpot get spot => popular.spot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Distance? distance = spot.distance;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // IntrinsicHeight lets the image column stretch to match the text
      // column's natural height without an unbounded-height Row.
      //
      // **`InkWell`은 `IntrinsicHeight` 안쪽이어야 한다.** 바깥에 두면 intrinsic
      // 높이를 재는 과정에서 무한 제약이 흘러 `height.isFinite` 단언이 깨진다
      // (썸네일이 `height: double.infinity`를 쓰기 때문). 실제로 그렇게 만들었다가
      // 카드가 렌더되지 않았다.
      child: IntrinsicHeight(
        child: InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                width: 96,
                child: SpotThumbnail(
                  imageRef: spot.thumbnailImageUrl ?? spot.imageRef,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        spot.name,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        spot.location,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // 좋아요 수와 거리를 한 줄에 둔다. 좋아요는 **랭킹 근거라
                      // 항상 보이고**(R18), 거리는 서버 계산값이라 없을 수 있다.
                      Text(
                        distance == null
                            ? l10n.popularLikeCount(popular.likeCount)
                            : '${l10n.popularLikeCount(popular.likeCount)}'
                                  ' · ${distanceLabel(l10n, distance)}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
