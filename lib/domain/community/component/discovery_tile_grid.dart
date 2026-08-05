import 'package:flutter/material.dart';

import '../../../common/widget/image_placeholder.dart';
import '../model/discovery_tile.dart';

/// 탐색 타일 2열 그리드(디자인 §1).
///
/// **빈 목록이 정상이다**(가이드 §15) — 어드민이 아직 없고, 활성 언어의 타일이 없으면
/// 다른 언어로 대체되지 않는다. 그래서 비었을 때는 빈 문구를 띄우는 대신 **영역 자체를
/// 그리지 않는다**: 사용자가 고칠 수 없는 운영 상태를 알릴 이유가 없다.
///
/// 타일 개수·행 수는 서버가 내려주는 만큼이다(디자인 §10 — 목업의 4개는 예시).
class DiscoveryTileGrid extends StatelessWidget {
  const DiscoveryTileGrid({
    super.key,
    required this.tiles,
    required this.onTap,
  });

  final List<DiscoveryTile> tiles;
  final ValueChanged<DiscoveryTile> onTap;

  @override
  Widget build(BuildContext context) {
    if (tiles.isEmpty) return const SizedBox.shrink();
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 110,
      ),
      itemCount: tiles.length,
      itemBuilder: (BuildContext context, int index) => DiscoveryTileCard(
        tile: tiles[index],
        onTap: () => onTap(tiles[index]),
      ),
    );
  }
}

/// 타일 하나 — 사진 + 하단 그라디언트 + 흰 제목.
///
/// [DiscoveryTile.title]은 **서버 문자열을 그대로** 표시한다. 운영자가 시즌마다 바꾸는
/// 자유 문구라 매핑할 enum이 없다(가이드 §10).
class DiscoveryTileCard extends StatelessWidget {
  const DiscoveryTileCard({super.key, required this.tile, required this.onTap});

  final DiscoveryTile tile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // 이미지가 없거나(null) 로드에 실패해도 레이아웃이 유지되도록 항상
            // 플레이스홀더를 깔고 그 위에 그린다.
            ImagePlaceholder(imageRef: tile.id),
            if (tile.imageUrl != null)
              Image.network(
                tile.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            // 제목 가독성을 위한 하단 그라디언트. 색은 테마에서 읽는다.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    theme.colorScheme.scrim.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  tile.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
