import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/view/email_verification_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../auth_test_doubles.dart';

/// A router starting on the verification screen with a stub login screen, so we
/// can assert the verify→login(prefill) transition.
GoRouter _router() => GoRouter(
  initialLocation: '/email-verification',
  routes: [
    GoRoute(
      path: '/email-verification',
      name: 'emailVerification',
      builder: (_, _) => const EmailVerificationScreen(
        verificationId: 'v1',
        email: 'user@example.com',
      ),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, state) => Scaffold(body: Text('LOGIN:${state.extra}')),
    ),
  ],
);

Widget _app() => ProviderScope(
  overrides: [
    secureStorageProvider.overrideWithValue(SecureStorage(MemoryStore())),
    authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
  ],
  child: MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    routerConfig: _router(),
  ),
);

void main() {
  testWidgets('verifying navigates to login with the email prefilled', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '123456');
    await tester.tap(find.widgetWithText(FilledButton, 'Verify'));
    await tester.pumpAndSettle();

    expect(find.text('LOGIN:user@example.com'), findsOneWidget);
  });

  testWidgets('shows an inline error when the code is empty', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Verify'));
    await tester.pump();

    expect(find.text('Enter the verification code.'), findsOneWidget);
  });
}
