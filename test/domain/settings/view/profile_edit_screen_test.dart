import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/profile_edit_controller.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/profile_providers.dart';
import 'package:ieuri_k_trip_spot/domain/settings/view/profile_edit_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../../auth/auth_test_doubles.dart';
import '../profile_test_doubles.dart';

/// 프로필 수정 화면(SPEC-0011 R4~R6) — 사용자가 무엇을 보는지만 본다.

Future<void> _pump(WidgetTester tester, FakeProfileRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(SecureStorage(MemoryStore())),
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: ProfileEditScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('변경 전에는 Save가 비활성이다', (WidgetTester tester) async {
    await _pump(tester, FakeProfileRepository());

    final TextButton save = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Save'),
    );
    expect(save.onPressed, isNull);
  });

  testWidgets('닉네임을 고치면 Save가 활성된다', (WidgetTester tester) async {
    await _pump(tester, FakeProfileRepository());

    await tester.enterText(find.byType(TextField).first, 'Wanderer');
    await tester.pump();

    final TextButton save = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Save'),
    );
    expect(save.onPressed, isNotNull);
  });

  testWidgets('서버가 중복이라고 하면 입력란 아래에 그 문구가 뜬다 (R5)', (
    WidgetTester tester,
  ) async {
    final FakeProfileRepository repo = FakeProfileRepository()
      ..nicknameFailure = SettingsFailure.userError(nicknameAlreadyTakenCode);
    await _pump(tester, repo);

    await tester.enterText(find.byType(TextField).first, 'Wanderer');
    await tester.pump();
    await tester.tap(find.widgetWithText(TextButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('This nickname is already taken.'), findsOneWidget);
  });

  testWidgets('이메일은 읽기 전용이며 변경 진입점이 없다 (R7·R8 계약 없음)', (
    WidgetTester tester,
  ) async {
    await _pump(tester, FakeProfileRepository());

    final TextField email = tester.widget<TextField>(
      find.byKey(const Key('profile-email-field')),
    );
    expect(email.enabled, isFalse);
    // 눌리지 않는 "Change" 버튼을 두면 고장으로 보인다 — 아예 없어야 한다.
    expect(find.widgetWithText(TextButton, 'Change'), findsNothing);
  });

  testWidgets('사진 변경 진입점이 있다 (R6)', (WidgetTester tester) async {
    await _pump(tester, FakeProfileRepository());

    expect(find.text('Change Photo'), findsOneWidget);
  });

  testWidgets('이미지가 없으면 삭제 버튼을 그리지 않는다 (R6)', (WidgetTester tester) async {
    // 지울 것이 없는데 버튼이 있으면 눌러 보게 되고, 서버는 그때 실패로 답한다.
    await _pump(tester, FakeProfileRepository());

    expect(find.text('Remove'), findsNothing);
  });
}
