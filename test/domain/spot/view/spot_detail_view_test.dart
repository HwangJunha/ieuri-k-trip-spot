import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/attribution_block.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/copyright_badge.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/detail_section.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/spot_gallery.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/spot_detail_view.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../spot_test_doubles.dart';

Future<void> _pump(WidgetTester tester, FakeSpotRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [spotRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(
        localizationsDelegates: <LocalizationsDelegate<Object>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: SpotDetailView(contentId: 'c1'),
      ),
    ),
  );
}

void main() {
  testWidgets('renders title, overview, attribution and like count', (
    tester,
  ) async {
    final repo = FakeSpotRepository(
      detail: detailSpot('c1', title: 'Gyeongbokgung', likeCount: 42),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('Gyeongbokgung'), findsOneWidget);
    // 소개 섹션이 보인다.
    expect(find.byType(DetailSection), findsWidgets);
    // 저작권 전문 블록(AC-28).
    expect(find.byType(AttributionBlock), findsOneWidget);
    // 좋아요 개수 배지.
    expect(find.text('42 likes'), findsOneWidget);
  });

  testWidgets('hides overview and contact sections when values are null', (
    tester,
  ) async {
    final repo = FakeSpotRepository(
      detail: detailSpot('c1', overview: null, homepage: null, tel: null),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    // overview·연락처 없음 → DetailSection 자체가 렌더되지 않는다(AC-25).
    expect(find.byType(DetailSection), findsNothing);
    // 저작권 블록은 항상 노출.
    expect(find.byType(AttributionBlock), findsOneWidget);
  });

  testWidgets('hides contact/overview when values are empty strings', (
    tester,
  ) async {
    // 서버가 null이 아니라 빈 문자열을 줘도 섹션이 렌더되면 안 된다.
    final repo = FakeSpotRepository(
      detail: detailSpot('c1', overview: '', homepage: '', tel: '   '),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.byType(DetailSection), findsNothing);
    final AppLocalizations l10n = AppLocalizations.of(
      tester.element(find.byType(SpotDetailView)),
    );
    expect(find.text(l10n.spotDetailContactTitle), findsNothing);
    expect(find.text(l10n.spotDetailHomepageLabel), findsNothing);
  });

  testWidgets('no copyright badge is overlaid on the gallery image', (
    tester,
  ) async {
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    // 출처는 이미지 위가 아니라 아래 AttributionBlock에만 있다.
    expect(
      find.descendant(
        of: find.byType(SpotGallery),
        matching: find.byType(CopyrightBadge),
      ),
      findsNothing,
    );
    expect(find.byType(AttributionBlock), findsOneWidget);
  });

  testWidgets('homepage row shows the extracted URL, not the raw anchor tag', (
    tester,
  ) async {
    final repo = FakeSpotRepository(
      detail: detailSpot(
        'c1',
        homepage:
            '<a href="http://www.i-etland.co.kr " target="_blank" '
            'title="용산전자랜드 홈페이지로 이동">http://www.i-etland.co.kr</a>',
      ),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('http://www.i-etland.co.kr'), findsOneWidget);
    // 태그 원문은 화면에 남지 않는다.
    expect(find.textContaining('<a href'), findsNothing);
    // 링크는 탭 가능해야 한다.
    expect(
      find.descendant(
        of: find.byType(InkWell),
        matching: find.text('http://www.i-etland.co.kr'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('homepage row is hidden when the value has no usable URL', (
    tester,
  ) async {
    final repo = FakeSpotRepository(
      detail: detailSpot('c1', homepage: '준비 중', tel: null),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    final AppLocalizations l10n = AppLocalizations.of(
      tester.element(find.byType(SpotDetailView)),
    );
    // 열 수 있는 URL이 없으면 연락처 섹션까지 사라진다.
    expect(find.text(l10n.spotDetailHomepageLabel), findsNothing);
    expect(find.text(l10n.spotDetailContactTitle), findsNothing);
  });

  testWidgets('shows the not-found error state (AC-26)', (tester) async {
    final repo = FakeSpotRepository(detailFailure: SpotFailure.notFound);
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    final AppLocalizations l10n = AppLocalizations.of(
      tester.element(find.byType(SpotDetailView)),
    );
    expect(find.text(l10n.spotDetailNotFoundTitle), findsOneWidget);
    expect(find.text(l10n.spotDetailRetryButton), findsOneWidget);
  });

  testWidgets('tapping Like optimistically increments the like count', (
    tester,
  ) async {
    final repo = FakeSpotRepository(detail: detailSpot('c1', likeCount: 10));
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('10 likes'), findsOneWidget);

    final AppLocalizations l10n = AppLocalizations.of(
      tester.element(find.byType(SpotDetailView)),
    );
    // 반응 바는 스크롤 하단이라 탭 전에 화면 안으로 스크롤한다.
    final Finder likeButton = find.widgetWithText(
      FilledButton,
      l10n.spotDetailLikeAction,
    );
    await tester.ensureVisible(likeButton);
    await tester.pumpAndSettle();
    await tester.tap(likeButton);
    await tester.pump();

    expect(find.text('11 likes'), findsOneWidget);
    expect(repo.recordedReactions, isNotEmpty);
  });
}
