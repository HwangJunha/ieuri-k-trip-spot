import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../../../common/widget/skeleton_list.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/map_cell.dart';
import '../model/national_map_skeleton_samples.dart';
import '../provider/national_map_providers.dart';

/// 겹치는 칸이 **어디인지** 보여 주는 시트.
///
/// "6곳이 겹쳐요"는 몇 곳인지만 말해 준다 — 어디인지는 지도에서 색칠된 칸을
/// 눈으로 찾아야 했다. 작은 칸이 섞이면 사실상 찾을 수 없다(사용자 지적).
///
/// **서버를 다시 부르지 않는다.** 칸 이름은 이미 받아 둔 `mapCells`에 있으므로
/// id로 맞춰 이름만 꺼낸다.
class OverlapListSheet extends ConsumerWidget {
  const OverlapListSheet({required this.cellIds, super.key});

  /// 겹치는 칸 id.
  final List<String> cellIds;

  /// 이 시트를 띄운다.
  static Future<void> show(BuildContext context, List<String> cellIds) {
    // **단일 관문이다** — 관계 상세와 공유 지도 두 진입이 모두 여기로 모인다.
    AppAnalytics.logEvent(AnalyticsEvents.overlapTripView, <String, Object>{
      AnalyticsParams.overlapCount: cellIds.length,
    });
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => OverlapListSheet(cellIds: cellIds),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<MapCell>> cells = ref.watch(mapCellsProvider);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.sharedMapOverlapCount(cellIds.length),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: switch (cells) {
                  AsyncData<List<MapCell>>(value: final List<MapCell> list) =>
                    _NameList(cellIds: cellIds, cells: list),
                  AsyncError<List<MapCell>>() => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(l10n.nationalMapUnavailable),
                  ),
                  // 실제 줄(`_NameList`)을 더미 칸으로 그린 뒤 시머로 덮는다.
                  // 구분선도 실제 목록과 같이 둬야 값이 도착할 때 줄 위치가
                  // 튀지 않는다.
                  _ => SkeletonList(
                    itemCount: 4,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    separator: const Divider(height: 1),
                    itemBuilder: (_, int i) => _NameTile(
                      cell:
                          mapCellSkeletonSamples[i %
                              mapCellSkeletonSamples.length],
                    ),
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameList extends StatelessWidget {
  const _NameList({required this.cellIds, required this.cells});

  final List<String> cellIds;
  final List<MapCell> cells;

  @override
  Widget build(BuildContext context) {
    final Map<String, MapCell> byId = <String, MapCell>{
      for (final MapCell c in cells) c.id: c,
    };
    // 시도 → 칸 이름 순으로 정렬한다. id 순은 사람에게 아무 뜻이 없다.
    final List<MapCell> found =
        <MapCell>[
          for (final String id in cellIds)
            if (byId[id] case final MapCell c) c,
        ]..sort((MapCell a, MapCell b) {
          final int p = a.provinceName.compareTo(b.provinceName);
          return p != 0 ? p : a.name.compareTo(b.name);
        });

    return ListView.separated(
      shrinkWrap: true,
      itemCount: found.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (BuildContext context, int i) => _NameTile(cell: found[i]),
    );
  }
}

/// 칸 한 줄. **로딩 뼈대도 이 위젯을 그린다** — 줄 모양을 한곳에 두어야 뼈대와
/// 실제 목록이 어긋나지 않는다.
class _NameTile extends StatelessWidget {
  const _NameTile({required this.cell});

  final MapCell cell;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(cell.name),
      subtitle: cell.provinceName.isEmpty ? null : Text(cell.provinceName),
      leading: Icon(Icons.place_outlined, color: theme.colorScheme.primary),
    );
  }
}
