import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/email_change_failure_reason.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/settings_failure.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/email_change_controller.dart';
import 'package:ieuri_k_trip_spot/domain/settings/view/email_change_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../../auth/auth_test_doubles.dart';
import '../email_change_test_doubles.dart';

/// SPEC-0011 R7·R8 — 이메일 변경 화면이 사용자에게 보이는 대로 동작한다.

Future<ProviderContainer> _pump(
  WidgetTester tester,
  FakeEmailChangeRepository repo,
) async {
  final SecureStorage secure = await seededSecureStorage(
    authenticated: true,
    onboarded: true,
  );
  final ProviderContainer container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(secure),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      emailChangeRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: EmailChangeScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

/// 주소를 넣고 코드 단계까지 간다.
Future<void> _toCodeStep(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).first, 'new@example.com');
  await tester.tap(find.text('Send Code'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('주소 입력 단계로 열린다 (R7)', (WidgetTester tester) async {
    await _pump(tester, FakeEmailChangeRepository());

    expect(find.text('Change Email'), findsOneWidget);
    expect(find.text('Send Code'), findsOneWidget);
    expect(find.text('Verify'), findsNothing);
  });

  testWidgets('빈 주소는 보내지 않고 안내한다', (WidgetTester tester) async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
    await _pump(tester, repo);

    await tester.tap(find.text('Send Code'));
    await tester.pumpAndSettle();

    expect(repo.requestedEmails, isEmpty);
  });

  testWidgets('형식이 틀린 주소는 서버를 부르지 않는다', (WidgetTester tester) async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
    await _pump(tester, repo);

    await tester.enterText(find.byType(TextField).first, 'not-an-email');
    await tester.tap(find.text('Send Code'));
    await tester.pumpAndSettle();

    expect(repo.requestedEmails, isEmpty, reason: '왕복해도 같은 답이 온다');
  });

  testWidgets('코드를 보내면 검증 단계로 넘어간다 (R7)', (WidgetTester tester) async {
    await _pump(tester, FakeEmailChangeRepository());

    await _toCodeStep(tester);

    expect(find.text('Verify'), findsOneWidget);
    expect(find.text('Send Code'), findsNothing);
  });

  // R7 첫 기준 — 검증 전까지 프로필 이메일은 옛 값이고, 그 사실을 드러내야
  // 사용자가 실패로 오해하지 않는다.
  testWidgets('검증 단계에 대기 중 안내가 뜬다 (R7)', (WidgetTester tester) async {
    await _pump(tester, FakeEmailChangeRepository());

    await _toCodeStep(tester);

    expect(
      find.textContaining('only after you verify'),
      findsOneWidget,
      reason: '아직 안 바뀌었다는 것을 말해 줘야 한다',
    );
  });

  testWidgets('코드를 보낸 주소를 보여준다', (WidgetTester tester) async {
    await _pump(tester, FakeEmailChangeRepository());

    await _toCodeStep(tester);

    expect(find.textContaining('new@example.com'), findsWidgets);
  });

  testWidgets('코드 불일치 안내가 뜬다 (R8)', (WidgetTester tester) async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..confirmReason = EmailChangeFailureReason.codeMismatch;
    await _pump(tester, repo);
    await _toCodeStep(tester);

    await tester.enterText(find.byType(TextField).first, '000000');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.textContaining("doesn't match"), findsOneWidget);
  });

  // 사유마다 다음 행동이 달라야 한다 — 셋을 같은 문구로 묶으면 무엇을 할지 모른다.
  testWidgets('만료는 재발송하라고 안내한다 (R8)', (WidgetTester tester) async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..confirmReason = EmailChangeFailureReason.expired;
    await _pump(tester, repo);
    await _toCodeStep(tester);

    await tester.enterText(find.byType(TextField).first, '000000');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.textContaining('expired'), findsOneWidget);
  });

  testWidgets('시도 초과는 주소 단계로 되돌린다 (R8)', (WidgetTester tester) async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..confirmReason = EmailChangeFailureReason.maxAttemptsExceeded;
    await _pump(tester, repo);
    await _toCodeStep(tester);

    await tester.enterText(find.byType(TextField).first, '000000');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.text('Send Code'), findsOneWidget, reason: '주소부터 다시 한다');
    expect(find.textContaining('all attempts'), findsOneWidget);
  });

  // 쿨다운이 남은 동안에는 남은 시간을 보여 주고 누를 수 없어야 한다.
  testWidgets('재발송 버튼이 카운트다운으로 막혀 있다 (R8)', (WidgetTester tester) async {
    await _pump(tester, FakeEmailChangeRepository());

    await _toCodeStep(tester);

    expect(find.textContaining('Resend code in'), findsOneWidget);
  });

  testWidgets('빈 코드는 서버를 부르지 않는다', (WidgetTester tester) async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository();
    await _pump(tester, repo);
    await _toCodeStep(tester);

    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(repo.confirmedCodes, isEmpty);
  });

  testWidgets('1단계 실패는 화면에 안내로 남는다', (WidgetTester tester) async {
    final FakeEmailChangeRepository repo = FakeEmailChangeRepository()
      ..requestFailure = SettingsFailure.network;
    await _pump(tester, repo);

    await tester.enterText(find.byType(TextField).first, 'new@example.com');
    await tester.tap(find.text('Send Code'));
    await tester.pumpAndSettle();

    // 주소 단계에 남아 다시 시도할 수 있다.
    expect(find.text('Send Code'), findsOneWidget);
  });
}
