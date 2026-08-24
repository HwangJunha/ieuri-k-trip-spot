import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/landmark_icon_binding.dart';
import '../model/map_cell.dart';
import '../provider/national_map_providers.dart';
import 'landmark_color_mapper.dart';

/// 칸 상세 맨 위에 들어가는 **상세용 그림**(SPEC-0031).
///
/// 지도용(`<slug>.svg`)과 **다른 파일**을 쓴다. 지도용은 120×120 정사각형을
/// 칸 윤곽으로 잘라 쓰는 그림이라, 여기에 늘려 놓으면 칸 모양 자국이 남아
/// 어색하다. 상세용(`<slug>@hero.svg`)은 320×180 가로형에 잘리지 않는 한 장면을
/// 담았고, 크게 보이므로 훨씬 자세하다.
class CellArtworkView extends ConsumerWidget {
  const CellArtworkView({
    required this.cellId,
    required this.visited,
    this.height = 200,
    super.key,
  });

  final String cellId;

  /// 부르는 쪽이 아는 방문 여부. 지도 목록에 값이 있으면 그쪽이 우선한다.
  final bool visited;

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final int? id = int.tryParse(cellId);
    final LandmarkIconBinding? binding = id == null
        ? null
        : landmarkIconBindings[id];

    if (binding == null) return SizedBox(height: height);

    // **방문 여부는 지도 목록을 따른다.** 상세는 서버에서 다시 받아오는데, 방금
    // 등록/해제한 낙관적 갱신은 `mapCellsProvider` 에만 반영돼 있다. 그래서
    // 시트는 컬러인데 상세만 회색으로 갈리는 일이 있었다.
    final bool isVisited =
        ref
            .watch(mapCellsProvider)
            .value
            ?.where((MapCell c) => c.id == cellId)
            .firstOrNull
            ?.visited ??
        visited;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: ColoredBox(
          color: theme.colorScheme.surfaceContainerHighest,
          child: SvgPicture.asset(
            landmarkIconAssetOf(binding.slug, suffix: '@hero'),
            // 가로형 그림을 가로형 자리에 넣으므로 채워도 거의 잘리지 않는다.
            fit: BoxFit.cover,
            colorMapper: isVisited
                ? const VisitedLandmarkColorMapper()
                : const UnvisitedLandmarkColorMapper(),
            placeholderBuilder: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
