import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/component/post_topic_label.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_topic.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

void main() {
  // 설계 §7 — 네 언어 모두 문자열이 있고 누락된 값이 없어야 한다. 서버가 표시명을
  // 내려주지 않으므로(POL-023) 이 매핑이 비면 칩이 빈 채로 뜬다.
  test('모든 PostTopic이 네 언어에서 비어 있지 않은 표시명을 가진다', () async {
    for (final Locale locale in AppLocalizations.supportedLocales) {
      final AppLocalizations l10n = await AppLocalizations.delegate.load(
        locale,
      );
      for (final PostTopic topic in PostTopic.values) {
        expect(
          postTopicLabel(l10n, topic),
          isNotEmpty,
          reason: '${locale.languageCode} / ${topic.name}',
        );
      }
    }
  });

  test('같은 언어 안에서 주제별 표시명이 서로 다르다', () async {
    final AppLocalizations l10n = await AppLocalizations.delegate.load(
      const Locale('en'),
    );
    final Set<String> labels = PostTopic.values
        .map((PostTopic t) => postTopicLabel(l10n, t))
        .toSet();

    expect(labels, hasLength(PostTopic.values.length));
  });

  group('상대 시각', () {
    late AppLocalizations l10n;
    final DateTime now = DateTime.utc(2026, 8, 5, 12);

    setUp(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    test('1분 미만은 "방금"이다', () {
      expect(
        relativePostTime(l10n, now.subtract(const Duration(seconds: 30)), now),
        l10n.communityTimeJustNow,
      );
    });

    test('분·시간·일 단위로 눈금이 바뀐다', () {
      expect(
        relativePostTime(l10n, now.subtract(const Duration(minutes: 5)), now),
        l10n.communityTimeMinutes(5),
      );
      expect(
        relativePostTime(l10n, now.subtract(const Duration(hours: 3)), now),
        l10n.communityTimeHours(3),
      );
      expect(
        relativePostTime(l10n, now.subtract(const Duration(days: 2)), now),
        l10n.communityTimeDays(2),
      );
    });

    // 서버 시계가 앞서면 음수가 나온다. 미래 시각을 "-3분 전"으로 보여주지 않는다.
    test('미래 시각은 "방금"으로 접힌다', () {
      expect(
        relativePostTime(l10n, now.add(const Duration(minutes: 5)), now),
        l10n.communityTimeJustNow,
      );
    });
  });
}
