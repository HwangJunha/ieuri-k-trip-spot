import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/national_map_canvas.dart';
import '../component/photo_sync_sheet.dart';
import '../component/province_progress_bar.dart';
import '../model/cell_geometry.dart';
import '../model/current_location_check.dart';
import '../model/map_cell.dart';
import '../model/province_progress.dart';
import '../provider/current_location_provider.dart';
import '../provider/national_map_providers.dart';
import '../provider/visit_controller.dart';
import 'cell_detail_screen.dart';

/// 전국 지도 — 161칸을 채워나가는 화면(R20~R22·R29·R33~R35).
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

    final AsyncValue<List<MapCell>> cells = ref.watch(mapCellsProvider);
    final AsyncValue<List<CellGeometry>> geometries = ref.watch(
      cellGeometriesProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navNationalMap),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo_library_outlined),
            tooltip: l10n.photoSyncTitle,
            onPressed: () => showPhotoSyncSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: switch ((cells, geometries)) {
          (AsyncError<List<MapCell>>(), _) ||
          (_, AsyncError<List<CellGeometry>>()) => _ErrorBody(
            message: l10n.nationalMapUnavailable,
            retryLabel: l10n.nationalMapRetry,
            onRetry: () => ref.invalidate(mapCellsProvider),
          ),
          (
            AsyncData<List<MapCell>>(value: final List<MapCell> c),
            AsyncData<List<CellGeometry>>(value: final List<CellGeometry> g),
          ) =>
            _Body(
              cells: c,
              geometries: g,
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
    required this.cells,
    required this.geometries,
    required this.selectedCellId,
    required this.onCellTap,
    required this.l10n,
  });

  final List<MapCell> cells;
  final List<CellGeometry> geometries;
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
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: NationalMapCanvas(
                  cells: geometries,
                  visitedCellIds: visited,
                  selectedCellId: selectedCellId,
                  onCellTap: onCellTap,
                ),
              ),
              // 현재 위치 등록(R33). 지도 위에 띄워 언제든 누를 수 있게 한다.
              Positioned(
                right: 16,
                bottom: 16,
                child: _HereButton(l10n: l10n),
              ),
            ],
          ),
        ),
        _SelectedCellBar(cell: selected, l10n: l10n),
      ],
    );
  }
}

/// "지금 여기" 버튼 — 현재 위치의 시군구를 등록한다(R33~R35).
class _HereButton extends ConsumerWidget {
  const _HereButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CurrentLocationCheck> check = ref.watch(
      currentLocationCheckProvider,
    );
    final bool busy = ref.watch(visitControllerProvider);

    // 위치를 얻지 못하면 버튼을 비활성화하고 사유를 보여준다(R35).
    final bool disabled =
        busy ||
        check.isLoading ||
        check.value is LocationUnavailable ||
        check.value is LocationOutsideKorea;

    return FloatingActionButton.extended(
      heroTag: 'national_map_here',
      onPressed: disabled ? null : () => _onPressed(context, ref, check.value),
      icon: check.isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.my_location),
      label: Text(_label()),
    );
  }

  String _label() => l10n.nationalMapHere;

  Future<void> _onPressed(
    BuildContext context,
    WidgetRef ref,
    CurrentLocationCheck? check,
  ) async {
    if (check == null) return;

    switch (check) {
      case LocationRegistrable(
        districtCode: final String code,
        districtName: final String name,
      ):
        // **확인을 받아야 등록한다**(R33). 취소하면 아무 일도 없다.
        final bool ok =
            await showDialog<bool>(
              context: context,
              builder: (BuildContext ctx) => AlertDialog(
                title: Text(l10n.nationalMapRegisterTitle),
                content: Text(l10n.nationalMapRegisterBody(name)),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(l10n.commonCancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(l10n.nationalMapRecordVisit),
                  ),
                ],
              ),
            ) ??
            false;
        if (!ok || !context.mounted) return;

        await ref
            .read(visitControllerProvider.notifier)
            .record(<String>[code]);
        // 방문이 늘었으니 다음 판정은 "이미 방문"이 되어야 한다.
        ref.invalidate(currentLocationCheckProvider);

      case LocationAlreadyVisited(cellName: final String name):
        _toast(context, l10n.nationalMapAlreadyVisited(name));

      case LocationOutsideKorea():
        _toast(context, l10n.nationalMapOutsideKorea);

      case LocationUnavailable():
        _toast(context, l10n.nationalMapLocationUnavailable);
    }
  }

  void _toast(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
