import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/navigation/root_navigator_key.dart';
import 'package:ieuri_k_trip_spot/common/permission/component/permission_boot_gate.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_kind.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_state.dart';
import 'package:ieuri_k_trip_spot/common/permission/provider/permission_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/auth/auth_test_doubles.dart';
import '../permission/permission_test_doubles.dart';

/// [AMEND] SPEC-0001: 위치는 필수 권한이다. 다만 **막는 자리가 옮겨졌다**
/// (2026-08-26): 예전에는 스플래시가 위치를 허용할 때까지 붙잡고 있었지만, 이제는
/// 라우터 게이트가 `/location-required`로 보낸다.
///
/// 스플래시에 세워 두면 거부한 사용자에게 남는 길이 그 화면의 안내뿐이라
/// 로그아웃·언어 변경 같은 탈출구가 없었다. 게이트로 옮기면 판정이 한곳에 모이고
/// (`route_gate.dart`) 설정 계열이 열려 있어 빠져나갈 수 있다.
///
/// 실제 스플래시·라우터·[PermissionBootGate]를 그대로 돌리고 OS 권한 결과만
/// 페이크로 바꾼다.
Future<(GoRouter, ProviderContainer)> _pumpBoot(
  WidgetTester tester,
  FakePermissionService service,
) async {
  SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
  final prefs = await SharedPreferences.getInstance();
  final SecureStorage secure = await seededSecureStorage(authenticated: false);

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secureStorageProvider.overrideWithValue(secure),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      permissionServiceProvider.overrideWithValue(service),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);

  final GoRouter router = container.read(goRouterProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        builder: (context, child) => PermissionBootGate(
          navigatorKey: rootNavigatorKey,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    ),
  );
  // The splash shows a looping progress bar, so pumpAndSettle would never
  // settle. Pump past the 1.5s min brand delay and let the boot sheets appear.
  await _tick(tester);
  return (router, container);
}

/// Advances time enough for the splash min-delay and any pending sheet/route
/// transition to complete, without waiting on the never-ending progress bar.
Future<void> _tick(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
}

String _path(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.path;

void main() {
  testWidgets('거부하면 위치 안내 화면으로 보낸다 — 앱 전체가 막힌다', (tester) async {
    // 위치를 거부했고 OS도 허용하지 않는다.
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.denied,
        PermissionKind.notification: PermissionState.granted,
      },
      requestResult: {PermissionKind.location: PermissionState.denied},
    );
    final (router, _) = await _pumpBoot(tester, service);

    // 필수 사전설명이 뜨고, OS 다이얼로그를 거쳐도 거부다.
    await tester.tap(find.text('Continue'));
    await _tick(tester);

    // 언어가 'en'으로 이미 정해져 있어도 로그인으로 가지 않는다 — 위치 게이트가
    // 먼저 막는다. 예전에는 여기서 스플래시('/')에 머물렀다.
    expect(_path(router), '/location-required');
  });

  testWidgets('splash advances once location is granted', (tester) async {
    // Location granted on the boot dialog → the splash hands off past `/`.
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.denied,
        PermissionKind.notification: PermissionState.granted,
      },
      requestResult: {PermissionKind.location: PermissionState.granted},
    );
    final (router, _) = await _pumpBoot(tester, service);

    await tester.tap(find.text('Continue')); // location granted
    await _tick(tester);

    // Language is already 'en', so the redirect chain lands on the login gate.
    expect(_path(router), '/login');
  });

  testWidgets('notification is still prompted after location, and dismissing it '
      'advances the splash (optional, R2)', (tester) async {
    // Location already granted; notification undecided → the splash must NOT
    // route yet: the optional notification prompt still has to run first.
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.granted,
        PermissionKind.notification: PermissionState.denied,
      },
      requestResult: {PermissionKind.notification: PermissionState.denied},
    );
    final (router, _) = await _pumpBoot(tester, service);

    // 알림 사전설명이 뜨고 스플래시는 아직 '/'다 — 위치 허용만으로 알림 프롬프트를
    // 건너뛰지 않는다는 뜻이다(R2).
    expect(find.text('Stay in the loop'), findsOneWidget);
    expect(_path(router), '/');

    // Dismissing the optional prompt completes the sequence → splash advances.
    await tester.tap(find.text('Not now'));
    await _tick(tester);

    expect(_path(router), '/login');
  });

  testWidgets(
    '영구거부는 설정 경로를 주고, 설정에서 켜고 돌아오면 게이트가 풀린다 (R5)',
    (tester) async {
      final service = FakePermissionService(
        initial: {
          PermissionKind.location: PermissionState.permanentlyDenied,
          PermissionKind.notification: PermissionState.granted,
        },
      );
      final (router, _) = await _pumpBoot(tester, service);

      // OS 다이얼로그를 띄울 수 없으므로 설정 경로를 주고 안내 화면에 세운다.
      expect(find.text('Open Settings'), findsOneWidget);
      expect(_path(router), '/location-required');

      // 설정에서 위치를 켜고 돌아오면 resume 재조회가 허용을 기록하고,
      // `GoRouterRefreshStream`이 그 변화를 듣고 게이트를 다시 평가한다.
      service.setStatus(PermissionKind.location, PermissionState.granted);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await _tick(tester);

      expect(_path(router), '/login');
    },
  );
}
