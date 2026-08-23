import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/map_cell.dart';
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
  static Future<void> show(BuildContext context, List<String> cellIds) =>
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) => OverlapListSheet(cellIds: cellIds),
      );

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
                  _ => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
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
          ]
          ..sort((MapCell a, MapCell b) {
            final int p = a.provinceName.compareTo(b.provinceName);
            return p != 0 ? p : a.name.compareTo(b.name);
          });

    final ThemeData theme = Theme.of(context);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: found.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (BuildContext context, int i) {
        final MapCell c = found[i];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(c.name),
          subtitle: c.provinceName.isEmpty ? null : Text(c.provinceName),
          leading: Icon(
            Icons.place_outlined,
            color: theme.colorScheme.primary,
          ),
        );
      },
    );
  }
}
