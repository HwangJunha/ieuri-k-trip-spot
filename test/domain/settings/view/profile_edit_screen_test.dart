import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/profile_edit_controller.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/profile_providers.dart';
import 'package:ieuri_k_trip_spot/domain/settings/view/profile_edit_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../../auth/auth_test_doubles.dart';
import '../profile_test_doubles.dart';

/// 프로필 수정 화면(SPEC-0011 R4~R6) — 사용자가 무엇을 보는지만 본다.

Future<void> _pump(
  WidgetTester tester,
  FakeProfileRepository repo, {
  /// 이메일 변경 진입점은 서버가 준 capability로 갈린다(SPEC-0024 R6).
  bool canChangeEmail = true,
}) async {
  // 화면이 **세션에 실린** `me`를 읽으므로(진입 지연을 피하려 재조회하지 않는다)
  // 저장소에 토큰을 심어 세션이 실제로 서게 해야 한다.
  final SecureStorage secure = await seededSecureStorage(
    authenticated: true,
    onboarded: true,
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(secure),
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(
            me: Me(
              id: '7',
              email: 'a@b.com',
              nickname: 'Traveler',
              emailVerified: true,
              canChangeEmail: canChangeEmail,
            ),
          ),
        ),
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

  testWidgets('이메일은 읽기 전용이되 변경 진입점이 있다 (R7·R8)', (WidgetTester tester) async {
    await _pump(tester, FakeProfileRepository());

    // 이 자리에서 직접 고치지 않는다 — 검증을 거쳐야 바뀌므로 별도 화면으로 간다.
    final TextField email = tester.widget<TextField>(
      find.byKey(const Key('profile-email-field')),
    );
    expect(email.enabled, isFalse);
    // 서버 계약(changeEmail)이 생겨 목적지가 있다 — 예전에는 갈 곳이 없어 뺐었다.
    expect(find.widgetWithText(TextButton, 'Change'), findsOneWidget);
  });

  testWidgets('canChangeEmail이 거짓이면 변경 진입점을 숨긴다 (SPEC-0024 R6)', (
    WidgetTester tester,
  ) async {
    await _pump(tester, FakeProfileRepository(), canChangeEmail: false);

    // **비활성이 아니라 없어야 한다** — 비활성으로 두면 왜 못 쓰는지 설명해야
    // 하는데, SNS 계정의 이메일이 provider 소유라는 사실은 설정 화면에서 설명할
    // 내용이 아니다.
    expect(find.byKey(const Key('profile-email-change-button')), findsNothing);
    // 이메일 자체는 여전히 보인다 — 어느 주소로 가입했는지는 확인할 수 있어야 한다.
    expect(find.byKey(const Key('profile-email-field')), findsOneWidget);
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
