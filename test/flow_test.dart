import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// End-to-end first-run flow: splash → language select → 3 onboarding pages →
/// home placeholder, driving through the real app in Korean.
void main() {
  testWidgets('walks splash → language → onboarding → home', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const KTripSpotApp(),
      ),
    );

    // Splash: advance past the fixed delay, then it routes to language select.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Language select: pick Korean, then confirm.
    expect(find.text('한국어'), findsOneWidget);
    await tester.tap(find.text('한국어'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('선택 완료'));
    await tester.pumpAndSettle();

    // Onboarding, three pages in Korean.
    expect(find.text('스와이프로 발견하세요'), findsOneWidget);
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    expect(find.text('붐비는 곳은 피하세요'), findsOneWidget);
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    expect(find.text('함께 여행해요'), findsOneWidget);

    // Finish onboarding → home placeholder.
    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();
    expect(find.text('로그인은 다음 단계에서 제공됩니다.'), findsOneWidget);
  });
}
