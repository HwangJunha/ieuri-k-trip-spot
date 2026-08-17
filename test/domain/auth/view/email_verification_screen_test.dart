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

Widget _app({SecureStorage? storage, FakeAuthRepository? repo}) => ProviderScope(
  overrides: [
    secureStorageProvider.overrideWithValue(
      storage ?? SecureStorage(MemoryStore()),
    ),
    authRepositoryProvider.overrideWithValue(repo ?? FakeAuthRepository()),
  ],
  child: MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    routerConfig: _router(),
  ),
);

/// 6칸에 코드를 채운다. 첫 칸에 통째로 넣으면 붙여넣기 경로를 타 여섯 칸이
/// 순서대로 채워진다(R11-4).
Future<void> _enterCode(WidgetTester tester, String code) async {
  await tester.enterText(
    find.byKey(const Key('verification-code-box-0')),
    code,
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('verifying navigates to login with the email prefilled', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // 여섯 칸이 차면 **자동 제출된다** — 버튼을 한 번 더 누르게 할 이유가 없다.
    await _enterCode(tester, '123456');

    expect(find.text('LOGIN:user@example.com'), findsOneWidget);
  });

  testWidgets('shows an inline error when the code is empty', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Verify'));
    await tester.pump();

    expect(find.text('Enter the verification code.'), findsOneWidget);
  });

  testWidgets('6칸 박스가 그려지고 붙여넣기가 칸을 나눠 채운다 (R11-1·R11-4)', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('verification-code-box-0')), findsOneWidget);
    expect(find.byKey(const Key('verification-code-box-5')), findsOneWidget);

    // 앞자리 0이 있는 값으로 확인한다 — 어딘가에서 수치 변환을 거치면 여기서
    // 무너진다(R11-5).
    //
    // 다섯 자리만 넣는다. 여섯 칸이 차면 자동 제출돼 화면이 전환되므로 칸을
    // 들여다볼 수 없다 — 분배 규칙 자체는 다섯 칸으로도 그대로 관찰된다.
    await _enterCode(tester, '01234');

    for (int i = 0; i < 5; i++) {
      final TextField box = tester.widget<TextField>(
        find.byKey(Key('verification-code-box-$i')),
      );
      expect(box.controller?.text, '01234'[i], reason: '$i번 칸');
    }
    // 남은 칸은 비어 있다.
    final TextField last = tester.widget<TextField>(
      find.byKey(const Key('verification-code-box-5')),
    );
    expect(last.controller?.text, isEmpty);
  });

  testWidgets('주소 정정이 새 주소로 나가고 화면의 표시 주소가 바뀐다 (SPEC-0024 R7)', (
    tester,
  ) async {
    // 게이트로 진입한 상태를 만든다 — 세션이 서 있어야 정정 버튼이 보인다.
    final SecureStorage storage = await seededSecureStorage(
      authenticated: true,
      onboarded: true,
    );
    final FakeAuthRepository repo = FakeAuthRepository();
    await tester.pumpWidget(_app(storage: storage, repo: repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('email-verification-retarget')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('email-verification-retarget-field')),
      'right@example.com',
    );
    await tester.tap(
      find.byKey(const Key('email-verification-retarget-submit')),
    );
    await tester.pumpAndSettle();

    // 정정한 주소로 서버에 나갔다.
    expect(repo.retargetedEmails, <String>['right@example.com']);
    // 화면은 **코드가 실제로 간 곳**을 보여준다. me.email은 인증을 통과할 때
    // 확정되므로 아직 이전 주소라, 그걸 그리면 사용자가 혼란스럽다.
    expect(
      find.byKey(const Key('email-verification-target')),
      findsOneWidget,
    );
    expect(find.text('right@example.com'), findsOneWidget);
  });

  testWidgets('코드를 보낸 뒤에는 재발송과 주소정정이 함께 잠긴다 (SPEC-0024 R7)', (
    tester,
  ) async {
    final SecureStorage storage = await seededSecureStorage(
      authenticated: true,
      onboarded: true,
    );
    await tester.pumpWidget(_app(storage: storage));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('email-verification-resend')));
    await tester.pumpAndSettle();

    // 서버가 두 오퍼레이션에 하나의 타이머를 쓴다 — 앱이 따로 세면 한쪽이 열려
    // 보이는데 누르면 실패한다.
    final TextButton resend = tester.widget<TextButton>(
      find.byKey(const Key('email-verification-resend')),
    );
    final TextButton retarget = tester.widget<TextButton>(
      find.byKey(const Key('email-verification-retarget')),
    );
    expect(resend.onPressed, isNull);
    expect(retarget.onPressed, isNull);
  });

  testWidgets('게이트로 진입해 핸들이 없으면 재발송을 숨기고 주소정정만 남긴다', (tester) async {
    // 세션 복원 경로(R10-4)다. verificationId가 없어 재발송은 부를 수 없지만,
    // 주소 정정은 토큰만으로 새 코드를 받아 낼 수 있어 **유일한 길**이다.
    final SecureStorage storage = await seededSecureStorage(
      authenticated: true,
      onboarded: true,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const EmailVerificationScreen(verificationId: '', email: ''),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('email-verification-resend')), findsNothing);
    expect(
      find.byKey(const Key('email-verification-retarget')),
      findsOneWidget,
    );
    // 인증할 수 없는 주소로 갇히지 않도록 로그아웃 출구도 남는다.
    expect(
      find.byKey(const Key('email-verification-sign-out')),
      findsOneWidget,
    );
  });
}
