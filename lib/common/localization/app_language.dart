import 'dart:ui' show Locale;

/// The languages the app supports. Korean is the translation source; the rest
/// are translations of it. [nativeName] is shown in the language picker in the
/// language's own script and is intentionally not localized.
enum AppLanguage {
  english('en', 'English', 'English', 'EN'),
  korean('ko', '한국어', 'Korean', 'KR'),
  japanese('ja', '日本語', 'Japanese', 'JP'),
  chinese('zh', '简体中文', 'Chinese', 'CN');

  const AppLanguage(this.code, this.nativeName, this.englishName, this.badge);

  final String code;

  /// The language's own name, shown in the picker (not localized).
  final String nativeName;

  /// The English name, shown as a secondary label in the picker.
  final String englishName;

  /// Short code badge shown in the picker (EN/KR/JP/CN).
  final String badge;

  Locale get locale => Locale(code);

  static AppLanguage? fromCode(String? code) {
    if (code == null) return null;
    for (final AppLanguage language in values) {
      if (language.code == code) return language;
    }
    return null;
  }

  /// The default language when nothing is saved: match the device locale to a
  /// supported language, falling back to English.
  static AppLanguage resolveDefault(String deviceLanguageCode) =>
      fromCode(deviceLanguageCode) ?? AppLanguage.english;

  static List<Locale> get supportedLocales =>
      values.map((AppLanguage language) => language.locale).toList();
}
