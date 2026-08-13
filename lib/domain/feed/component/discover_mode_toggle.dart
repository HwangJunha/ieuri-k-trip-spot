import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/discover_segment.dart';

/// 둘러보기 탭의 추천↔피드 세그먼트 토글(R5).
///
/// **헤더 안에 산다 — 제스처 표면 위 오버레이가 아니다**(설계 §1). 두 화면 모두
/// 화면 전체를 제스처 표면으로 쓰기 때문에(추천은 카드 드래그, 피드는 세로 스크롤)
/// 토글을 그 위에 겹치면 토글 탭과 드래그 시작이 같은 영역에서 경합한다.
///
/// 커뮤니티의 `FeedSortToggle`과 같은 시각 언어를 쓰되 **폭을 전체로 편다** — 저쪽은
/// 같은 목록을 다르게 줄 세우는 정렬이고 이쪽은 화면 자체를 바꾼다. 정렬 토글처럼
/// 작게 접어 두면 두 화면이 있다는 사실 자체가 눈에 덜 띈다(디자인 §1).
///
/// **상태를 소유하지 않는다.** 선택 값은 화면 레벨 provider가 쥐고 이 위젯은 그리기만
/// 한다 — 토글이 상태를 가지면 두 화면의 격리(AC5-3)가 이 위젯을 거치게 된다.
class DiscoverModeToggle extends StatelessWidget {
  const DiscoverModeToggle({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final DiscoverSegment selected;
  final ValueChanged<DiscoverSegment> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<DiscoverSegment>(
          segments: <ButtonSegment<DiscoverSegment>>[
            ButtonSegment<DiscoverSegment>(
              value: DiscoverSegment.recommendation,
              label: Text(l10n.feedSegmentForYou),
            ),
            ButtonSegment<DiscoverSegment>(
              value: DiscoverSegment.feed,
              label: Text(l10n.feedSegmentFeed),
            ),
          ],
          selected: <DiscoverSegment>{selected},
          showSelectedIcon: false,
          onSelectionChanged: (Set<DiscoverSegment> next) =>
              onSelected(next.first),
        ),
      ),
    );
  }
}
