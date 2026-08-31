import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/cell_sheet.dart';
import '../component/overlap_list_sheet.dart';
import '../component/national_map_canvas.dart';
import '../model/cell_geometry.dart';
import '../model/map_relation.dart';
import '../provider/national_map_providers.dart';
import '../provider/relation_providers.dart';

/// 관계 한 명의 겹침 지도(SPEC-0030 관계 지도).
///
/// **서버를 다시 부르지 않는다** — `mapRelations`가 이미 `overlappingCellIds`를
/// 주므로 그 값으로 그린다. 공유 링크(`sharedMap`)는 토큰이 있어야 하는데
/// 관계 목록에는 토큰이 오지 않으며, 애초에 필요도 없다.
class RelationDetailScreen extends ConsumerStatefulWidget {
  const RelationDetailScreen({required this.memberId, super.key});

  static String get routeName => 'relation-detail';

  final String memberId;

  @override
  ConsumerState<RelationDetailScreen> createState() =>
      _RelationDetailScreenState();
}

class _RelationDetailScreenState extends ConsumerState<RelationDetailScreen> {
  String? _selectedCellId;

  void _onCellTap(String cellId) {
    setState(() => _selectedCellId = cellId);
    showCellSheet(context, cellId: cellId).whenComplete(() {
      if (mounted) setState(() => _selectedCellId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String memberId = widget.memberId;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<MapRelationPage> page = ref.watch(mapRelationsProvider);

    final MapRelation? relation = page.value?.relations
        .where((MapRelation r) => r.memberId == memberId)
        .firstOrNull;

    if (relation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.nationalMapUnavailable)),
      );
    }

    // 조립 결과에서 도형만 꺼낸다 — 출처는 화면이 쓰지 않는다(SPEC-0034 R4).
    final AsyncValue<List<CellGeometry>> geometries = ref
        .watch(cellGeometriesProvider)
        .whenData((CellGeometrySet s) => s.geometries);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top + 52,
                // 전국 지도와 같은 값 — 제주가 하단 바에 잘리지 않게 비켜선다.
                // **하단 바 높이를 비우지 않는다.** 이 화면은 하단 바 없이
                // 단독으로 열리므로 그만큼이 빈 공간이 되어 지도가 작아진다.
                bottom: MediaQuery.paddingOf(context).bottom + 12,
              ),
              child: switch (geometries) {
                AsyncData<List<CellGeometry>>(
                  value: final List<CellGeometry> g,
                ) =>
                  NationalMapCanvas(
                    cells: g,
                    // 겹치는 칸만 칠한다 — 상대의 전체 방문 칸은 이 조회에
                    // 오지 않고, 이 화면이 답할 질문도 아니다.
                    visitedCellIds: relation.overlappingCellIds.toSet(),
                    overlappingCellIds: relation.overlappingCellIds.toSet(),
                    selectedCellId: _selectedCellId,
                    // 어디를 함께 갔는지는 칸을 눌러야 알 수 있다.
                    onCellTap: _onCellTap,
                    cover: true,
                  ),
                AsyncError<List<CellGeometry>>() => Center(
                  child: Text(l10n.nationalMapUnavailable),
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ColoredBox(
              color: theme.colorScheme.surface.withValues(alpha: 0.92),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  4,
                  MediaQuery.paddingOf(context).top + 4,
                  16,
                  6,
                ),
                child: Row(
                  children: <Widget>[
                    const BackButton(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            relation.nickname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            l10n.sharedMapOverlapCount(
                              relation.overlappingCount,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 겹치는 곳을 목록으로 본다.
                    if (relation.overlappingCellIds.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.format_list_bulleted),
                        tooltip: l10n.sharedMapOverlapCount(
                          relation.overlappingCount,
                        ),
                        onPressed: () => OverlapListSheet.show(
                          context,
                          relation.overlappingCellIds,
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.person_remove_outlined),
                      tooltip: l10n.relationRemove,
                      onPressed: () => _remove(relation),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **내 목록에서만** 지운다 — 상대 목록의 나는 남는다.
  Future<void> _remove(MapRelation relation) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final NavigatorState navigator = Navigator.of(context);
    try {
      await ref.read(mapRelationsProvider.notifier).remove(relation.memberId);
      // 목록에서 사라졌으므로 이 화면도 닫는다.
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.relationRemoved)));
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l10n.relationRemoveFailed)));
    }
  }
}
