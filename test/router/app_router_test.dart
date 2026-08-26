import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_qa_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/seen_answer_counts_providers.dart';
import '../domain/spot_qa/spot_qa_test_doubles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/common/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/domain/settings/model/agreement_status.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/agreements_controller.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/common/permission/provider/permission_providers.dart';
import 'package:ieuri_k_trip_spot/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/auth/auth_test_doubles.dart';
import '../domain/settings/settings_test_doubles.dart';
import '../domain/spot/spot_test_doubles.dart';
import '../common/permission/permission_test_doubles.dart';

Future<ProviderContainer> _container({
  required bool authed,
  required bool onboarded,
  List<AgreementStatus>? agreements,
  FakeSettingsRepository? repo,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
  final prefs = await SharedPreferences.getInstance();
  final SecureStorage secure = await seededSecureStorage(
    authenticated: authed,
    onboarded: onboarded,
  );

  final ProviderContainer container = ProviderContainer(
    overrides: [
      permissionServiceProvider.overrideWithValue(grantedPermissionService()),
      sharedPreferencesProvider.overrideWithValue(prefs),
      secureStorageProvider.overrideWithValue(secure),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        // SPEC-0026: 홈 상단 「내 질문」 배지가 로그인 상태에서 목록을 받는다.
        // 오버라이드가 없으면 실제 GraphQL 클라이언트로 나가 타이머가 남는다.
        spotQaRepositoryProvider.overrideWithValue(FakeSpotQaRepository()),
        seenAnswerCountsStoreProvider.overrideWithValue(
          FakeSeenAnswerCountsStore(),
        ),
      // 착지점이 Discover라 스팟 조회가 실제로 돈다 — 네트워크 없이 끝나도록 스텁.
      spotRepositoryProvider.overrideWithValue(FakeSpotRepository()),
      // 게이트가 필수 약관 상태를 읽는다(SPEC-0011 R11) — 기본은 충족 상태여야
      // 인증·온보딩 판정을 관찰할 수 있고, 약관 게이트를 보려는 테스트만 미동의
      // 목록을 넘긴다.
      settingsRepositoryProvider.overrideWithValue(
        repo ?? FakeSettingsRepository(agreements: agreements),
      ),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
    ],
  );
  addTearDown(container.dispose);
  // Resolve auth state before redirects evaluate.
  await container.read(authControllerProvider.future);
  await seedGrantedPermissions(container);
  return container;
}

Future<String> _land(WidgetTester tester, ProviderContainer container) async {
  final GoRouter router = container.read(goRouterProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router.routerDelegate.currentConfiguration.uri.path;
}

void main() {
  testWidgets('unauthenticated user is pinned to the login gate', (
    tester,
  ) async {
    final container = await _container(authed: false, onboarded: false);
    container.read(goRouterProvider).goNamed('home');
    expect(await _land(tester, container), '/login');
  });

  testWidgets('authenticated but not onboarded goes to onboarding', (
    tester,
  ) async {
    final container = await _container(authed: true, onboarded: false);
    container.read(goRouterProvider).goNamed('home');
    expect(await _land(tester, container), '/onboarding');
  });

  // 로그인·온보딩을 마치면 홈이 아니라 Discover로 착지한다 — 앱의 핵심 동선이
  // 스와이프이므로 바로 카드를 보게 한다.
  testWidgets('authenticated and onboarded reaches discover', (tester) async {
    final container = await _container(authed: true, onboarded: true);
    container.read(goRouterProvider).goNamed('login');
    expect(await _land(tester, container), '/discover');
  });

  // 필수 약관 게이트가 실제 라우터에서 도는지 본다(R11·R12). 판정 자체는
  // `route_gate_test.dart`가 표처럼 덮고, 여기서는 **라우터에 실제로 연결됐는지**와
  // 해제 후 복귀가 일어나는지를 확인한다 — 순수 함수 테스트만으로는 배선이 빠져도
  // 통과하기 때문이다(실제로 `take()`가 아무 데서도 안 불리는 상태가 있었다).
  testWidgets('미동의 필수 약관이 있으면 동의 화면으로 보낸다 (R11)', (tester) async {
    final container = await _container(
      authed: true,
      onboarded: true,
      agreements: _unmetRequired(),
    );
    container.read(goRouterProvider).goNamed('home');

    expect(await _land(tester, container), '/required-terms');
  });

  testWidgets('미동의여도 설정 계열은 열려 있다 (R11)', (tester) async {
    final container = await _container(
      authed: true,
      onboarded: true,
      agreements: _unmetRequired(),
    );
    container.read(goRouterProvider).goNamed('settings');

    expect(await _land(tester, container), '/settings');
  });

  testWidgets('동의하면 게이트에 막히기 전 목적지로 돌아간다 (R12)', (tester) async {
    final FakeSettingsRepository repo = FakeSettingsRepository(
      agreements: _unmetRequired(),
    );
    final container = await _container(
      authed: true,
      onboarded: true,
      repo: repo,
    );
    // 보관함으로 가려다 게이트에 막힌다(SPEC-0030 R18로 커뮤니티가 그 안으로
    // 들어갔다 — 검사하는 것은 "기본 착지점이 아닌 곳"이면 무엇이든 된다).
    container.read(goRouterProvider).goNamed('library');
    expect(await _land(tester, container), '/required-terms');

    // 동의하면 게이트가 풀리고 **원래 가려던 곳**으로 복귀한다 — 기본 착지점인
    // /discover가 아니다.
    await container
        .read(agreementsControllerProvider.notifier)
        .agreeToRequired();
    await tester.pumpAndSettle();

    expect(
      container
          .read(goRouterProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .path,
      '/library',
    );
  });
}

/// 필수 하나가 미동의인 목록 — 게이트가 닫힌 상태를 만든다.
List<AgreementStatus> _unmetRequired() => <AgreementStatus>[
  agreement(
    TermsCode.service,
    required: true,
    agreed: true,
    agreedAt: '2026-01-12',
  ),
  agreement(TermsCode.privacy, required: true),
];
