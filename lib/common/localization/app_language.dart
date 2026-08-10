import 'dart:ui' show Locale;

/// The languages the app supports. Korean is the translation source; the rest
/// are translations of it. [nativeName] is shown in the language picker in the
/// language's own script and is intentionally not localized.
enum AppLanguage {
  english('en', 'English', 'English', 'EN'),
  korean('ko', '한국어', 'Korean', 'KR'),
  japanese('ja', '日本語', 'Japanese', 'JP'),
  // 번체만 지원한다. 간체는 중국 본토용인데 본토에는 Play/App Store가 없어
  // 자체 스토어 등록 절차를 거쳐야 하므로 사실상 서비스할 수 없다.
  chinese('zh', '繁體中文', 'Chinese', 'TW');

  const AppLanguage(this.code, this.nativeName, this.englishName, this.badge);

  final String code;

  /// The language's own name, shown in the picker (not localized).
  final String nativeName;

  /// The English name, shown as a secondary label in the picker.
  final String englishName;

  /// Short code badge shown in the picker (EN/KR/JP/TW).
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
