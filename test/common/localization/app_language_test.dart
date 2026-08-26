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

  // 언어 선택·설정·환경설정 세 화면이 모두 이 값을 그대로 쓴다(사용자 지적
  // 2026-08-26).
  group('nativeName', () {
    test('중국어는 괄호로 번체임을 밝힌다', () {
      // 중국어권 사용자에게는 간체냐 번체냐가 곧 읽을 수 있느냐의 문제다.
      expect(AppLanguage.chinese.nativeName, '中文（繁體）');
    });

    test('저마다 자기 문자로 적는다', () {
      expect(AppLanguage.english.nativeName, 'English');
      expect(AppLanguage.korean.nativeName, '한국어');
      expect(AppLanguage.japanese.nativeName, '日本語');
    });

    test('영어 이름을 덧붙이지 않는다', () {
      // "한국어 / Korean"처럼 보조 라벨을 함께 적지 않는다 — 자기 언어를 자기
      // 문자로 보여 주는 것으로 충분하다.
      for (final AppLanguage l in AppLanguage.values) {
        if (l == AppLanguage.english) continue;
        expect(
          RegExp(r'[A-Za-z]').hasMatch(l.nativeName),
          isFalse,
          reason: '${l.code}의 표기에 로마자가 섞였다: ${l.nativeName}',
        );
      }
    });
  });
}
