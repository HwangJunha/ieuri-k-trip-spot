import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/component/sns_login_buttons.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

Widget _app(List<SnsProvider> providers) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('en'),
  home: Scaffold(
    body: SnsLoginButtons(onProvider: (_) {}, providers: providers),
  ),
);

void main() {
  testWidgets('애플이 빠진 플랫폼에서는 애플 버튼이 없다', (WidgetTester tester) async {
    await tester.pumpWidget(_app(snsProvidersFor(isApplePlatform: false)));
    await tester.pumpAndSettle();

    expect(find.text('Continue with Apple'), findsNothing);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Kakao'), findsOneWidget);
  });

  testWidgets('애플 기기에서는 세 버튼이 모두 있다', (WidgetTester tester) async {
    await tester.pumpWidget(_app(snsProvidersFor(isApplePlatform: true)));
    await tester.pumpAndSettle();

    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Kakao'), findsOneWidget);
  });

  testWidgets('버튼을 누르면 그 provider를 알린다', (WidgetTester tester) async {
    final List<SnsProvider> tapped = <SnsProvider>[];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: SnsLoginButtons(
            onProvider: tapped.add,
            providers: snsProvidersFor(isApplePlatform: false),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue with Kakao'));

    expect(tapped, <SnsProvider>[SnsProvider.kakao]);
  });
}
