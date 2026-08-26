import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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

  // 중국어 폰트를 SC(간체)에서 TC(번체)로 바꿨다(사용자 지적 2026-08-26).
  // 앱이 스스로 '繁體中文'이라 하고 서버에 TW를 보내는데 폰트만 간체였다.
  // TC 폰트에는 간체 글리프가 없어, 문자열에 간체가 남으면 **두부(□)로 깨진다.**
  group('번들 폰트가 모든 문구를 그릴 수 있다', () {
    test('네 언어의 모든 글자가 번들 폰트 안에 있다', () {
      final Set<int> covered = _bundledFontCoverage();
      expect(
        covered,
        isNotEmpty,
        reason: '폰트를 하나도 읽지 못했다 — asset/fonts 경로를 확인하라',
      );

      final Map<String, Set<String>> missing = <String, Set<String>>{};
      for (final String locale in _locales) {
        for (final MapEntry<String, dynamic> e in _arb(locale).entries) {
          if (e.key.startsWith('@') || e.value is! String) continue;
          for (final int cp in (e.value as String).runes) {
            // ASCII는 어떤 폰트에나 있다. 시스템 폴백이 도는 이모지도 제외한다.
            if (cp <= 0x7F || cp >= 0x1F000) continue;
            if (!covered.contains(cp)) {
              (missing['$locale/${e.key}'] ??= <String>{})
                  .add(String.fromCharCode(cp));
            }
          }
        }
      }

      expect(
        missing,
        isEmpty,
        reason:
            '번들 폰트로 못 그리는 글자가 있다(화면에 □로 나온다): '
            '${missing.entries.take(5).map((MapEntry<String, Set<String>> e) => "${e.key}=${e.value.join()}").join(", ")}',
      );
    });
  });
}

/// `asset/fonts/`에 실린 폰트 전부가 그릴 수 있는 코드포인트.
///
/// `cmap` 테이블을 직접 읽는다 — 폰트 라이브러리를 테스트에 들이지 않기 위해서다.
/// 형식 4(BMP)와 12(전체 평면)만 읽으면 Noto 계열은 전부 커버된다.
Set<int> _bundledFontCoverage() {
  final Set<int> out = <int>{};
  final Directory dir = Directory('asset/fonts');
  if (!dir.existsSync()) return out;

  for (final FileSystemEntity f in dir.listSync(recursive: true)) {
    if (f is! File || !f.path.endsWith('.ttf')) continue;
    out.addAll(_cmapCodePoints(f.readAsBytesSync()));
  }
  return out;
}

Set<int> _cmapCodePoints(Uint8List bytes) {
  final ByteData d = ByteData.sublistView(bytes);
  final Set<int> out = <int>{};

  final int numTables = d.getUint16(4);
  int? cmapOffset;
  for (int i = 0; i < numTables; i++) {
    final int rec = 12 + i * 16;
    final String tag = String.fromCharCodes(bytes.sublist(rec, rec + 4));
    if (tag == 'cmap') {
      cmapOffset = d.getUint32(rec + 8);
      break;
    }
  }
  if (cmapOffset == null) return out;

  // 유니코드 서브테이블을 고른다. 전체 평면(3,10)이 있으면 그것을 쓴다.
  final int n = d.getUint16(cmapOffset + 2);
  int? best;
  for (int i = 0; i < n; i++) {
    final int rec = cmapOffset + 4 + i * 8;
    final int pid = d.getUint16(rec);
    final int eid = d.getUint16(rec + 2);
    final int sub = cmapOffset + d.getUint32(rec + 4);
    if (pid == 3 && eid == 10) {
      best = sub;
      break;
    }
    if (best == null &&
        ((pid == 3 && eid == 1) || (pid == 0 && (eid == 3 || eid == 4)))) {
      best = sub;
    }
  }
  if (best == null) return out;

  switch (d.getUint16(best)) {
    case 12:
      final int groups = d.getUint32(best + 12);
      for (int g = 0; g < groups; g++) {
        final int rec = best + 16 + g * 12;
        final int start = d.getUint32(rec);
        final int end = d.getUint32(rec + 4);
        // 이모지 평면까지 펼치면 수십만 개가 되어 테스트가 느려진다.
        for (int c = start; c <= end && c < 0x1F000; c++) {
          out.add(c);
        }
      }
    case 4:
      final int segX2 = d.getUint16(best + 6);
      final int seg = segX2 ~/ 2;
      final int endsAt = best + 14;
      final int startsAt = endsAt + segX2 + 2;
      for (int i = 0; i < seg; i++) {
        final int end = d.getUint16(endsAt + i * 2);
        final int start = d.getUint16(startsAt + i * 2);
        for (int c = start; c <= end && c != 0xFFFF; c++) {
          out.add(c);
        }
      }
  }
  return out;
}
