import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/cell_detail.dart';
import '../model/map_cell.dart';
import '../provider/national_map_providers.dart';
import '../provider/visit_controller.dart';
import '../view/cell_detail_screen.dart';
import 'cell_image_view.dart';
import 'map_sheet.dart';

/// 지도에서 칸을 눌렀을 때 올라오는 시트(R22·R24).
///
/// **랜드마크 실사진이 여기서 크게 보인다.** 지도의 칸에는 유형별 도형만 그리고
/// 사진은 이 자리에서 보여준다 — 칸 크기에서는 사진이 읽히지 않고, 56칸이
/// 변경금지 유형이라 칸 모양으로 오릴 수도 없다.
Future<void> showCellSheet(BuildContext context, {required String cellId}) =>
    showMapSheet<void>(
      context,
      builder: (_) => CellSheet(cellId: cellId),
    );

class CellSheet extends ConsumerWidget {
  const CellSheet({required this.cellId, super.key});

  final String cellId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<CellDetail> detail = ref.watch(
      cellDetailControllerProvider(cellId),
    );

    // 상세를 기다리는 동안에도 이름은 바로 보여준다 — 이미 갖고 있는 값이다.
    final MapCell? known = ref
        .watch(mapCellsProvider)
        .value
        ?.where((MapCell c) => c.id == cellId)
        .firstOrNull;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _Header(cell: detail.value?.cell ?? known, l10n: l10n, theme: theme),
        const SizedBox(height: 16),
        switch (detail) {
          AsyncError<CellDetail>() => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l10n.nationalMapUnavailable,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          AsyncData<CellDetail>(value: final CellDetail d) => _Content(
            detail: d,
            l10n: l10n,
            theme: theme,
          ),
          _ => const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          ),
        },
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.cell, required this.l10n, required this.theme});

  final MapCell? cell;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final MapCell? c = cell;
    if (c == null) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                c.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                c.provinceName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (c.visited)
          Chip(
            avatar: Icon(
              Icons.check_circle,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            label: Text(l10n.nationalMapVisited),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({
    required this.detail,
    required this.l10n,
    required this.theme,
  });

  final CellDetail detail;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MapCell cell = detail.cell;
    final bool busy = ref.watch(visitControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // **이미지가 없어도 빈 칸으로 두지 않는다**(R10) — 지역명만 보인다.
        if (cell.representativeImage != null)
          CellImageView(image: cell.representativeImage!, height: 180),
        const SizedBox(height: 16),
        if (detail.spots.isNotEmpty) ...<Widget>[
          Text(
            l10n.nationalMapSpotsTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          // 시트에서는 몇 개만 맛보기로 — 전체는 상세 화면에서 본다.
          for (final CellSpot spot in detail.spots.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '· ${spot.title}',
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(height: 12),
        ],
        Row(
          children: <Widget>[
            if (cell.visited)
              Expanded(
                child: OutlinedButton(
                  onPressed: busy
                      ? null
                      : () => ref
                            .read(visitControllerProvider.notifier)
                            .remove(cell.id),
                  child: Text(l10n.nationalMapRemoveVisit),
                ),
              ),
            if (cell.visited) const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).maybePop();
                  context.pushNamed(
                    CellDetailScreen.routeName,
                    pathParameters: <String, String>{'id': cell.id},
                  );
                },
                child: Text(l10n.nationalMapOpenDetail),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
