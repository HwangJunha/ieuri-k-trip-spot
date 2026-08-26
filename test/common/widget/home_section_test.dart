import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/common/widget/home_section.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

/// [HomeSection]을 영어 로케일로 띄운다. 문구를 하드코딩하지 않고 [AppLocalizations]
/// 에서 꺼내 비교하므로, ARB를 고쳐도 테스트가 문구를 따라간다.
Future<void> _pump(
  WidgetTester tester, {
  required AsyncValue<List<String>> value,
  VoidCallback? onRetry,
}) => tester.pumpWidget(
  ProviderScope(
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: HomeSection<String>(
          title: 'Near you',
          value: value,
          emptyMessage: 'empty',
          onRetry: onRetry ?? () {},
          builder: (List<String> items) =>
              Column(children: items.map(Text.new).toList()),
        ),
      ),
    ),
  ),
);

/// 위젯 트리에서 실제로 쓰인 문구를 꺼낸다.
AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(HomeSection<String>)));

void main() {
  group('HomeSection 실패 상태', () {
    // 위치 실패는 "다시 시도"로 풀리지 않는다. 사용자가 할 일은 설정에서 위치를
    // 켜는 것 하나뿐이라, 조회 실패와 같은 문구로 뭉뚱그리면 안 된다.
    testWidgets('위치를 얻지 못하면 위치 꺼짐 안내를 보여준다', (WidgetTester tester) async {
      await _pump(
        tester,
        value: AsyncValue<List<String>>.error(
          const LocationUnavailable(LocationUnavailableReason.permissionDenied),
          StackTrace.empty,
        ),
      );

      final AppLocalizations l10n = _l10n(tester);
      expect(find.text(l10n.permissionLocationBlockedMessage), findsOneWidget);
      expect(find.text(l10n.homeSectionError), findsNothing);
    });

    // 눌러도 상태가 바뀌지 않는 버튼을 띄우면 사용자가 반복해서 누르게 된다.
    testWidgets('위치 꺼짐에는 재시도 버튼을 두지 않는다', (WidgetTester tester) async {
      await _pump(
        tester,
        value: AsyncValue<List<String>>.error(
          const LocationUnavailable(LocationUnavailableReason.serviceDisabled),
          StackTrace.empty,
        ),
      );

      expect(find.text(_l10n(tester).homeSectionRetry), findsNothing);
    });

    // 위치와 무관한 조회 실패는 예전 동작 그대로다 — 재시도가 실제로 통한다.
    testWidgets('조회 실패는 오류 문구와 재시도를 함께 보여준다', (WidgetTester tester) async {
      int retries = 0;
      await _pump(
        tester,
        value: AsyncValue<List<String>>.error(
          Exception('network'),
          StackTrace.empty,
        ),
        onRetry: () => retries++,
      );

      final AppLocalizations l10n = _l10n(tester);
      expect(find.text(l10n.homeSectionError), findsOneWidget);
      expect(find.text(l10n.permissionLocationBlockedMessage), findsNothing);

      await tester.tap(find.text(l10n.homeSectionRetry));
      expect(retries, 1);
    });
  });
}
