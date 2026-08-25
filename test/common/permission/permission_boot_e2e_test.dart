import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/permission/component/permission_boot_gate.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_kind.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_state.dart';
import 'package:ieuri_k_trip_spot/common/permission/provider/permission_providers.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import 'permission_test_doubles.dart';

/// End-to-end of the first-launch permission sequence (SPEC-0001): mounts the
/// real [PermissionBootGate] over a child screen and drives the whole flow
/// through a scripted [FakePermissionService] — the coordinator, the rationale
/// sheets, and the provider all run together, only the OS plugin is faked.
Future<ProviderContainer> _bootApp(
  WidgetTester tester,
  FakePermissionService service, {
  FakeRationaleShownStore? shownStore,
}) async {
  final container = ProviderContainer(
    overrides: [
      permissionServiceProvider.overrideWithValue(service),
      // 사전설명은 한 번만 뜬다 — 디스크 대신 메모리 기록으로 매 테스트를
      // "아직 안 물어본" 상태에서 시작한다. 재부팅을 흉내 내는 테스트는 같은
      // 저장소를 두 번의 부팅에 건네 기록이 살아남는 것을 확인한다.
      rationaleShownStoreProvider.overrideWithValue(
        shownStore ?? FakeRationaleShownStore(),
      ),
    ],
  );
  addTearDown(container.dispose);

  // The gate sits above the app's Navigator and shows sheets through this key —
  // the same wiring main.dart uses with the router's root navigator key.
  final navigatorKey = GlobalKey<NavigatorState>();

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        // The gate wraps the routed content exactly as main.dart wires it.
        builder: (context, child) => PermissionBootGate(
          navigatorKey: navigatorKey,
          child: child ?? const SizedBox.shrink(),
        ),
        home: const Scaffold(body: Center(child: Text('HOME'))),
      ),
    ),
  );
  // Let the post-first-frame callback fire and the first status check resolve.
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets(
    'both undetermined: rationales shown in order, both OS requests fire',
    (tester) async {
      final service = FakePermissionService(
        initial: {
          PermissionKind.location: PermissionState.denied,
          PermissionKind.notification: PermissionState.denied,
        },
        requestResult: {
          PermissionKind.location: PermissionState.granted,
          PermissionKind.notification: PermissionState.granted,
        },
      );
      final container = await _bootApp(tester, service);

      // The home screen is visible the whole time — permissions never block it.
      expect(find.text('HOME'), findsOneWidget);

      // Location rationale comes first (R2: sequential, location before notif).
      expect(find.text('Find spots around you'), findsOneWidget);
      expect(find.text('Stay in the loop'), findsNothing);
      // Location is mandatory ([AMEND]): its sheet offers no "Not now".
      expect(find.text('Not now'), findsNothing);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Only after the location flow ends does the notification rationale show.
      expect(find.text('Stay in the loop'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Both OS dialogs fired, location strictly before notification (R2).
      expect(service.calls, <String>[
        'status:location',
        'request:location',
        'status:notification',
        'request:notification',
      ]);
      expect(container.read(permissionControllerProvider), {
        PermissionKind.location: PermissionState.granted,
        PermissionKind.notification: PermissionState.granted,
      });
    },
  );

  testWidgets(
    'dismissing the optional notification rationale skips its OS request (R3)',
    (tester) async {
      // Location granted up front (mandatory), so the flow reaches the optional
      // notification sheet, which the user dismisses.
      final service = FakePermissionService(
        initial: {
          PermissionKind.location: PermissionState.granted,
          PermissionKind.notification: PermissionState.denied,
        },
      );
      final container = await _bootApp(tester, service);

      // Location was already granted → no location sheet, straight to notif.
      expect(find.text('Find spots around you'), findsNothing);
      expect(find.text('Stay in the loop'), findsOneWidget);

      // Dismiss the notification rationale → no OS request for notification.
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();

      expect(service.calls, <String>[
        'status:location',
        'status:notification',
        // no request:notification — the user dismissed the rationale
      ]);
      expect(
        container.read(
          permissionControllerProvider,
        )[PermissionKind.notification],
        PermissionState.denied,
      );
    },
  );

  testWidgets('already-decided permissions are not re-requested (R6)', (
    tester,
  ) async {
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.granted,
        PermissionKind.notification: PermissionState.permanentlyDenied,
      },
    );
    await _bootApp(tester, service);

    // No rationale sheet appears for either — both are already decided.
    expect(find.text('Find spots around you'), findsNothing);
    expect(find.text('Stay in the loop'), findsNothing);
    expect(find.text('HOME'), findsOneWidget);

    // Status was checked, but no OS request was ever made (R6).
    expect(service.calls, <String>['status:location', 'status:notification']);
  });

  testWidgets('notification denial never blocks the app (R4, optional)', (
    tester,
  ) async {
    // Location granted (mandatory satisfied); notification is requested and
    // denied — the app must still fall through to HOME.
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.granted,
        PermissionKind.notification: PermissionState.denied,
      },
      requestResult: {PermissionKind.notification: PermissionState.denied},
    );
    await _bootApp(tester, service);

    await tester.tap(find.text('Continue')); // notification → denied
    await tester.pumpAndSettle();

    // Notification denied, but the app is not blocked by it (R4 for the
    // optional permission).
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('location granted on the boot dialog satisfies the mandatory gate '
      '([AMEND] SPEC-0001)', (tester) async {
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.denied,
        PermissionKind.notification: PermissionState.granted,
      },
      requestResult: {PermissionKind.location: PermissionState.granted},
    );
    final container = await _bootApp(tester, service);

    // The mandatory location rationale is shown; Continue fires the OS dialog.
    expect(find.text('Find spots around you'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(
      container.read(permissionControllerProvider)[PermissionKind.location],
      PermissionState.granted,
    );
    expect(
      container.read(permissionControllerProvider.notifier).isLocationGranted,
      isTrue,
    );
  });

  testWidgets(
    'location not granted on the boot dialog is promoted to needs-Settings (R5)',
    (tester) async {
      // The OS dialog returns denied and won't prompt again — the app must route
      // the user to Settings rather than sit on the splash forever.
      final service = FakePermissionService(
        initial: {
          PermissionKind.location: PermissionState.denied,
          PermissionKind.notification: PermissionState.granted,
        },
        requestResult: {PermissionKind.location: PermissionState.denied},
      );
      final container = await _bootApp(tester, service);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Promoted so the splash can offer "open Settings" instead of re-prompting.
      final PermissionState? location = container.read(
        permissionControllerProvider,
      )[PermissionKind.location];
      expect(location, PermissionState.permanentlyDenied);
      expect(
        container.read(permissionControllerProvider.notifier).isLocationBlocked,
        isTrue,
      );
    },
  );

  testWidgets(
    'resume after Settings re-reads a flipped permission without restart (R5)',
    (tester) async {
      final service = FakePermissionService(
        initial: {
          PermissionKind.location: PermissionState.permanentlyDenied,
          PermissionKind.notification: PermissionState.granted,
        },
      );
      final container = await _bootApp(tester, service);

      // Boot queried both; location is blocked (needs Settings).
      expect(
        container.read(permissionControllerProvider)[PermissionKind.location],
        PermissionState.permanentlyDenied,
      );

      // User flips location on in the OS Settings app, then returns to the app.
      service.setStatus(PermissionKind.location, PermissionState.granted);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      // The flip is reflected immediately — no restart needed.
      expect(
        container.read(permissionControllerProvider)[PermissionKind.location],
        PermissionState.granted,
      );
    },
  );

  testWidgets('선택 권한 사전설명은 한 번 보여 주면 다시 뜨지 않는다', (tester) async {
    // "나중에"는 OS에 남지 않는다 — 요청 자체를 안 했으므로 다음 부팅에서도
    // 상태가 여전히 미결정이다. 그래서 앱을 켤 때마다 같은 시트가 떴다.
    final FakeRationaleShownStore shown = FakeRationaleShownStore();
    FakePermissionService newService() => FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.granted,
        PermissionKind.notification: PermissionState.denied,
      },
    );

    await _bootApp(tester, newService(), shownStore: shown);
    expect(find.text('Stay in the loop'), findsOneWidget);
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();

    // 물어봤다는 사실이 남는다 — 이것이 다음 부팅의 판단 근거다.
    expect(shown.wasShown(PermissionKind.notification), isTrue);

    // 두 번째 부팅 — 같은 기기이므로 기록이 살아 있다. 위젯 트리를 완전히
    // 버리고 새로 세워야 게이트의 initState가 다시 돈다.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    final FakePermissionService second = newService();
    await _bootApp(tester, second, shownStore: shown);

    expect(find.text('Stay in the loop'), findsNothing);
    // 상태는 조회하되 OS 요청은 하지 않는다.
    expect(second.calls, isNot(contains('request:notification')));
  });
}
