import 'package:flutter/material.dart';

import '../model/post_target.dart';
import '../model/post_topic.dart';

/// 글이 달린 대상 pill — 위치 핀 + 대상 이름, secondary 톤(디자인 §1).
///
/// 탭하면 대상 상세로 이동한다. **[PostTarget.type]이 null이면 탭해도 이동하지
/// 않는다** — 클라이언트가 아직 모르는 대상 종류라 어디로 보낼지 알 수 없다.
/// 그때도 pill 자체는 표시한다(어느 대상의 글인지는 여전히 유용한 정보다).
///
/// spot 상세 안의 피드에서는 이 pill을 **생략한다** — 이미 그 spot의 화면이다
/// (디자인 §2).
class PostTargetChip extends StatelessWidget {
  const PostTargetChip({super.key, required this.target, this.onTap});

  final PostTarget target;

  /// 대상 상세로의 이동. null이면 표시만 하고 반응하지 않는다.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool tappable = onTap != null && target.type == PostTargetType.spot;
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: tappable ? onTap : null,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.place_outlined,
                  size: 14,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: Text(
                    target.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
