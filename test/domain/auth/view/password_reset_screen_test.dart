import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/component/verification_code_field.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/view/password_reset_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../auth_test_doubles.dart';

/// 비밀번호 재설정(SPEC-0024 개편) — 두 단계가 시각적으로 분리되는지 본다.
///
/// 사용자가 지금 무엇을 하는 중인지 화면만 보고 알아야 한다. 예전에는 코드를 받은
/// 뒤에도 비활성 이메일 칸이 남아 "입력하다 만 폼"처럼 보였다.

Future<void> _pump(WidgetTester tester, {FakeAuthRepository? repo}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        secureStorageProvider.overrideWithValue(SecureStorage(MemoryStore())),
        authRepositoryProvider.overrideWithValue(repo ?? FakeAuthRepository()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: PasswordResetScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// 1단계를 통과해 코드 입력 단계로 넘어간다.
Future<void> _requestCode(
  WidgetTester tester, {
  String email = 'user@example.com',
}) async {
  await tester.enterText(find.byType(TextField).first, email);
  await tester.tap(find.widgetWithText(FilledButton, 'Send code'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('1단계에서는 이메일만 묻는다', (tester) async {
    await _pump(tester);

    // 코드 칸과 새 비밀번호가 미리 보이면 무엇을 해야 하는지 흐려진다.
    expect(find.byType(VerificationCodeField), findsNothing);
    expect(find.text('New password'), findsNothing);
  });

  testWidgets('코드를 받으면 코드·새 비밀번호 단계로 넘어간다', (tester) async {
    await _pump(tester);
    await _requestCode(tester);

    // 인증 화면과 같은 6칸 입력을 쓴다 — 같은 성격의 코드를 두 화면이 다른 모양으로
    // 받으면 사용자가 매번 형식을 다시 파악해야 한다.
    expect(find.byType(VerificationCodeField), findsOneWidget);
    expect(find.byKey(const Key('verification-code-box-0')), findsOneWidget);
    expect(find.byKey(const Key('verification-code-box-5')), findsOneWidget);
  });

  testWidgets('2단계에서는 이메일 입력칸 대신 보낸 주소를 보여준다', (tester) async {
    await _pump(tester);
    await _requestCode(tester);

    // 이미 확정된 값은 입력칸이 아니라 읽는 정보로 그린다.
    expect(
      find.byKey(const Key('password-reset-sent-to')),
      findsOneWidget,
    );
    expect(find.text('user@example.com'), findsOneWidget);
  });

  testWidgets('주소를 잘못 넣었으면 1단계로 되돌아갈 수 있다', (tester) async {
    await _pump(tester);
    await _requestCode(tester, email: 'typo@example.com');

    await tester.tap(find.byKey(const Key('password-reset-change-email')));
    await tester.pumpAndSettle();

    // 되돌아가면 이메일을 다시 입력할 수 있고 코드 단계는 사라진다.
    expect(find.byType(VerificationCodeField), findsNothing);
    expect(find.byKey(const Key('password-reset-sent-to')), findsNothing);
  });

  testWidgets('코드가 오지 않는 이유를 미리 알려준다', (tester) async {
    // 서버가 계정 존재 여부를 숨기므로 "당신 계정은 SNS다"라고 말할 수는 없지만,
    // 조건 자체는 알려 줄 수 있다 — 그래야 오지 않을 메일을 기다리지 않는다.
    await _pump(tester);
    await _requestCode(tester);

    expect(
      find.byKey(const Key('password-reset-no-code-hint')),
      findsOneWidget,
    );
  });
}
