import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/component/congestion_legend.dart';
import 'package:ieuri_k_trip_spot/domain/map/component/map_notice_banner.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

/// 범례(R24)와 상단 안내(R23·R29).
void main() {
  const List<LocalizationsDelegate<Object>> delegates =
      <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: delegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: child),
    ),
  );

  group('범례 (R24)', () {
    testWidgets('네 단계가 모두 라벨로 나열된다', (WidgetTester tester) async {
      await pump(tester, const CongestionLegend());

      expect(find.text('Not busy'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
      expect(find.text('Getting busy'), findsOneWidget);
      expect(find.text('Crowded'), findsOneWidget);
    });
  });

  group('잘림 안내 (R23)', () {
    testWidgets('확대를 유도하는 문구가 보인다', (WidgetTester tester) async {
      await pump(tester, TruncatedNoticeBanner(onDismiss: () {}));

      expect(find.textContaining('Zoom in'), findsOneWidget);
    });

    testWidgets('닫을 수 있다', (WidgetTester tester) async {
      bool dismissed = false;
      await pump(
        tester,
        TruncatedNoticeBanner(onDismiss: () => dismissed = true),
      );

      await tester.tap(find.byIcon(Icons.close));

      expect(dismissed, isTrue);
    });
  });

  group('혼잡도 실패 안내 (R29)', () {
    testWidgets('레이어를 쓸 수 없다는 문구가 보인다', (WidgetTester tester) async {
      await pump(tester, const CongestionDegradedNotice());

      expect(find.textContaining('unavailable'), findsOneWidget);
    });

    /// 사용자가 조작으로 해소할 수 없는 상태라 닫기를 두지 않는다 — 닫아 버리면
    /// 왜 폴리곤이 없는지 알 방법이 사라진다.
    testWidgets('닫기 버튼이 없다', (WidgetTester tester) async {
      await pump(tester, const CongestionDegradedNotice());

      expect(find.byIcon(Icons.close), findsNothing);
    });
  });
}
