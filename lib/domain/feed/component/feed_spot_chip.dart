import 'package:flutter/material.dart';

import '../../../common/model/post_spot.dart';
import '../../../common/network/media_cdn.dart';

/// 피드에 붙은 장소 pill. 탭하면 스팟 상세로 간다(R13).
///
/// **피드는 장소가 반드시 하나 있다**(`FeedItem.spot`은 non-null, R1) — 커뮤니티
/// 글과 달리 "장소 없음" 상태가 없어 자리를 비울 분기가 필요 없다. 여기서 스팟
/// 상세로 넘어가는 것이 피드의 목적이다.
///
/// 사진 위 스크림에 얹히므로 반투명 배경을 두른다.
class FeedSpotChip extends StatelessWidget {
  const FeedSpotChip({super.key, required this.spot, required this.onTap});

  final PostSpot spot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foreground = theme.colorScheme.onPrimary;
    final String? thumbnail = MediaCdn.profileImage(spot.thumbnailImageUrl);

    return Material(
      color: theme.colorScheme.scrim.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: 12,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                foregroundImage: (thumbnail == null || thumbnail.isEmpty)
                    ? null
                    : NetworkImage(thumbnail),
                // 썸네일이 없거나 404면 위치 핀만 남는다 — 크기는 그대로다.
                child: Icon(
                  Icons.place_outlined,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  spot.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
