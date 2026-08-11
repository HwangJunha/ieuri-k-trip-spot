import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 지도에서 추천 지역 목록으로 들어가는 버튼(SPEC-0015 진입 트리거).
///
/// **지도 화면에는 앱바가 없다.** 상단은 검색창과 "이 지역 재검색"이, 좌측 상단은
/// 혼잡도 범례가 이미 차지하고 있어, 남는 자리는 우측의 컨트롤 열뿐이다 —
/// 줌·현재 위치와 같은 모양(44dp 원형 Material)으로 그 아래에 붙인다.
///
/// 줌·현재 위치와 시각적으로 떨어뜨리지 않는 이유는, 셋 다 "지도를 어디로 볼 것인가"를
/// 다루는 조작이기 때문이다.
class RegionRecommendationButton extends StatelessWidget {
  const RegionRecommendationButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 3,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Tooltip(
        message: AppLocalizations.of(context).mapRegionRecommendationsAction,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.auto_awesome,
              size: 22,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
