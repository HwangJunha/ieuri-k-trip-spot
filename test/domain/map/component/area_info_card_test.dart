import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/component/area_info_card.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/commercial_activity_level.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/commercial_display_state.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_area.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

/// 구역 정보 카드가 **사용자에게 보여주는 것**을 검증한다(R27·R28).
void main() {
  const List<LocalizationsDelegate<Object>> delegates =
      <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  CongestionArea areaWith({CommercialStatus? commercial}) => CongestionArea(
    id: 'POI014',
    name: 'Gangnam MICE Special Tourist Zone',
    congestion: CongestionSnapshot(
      level: CongestionLevel.crowded,
      populationMin: 3000,
      populationMax: 3500,
      observedAt: DateTime(2026, 8, 10, 3, 30),
    ),
    commercial: commercial,
  );

  Future<void> pump(WidgetTester tester, CongestionArea area) =>
      tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: delegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: AreaInfoCard(area: area, onClose: () {}),
          ),
        ),
      );

  group('네 항목 표시 (R27)', () {
    testWidgets('구역명이 보인다', (WidgetTester tester) async {
      await pump(tester, areaWith());

      expect(find.text('Gangnam MICE Special Tourist Zone'), findsOneWidget);
    });

    testWidgets('혼잡 단계가 라벨로 보인다 — 색만으로 표현하지 않는다', (WidgetTester tester) async {
      await pump(tester, areaWith());

      expect(find.text('Crowded'), findsOneWidget);
    });

    testWidgets('인구 범위의 하한과 상한이 모두 보인다', (WidgetTester tester) async {
      await pump(tester, areaWith());

      expect(find.textContaining('3,000'), findsOneWidget);
      expect(find.textContaining('3,500'), findsOneWidget);
    });

    testWidgets('기준 시각이 보이며 "지금"을 쓰지 않는다', (WidgetTester tester) async {
      await pump(tester, areaWith());

      expect(find.textContaining('3:30'), findsWidgets);
      expect(find.textContaining('Now'), findsNothing);
      expect(find.textContaining('now'), findsNothing);
    });
  });

  group('상권 3상태 (R28)', () {
    testWidgets('부재면 정보 없음으로 보인다', (WidgetTester tester) async {
      await pump(tester, areaWith());

      expect(find.text('No data'), findsOneWidget);
    });

    testWidgets('기본값이면 실측이 아니라는 표시가 함께 보인다', (WidgetTester tester) async {
      await pump(
        tester,
        areaWith(
          commercial: CommercialStatus(
            level: CommercialActivityLevel.normal,
            isDefaulted: true,
            observedAt: DateTime(2026, 8, 9, 23, 50),
          ),
        ),
      );

      expect(find.text('Not measured here'), findsOneWidget);
    });

    testWidgets('실측이면 그 표시가 붙지 않는다', (WidgetTester tester) async {
      await pump(
        tester,
        areaWith(
          commercial: CommercialStatus(
            level: CommercialActivityLevel.busy,
            isDefaulted: false,
            observedAt: DateTime(2026, 8, 9, 23, 50),
          ),
        ),
      );

      expect(find.text('Busy hours'), findsOneWidget);
      expect(find.text('Not measured here'), findsNothing);
      expect(find.text('No data'), findsNothing);
    });

    /// 상권의 기준 시각은 인구와 다르다(spec §4.3) — 하나로 합쳐 표시하면 인구의
    /// 신선도가 상권에도 있는 것처럼 읽힌다.
    testWidgets('실측 상권은 자기 기준 시각을 따로 보여준다', (WidgetTester tester) async {
      await pump(
        tester,
        areaWith(
          commercial: CommercialStatus(
            level: CommercialActivityLevel.quiet,
            isDefaulted: false,
            observedAt: DateTime(2026, 8, 9, 23, 50),
          ),
        ),
      );

      // 인구는 3:30, 상권은 11:50 PM — 둘이 각각 보인다.
      expect(find.textContaining('3:30'), findsOneWidget);
      expect(find.textContaining('11:50'), findsOneWidget);
    });
  });

  testWidgets('닫기를 누르면 콜백이 불린다', (WidgetTester tester) async {
    bool closed = false;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: delegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: AreaInfoCard(area: areaWith(), onClose: () => closed = true),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close));

    expect(closed, isTrue);
  });
}
