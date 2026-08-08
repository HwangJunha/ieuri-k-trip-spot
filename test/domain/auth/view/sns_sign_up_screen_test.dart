import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_credential.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/auth_repository.dart';
import 'package:ieuri_k_trip_spot/domain/auth/view/sns_sign_up_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../auth_test_doubles.dart';

Widget _app(SnsCredential credential, {AuthRepository? repo}) => ProviderScope(
  overrides: [
    secureStorageProvider.overrideWithValue(SecureStorage(MemoryStore())),
    authRepositoryProvider.overrideWithValue(repo ?? FakeAuthRepository()),
  ],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: SnsSignUpScreen(credential: credential),
  ),
);

void main() {
  testWidgets('provider가 준 이메일은 고칠 수 없다', (WidgetTester tester) async {
    // provider가 검증한 주소다. 편집을 허용하면 검증되지 않은 값으로 바꿔
    // 인증 절차를 우회할 수 있어, 아예 잠근다.
    await tester.pumpWidget(
      _app(
        const SnsCredential(
          provider: SnsProvider.apple,
          idToken: 'id-token',
          email: 'given@example.com',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final TextField field = tester.widget<TextField>(find.byType(TextField));

    expect(field.enabled, isFalse);
    expect(field.controller?.text, 'given@example.com');
  });

  testWidgets('provider가 이메일을 안 주면 직접 입력한다', (WidgetTester tester) async {
    await tester.pumpWidget(
      _app(
        const SnsCredential(provider: SnsProvider.apple, idToken: 'id-token'),
      ),
    );
    await tester.pumpAndSettle();

    final TextField field = tester.widget<TextField>(find.byType(TextField));

    expect(field.enabled, isTrue);
    expect(field.controller?.text, isEmpty);
  });
}
