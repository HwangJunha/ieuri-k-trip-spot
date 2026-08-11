import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 조회 실패 안내와 재시도(R28 · POL-040 · 설계 §5.2).
///
/// **빈 결과와는 다른 경로다.** 여기 오는 것은 네트워크 실패처럼 재시도가 실제로
/// 해결할 수 있는 상황뿐이다.
///
/// **재시도는 횟수로 제한한다.** 시간 기반이 아닌 이유는 응답 시간 목표(POL-029)에
/// 근거가 없어 "N초 뒤 다시 시도"가 근거 없는 수치가 되기 때문이다. 상한에 닿으면
/// 버튼을 감추고 문구를 바꾼다 — 눌러도 아무 일이 없는 버튼을 남겨 두지 않는다.
class RegionRecommendationErrorState extends StatelessWidget {
  const RegionRecommendationErrorState({
    required this.canRetry,
    required this.onRetry,
    super.key,
  });

  /// 재시도 상한이 남아 있는가. 거짓이면 버튼 대신 "나중에 다시" 문구를 보여 준다.
  final bool canRetry;

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              canRetry
                  ? l10n.mapRegionRecommendationsError
                  : l10n.mapRegionRecommendationsRetryExhausted,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (canRetry) ...<Widget>[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                child: Text(l10n.mapRegionRecommendationsRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
