import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_credential.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/view/login_screen.dart';
import 'package:ieuri_k_trip_spot/domain/auth/view/sns_sign_up_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/router/routes.dart';

/// SNS 가입 라우트 하나만 태운다. `extra`가 위젯으로 어떻게 넘어가는지만 본다.
Future<void> _pumpRoute(WidgetTester tester, {Object? extra}) async {
  final GoRoute route = buildRoutes().whereType<GoRoute>().firstWhere(
    (GoRoute r) => r.name == SnsSignUpScreen.routeName,
  );

  await tester.pumpWidget(
    ProviderScope(
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
          initialExtra: extra,
          routes: <RouteBase>[route],
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('자격증명을 받으면 SNS 가입 화면을 그린다', (tester) async {
    await _pumpRoute(
      tester,
      extra: const SnsCredential(
        provider: SnsProvider.kakao,
        idToken: 'token',
      ),
    );

    expect(find.byType(SnsSignUpScreen), findsOneWidget);
  });

  // 실기기 회귀(2026-08-24): 이 경로에 머문 채 핫 리스타트하면 빨간 화면이 떴다.
  //
  // `extra`는 메모리에만 있고 URL에 실리지 않아 라우트가 다시 만들어지면 null이다.
  // 게이트는 `/sns-sign-up`을 미인증 허용 경로로 통과시키므로 빌더까지 도달하는데,
  // 예전에는 `state.extra!`가 그 자리에서 터졌다.
  testWidgets('extra가 없으면 터지지 않고 로그인으로 되돌린다', (tester) async {
    await _pumpRoute(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(SnsSignUpScreen), findsNothing);
  });

  testWidgets('extra 타입이 어긋나도 터지지 않는다', (tester) async {
    // 다른 화면이 남긴 값이 그대로 실려 오는 경우.
    await _pumpRoute(tester, extra: 'someone@example.com');

    expect(tester.takeException(), isNull);
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
