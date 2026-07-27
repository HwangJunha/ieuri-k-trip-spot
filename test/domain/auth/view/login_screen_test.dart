import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/auth_repository.dart';
import 'package:ieuri_k_trip_spot/domain/auth/view/login_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../auth_test_doubles.dart';

/// signIn always fails, to drive the error UI.
final AuthRepository _failing = FakeAuthRepository(
  failure: const AuthFailure(AuthFailureKind.invalidCredentials),
);

Widget _app(AuthRepository repo) => ProviderScope(
  overrides: [
    secureStorageProvider.overrideWithValue(SecureStorage(MemoryStore())),
    authRepositoryProvider.overrideWithValue(repo),
  ],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale('en'),
    home: LoginScreen(),
  ),
);

void main() {
  testWidgets('shows an inline error when email is empty on submit', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_failing));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
    await tester.pump();

    expect(find.text('Enter your email.'), findsOneWidget);
  });

  testWidgets('shows the server error message after a failed sign-in', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_failing));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'user@example.com');
    await tester.enterText(find.byType(TextField).last, 'anything');
    await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Incorrect email or password.'), findsOneWidget);
  });
}
