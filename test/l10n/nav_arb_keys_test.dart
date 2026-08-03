import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// SPEC-0008 R-14. 하단 내비 라벨은 EN/KO/JA/ZH 네 언어에 전부 값이 있어야 하고
/// (AC-43 · POL-022), 쓰이지 않게 된 키는 남기지 않는다(AC-44).
///
/// 위젯을 세우지 않고 `.arb` 키 존재만 검사한다(설계 §6).
const List<String> _locales = <String>['en', 'ko', 'ja', 'zh'];

/// 탭이 5개이므로 라벨도 5개다. `navLiked`·`navCommunity`가 `navEvents`·`navChat`을
/// 대체한다.
const List<String> _requiredKeys = <String>[
  'navHome',
  'navMap',
  'navDiscover',
  'navLiked',
  'navCommunity',
  'likedSpotsEmpty',
];

/// 대체되어 더는 참조되지 않는 키.
const List<String> _retiredKeys = <String>['navEvents', 'navChat'];

Map<String, dynamic> _arb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  for (final String locale in _locales) {
    test('$locale has every nav label with a non-empty value', () {
      final Map<String, dynamic> arb = _arb(locale);
      for (final String key in _requiredKeys) {
        expect(arb[key], isA<String>(), reason: '$locale is missing $key');
        expect(
          (arb[key] as String).trim(),
          isNotEmpty,
          reason: '$locale has an empty $key',
        );
      }
    });

    test('$locale keeps no retired nav keys', () {
      final Map<String, dynamic> arb = _arb(locale);
      for (final String key in _retiredKeys) {
        expect(arb.containsKey(key), isFalse, reason: '$locale still has $key');
      }
    });
  }
}
