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

/// **위치를 거부해도 앱은 열린다**(2026-08-29, SPEC-0001 R4).
///
/// 2026-08-26에 위치를 필수로 보고 두 자리에서 막았다 — 스플래시가 허용될 때까지
/// 붙잡고, 라우터 게이트가 `/location-required`로 보냈다. 그 구조가 App Store
/// 심사에서 거절됐다(Guideline 5.1.5 "위치 서비스를 끄면 앱이 동작하지 않는다",
/// 2.1(a) "데모 계정으로 앱에 접근할 수 없다" — 후자는 위치 판정이 인증보다 앞이라
/// 로그인 화면에조차 도달하지 못한 결과였다).
///
/// 이 테스트는 그 회귀를 막는다. 위치를 어떤 상태로 두든 부트 시퀀스가 끝나면
/// 스플래시를 떠나 인증 흐름으로 가야 한다.
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
      // 위치도 "한 번 물어봤으면 다시 묻지 않는다"를 따르게 되면서(2026-08-29)
      // 이 저장소를 읽는다. 메모리 페이크로 두어야 테스트끼리 기록이 새지 않는다.
      rationaleShownStoreProvider.overrideWithValue(FakeRationaleShownStore()),
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
  testWidgets('위치를 거부해도 앱에 들어간다 (App Store 5.1.5 회귀)', (tester) async {
    // 위치를 거부했고 OS도 허용하지 않는다.
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.denied,
        PermissionKind.notification: PermissionState.granted,
      },
      requestResult: {PermissionKind.location: PermissionState.denied},
    );
    final (router, _) = await _pumpBoot(tester, service);

    // 사전설명이 뜨고, OS 다이얼로그를 거쳐도 거부다.
    await tester.tap(find.text('Continue'));
    await _tick(tester);

    // **거부해도 앱이 열린다.** 예전에는 여기서 `/location-required`에 갇혔고,
    // 그 화면에서 나가는 길은 설정에서 위치를 켜는 것뿐이었다.
    expect(_path(router), '/login');
  });

  testWidgets('사전설명을 닫아도(나중에) 앱에 들어간다', (tester) async {
    // 닫을 수 없는 사전설명 모달은 그 자체로 심사 위험이다(Guideline 5.1.1).
    // 이제 위치 시트에도 "나중에"가 있고, 누르면 OS 요청 없이 넘어간다.
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.denied,
        PermissionKind.notification: PermissionState.granted,
      },
    );
    final (router, _) = await _pumpBoot(tester, service);

    expect(find.text('Not now'), findsOneWidget);
    await tester.tap(find.text('Not now'));
    await _tick(tester);

    expect(_path(router), '/login');
    // 거부를 눌렀으므로 OS 다이얼로그는 뜨지 않았어야 한다(R3 실패 경로).
    expect(service.calls, isNot(contains('request:location')));
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

  testWidgets('영구거부여도 앱에 들어간다 (R5는 화면별 안내가 맡는다)', (tester) async {
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.permanentlyDenied,
        PermissionKind.notification: PermissionState.granted,
      },
    );
    final (router, _) = await _pumpBoot(tester, service);

    // OS 다이얼로그를 띄울 수 없는 상태지만 앱을 막지 않는다 — 설정 이동 경로는
    // 좌표가 필요한 화면이 `LocationNeededNotice`로 각자 제공한다.
    expect(_path(router), '/login');

    // 이미 결정된 권한이라 사전설명도 띄우지 않는다(R6).
    expect(find.text('Continue'), findsNothing);
  });
}
