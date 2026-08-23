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
    // **저장은 언제나 한다.** 값이 같다고 여기서 돌아서면 첫 실행 언어 선택이
    // 먹히지 않는다 — 기기 언어가 한국어면 [build]가 이미 한국어로 시작하므로,
    // 사용자가 한국어 그대로 확인해도 `state == locale` 이라 저장을 건너뛰었다.
    // 그러면 `savedLanguage` 가 null 로 남고 라우터 게이트가 다시 이 화면으로
    // 돌려보내, 버튼이 안 눌리는 것처럼 보였다.
    await ref.read(appPreferencesProvider).saveLanguage(language);

    // 화면을 다시 세우고 언어에 매인 상태를 비우는 일은 **실제로 바뀔 때만**
    // 한다. 같은 언어에 이것까지 돌리면 들고 있던 목록이 이유 없이 사라진다.
    if (state == language.locale) return;

    state = language.locale;
    invalidateLocaleScopedState(ref);
  }

  AppLanguage get current =>
      AppLanguage.fromCode(state.languageCode) ?? AppLanguage.english;
}
