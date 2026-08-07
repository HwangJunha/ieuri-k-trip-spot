import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/component/community_labels.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot_category.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

/// 서버는 표시 문자열을 주지 않는다 — enum은 안정 식별자이고 매핑은 클라이언트
/// 몫이다(POL-023, 가이드 §9). 네 언어 전부에서 값이 채워지는지 확인한다.
Future<AppLocalizations> _l10n(WidgetTester tester, Locale locale) async {
  late AppLocalizations l10n;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Builder(
        builder: (BuildContext context) {
          l10n = AppLocalizations.of(context);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
  return l10n;
}

void main() {
  for (final Locale locale in const <Locale>[
    Locale('en'),
    Locale('ko'),
    Locale('ja'),
    Locale('zh'),
  ]) {
    testWidgets('${locale.languageCode}: 9개 카테고리 모두 표시명이 있다', (
      WidgetTester tester,
    ) async {
      final AppLocalizations l10n = await _l10n(tester, locale);

      for (final TargetCategory category in TargetCategory.values) {
        expect(
          targetCategoryLabel(l10n, category),
          isNotEmpty,
          reason: '$category 표시명 누락',
        );
      }
    });

    // 장소 카테고리는 **글 카테고리와 같은 ARB 키를 재사용한다** — 식별자가 같고
    // 커뮤니티 안에서 같은 뜻으로 읽히므로 키를 9개 복제하지 않는다.
    testWidgets('${locale.languageCode}: 장소 카테고리도 9개 모두 표시명이 있다', (
      WidgetTester tester,
    ) async {
      final AppLocalizations l10n = await _l10n(tester, locale);

      for (final NearbySpotCategory category in NearbySpotCategory.values) {
        expect(
          nearbySpotCategoryLabel(l10n, category),
          isNotEmpty,
          reason: '$category 표시명 누락',
        );
      }
    });
  }

  testWidgets('상대 시각은 모델 버킷을 문구로 옮긴다', (WidgetTester tester) async {
    final AppLocalizations l10n = await _l10n(tester, const Locale('en'));
    final DateTime now = DateTime.utc(2026, 8, 6, 12);

    expect(
      relativePostTime(l10n, now.subtract(const Duration(seconds: 10)), now),
      'Just now',
    );
    expect(
      relativePostTime(l10n, now.subtract(const Duration(minutes: 5)), now),
      '5m ago',
    );
    expect(
      relativePostTime(l10n, now.subtract(const Duration(hours: 3)), now),
      '3h ago',
    );
    expect(
      relativePostTime(l10n, now.subtract(const Duration(days: 3)), now),
      '3d ago',
    );
    // 사용자가 지정한 버킷: 30일부터 개월, 1년부터 년.
    expect(
      relativePostTime(l10n, now.subtract(const Duration(days: 60)), now),
      '2mo ago',
    );
    expect(
      relativePostTime(l10n, now.subtract(const Duration(days: 400)), now),
      '1y ago',
    );
  });
}
