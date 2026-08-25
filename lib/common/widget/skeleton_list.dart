import 'package:flutter/material.dart';

import 'app_skeleton.dart';

/// 목록 초기 로딩 자리에 놓는 뼈대. **`Center(CircularProgressIndicator())`를
/// 대체한다.**
///
/// ## 왜 공용인가
///
/// 초기 로딩은 `PaginationListView`가 아니라 **호출부의 `state.when(loading:)`**이
/// 그린다 — 그 위젯은 데이터가 온 뒤(`data:` 갈래)에야 트리에 들어오므로, 거기를
/// 고쳐도 초기 로딩은 하나도 바뀌지 않는다. 그래서 로딩 갈래를 받아 줄 자리가 따로
/// 필요하다.
///
/// 15개 목록 화면이 같은 모양을 써야 하므로 각 화면이 `Skeletonizer`를 직접 부르게
/// 두지 않는다 — `region_recommendation_screen.dart`의 주석이 "이 화면만 스켈레톤을
/// 두면 로딩 모양이 화면마다 달라진다"며 미뤄 둔 결정이 이것이다.
///
/// ## 쓰는 법
///
/// 실제 항목 위젯에 더미 모델을 넣어 넘긴다. 뼈대를 손으로 그리지 않으므로 카드
/// 디자인이 바뀌어도 저절로 따라간다.
///
/// ```dart
/// state.when(
///   loading: () => SkeletonList(
///     itemCount: 6,
///     itemBuilder: (_, _) => LikedSpotCard(spot: likedSpotSkeletonSample),
///   ),
///   ...
/// )
/// ```
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    required this.itemBuilder,
    this.itemCount = 6,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.separator,
  });

  final IndexedWidgetBuilder itemBuilder;

  /// 그릴 뼈대 개수. 한 화면을 채울 만큼이면 충분하다 — 스크롤 밖은 보이지 않고
  /// 빌드 비용만 든다.
  final int itemCount;

  final EdgeInsetsGeometry padding;

  /// 항목 사이에 넣을 위젯(대개 [Divider]). 실제 목록이 구분선을 쓰면 뼈대도 써야
  /// 데이터가 도착할 때 줄 위치가 튀지 않는다.
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: ListView.separated(
        padding: padding,
        // 뼈대는 당길 수 없다 — 아직 새로고칠 대상이 없다.
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, _) => separator ?? const SizedBox.shrink(),
        itemBuilder: itemBuilder,
      ),
    );
  }
}
