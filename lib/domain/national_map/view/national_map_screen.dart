import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/national_map_canvas.dart';
import '../component/province_progress_bar.dart';
import '../model/cell_geometry.dart';
import '../model/map_cell.dart';
import '../model/province_progress.dart';
import '../provider/cell_geometry_provider.dart';
import '../provider/national_map_providers.dart';

/// 전국 지도 — 161칸을 채워나가는 화면(R20~R22).
///
/// 참조 디자인은 스크래치 지도다. 칸을 긁어 채우는 경험을 앱 팔레트로 옮긴다 —
/// 미방문은 가라앉히고 방문은 브랜드 코럴로 채운다(설계 §3, `CellPalette`).
class NationalMapScreen extends ConsumerStatefulWidget {
  const NationalMapScreen({super.key});

  static String get routeName => 'national-map';

  @override
  ConsumerState<NationalMapScreen> createState() => _NationalMapScreenState();
}

class _NationalMapScreenState extends ConsumerState<NationalMapScreen> {
  String? _selectedCode;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    final AsyncValue<List<CellGeometry>> geometries = ref.watch(
      cellGeometriesProvider,
    );
    final AsyncValue<List<MapCell>> cells = ref.watch(mapCellsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navNationalMap)),
      body: SafeArea(
        child: switch ((geometries, cells)) {
          (AsyncLoading<List<CellGeometry>>(), _) ||
          (_, AsyncLoading<List<MapCell>>()) => const Center(
            child: CircularProgressIndicator(),
          ),
          (AsyncError<List<CellGeometry>>(), _) ||
          (_, AsyncError<List<MapCell>>()) => Center(
            child: Text(l10n.nationalMapUnavailable),
          ),
          _ => _Body(
            geometries: geometries.requireValue,
            cells: cells.requireValue,
            selectedCode: _selectedCode,
            onCellTap: (String code) => setState(() => _selectedCode = code),
            theme: theme,
            l10n: l10n,
          ),
        },
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.geometries,
    required this.cells,
    required this.selectedCode,
    required this.onCellTap,
    required this.theme,
    required this.l10n,
  });

  final List<CellGeometry> geometries;
  final List<MapCell> cells;
  final String? selectedCode;
  final ValueChanged<String> onCellTap;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Set<String> visited = <String>{
      for (final MapCell c in cells)
        if (c.visited) c.code,
    };
    final ProvinceProgress nationwide = nationwideProgressOf(
      cells,
      label: l10n.nationalMapNationwide,
    );

    return Column(
      children: <Widget>[
        _SummaryCard(
          progress: nationwide,
          label: l10n.nationalMapCellCount(nationwide.visited, nationwide.total),
          emptyHint: nationwide.visited == 0
              ? l10n.nationalMapEmptyHint
              : null,
        ),
        Expanded(
          child: NationalMapCanvas(
            cells: geometries,
            visitedCodes: visited,
            selectedCode: selectedCode,
            onCellTap: onCellTap,
          ),
        ),
        _SelectedCellBar(
          cell: selectedCode == null
              ? null
              : cells.where((MapCell c) => c.code == selectedCode).firstOrNull,
          l10n: l10n,
          onToggle: (MapCell cell) {
            final LocalVisitedCells notifier = ref.read(
              localVisitedCellsProvider.notifier,
            );
            cell.visited
                ? notifier.remove(cell.code)
                : notifier.record(cell.code);
          },
        ),
      ],
    );
  }
}

/// 전국 진척 요약.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.progress,
    required this.label,
    this.emptyHint,
  });

  final ProvinceProgress progress;
  final String label;
  final String? emptyHint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ProvinceProgressBar(progress: progress, label: label),
          if (emptyHint != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              emptyHint!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 선택한 칸의 이름과 등록 버튼(R33·R34).
class _SelectedCellBar extends StatelessWidget {
  const _SelectedCellBar({
    required this.cell,
    required this.l10n,
    required this.onToggle,
  });

  final MapCell? cell;
  final AppLocalizations l10n;
  final ValueChanged<MapCell> onToggle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MapCell? selected = cell;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + FloatingBottomNavScaffold.barExtent,
      ),
      color: theme.colorScheme.surfaceContainerLow,
      child: selected == null
          ? Text(
              l10n.nationalMapSelectHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        selected.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        selected.provinceName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () => onToggle(selected),
                  child: Text(
                    selected.visited
                        ? l10n.nationalMapRemoveVisit
                        : l10n.nationalMapRecordVisit,
                  ),
                ),
              ],
            ),
    );
  }
}
