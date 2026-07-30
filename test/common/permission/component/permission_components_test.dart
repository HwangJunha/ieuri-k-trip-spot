import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/permission/component/permission_blocked_notice.dart';
import 'package:ieuri_k_trip_spot/common/permission/component/permission_rationale_sheet.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_kind.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_state.dart';
import 'package:ieuri_k_trip_spot/common/permission/provider/permission_providers.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../permission_test_doubles.dart';

const List<LocalizationsDelegate<Object>> _delegates =
    <LocalizationsDelegate<Object>>[
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

/// A localized [MaterialApp] shell around [home], sharing an existing
/// [container] so tests can seed permission state before pumping.
Widget _shell(ProviderContainer container, Widget home) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      localizationsDelegates: _delegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: home,
    ),
  );
}

ProviderContainer _container(FakePermissionService service) {
  final container = ProviderContainer(
    overrides: [permissionServiceProvider.overrideWithValue(service)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('PermissionRationaleSheet', () {
    testWidgets('Continue resolves to true and shows location copy', (
      tester,
    ) async {
      bool? result;
      await tester.pumpWidget(
        _shell(
          _container(FakePermissionService()),
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await PermissionRationaleSheet.show(
                      context,
                      PermissionKind.location,
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Find spots around you'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('Not now resolves to false — R3 failure path', (tester) async {
      bool? result;
      await tester.pumpWidget(
        _shell(
          _container(FakePermissionService()),
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await PermissionRationaleSheet.show(
                      context,
                      PermissionKind.notification,
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });
  });

  group('PermissionBlockedNotice', () {
    testWidgets('renders nothing for a plain denial (R4)', (tester) async {
      final service = FakePermissionService(
        initial: {PermissionKind.location: PermissionState.denied},
      );
      final container = _container(service);
      await container
          .read(permissionControllerProvider.notifier)
          .check(PermissionKind.location);

      await tester.pumpWidget(
        _shell(
          container,
          const Scaffold(
            body: PermissionBlockedNotice(kind: PermissionKind.location),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Open Settings'), findsNothing);
    });

    testWidgets('shows notice + Open Settings when permanently denied (R5)', (
      tester,
    ) async {
      final service = FakePermissionService(
        initial: {PermissionKind.location: PermissionState.permanentlyDenied},
      );
      final container = _container(service);
      await container
          .read(permissionControllerProvider.notifier)
          .check(PermissionKind.location);

      await tester.pumpWidget(
        _shell(
          container,
          const Scaffold(
            body: PermissionBlockedNotice(kind: PermissionKind.location),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Open Settings'), findsOneWidget);

      await tester.tap(find.text('Open Settings'));
      await tester.pump();
      expect(service.openSettingsCount, 1);
    });
  });
}
