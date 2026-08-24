import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../component/cell_artwork_view.dart';
import '../component/cell_image_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../spot/view/spot_detail_view.dart';
import '../model/cell_detail.dart';
import '../model/map_cell.dart';
import '../provider/national_map_providers.dart';

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
          // **상세는 실사 사진이다**(SPEC-0031, 2026-08-23 결정). 지도 칸은 우리
          // 그림이고, 확대하면 그 지역의 실제 모습을 본다. 사진이 아직 없는
          // 칸은 그림으로 대체한다.
          if (cell.representativeImage != null)
            CellImageView(image: cell.representativeImage!)
          else
            CellArtworkView(cellId: cell.id, visited: cell.visited),
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
              // **해제 버튼을 두지 않는다.** 여기는 지역을 둘러보는 화면이고
              // 해제는 지도에서 칸을 눌렀을 때 뜨는 시트에 있다. 상태만 알린다.
              if (cell.visited)
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
          ),
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
