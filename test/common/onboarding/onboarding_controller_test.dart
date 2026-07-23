import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/onboarding/provider/onboarding_controller.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _container() async {
  final prefs = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('is false on first run', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final container = await _container();
    addTearDown(container.dispose);

    expect(container.read(onboardingControllerProvider), isFalse);
  });

  test('complete() flips state and persists', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final container = await _container();
    addTearDown(container.dispose);

    await container.read(onboardingControllerProvider.notifier).complete();

    expect(container.read(onboardingControllerProvider), isTrue);
    expect(
      container.read(appPreferencesProvider).onboardingCompleted,
      isTrue,
    );
  });

  test('reads true when previously completed', () async {
    SharedPreferences.setMockInitialValues(
      <String, Object>{'onboarding_completed': true},
    );
    final container = await _container();
    addTearDown(container.dispose);

    expect(container.read(onboardingControllerProvider), isTrue);
  });
}
