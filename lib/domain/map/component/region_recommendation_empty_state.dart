import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 빈 결과 안내(R15 · R20 · 설계 §5.1).
///
/// **빈 결과는 오류가 아니다.** 이것을 오류 화면으로 그리면 사용자가 해결되지 않는
/// 재시도를 반복한다. 그래서 오류 색(`error` 롤)도, 재시도 버튼도 쓰지 않는다.
///
/// **문구는 하나다.** 설계 초안은 기준 시점 유무로 "모으는 중"과 "조건 불충족"을
/// 갈랐지만, 서버가 그 필드를 두지 않는 쪽으로 확정했다 — 기준일은 항목마다 달라서
/// 응답 하나에 날짜를 하나만 두면 나머지 항목에 대해 틀린 표기가 되기 때문이다.
///
/// 서버가 빈 목록을 주는 사유는 여럿이지만(바다·해외 좌표, 시군구 3개 미만인 시도,
/// 후보가 없는 시도) **클라이언트가 어느 쪽인지 알 방법이 없다.** 모르는 것을 아는
/// 척 가르면 틀린 안내를 하게 되므로, 어느 경우에나 맞는 "지금은 없다"로 적는다.
class RegionRecommendationEmptyState extends StatelessWidget {
  const RegionRecommendationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    const IconData icon = Icons.search_off_outlined;
    final String title = l10n.mapRegionRecommendationsNoMatchTitle;
    final String body = l10n.mapRegionRecommendationsNoMatch;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 56, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
