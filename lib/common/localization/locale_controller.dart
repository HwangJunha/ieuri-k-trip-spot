import 'dart:ui' show Locale;

import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/app_preferences.dart';
import 'app_language.dart';
import 'locale_invalidation.dart';

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

  /// 활성 언어를 [language]로 바꾼다.
  ///
  /// **상태만 바꾸지 않는다**(SPEC-0029 R-18·R-26). 언어가 spot의 열람 가능 여부를
  /// 가르므로, 들고 있던 spot id는 새 언어에서 해소되지 않을 수 있다 — 비우지 않으면
  /// 조용히 틀린 데이터이거나 오류 화면이 된다.
  ///
  /// **상태를 먼저 바꾸고 무효화한다.** 순서가 반대면 무효화가 촉발한 재조회가 아직
  /// 이전 언어의 `Accept-Language`를 싣고 나가, 방금 비운 자리를 낡은 응답으로 다시
  /// 채운다.
  Future<void> select(AppLanguage language) async {
    if (state == language.locale) return;

    await ref.read(appPreferencesProvider).saveLanguage(language);
    state = language.locale;

    invalidateLocaleScopedState(ref);
  }

  AppLanguage get current =>
      AppLanguage.fromCode(state.languageCode) ?? AppLanguage.english;
}
