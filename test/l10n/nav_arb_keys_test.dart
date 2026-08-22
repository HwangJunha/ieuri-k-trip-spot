import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// SPEC-0008 R-14. 하단 내비 라벨은 EN/KO/JA/ZH 네 언어에 전부 값이 있어야 하고
/// (AC-43 · POL-022), 쓰이지 않게 된 키는 남기지 않는다(AC-44).
///
/// 위젯을 세우지 않고 `.arb` 키 존재만 검사한다(설계 §6).
const List<String> _locales = <String>['en', 'ko', 'ja', 'zh'];

/// 탭이 5개이므로 탭 라벨도 5개다(SPEC-0030 R17: 홈·전국 지도·둘러보기·보관함·지도).
///
/// `navLiked`·`navCommunity`는 **탭 라벨에서는 빠졌지만 지워지지 않는다** —
/// 보관함의 세그먼트 토글이 같은 문구를 쓴다(R18). 그래서 폐기 키가 아니다.
const List<String> _requiredKeys = <String>[
  'navHome',
  'navNationalMap',
  'navDiscover',
  'navLibrary',
  'navMap',
  'navLiked',
  'navCommunity',
  'likedSpotsEmpty',
  'likedSpotsUnavailable',
  // SPEC-0013 홈 섹션 — 세 섹션 모두 빈 상태 문구를 갖는다(설계 §2). 빈 섹션을
  // 빈 공간으로 두지 않는 것이 요건이므로 문구 부재는 곧 요건 미충족이다.
  'homeSectionNearYou',
  'homeNearYouEmpty',
  'homeHappeningNowEmpty',
  'homePopularEmpty',
  'homeSectionRetry',
  'homeSectionError',
];

/// 대체되어 더는 참조되지 않는 키.
///
/// SPEC-0013이 별점·혼잡도를 **모델에서 제거**했다(R15, AC-15.2·AC-15.3). 화면에서
/// 감추는 것으로는 부족해 문구까지 지웠고, 여기서 되살아나지 않는지 지킨다 —
/// 키가 남아 있으면 다음 사람이 "쓰던 문구가 있네" 하고 다시 붙인다.
const List<String> _retiredKeys = <String>[
  'navEvents',
  'navChat',
  'congestionLow',
  'congestionModerate',
  'congestionHigh',
  'distanceAway',
  // "Recommended for You" → "Near You"(R16 — 거리순이지 취향 추론이 아니다).
  'homeSectionRecommended',
];

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
