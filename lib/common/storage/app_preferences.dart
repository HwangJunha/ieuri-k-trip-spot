import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/app_language.dart';

part 'app_preferences.g.dart';

/// The [SharedPreferences] instance, loaded once in `main()` and injected via
/// an override on this provider.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');

@Riverpod(keepAlive: true)
AppPreferences appPreferences(Ref ref) =>
    AppPreferences(ref.watch(sharedPreferencesProvider));

/// Thin wrapper over [SharedPreferences] for non-secret app flags: the chosen
/// locale and whether onboarding has been completed. Secrets never go here —
/// tokens use secure storage (Step 2).
class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const String _localeKey = 'locale';
  static const String _onboardingKey = 'onboarding_completed';

  AppLanguage? get savedLanguage =>
      AppLanguage.fromCode(_prefs.getString(_localeKey));

  Future<void> saveLanguage(AppLanguage language) =>
      _prefs.setString(_localeKey, language.code);

  bool get onboardingCompleted => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingCompleted({required bool completed}) =>
      _prefs.setBool(_onboardingKey, completed);
}
