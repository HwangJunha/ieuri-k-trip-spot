import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/national_map_canvas.dart';
import '../model/cell_geometry.dart';
import '../model/national_map_failure.dart';
import '../model/shared_map.dart';
import '../provider/national_map_providers.dart';
import '../provider/share_providers.dart';

/// 공유 링크로 연 남의 지도(R37·R38).
///
/// 인증 없이 열린다. 본인 지도가 있으면 **겹치는 칸을 강조**한다.
class SharedMapScreen extends ConsumerWidget {
  const SharedMapScreen({required this.token, super.key});

  static String get routeName => 'shared-map';

  /// 링크의 마지막 경로 조각. 스킴이 바뀌어도 이 값만 넘기면 된다.
  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<SharedMap> shared = ref.watch(sharedMapProvider(token));

    return Scaffold(
      appBar: AppBar(title: Text(shared.value?.ownerNickname ?? '')),
      body: SafeArea(
        child: switch (shared) {
          AsyncError<SharedMap>(error: final Object e) => _ErrorBody(
            message: _messageFor(e, l10n),
          ),
          AsyncData<SharedMap>(value: final SharedMap map) => _Body(
            map: map,
            l10n: l10n,
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }

  /// 폐기·차단·그 밖을 구분해 사유를 보여준다(R38).
  String _messageFor(Object error, AppLocalizations l10n) {
    if (error is NationalMapFailure) {
      // 서버가 "없음"과 "폐기됨"을 구분하지 않는다 — 구분하면 토큰을 넣어 보며
      // 그 사람이 공유했었는지 알아낼 수 있다.
      if (error.isShareLinkGone) return l10n.sharedMapGone;
      if (error.isShareLinkBlocked) return l10n.sharedMapBlocked;
    }
    return l10n.nationalMapUnavailable;
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.map, required this.l10n});

  final SharedMap map;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<CellGeometry>> geometries = ref.watch(
      cellGeometriesProvider,
    );

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.sharedMapVisitedCount(map.visitedCount),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                // **null과 빈 배열이 다르다.** null은 비교 자체를 못 한 것이고
                // 빈 배열은 비교했는데 겹치는 곳이 없는 것이다.
                switch (map) {
                  SharedMap(canCompare: false) => l10n.sharedMapSignInToCompare,
                  SharedMap(hasNoOverlap: true) => l10n.sharedMapNoOverlap,
                  _ => l10n.sharedMapOverlapCount(
                    map.overlappingCellIds!.length,
                  ),
                },
                style: theme.textTheme.bodySmall?.copyWith(
                  color: map.canCompare && !map.hasNoOverlap
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: switch (geometries) {
            AsyncData<List<CellGeometry>>(value: final List<CellGeometry> g) =>
              NationalMapCanvas(
                cells: g,
                visitedCellIds: map.visitedCellIds.toSet(),
                overlappingCellIds: map.overlappingCellIds?.toSet(),
              ),
            AsyncError<List<CellGeometry>>() => Center(
              child: Text(l10n.nationalMapUnavailable),
            ),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ),
  );
}
