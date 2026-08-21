import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../spot/view/spot_detail_view.dart';
import '../component/cell_image_view.dart';
import '../component/province_progress_bar.dart';
import '../model/cell_detail.dart';
import '../model/map_cell.dart';
import '../model/province_progress.dart';
import '../provider/national_map_providers.dart';
import '../provider/visit_controller.dart';

/// 지역 상세 — 대표 이미지와 그 칸의 장소 목록(R11·R22·R23·R24).
class CellDetailScreen extends ConsumerWidget {
  const CellDetailScreen({required this.cellId, super.key});

  static String get routeName => 'cell-detail';

  final String cellId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<CellDetail> detail = ref.watch(
      cellDetailControllerProvider(cellId),
    );

    return Scaffold(
      appBar: AppBar(title: Text(detail.value?.cell.name ?? '')),
      body: switch (detail) {
        AsyncError<CellDetail>() => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(l10n.nationalMapUnavailable),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () =>
                    ref.invalidate(cellDetailControllerProvider(cellId)),
                child: Text(l10n.nationalMapRetry),
              ),
            ],
          ),
        ),
        AsyncData<CellDetail>(value: final CellDetail d) => _Body(
          detail: d,
          cellId: cellId,
          l10n: l10n,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.detail, required this.cellId, required this.l10n});

  final CellDetail detail;
  final String cellId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final MapCell cell = detail.cell;
    final bool busy = ref.watch(visitControllerProvider);

    return NotificationListener<ScrollNotification>(
      // 바닥 근처에서 다음 페이지를 당긴다. 컨트롤러가 중복 요청을 막는다.
      onNotification: (ScrollNotification n) {
        if (detail.hasMore &&
            n.metrics.pixels >= n.metrics.maxScrollExtent - 240) {
          ref.read(cellDetailControllerProvider(cellId).notifier).loadMore();
        }
        return false;
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: <Widget>[
          // **이미지가 없어도 빈 칸으로 두지 않는다**(R10) — 지역명만 보인다.
          if (cell.representativeImage != null)
            CellImageView(image: cell.representativeImage!),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(cell.name, style: theme.textTheme.titleLarge),
                    Text(
                      cell.provinceName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (cell.visited)
                OutlinedButton.icon(
                  onPressed: busy
                      ? null
                      : () => ref
                            .read(visitControllerProvider.notifier)
                            .remove(cell.id),
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: Text(l10n.nationalMapRemoveVisit),
                ),
            ],
          ),
          const SizedBox(height: 20),
          // 이 칸이 속한 시도의 진척(R21). 지도에서는 전국 한 줄만 보여주므로
          // 시도 단위는 여기가 자리다 — "경상북도 22칸 중 5칸".
          _ProvinceProgress(provinceCode: cell.provinceCode, l10n: l10n),
          const SizedBox(height: 24),
          Text(
            l10n.nationalMapSpotsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (detail.spots.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.nationalMapSpotsEmpty,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else ...<Widget>[
            for (final CellSpot spot in detail.spots) _SpotTile(spot: spot),
            if (detail.hasMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ],
      ),
    );
  }
}

class _SpotTile extends StatelessWidget {
  const _SpotTile({required this.spot});

  final CellSpot spot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 56,
          height: 56,
          child: spot.thumbnailImageUrl.isEmpty
              ? ColoredBox(color: theme.colorScheme.surfaceContainerHighest)
              : Image.network(
                  spot.thumbnailImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
        ),
      ),
      title: Text(spot.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(spot.categoryLabel),
      onTap: () => context.pushNamed(
        SpotDetailView.routeName,
        pathParameters: <String, String>{'id': spot.id},
      ),
    );
  }
}


/// 이 칸이 속한 시도의 진척(R21).
class _ProvinceProgress extends ConsumerWidget {
  const _ProvinceProgress({required this.provinceCode, required this.l10n});

  final String provinceCode;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ProvinceProgress>> all = ref.watch(
      provinceProgressProvider,
    );
    final ProvinceProgress? mine = all.value
        ?.where((ProvinceProgress p) => p.provinceCode == provinceCode)
        .firstOrNull;
    if (mine == null) return const SizedBox.shrink();

    return ProvinceProgressBar(
      progress: mine,
      label: l10n.nationalMapCellCount(mine.visited, mine.total),
    );
  }
}
