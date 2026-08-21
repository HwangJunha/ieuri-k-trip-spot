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
              top: MediaQuery.paddingOf(context).top + 52,
              bottom: FloatingBottomNavScaffold.barExtent,
            ),
            child: NationalMapCanvas(
              cells: widget.geometries,
              visitedCellIds: visited,
              selectedCellId: _selectedCellId,
              onCellTap: _onCellTap,
              // 지도가 거의 정사각형이라 fit이면 세로가 절반 가까이 빈다.
              // 세로를 채우고 좌우로 넘치는 빈 바다는 잘라 낸다.
              cover: true,
            ),
          ),
        ),

        // 상단: 진척 막대와 동작 아이콘만. 숫자는 적지 않는다.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TopBar(
            progress: nationwide,
            onPhotoSync: () => showPhotoSyncSheet(context),
            l10n: l10n,
          ),
        ),

        // 공유는 오른쪽 아래. 지도를 다 채운 뒤에 하는 일이라 주 동작과 떨어뜨린다.
        Positioned(
          right: 16,
          bottom: FloatingBottomNavScaffold.barExtent + 12,
          child: _ShareButton(onShare: () => _share(context), l10n: l10n),
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

/// 지도 위에 떠 있는 얇은 상단 바.
///
/// **숫자를 적지 않는다** — "161칸 중 7칸"은 막대가 이미 보여주는 것을 글자로
/// 반복할 뿐이고 지도를 가리는 값을 한다. 정확한 수치는 지역 상세에 있다.
///
/// 오른쪽 **맨 끝이 현재 위치 등록**이다. 지도를 채우는 주 동작이라 엄지가 가장
/// 먼저 닿는 자리에 두고, 브랜드 코럴로 칠해 다른 아이콘과 구분한다.
class _TopBar extends ConsumerWidget {
  const _TopBar({
    required this.progress,
    required this.onPhotoSync,
    required this.l10n,
  });

  final ProvinceProgress progress;
  final VoidCallback onPhotoSync;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: scheme.surface.withValues(alpha: 0.92),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 6,
          4,
          8,
        ),
        child: Row(
          children: <Widget>[
            // 진척은 막대만. 얼마나 찼는지는 길이로 읽는다.
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.ratio,
                  minHeight: 6,
                  backgroundColor: scheme.surfaceDim,
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.photo_library_outlined),
              tooltip: l10n.photoSyncTitle,
              onPressed: onPhotoSync,
            ),
            // 맨 끝. 빨간색으로 이것이 주 동작임을 알린다.
            _HereButton(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

/// 공유 링크를 발급해 시스템 공유 시트로 넘긴다(R36).
class _ShareButton extends ConsumerWidget {
  const _ShareButton({required this.onShare, required this.l10n});

  final VoidCallback onShare;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool sharing = ref.watch(shareControllerProvider);
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return FloatingActionButton.small(
      heroTag: 'national_map_share',
      // 주 동작(등록)이 아니므로 코럴을 쓰지 않는다.
      backgroundColor: scheme.surfaceContainerHighest,
      foregroundColor: scheme.onSurface,
      tooltip: l10n.nationalMapShare,
      onPressed: sharing ? null : onShare,
      child: sharing
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.ios_share),
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

/// 현재 위치의 시군구를 등록한다(R33~R35). 상단 바의 아이콘이다.
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

    final ColorScheme scheme = Theme.of(context).colorScheme;

    // **브랜드 코럴로 칠한다.** 지도를 채우는 주 동작이라 다른 아이콘과 구분되어야
    // 한다. 비활성일 때는 색을 빼 눌러도 안 된다는 것을 보여준다.
    return IconButton(
      icon: check.isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.my_location),
      color: scheme.primary,
      tooltip: l10n.nationalMapHere,
      onPressed: disabled ? null : () => _onPressed(context, ref, check.value),
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
