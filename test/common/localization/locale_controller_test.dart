import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/localization/locale_controller.dart';
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

  test('defaults to a supported locale when nothing is saved', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final container = await _container();
    addTearDown(container.dispose);

    final locale = container.read(localeControllerProvider);
    expect(
      AppLanguage.supportedLocales.map((l) => l.languageCode),
      contains(locale.languageCode),
    );
  });

  test('select() updates state and persists the choice', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final container = await _container();
    addTearDown(container.dispose);

    await container
        .read(localeControllerProvider.notifier)
        .select(AppLanguage.korean);

    expect(container.read(localeControllerProvider).languageCode, 'ko');
    expect(
      container.read(appPreferencesProvider).savedLanguage,
      AppLanguage.korean,
    );
  });

  test('restores the saved language on build', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'ja'});
    final container = await _container();
    addTearDown(container.dispose);

    expect(container.read(localeControllerProvider).languageCode, 'ja');
  });
}
