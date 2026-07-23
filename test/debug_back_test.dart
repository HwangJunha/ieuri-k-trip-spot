import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The temporary debug back button on home resets onboarding and replays it.
void main() {
  testWidgets('home back button resets onboarding and returns to it',
      (tester) async {
    // Start already onboarded so the app lands on home.
    SharedPreferences.setMockInitialValues(
      <String, Object>{'onboarding_completed': true, 'locale': 'ko'},
    );
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const KTripSpotApp(),
      ),
    );

    // Splash → home (onboarding already completed).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();
    expect(find.text('로그인은 다음 단계에서 제공됩니다.'), findsOneWidget);

    // Tap the debug back button: resets onboarding and reopens it.
    await tester.tap(find.byTooltip('Debug: back'));
    await tester.pumpAndSettle();

    expect(find.text('스와이프로 발견하세요'), findsOneWidget);
    expect(prefs.getBool('onboarding_completed'), isFalse);
  });
}
