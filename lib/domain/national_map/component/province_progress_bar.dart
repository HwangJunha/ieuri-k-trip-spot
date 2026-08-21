import 'package:flutter/material.dart';

import '../model/province_progress.dart';

/// 시도 1곳의 진척 막대(R21). "경기도 31칸 중 12칸".
///
/// **숫자는 방문 칸 수지 점수가 아니다.** 통계 수치를 합산하지 않는다.
class ProvinceProgressBar extends StatelessWidget {
  const ProvinceProgressBar({required this.progress, this.label, super.key});

  final ProvinceProgress progress;

  /// "31칸 중 12칸"에 해당하는 문구. 활성 언어로 만들어 넘긴다.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  progress.provinceName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (label != null)
                Text(
                  label!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              if (progress.isComplete) ...<Widget>[
                const SizedBox(width: 4),
                Icon(Icons.check_circle, size: 14, color: scheme.primary),
              ],
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.ratio,
              minHeight: 6,
              backgroundColor: scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
