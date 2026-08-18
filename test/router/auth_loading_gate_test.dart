import 'package:ieuri_k_trip_spot/domain/dm/provider/dm_providers.dart';
import '../domain/dm/dm_test_doubles.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/onboarding/view/splash_screen.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/home_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/auth/auth_test_doubles.dart';

/// 라우터 인증 게이트(SPEC-0005 §2.5, R1·R2·AC-1·AC-4).
///
/// 인증 상태가 `loading`인 동안 보호 대상 화면이 **한 프레임도** 렌더링되지 않아야
/// 한다. 이전 구현은 loading에서 리다이렉트를 포기(`null` 반환)했기 때문에 그 구간에
/// 보호 화면이 그려지고 provider가 발화했다.
///
/// `spots`가 토큰 없이도 200에 데이터를 반환하므로, 게이트가 새면 화면이 정상처럼
/// 채워져 결함이 눈에 띄지 않는다 — 그래서 이 테스트가 유일한 방어선이다.

/// `fetchMe`를 테스트가 풀어줄 때까지 붙잡아 두는 저장소. 인증 상태를 `loading`에
/// 고정시켜 게이트가 그 구간에 무엇을 그리는지 관찰할 수 있게 한다.
class _PendingAuthRepository extends FakeAuthRepository {
  _PendingAuthRepository();

  final Completer<Me> _gate = Completer<Me>();

  void release() => _gate.complete(me);

  @override
  Future<Me> fetchMe() => _gate.future;
}

Future<GoRouter> _pumpApp(
  WidgetTester tester, {
  required ProviderContainer container,
}) async {
  final GoRouter router = container.read(goRouterProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  return router;
}

void main() {
  testWidgets('인증이 해소되기 전에는 보호 화면이 렌더링되지 않는다 (AC-1)', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // 언어는 이미 선택됨 + 토큰은 저장돼 있음 → 게이트는 인증 확인 단계에 들어간다.
    final SecureStorage secure = await seededSecureStorage(
      authenticated: true,
      onboarded: true,
    );
    final _PendingAuthRepository repo = _PendingAuthRepository();

    final ProviderContainer container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        secureStorageProvider.overrideWithValue(secure),
        authRepositoryProvider.overrideWithValue(repo),
        // SPEC-0026: 홈 상단의 메시지 배지가 대화 목록을 받는다. 오버라이드가
        // 없으면 실제 GraphQL 클라이언트로 나가 타이머가 남는다.
        dmRepositoryProvider.overrideWithValue(FakeDmRepository()),
      ],
    );
    addTearDown(container.dispose);

    final GoRouter router = await _pumpApp(tester, container: container);

    // 인증이 아직 해소되지 않은 상태에서 보호 경로로 진입을 시도한다.
    router.go('/home');
    await tester.pump();

    // 게이트가 보호 경로를 해소하지 않고 통과시키면 그 구간에 보호 화면이 마운트되고
    // provider가 발화한다. 경로 자체가 /home에 머무르면 안 된다.
    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      isNot('/home'),
      reason: 'loading 구간에 보호 경로가 열려 있으면 provider가 발화한다',
    );
    expect(
      find.byType(HomeScreen),
      findsNothing,
      reason: '보호 화면은 한 프레임도 렌더링되지 않아야 한다',
    );

    // 대기 화면은 빈 화면이나 에러 화면이 아니어야 한다(AC-2) — 스플래시를 유지한다.
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(ErrorWidget), findsNothing);

    repo.release();
    // 스플래시의 최소 브랜드 노출 타이머(1.5s)를 흘려보내 대기 타이머를 정리한다.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
  });

  testWidgets('인증이 해소되면 보호 화면으로 들어갈 수 있다', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SecureStorage secure = await seededSecureStorage(
      authenticated: true,
      onboarded: true,
    );

    final ProviderContainer container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        secureStorageProvider.overrideWithValue(secure),
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        // SPEC-0026: 홈 상단의 메시지 배지가 대화 목록을 받는다. 오버라이드가
        // 없으면 실제 GraphQL 클라이언트로 나가 타이머가 남는다.
        dmRepositoryProvider.overrideWithValue(FakeDmRepository()),
      ],
    );
    addTearDown(container.dispose);
    // 게이트가 통과 상태가 되도록 인증을 먼저 해소한다.
    await container.read(authControllerProvider.future);

    final GoRouter router = await _pumpApp(tester, container: container);
    router.go('/home');
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('loading 중에도 로그인 화면은 막지 않는다', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SecureStorage secure = await seededSecureStorage(authenticated: true);
    final _PendingAuthRepository repo = _PendingAuthRepository();

    final ProviderContainer container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        secureStorageProvider.overrideWithValue(secure),
        authRepositoryProvider.overrideWithValue(repo),
        // SPEC-0026: 홈 상단의 메시지 배지가 대화 목록을 받는다. 오버라이드가
        // 없으면 실제 GraphQL 클라이언트로 나가 타이머가 남는다.
        dmRepositoryProvider.overrideWithValue(FakeDmRepository()),
      ],
    );
    addTearDown(container.dispose);

    final GoRouter router = await _pumpApp(tester, container: container);
    router.go('/login');
    await tester.pump();

    // 인증 경로는 loading 구간에도 그대로 열려 있어야 로그인 흐름이 막히지 않는다.
    expect(router.routerDelegate.currentConfiguration.uri.path, '/login');

    repo.release();
    // 스플래시의 최소 브랜드 노출 타이머(1.5s)를 흘려보내 대기 타이머를 정리한다.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
  });
}
