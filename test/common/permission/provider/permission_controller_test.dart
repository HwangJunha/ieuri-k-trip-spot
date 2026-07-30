import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_kind.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_state.dart';
import 'package:ieuri_k_trip_spot/common/permission/provider/permission_providers.dart';

import '../permission_test_doubles.dart';

ProviderContainer _container(FakePermissionService service) {
  final ProviderContainer container = ProviderContainer(
    overrides: [permissionServiceProvider.overrideWithValue(service)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('starts empty — nothing queried yet', () {
    final container = _container(FakePermissionService());
    expect(container.read(permissionControllerProvider), isEmpty);
  });

  test('check records the OS status for a kind', () async {
    final service = FakePermissionService(
      initial: {PermissionKind.location: PermissionState.granted},
    );
    final container = _container(service);
    final controller = container.read(permissionControllerProvider.notifier);

    final result = await controller.check(PermissionKind.location);

    expect(result, PermissionState.granted);
    expect(
      controller.stateOf(PermissionKind.location),
      PermissionState.granted,
    );
  });

  test('request records the OS decision', () async {
    final service = FakePermissionService(
      requestResult: {PermissionKind.notification: PermissionState.denied},
    );
    final container = _container(service);
    final controller = container.read(permissionControllerProvider.notifier);

    final result = await controller.request(PermissionKind.notification);

    expect(result, PermissionState.denied);
    expect(
      container.read(permissionControllerProvider)[PermissionKind.notification],
      PermissionState.denied,
    );
  });

  test('refreshAll re-reads only already-queried kinds (resume, R5)', () async {
    final service = FakePermissionService(
      initial: {PermissionKind.location: PermissionState.permanentlyDenied},
    );
    final container = _container(service);
    final controller = container.read(permissionControllerProvider.notifier);
    await controller.check(PermissionKind.location);

    // User flips it on in Settings, then the app resumes.
    service.setStatus(PermissionKind.location, PermissionState.granted);
    await controller.refreshAll();

    expect(
      controller.stateOf(PermissionKind.location),
      PermissionState.granted,
    );
    // Notification was never queried, so it must not be probed on resume.
    expect(controller.stateOf(PermissionKind.notification), isNull);
    expect(service.calls, isNot(contains('status:notification')));
  });

  test('refreshAll is a no-op when nothing has been queried', () async {
    final service = FakePermissionService();
    final container = _container(service);

    await container.read(permissionControllerProvider.notifier).refreshAll();

    expect(service.calls, isEmpty);
  });

  test('openSettings delegates to the service (R5)', () async {
    final service = FakePermissionService();
    final container = _container(service);

    final opened = await container
        .read(permissionControllerProvider.notifier)
        .openSettings();

    expect(opened, isTrue);
    expect(service.openSettingsCount, 1);
  });
}
