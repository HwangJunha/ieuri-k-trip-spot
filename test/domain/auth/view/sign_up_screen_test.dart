import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/component/agreement_checklist.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/view/email_verification_screen.dart';
import 'package:ieuri_k_trip_spot/domain/auth/view/sign_up_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../auth_test_doubles.dart';

/// A tiny router with the sign-up screen and a stub email-verification screen so
/// we can assert the post-sign-up transition carries the verificationId/email.
GoRouter _router() => GoRouter(
  initialLocation: '/sign-up',
  routes: [
    GoRoute(
      path: '/sign-up',
      name: 'signUp',
      builder: (_, _) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/email-verification',
      name: 'emailVerification',
      builder: (_, state) {
        final EmailVerificationArgs args =
            state.extra! as EmailVerificationArgs;
        return Scaffold(
          body: Text('VERIFY:${args.verificationId}:${args.email}'),
        );
      },
    ),
  ],
);

Widget _app(GoRouter router) => ProviderScope(
  overrides: [
    secureStorageProvider.overrideWithValue(SecureStorage(MemoryStore())),
    authRepositoryProvider.overrideWithValue(
      FakeAuthRepository(verificationId: 'verify-1'),
    ),
  ],
  child: MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    routerConfig: router,
  ),
);

/// Checks every required consent item + fills a valid password so the submit
/// button becomes enabled.
Future<void> _satisfyGate(WidgetTester tester) async {
  final Finder fields = find.byType(TextField);
  await tester.enterText(fields.at(0), 'user@example.com');
  await tester.enterText(fields.at(1), 'abcd123!');
  await tester.enterText(fields.at(2), 'abcd123!');
  // Master "agree to all" toggles every child on.
  await tester.tap(find.byType(CheckboxListTile));
  await tester.pumpAndSettle();
}

/// Scrolls the form up so the submit button enters the viewport (the tall
/// agreement checklist pushes it below the fold on the default test surface).
Future<void> _scrollToButton(WidgetTester tester) async {
  await tester.drag(find.byType(ListView), const Offset(0, -600));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the password policy error on a weak password', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_router()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), 'short');
    await tester.pump();

    expect(
      find.text(
        'Use 8+ characters with a letter, a number, and a special character.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('submit is disabled until required agreements are checked', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_router()));
    await tester.pumpAndSettle();

    final Finder fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'user@example.com');
    await tester.enterText(fields.at(1), 'abcd123!');
    await tester.enterText(fields.at(2), 'abcd123!');
    await tester.pump();
    await _scrollToButton(tester);

    // Password is valid but no agreements checked → still disabled.
    final FilledButton button = tester.widget<FilledButton>(
      find.byType(FilledButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets(
    'the master checkbox toggles all children on then submit enables',
    (tester) async {
      await tester.pumpWidget(_app(_router()));
      await tester.pumpAndSettle();

      await _satisfyGate(tester);

      // Every checkbox — the master + one per item — is now checked.
      final List<Checkbox> boxes = tester
          .widgetList<Checkbox>(find.byType(Checkbox))
          .toList();
      expect(boxes.length, AgreementItem.all.length + 1);
      expect(boxes.every((Checkbox c) => c.value == true), isTrue);

      await _scrollToButton(tester);
      final FilledButton button = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets('transitions to email verification on success', (tester) async {
    await tester.pumpWidget(_app(_router()));
    await tester.pumpAndSettle();

    await _satisfyGate(tester);
    await _scrollToButton(tester);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('VERIFY:verify-1:user@example.com'), findsOneWidget);
  });
}
