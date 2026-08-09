import 'package:flutter/material.dart';

import '../../../common/pagination/pagination_list_view.dart';
import '../../../common/widget/highlighted_text.dart';
import '../../../common/widget/spot_thumbnail.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/distance.dart';
import '../model/spot_search_result.dart';
import '../model/tourist_spot.dart';
import 'spot_display.dart';

/// 검색 결과 목록(AC-11.1·AC-13.1·R7).
///
/// 서버가 BM25 관련도를 거리로 가중해 정렬해 주므로 **클라이언트는 재정렬하지
/// 않는다**(POL-019 — 정렬은 계약이다).
///
/// 페이징은 공용 [PaginationListView]가 맡는다 — 기능이 자기 페이지네이션을
/// 만들지 않는다(CLAUDE.md §4). 이 위젯은 바닥 근처에서 [onLoadMore]를 여러 번
/// 부를 수 있고, 중복을 거르는 것은 notifier 몫이다.
///
/// 이동은 [onSelect]로 화면에 맡긴다 — `component`는 `view`를 import하지 않는다
/// (CLAUDE.md §3).
class SearchResultList extends StatelessWidget {
  const SearchResultList({
    super.key,
    required this.result,
    required this.query,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onSelect,
  });

  final SpotSearchResult result;

  /// 강조에 쓸 질의. 결과에 실린 것과 같은 문자열이다.
  final String query;

  /// 다음 페이지를 받는 중인지 — 목록 끝에 인디케이터 한 칸이 붙는다.
  final bool isLoadingMore;

  final VoidCallback onLoadMore;

  /// 결과를 선택했을 때 호출된다(AC-13.1). 화면이 상세 라우트로 보낸다.
  final void Function(TouristSpot spot) onSelect;

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      itemCount: result.spots.length,
      hasMore: result.hasNextPage,
      isLoadingMore: isLoadingMore,
      onLoadMore: onLoadMore,
      itemBuilder: (BuildContext context, int index) =>
          _ResultTile(spot: result.spots[index], query: query, onTap: onSelect),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.spot,
    required this.query,
    required this.onTap,
  });

  final TouristSpot spot;
  final String query;
  final void Function(TouristSpot spot) onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Distance? distance = spot.distance;

    return ListTile(
      leading: SizedBox(
        width: 56,
        height: 56,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SpotThumbnail(
            imageRef: spot.thumbnailImageUrl ?? spot.imageRef,
          ),
        ),
      ),
      title: HighlightedText(
        text: spot.name,
        query: query,
        maxLines: 1,
      ),
      // **주소와 거리를 두 줄로 나눈다.** 한 줄에 이어 붙이면 주소가 긴 곳에서
      // 거리가 잘려 나가 정작 필요한 값이 안 보인다(실제로 그랬다).
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HighlightedText(
            text: spot.location,
            query: query,
            maxLines: 1,
            style: theme.textTheme.bodySmall,
          ),
          if (distance != null)
            Text(
              distanceLabel(l10n, distance),
              maxLines: 1,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      isThreeLine: distance != null,
      onTap: () => onTap(spot),
    );
  }
}
