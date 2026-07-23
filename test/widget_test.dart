import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/localization/locale_controller.dart';
import 'package:ieuri_k_trip_spot/common/onboarding/view/language_selection_screen.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Minimal app harness wiring MaterialApp's locale to the controller, so a
/// language tap re-renders the tree in the chosen language (as in main.dart).
class _Harness extends ConsumerWidget {
  const _Harness();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = ref.watch(localeControllerProvider);
    return MaterialApp(
      locale: locale,
      supportedLocales: AppLanguage.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const LanguageSelectionScreen(),
    );
  }
}

void main() {
  testWidgets('selecting a language re-renders the screen in that language',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const _Harness(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap the Korean option; the title must switch to Korean copy.
    await tester.tap(find.text('한국어'));
    await tester.pumpAndSettle();

    expect(find.text('언어를 선택하세요'), findsOneWidget);
  });
}
