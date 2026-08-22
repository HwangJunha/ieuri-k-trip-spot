import 'package:flutter/material.dart';

import '../../../common/widget/floating_bottom_nav_scaffold.dart';

/// 전국 지도 탭에서 쓰는 바텀 시트.
///
/// **하단 탭 바를 피해 띄운다.** 셸이 `extendBody: true`라 시트의 아래쪽이 떠 있는
/// 내비 바에 그대로 가린다 — 실제로 "사진으로 채우기" 시트의 버튼이 탭 바 뒤로
/// 들어가 눌리지 않았다. 시트마다 여백을 적지 않고 여기 한 곳에 둔다.
Future<T?> showMapSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  // 시트가 화면을 다 덮지 않게 — 지도가 뒤로 보여야 어느 칸을 눌렀는지 안다.
  constraints: BoxConstraints(
    maxHeight: MediaQuery.sizeOf(context).height * 0.78,
  ),
  builder: (BuildContext ctx) => SafeArea(
    top: false,
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          4,
          24,
          // 내비 바 높이 + 키보드가 올라오면 그만큼 더.
          FloatingBottomNavScaffold.barExtent +
              16 +
              MediaQuery.viewInsetsOf(ctx).bottom,
        ),
        child: builder(ctx),
      ),
    ),
  ),
);
