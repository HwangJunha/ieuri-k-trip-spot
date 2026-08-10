import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 서울시 실시간 도시데이터 출처 표기(R30).
///
/// **공공누리 1유형은 출처 표시가 필수다.** 혼잡도 레이어가 보이는 동안 노출하며,
/// 접히거나 가려지는 위치에 두지 않는다(설계 §6.4).
///
/// 지도 위에 얹히므로 배경을 반투명하게 깔아 밝은 타일 위에서도 읽히게 한다 —
/// 글자만 올리면 지도 무늬에 묻혀 표기가 있으나 마나가 된다.
class CongestionAttribution extends StatelessWidget {
  const CongestionAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          l10n.mapAttribution,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
