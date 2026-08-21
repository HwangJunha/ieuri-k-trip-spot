import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/cell_sheet.dart';
import '../component/national_map_canvas.dart';
import '../component/photo_sync_sheet.dart';
import '../model/cell_geometry.dart';
import '../model/current_location_check.dart';
import '../model/map_cell.dart';
import '../model/province_progress.dart';
import '../provider/current_location_provider.dart';
import '../provider/national_map_providers.dart';
import '../provider/share_providers.dart';
import '../provider/visit_controller.dart';

/// 전국 지도 — 161칸을 채워나가는 화면(R20~R22·R29·R33~R36).
///
/// 참조 디자인은 스크래치 지도 포스터다. **지도가 주인공이고 나머지는 비켜선다** —
/// 진척 바·선택 바를 화면에 상시로 쌓으면 지도가 작아지고 자잘해 보인다. 진척은
/// 상단에 한 줄, 칸을 누르면 아래에서 시트가 올라온다.
class NationalMapScreen extends ConsumerWidget {
  const NationalMapScreen({super.key});

  static String get routeName => 'national-map';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final AsyncValue<List<MapCell>> cells = ref.watch(mapCellsProvider);
    final AsyncValue<List<CellGeometry>> geometries = ref.watch(
      cellGeometriesProvider,
    );

    return Scaffold(
      // 지도를 화면 끝까지 쓰기 위해 AppBar를 두지 않는다. 제목·동작은 지도 위에
      // 떠 있는 얇은 바가 대신한다.
      body: switch ((cells, geometries)) {
        (AsyncError<List<MapCell>>(), _) ||
        (_, AsyncError<List<CellGeometry>>()) => SafeArea(
          child: _ErrorBody(
            message: l10n.nationalMapUnavailable,
            retryLabel: l10n.nationalMapRetry,
            onRetry: () => ref.invalidate(mapCellsProvider),
          ),
        ),
        (
          AsyncData<List<MapCell>>(value: final List<MapCell> c),
          AsyncData<List<CellGeometry>>(value: final List<CellGeometry> g),
        ) =>
          _Body(cells: c, geometries: g, l10n: l10n),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.cells,
    required this.geometries,
    required this.l10n,
  });

  final List<MapCell> cells;
  final List<CellGeometry> geometries;
  final AppLocalizations l10n;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  String? _selectedCellId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = widget.l10n;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    final Set<String> visited = <String>{
      for (final MapCell c in widget.cells)
        if (c.visited) c.id,
    };
    final ProvinceProgress nationwide = nationwideProgressOf(
      widget.cells,
      label: l10n.nationalMapNationwide,
    );

    return Stack(
      children: <Widget>[
        // 지도가 화면 전체를 쓴다. 상단 바와 하단 탭에 가리는 만큼만 여백을 준다.
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 60,
              bottom: FloatingBottomNavScaffold.barExtent,
            ),
            child: NationalMapCanvas(
              cells: widget.geometries,
              visitedCellIds: visited,
              selectedCellId: _selectedCellId,
              onCellTap: _onCellTap,
              // 세로 화면에서 좌우 빈 바다를 줄인다 — 지도가 주인공이다.
              cover: true,
            ),
          ),
        ),

        // 상단: 제목 대신 진척 한 줄.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TopBar(
            progress: nationwide,
            label: l10n.nationalMapCellCount(
              nationwide.visited,
              nationwide.total,
            ),
            onPhotoSync: () => showPhotoSyncSheet(context),
            onShare: () => _share(context),
            l10n: l10n,
          ),
        ),

        // 현재 위치 등록. 하단 탭 위로 띄운다.
        Positioned(
          right: 16,
          bottom: FloatingBottomNavScaffold.barExtent + 12,
          child: _HereButton(l10n: l10n),
        ),

        if (nationwide.visited == 0)
          Positioned(
            left: 24,
            right: 24,
            bottom: FloatingBottomNavScaffold.barExtent + 76,
            child: _EmptyHint(text: l10n.nationalMapEmptyHint, scheme: scheme),
          ),
      ],
    );
  }

  void _onCellTap(String cellId) {
    setState(() => _selectedCellId = cellId);
    // 칸 정보를 화면에 상시로 붙여 두지 않고 시트로 띄운다 — 지도가 넓어진다.
    showCellSheet(context, cellId: cellId).whenComplete(() {
      if (mounted) setState(() => _selectedCellId = null);
    });
  }

  Future<void> _share(BuildContext context) async {
    try {
      await ref
          .read(shareControllerProvider.notifier)
          .share(message: widget.l10n.nationalMapShareMessage);
    } on Object {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.l10n.nationalMapShareFailed)),
      );
    }
  }
}

/// 지도 위에 떠 있는 얇은 상단 바 — 진척과 동작만 담는다.
class _TopBar extends ConsumerWidget {
  const _TopBar({
    required this.progress,
    required this.label,
    required this.onPhotoSync,
    required this.onShare,
    required this.l10n,
  });

  final ProvinceProgress progress;
  final String label;
  final VoidCallback onPhotoSync;
  final VoidCallback onShare;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool sharing = ref.watch(shareControllerProvider);

    return ColoredBox(
      // 지도가 뒤로 살짝 비치되 글씨는 읽히게 한다.
      color: scheme.surface.withValues(alpha: 0.92),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 8,
          6,
          10,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.navNationalMap,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress.ratio,
                      minHeight: 5,
                      backgroundColor: scheme.surfaceDim,
                      valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.photo_library_outlined),
              tooltip: l10n.photoSyncTitle,
              onPressed: onPhotoSync,
            ),
            IconButton(
              icon: sharing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.ios_share),
              tooltip: l10n.nationalMapShare,
              onPressed: sharing ? null : onShare,
            ),
          ],
        ),
      ),
    );
  }
}

/// 한 칸도 없을 때의 안내. 지도 위에 얹어 시선을 끈다.
class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text, required this.scheme});

  final String text;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: scheme.inverseSurface.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: scheme.onInverseSurface),
      ),
    ),
  );
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

    // 위치를 얻지 못하면 버튼을 비활성화한다(R35).
    final bool disabled =
        busy ||
        check.isLoading ||
        check.value is LocationNotAvailable ||
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
      label: Text(l10n.nationalMapHere),
    );
  }

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

        await ref.read(visitControllerProvider.notifier).record(<String>[code]);
        // 방문이 늘었으니 다음 판정은 "이미 방문"이 되어야 한다.
        ref.invalidate(currentLocationCheckProvider);

      case LocationAlreadyVisited(cellName: final String name):
        _toast(context, l10n.nationalMapAlreadyVisited(name));

      case LocationOutsideKorea():
        _toast(context, l10n.nationalMapOutsideKorea);

      case LocationNotAvailable():
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
