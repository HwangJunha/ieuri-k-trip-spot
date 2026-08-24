import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/post_sort_order.dart';

/// 피드 정렬 토글 — **최신순 / 거리순**(2차 가이드 §3, 당근 동네생활과 같은 형태).
///
/// 칩 줄 아래 왼쪽에 작게 붙는다. 필터가 아니라 같은 목록을 다르게 줄 세우는
/// 것이므로 카테고리 칩과 같은 크기로 그리면 두 축이 섞여 보인다.
///
/// **설명 문구를 두지 않는다.** "거리순에서는 장소 없는 글이 빠진다"는 사실이 있지만
/// 토글 옆에 문단을 붙이면 목록보다 안내가 커진다 — 라벨 두 개로 충분하다.
class FeedSortToggle extends StatelessWidget {
  const FeedSortToggle({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PostSortOrder selected;

  /// **호출부는 정렬 상태만 바꾼다** — 피드 provider가 정렬별 family라 값이 바뀌면
  /// 새 인스턴스가 커서 없이 첫 페이지부터 받는다. 화면이 커서를 손으로 비울 일이
  /// 없다(2차 가이드 §3).
  final ValueChanged<PostSortOrder> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
        child: SegmentedButton<PostSortOrder>(
          segments: <ButtonSegment<PostSortOrder>>[
            ButtonSegment<PostSortOrder>(
              value: PostSortOrder.latest,
              label: Text(l10n.communitySortLatest),
            ),
            ButtonSegment<PostSortOrder>(
              value: PostSortOrder.distance,
              label: Text(l10n.communitySortDistance),
            ),
          ],
          selected: <PostSortOrder>{selected},
          showSelectedIcon: false,
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onSelectionChanged: (Set<PostSortOrder> next) =>
              onSelected(next.first),
        ),
      ),
    );
  }
}
