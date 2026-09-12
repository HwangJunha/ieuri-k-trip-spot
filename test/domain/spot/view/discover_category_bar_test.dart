import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/category/category_bar.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category_bar.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

/// Discover 바의 첫 칩 문구(SPEC-0035). 소스가 추천 묶음 하나라 「전체」 대신 「추천」이다.
/// 다른 화면(좋아요·검색·지도)은 기본값 「전체」를 유지해야 한다 — 그쪽은 목록이다.
void main() {
  const List<SpotCategory> available = <SpotCategory>[
    SpotCategory(code: 'TOURIST_SPOT', label: '관광지'),
  ];

  Future<void> pump(WidgetTester tester, {String? allLabel, IconData? icon}) =>
      tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SpotCategoryBar(
              available: available,
              selected: const <SpotCategory>{},
              onToggle: (_) {},
              onSelectAll: () {},
              allLabel: allLabel,
              allIcon: icon ?? Icons.grid_view_rounded,
            ),
          ),
        ),
      );

  testWidgets('allLabel을 주면 첫 칩이 그 문구·아이콘으로 그려진다', (tester) async {
    await pump(tester, allLabel: '추천', icon: Icons.auto_awesome_rounded);

    expect(find.text('추천'), findsOneWidget);
    expect(find.text('전체'), findsNothing);
    final CategoryBarEntry first = tester.widget<CategoryBarEntry>(
      find.byType(CategoryBarEntry).first,
    );
    expect(first.icon, Icons.auto_awesome_rounded);
    expect(first.selected, isTrue, reason: '빈 선택이면 첫 칩이 켜진다');
  });

  testWidgets('allLabel이 없으면 공용 「전체」다', (tester) async {
    await pump(tester);

    expect(find.text('전체'), findsOneWidget);
    expect(find.text('추천'), findsNothing);
  });
}
