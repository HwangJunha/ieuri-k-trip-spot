import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_credential.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/pending_sns_credential.dart';
import 'package:ieuri_k_trip_spot/domain/auth/view/login_screen.dart';
import 'package:ieuri_k_trip_spot/domain/auth/view/sns_sign_up_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/router/routes.dart';

const SnsCredential _credential = SnsCredential(
  provider: SnsProvider.google,
  idToken: 'id-token',
);

/// SNS 가입 라우트 하나만 태운다. 자격증명이 위젯으로 어떻게 넘어가는지만 본다.
Future<ProviderContainer> _pumpRoute(
  WidgetTester tester, {
  SnsCredential? pending,
}) async {
  final ProviderContainer container = ProviderContainer();
  addTearDown(container.dispose);
  if (pending != null) {
    container.read(pendingSnsCredentialProvider.notifier).set(pending);
  }

  final GoRoute route = buildRoutes().whereType<GoRoute>().firstWhere(
    (GoRoute r) => r.name == SnsSignUpScreen.routeName,
  );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        routerConfig: GoRouter(
          initialLocation: '/sns-sign-up',
          routes: <RouteBase>[route],
        ),
      ),
    ),
  );
  await tester.pump();
  return container;
}

void main() {
  testWidgets('자격증명이 있으면 SNS 가입 화면을 그린다', (tester) async {
    await _pumpRoute(tester, pending: _credential);

    expect(find.byType(SnsSignUpScreen), findsOneWidget);
  });

  // 실기기 회귀(2026-08-25): 구글·애플 로그인이 가입 화면 대신 로그인으로 떨어졌다.
  //
  // 자격증명을 `extra`로 넘기고 있었는데, 이 앱은 인증 상태가 바뀔 때마다
  // 라우트를 다시 만든다(refreshListenable). `signInSns`가 state를
  // loading → previous로 두 번 바꾸므로 push 직후 재빌드가 일어나고 `extra`가
  // 사라진다. 카카오만 멀쩡했던 것은 authorizationCode를 받지 않아 순서가
  // 어긋나지 않았기 때문이다.
  //
  // provider에 담으면 재빌드를 견딘다 — 이 테스트가 그것을 고정한다.
  testWidgets('라우트가 다시 만들어져도 자격증명이 살아 있다', (tester) async {
    await _pumpRoute(tester, pending: _credential);
    expect(find.byType(SnsSignUpScreen), findsOneWidget);

    // 인증 상태 변화로 인한 재빌드를 흉내 낸다.
    await tester.pump();
    await tester.pump();

    expect(
      find.byType(SnsSignUpScreen),
      findsOneWidget,
      reason: '재빌드 후에도 가입 화면이어야 한다',
    );
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('자격증명이 없으면 터지지 않고 로그인으로 되돌린다', (tester) async {
    // 앱 재시작·딥링크로 이 경로에 직접 닿는 경우.
    await _pumpRoute(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(SnsSignUpScreen), findsNothing);
  });

  test('가입을 마치면 자격증명을 비운다', () {
    final ProviderContainer c = ProviderContainer();
    addTearDown(c.dispose);

    c.read(pendingSnsCredentialProvider.notifier).set(_credential);
    expect(c.read(pendingSnsCredentialProvider), isNotNull);

    // 남겨 두면 다음 로그인 시도에서 남의 자격증명으로 가입 화면이 열린다.
    c.read(pendingSnsCredentialProvider.notifier).clear();
    expect(c.read(pendingSnsCredentialProvider), isNull);
  });
}
