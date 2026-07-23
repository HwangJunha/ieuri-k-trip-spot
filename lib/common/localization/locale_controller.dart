import 'dart:ui' show Locale;

import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/app_preferences.dart';
import 'app_language.dart';

part 'locale_controller.g.dart';

/// Holds the active [Locale] for the whole app. Initialised from the saved
/// choice, or the device locale matched to a supported language (English
/// otherwise). Changing it re-renders every screen in the new language.
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Locale build() {
    final AppLanguage? saved = ref.watch(appPreferencesProvider).savedLanguage;
    if (saved != null) return saved.locale;

    final String deviceCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return AppLanguage.resolveDefault(deviceCode).locale;
  }

  Future<void> select(AppLanguage language) async {
    await ref.read(appPreferencesProvider).saveLanguage(language);
    state = language.locale;
  }

  AppLanguage get current =>
      AppLanguage.fromCode(state.languageCode) ?? AppLanguage.english;
}
