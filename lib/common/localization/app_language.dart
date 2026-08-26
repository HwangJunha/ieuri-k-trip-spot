import 'dart:ui' show Locale;

/// The languages the app supports. Korean is the translation source; the rest
/// are translations of it. [nativeName] is shown in the language picker in the
/// language's own script and is intentionally not localized.
enum AppLanguage {
  english('en', 'English', 'EN'),
  korean('ko', '한국어', 'KR'),
  japanese('ja', '日本語', 'JP'),
  // 번체만 지원한다. 간체는 중국 본토용인데 본토에는 Play/App Store가 없어
  // 자체 스토어 등록 절차를 거쳐야 하므로 사실상 서비스할 수 없다.
  //
  // **표기에 괄호로 번체를 밝힌다**(사용자 지적 2026-08-26). 중국어권 사용자에게
  // 간체인지 번체인지가 곧 읽을 수 있느냐의 문제라, 고르기 전에 알려야 한다.
  // 전각 괄호（）를 쓴다 — 중문 조판의 표준이고 반각을 섞으면 자간이 튄다.
  chinese('zh', '中文（繁體）', 'TW');

  const AppLanguage(this.code, this.nativeName, this.badge);

  final String code;

  /// The language's own name, shown in the picker (not localized).
  ///
  /// **영어 이름을 따로 두지 않는다**(사용자 지적 2026-08-26). 언어 선택 화면에
  /// "English / Korean / Japanese / Chinese"를 보조 라벨로 함께 적었는데, 자기
  /// 언어를 자기 문자로 보여 주는 것이 이미 목적을 다한다 — 영어를 못 읽는
  /// 사용자에게는 군더더기이고, 읽는 사용자에게도 같은 말의 반복이다.
  final String nativeName;

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
