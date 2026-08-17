import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/category/category_bar.dart';

/// 카테고리 칩 라벨 색(SPEC-0025 R14).
///
/// 이 바는 네 화면이 함께 쓴다(둘러보기·좋아요·검색·커뮤니티). **둘러보기만 사진 위에
/// 얹혀 있어** 라벨을 흰색으로 그려야 하는데, 그 색을 공용 위젯에 못 박으면 나머지
/// 세 화면의 흰 배경에서 라벨이 사라진다 — 실제로 겪은 실패라 양쪽을 함께 지킨다.
void main() {
  /// [onImage]로 그린 라벨의 실제 색.
  Future<Color?> labelColor(WidgetTester tester, {required bool onImage}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryBarEntry(
            icon: Icons.grid_view_rounded,
            label: '관광지',
            selected: false,
            onTap: () {},
            onImage: onImage,
          ),
        ),
      ),
    );

    return tester.widget<Text>(find.text('관광지')).style?.color;
  }

  testWidgets('사진 위에서는 라벨이 흰색이다', (WidgetTester tester) async {
    expect(await labelColor(tester, onImage: true), Colors.white);
  });

  /// **기본값은 건드리지 않는다.** 좋아요·검색·커뮤니티는 평범한 배경 위에 있어
  /// 테마 색이 맞다 — 여기가 흰색이 되면 그 세 화면에서 라벨이 사라진다.
  testWidgets('사진 위가 아니면 테마 색을 그대로 쓴다', (WidgetTester tester) async {
    final Color? color = await labelColor(tester, onImage: false);

    expect(color, isNot(Colors.white));
    expect(color, isNotNull);
  });
}
