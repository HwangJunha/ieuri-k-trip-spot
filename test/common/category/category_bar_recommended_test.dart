import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/category/category_bar.dart';
import 'package:ieuri_k_trip_spot/common/category/category_chip_data.dart';

/// 카테고리 바의 「추천」 항목(SPEC-0035). Discover만 넘기며, 칩처럼 독립으로 켜고
/// 끄되 「전체」와는 배타다.
void main() {
  const List<CategoryChipData> chips = <CategoryChipData>[
    CategoryChipData(id: 'TOURIST_SPOT', label: '관광지', icon: Icons.place),
  ];

  Future<void> pump(
    WidgetTester tester, {
    Set<String> selectedIds = const <String>{},
    bool recommendedSelected = false,
    VoidCallback? onRecommended,
    VoidCallback? onSelectAll,
  }) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CategoryBar(
          available: chips,
          selectedIds: selectedIds,
          allLabel: '전체',
          onToggle: (_) {},
          onSelectAll: onSelectAll ?? () {},
          recommendedLabel: '추천',
          recommendedSelected: recommendedSelected,
          onRecommended: onRecommended,
        ),
      ),
    ),
  );

  bool selectedOf(WidgetTester tester, String label) => tester
      .widget<CategoryBarEntry>(
        find.ancestor(
          of: find.text(label),
          matching: find.byType(CategoryBarEntry),
        ),
      )
      .selected;

  testWidgets('onRecommended가 없으면 「추천」을 그리지 않는다', (tester) async {
    await pump(tester);

    expect(find.text('추천'), findsNothing);
    expect(find.text('전체'), findsOneWidget);
  });

  testWidgets('「추천」은 「전체」 뒤에 놓이고 누르면 콜백이 온다', (tester) async {
    int taps = 0;
    await pump(tester, onRecommended: () => taps++);

    expect(find.text('추천'), findsOneWidget);
    final double allX = tester.getCenter(find.text('전체')).dx;
    final double recX = tester.getCenter(find.text('추천')).dx;
    final double chipX = tester.getCenter(find.text('관광지')).dx;
    expect(allX < recX && recX < chipX, isTrue);

    await tester.tap(find.text('추천'));
    expect(taps, 1);
  });

  testWidgets('추천이 켜져 있으면 칩이 없어도 「전체」는 꺼진다', (tester) async {
    await pump(tester, recommendedSelected: true, onRecommended: () {});

    expect(selectedOf(tester, '추천'), isTrue);
    expect(selectedOf(tester, '전체'), isFalse);
  });

  testWidgets('추천과 칩은 함께 켜질 수 있다', (tester) async {
    await pump(
      tester,
      selectedIds: <String>{'TOURIST_SPOT'},
      recommendedSelected: true,
      onRecommended: () {},
    );

    expect(selectedOf(tester, '추천'), isTrue);
    expect(selectedOf(tester, '관광지'), isTrue);
    expect(selectedOf(tester, '전체'), isFalse);
  });

  testWidgets('아무것도 켜지지 않으면 「전체」가 켜진다', (tester) async {
    await pump(tester, onRecommended: () {});

    expect(selectedOf(tester, '전체'), isTrue);
    expect(selectedOf(tester, '추천'), isFalse);
  });
}
