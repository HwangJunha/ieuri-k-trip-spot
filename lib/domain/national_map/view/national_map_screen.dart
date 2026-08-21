import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/national_map_canvas.dart';
import '../component/province_progress_bar.dart';
import '../model/cell_geometry.dart';
import '../model/cell_geometry_index.dart';
import '../model/map_cell.dart';
import '../model/province_progress.dart';
import '../provider/cell_geometry_provider.dart';
import '../provider/national_map_providers.dart';
import 'cell_detail_screen.dart';

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
  String? _selectedCellId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final AsyncValue<List<CellGeometry>> geometries = ref.watch(
      cellGeometriesProvider,
    );
    final AsyncValue<List<MapCell>> cells = ref.watch(mapCellsProvider);
    final AsyncValue<CellGeometryIndex> index = ref.watch(
      cellGeometryIndexProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navNationalMap),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.nationalMapRetry,
            onPressed: () => ref.invalidate(mapCellsProvider),
          ),
        ],
      ),
      body: SafeArea(
        child: switch ((geometries, cells, index)) {
          (AsyncError<List<CellGeometry>>(), _, _) ||
          (_, AsyncError<List<MapCell>>(), _) ||
          (_, _, AsyncError<CellGeometryIndex>()) => _ErrorBody(
            message: l10n.nationalMapUnavailable,
            retryLabel: l10n.nationalMapRetry,
            onRetry: () => ref.invalidate(mapCellsProvider),
          ),
          (
            AsyncData<List<CellGeometry>>(value: final List<CellGeometry> g),
            AsyncData<List<MapCell>>(value: final List<MapCell> c),
            AsyncData<CellGeometryIndex>(value: final CellGeometryIndex i),
          ) =>
            _Body(
              geometries: g,
              cells: c,
              index: i,
              selectedCellId: _selectedCellId,
              onCellTap: (String id) => setState(() => _selectedCellId = id),
              l10n: l10n,
            ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.geometries,
    required this.cells,
    required this.index,
    required this.selectedCellId,
    required this.onCellTap,
    required this.l10n,
  });

  final List<CellGeometry> geometries;
  final List<MapCell> cells;
  final CellGeometryIndex index;
  final String? selectedCellId;
  final ValueChanged<String> onCellTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Set<String> visited = <String>{
      for (final MapCell c in cells)
        if (c.visited) c.id,
    };
    final ProvinceProgress nationwide = nationwideProgressOf(
      cells,
      label: l10n.nationalMapNationwide,
    );
    final MapCell? selected = selectedCellId == null
        ? null
        : cells.where((MapCell c) => c.id == selectedCellId).firstOrNull;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProvinceProgressBar(
                progress: nationwide,
                label: l10n.nationalMapCellCount(
                  nationwide.visited,
                  nationwide.total,
                ),
              ),
              if (nationwide.visited == 0) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  l10n.nationalMapEmptyHint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: NationalMapCanvas(
            cells: geometries,
            cellIdOf: index.cellIdByGeometryCode,
            visitedCellIds: visited,
            selectedCellId: selectedCellId,
            onCellTap: onCellTap,
          ),
        ),
        _SelectedCellBar(cell: selected, l10n: l10n),
      ],
    );
  }
}

/// 선택한 칸의 이름과 상세 진입(R22).
class _SelectedCellBar extends StatelessWidget {
  const _SelectedCellBar({required this.cell, required this.l10n});

  final MapCell? cell;
  final AppLocalizations l10n;

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
                        selected.visited
                            ? l10n.nationalMapVisited
                            : selected.provinceName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: selected.visited
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () => context.pushNamed(
                    CellDetailScreen.routeName,
                    pathParameters: <String, String>{'id': selected.id},
                  ),
                  child: Text(l10n.nationalMapOpenDetail),
                ),
              ],
            ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(message, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: Text(retryLabel)),
      ],
    ),
  );
}
