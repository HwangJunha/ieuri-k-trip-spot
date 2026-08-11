import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 추천의 기준 위치를 고르는 토글(사용자 요청, 2026-08-12).
///
/// **두 기준이 정말 다른 결과를 낸다.** 서버는 origin이 속한 시도 안에서만 후보를
/// 고르고 origin의 시군구 자신은 제외하므로, 지도를 다른 시도로 옮겨 두고 열면 그쪽
/// 지역들이 나온다 — "지금 내 주변"과 "지도에서 보던 곳 주변"은 서로 다른 질문이다.
///
/// `SegmentedButton`을 쓰는 이유는 **둘 중 하나가 늘 켜져 있는 선택**이기 때문이다.
/// 스위치로 두면 꺼진 상태가 무엇을 뜻하는지 읽히지 않는다.
class RegionOriginToggle extends StatelessWidget {
  const RegionOriginToggle({
    required this.useMapCenter,
    required this.onChanged,
    super.key,
  });

  final bool useMapCenter;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<bool>(
        segments: <ButtonSegment<bool>>[
          ButtonSegment<bool>(
            value: false,
            icon: const Icon(Icons.my_location, size: 18),
            label: Text(l10n.mapRegionRecommendationsOriginMyLocation),
          ),
          ButtonSegment<bool>(
            value: true,
            icon: const Icon(Icons.map_outlined, size: 18),
            label: Text(l10n.mapRegionRecommendationsOriginMapCenter),
          ),
        ],
        selected: <bool>{useMapCenter},
        onSelectionChanged: (Set<bool> selection) =>
            onChanged(selection.first),
        showSelectedIcon: false,
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
