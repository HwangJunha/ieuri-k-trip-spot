import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';

void main() {
  group('AppLanguage.fromCode', () {
    test('returns the matching language for a supported code', () {
      expect(AppLanguage.fromCode('ja'), AppLanguage.japanese);
    });

    test('returns null for an unsupported or null code', () {
      expect(AppLanguage.fromCode('fr'), isNull);
      expect(AppLanguage.fromCode(null), isNull);
    });
  });

  group('AppLanguage.resolveDefault', () {
    test('matches a supported device language', () {
      expect(AppLanguage.resolveDefault('ko'), AppLanguage.korean);
    });

    test('falls back to English for an unsupported device language', () {
      expect(AppLanguage.resolveDefault('de'), AppLanguage.english);
    });
  });

  test('supportedLocales covers all four languages', () {
    expect(
      AppLanguage.supportedLocales.map((l) => l.languageCode).toSet(),
      <String>{'en', 'ko', 'ja', 'zh'},
    );
  });
}
