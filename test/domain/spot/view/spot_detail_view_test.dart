import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/widget/failure_notice.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/attribution_block.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/copyright_badge.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/detail_section.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/spot_gallery.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/spot_info_item_list.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/spot_intro_rows.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_image.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_info_item.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_intro.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/spot_detail_view.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../spot_test_doubles.dart';

Future<void> _pump(
  WidgetTester tester,
  FakeSpotRepository repo, {
  String? initialThumbnailUrl,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [spotRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: SpotDetailView(
          contentId: 'c1',
          category: SpotCategory.touristSpot,
          initialThumbnailUrl: initialThumbnailUrl,
        ),
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

  testWidgets('passes the route category through to the repository', (
    tester,
  ) async {
    // 서버 intro/infoItems가 필수로 요구하는 값 — 화면이 조회 시 넘겨야 한다.
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(repo.requestedDetailCategory, SpotCategory.touristSpot);
  });

  testWidgets('renders only the intro rows that have a value', (tester) async {
    final repo = FakeSpotRepository(
      detail: detailSpot(
        'c1',
        intro: const SpotIntro(
          businessHours: '09:00 ~ 18:00',
          // 이 카테고리엔 없는 개념 → 서버가 null. 라벨도 그려지면 안 된다.
          parking: null,
          fee: '',
        ),
      ),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    final AppLocalizations l10n = AppLocalizations.of(
      tester.element(find.byType(SpotDetailView)),
    );
    expect(find.text(l10n.spotDetailIntroTitle), findsOneWidget);
    expect(find.text('09:00 ~ 18:00'), findsOneWidget);
    expect(find.text(l10n.spotDetailIntroBusinessHours), findsOneWidget);
    // 값 없는 항목의 라벨은 아예 없다.
    expect(find.text(l10n.spotDetailIntroParking), findsNothing);
    expect(find.text(l10n.spotDetailIntroFee), findsNothing);
  });

  testWidgets('renders <br> in intro values as real line breaks', (
    tester,
  ) async {
    // 서버가 실제로 내려주는 형태 — 태그가 화면에 리터럴로 보이면 안 된다.
    final repo = FakeSpotRepository(
      detail: detailSpot(
        'c1',
        intro: const SpotIntro(
          businessHours: '[평일]<br>- 11:30~22:00<br>- 준비시간 15:00~17:30',
        ),
      ),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(
      find.text('[평일]\n- 11:30~22:00\n- 준비시간 15:00~17:30'),
      findsOneWidget,
    );
    expect(find.textContaining('<br>'), findsNothing);
  });

  testWidgets('strips tags from the overview text', (tester) async {
    final repo = FakeSpotRepository(
      detail: detailSpot('c1', overview: '첫 줄<br>둘째 줄 &amp; 셋째'),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('첫 줄\n둘째 줄 & 셋째'), findsOneWidget);
    expect(find.textContaining('<br>'), findsNothing);
    expect(find.textContaining('&amp;'), findsNothing);
  });

  testWidgets('hides a section whose value is only markup', (tester) async {
    // 태그만 남은 값은 정리 후 비므로 "값 없음"과 똑같이 다뤄야 한다.
    final repo = FakeSpotRepository(
      detail: detailSpot(
        'c1',
        overview: '<br>',
        homepage: null,
        tel: '<br><br>',
      ),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    final AppLocalizations l10n = AppLocalizations.of(
      tester.element(find.byType(SpotDetailView)),
    );
    expect(find.text(l10n.spotDetailOverviewTitle), findsNothing);
    expect(find.text(l10n.spotDetailContactTitle), findsNothing);
  });

  testWidgets('hides the intro section when no field has a value', (
    tester,
  ) async {
    final repo = FakeSpotRepository(
      // 여행코스처럼 운영 정보 개념이 없는 상세 — 빈 껍데기가 와도 섹션이 없어야 한다.
      detail: detailSpot('c1', intro: const SpotIntro()),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    final AppLocalizations l10n = AppLocalizations.of(
      tester.element(find.byType(SpotDetailView)),
    );
    expect(find.text(l10n.spotDetailIntroTitle), findsNothing);
    expect(find.byType(SpotIntroRows), findsNothing);
  });

  testWidgets('renders info items and drops the blank ones', (tester) async {
    final repo = FakeSpotRepository(
      detail: detailSpot(
        'c1',
        infoItems: const <SpotInfoItem>[
          SpotInfoItem(name: '입장료', text: '성인 3,000원'),
          SpotInfoItem(name: '  ', text: ''),
        ],
      ),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    final AppLocalizations l10n = AppLocalizations.of(
      tester.element(find.byType(SpotDetailView)),
    );
    expect(find.text(l10n.spotDetailInfoTitle), findsOneWidget);
    expect(find.text('입장료'), findsOneWidget);
    expect(find.text('성인 3,000원'), findsOneWidget);
    // 빈 항목은 줄이 생기지 않는다 — 걸러지지 않으면 공백 Text('  ')가 남는다.
    expect(find.text('  '), findsNothing);
    expect(
      find.descendant(
        of: find.byType(SpotInfoItemList),
        matching: find.byType(Text),
      ),
      findsNWidgets(2),
    );
  });

  testWidgets('keeps spacing between info items that have identical values', (
    tester,
  ) async {
    // TourAPI가 같은 항목을 중복으로 주기도 한다. 첫 항목을 값 비교로 가르면
    // 중복 항목의 간격이 사라지므로 인덱스로 갈라야 한다.
    final repo = FakeSpotRepository(
      detail: detailSpot(
        'c1',
        infoItems: const <SpotInfoItem>[
          SpotInfoItem(name: '안내', text: '동일 내용'),
          SpotInfoItem(name: '안내', text: '동일 내용'),
        ],
      ),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    // 값이 같아도 두 항목 모두 남는다(간격 위젯 개수 같은 내부 구조는 보지 않는다).
    expect(find.text('동일 내용'), findsNWidgets(2));
    expect(find.text('안내'), findsNWidgets(2));
  });

  testWidgets('renders <br> in info item text as real line breaks', (
    tester,
  ) async {
    // 모델 → presentInfoItems → 위젯까지 정리된 값이 흘러가는지 끝까지 확인한다.
    final repo = FakeSpotRepository(
      detail: detailSpot(
        'c1',
        infoItems: const <SpotInfoItem>[
          SpotInfoItem(name: '이용시간', text: '[평일]<br>09:00~18:00'),
        ],
      ),
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('[평일]\n09:00~18:00'), findsOneWidget);
    expect(find.textContaining('<br>'), findsNothing);
  });

  testWidgets('hides the info section when there are no items', (tester) async {
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    final AppLocalizations l10n = AppLocalizations.of(
      tester.element(find.byType(SpotDetailView)),
    );
    expect(find.text(l10n.spotDetailInfoTitle), findsNothing);
    expect(find.byType(SpotInfoItemList), findsNothing);
  });

  // 첫 실패 직후의 유형별 오류 화면(SPOT_NOT_FOUND 등)은 자동 재시도 타이머가 도는
  // 중간 프레임이라 위젯 테스트에서 안정적으로 붙잡기 어렵다. 유형별 분기 자체는
  // `_ErrorState`가 `SpotFailure.kind`로 하는 순수 매핑이고, 자동 재시도 상한의
  // 동작은 provider 테스트가 다룬다(설계문서 §7). 여기서는 소진 뒤의 종료 상태만
  // 확인한다 — 그것이 이 화면에서 새로 생긴 관찰 가능한 상태다.

  testWidgets('자동 재시도를 모두 쓰면 종료 상태가 일반 오류와 구분되어 표시된다 (AC-5·AC-6)', (
    tester,
  ) async {
    final repo = FakeSpotRepository(detailFailure: SpotFailure.notFound);
    await _pump(tester, repo);
    // 상한(최초 1회 + 자동 재시도 1회)을 모두 소진할 때까지 진행시킨다.
    await tester.pumpAndSettle();

    final AppLocalizations l10n = AppLocalizations.of(
      tester.element(find.byType(SpotDetailView)),
    );
    expect(find.byKey(FailureNotice.terminalKey), findsOneWidget);
    expect(find.text(l10n.retryExhaustedTitle), findsOneWidget);
    // 종료 상태에서도 명시적 재시도는 가능하다(AC-8).
    expect(find.text(l10n.retryExhaustedAction), findsOneWidget);
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

  // --- SPEC-0006 R8: 리스트에서 보던 썸네일이 상세 첫 장으로 이어진다 ---

  testWidgets(
    'R8 the card thumbnail stays the first gallery image even when the '
    'server returns its own gallery',
    (tester) async {
      // 갤러리를 가진 스팟(관광지·문화시설 등에서 흔하다). 예전에는 조회가 끝나는
      // 순간 첫 장이 gallery[0]으로 바뀌어, 카드에서 보던 이미지가 사라졌다.
      const String cardThumb = 'https://img/card-thumb.jpg';
      final repo = FakeSpotRepository(
        detail: detailSpot(
          'c1',
          gallery: const <SpotImage>[
            SpotImage(
              imageUrl: 'https://img/server-1.jpg',
              copyright: CopyrightType.type1,
              attributionText: 'KTO',
            ),
          ],
        ),
      );

      await _pump(tester, repo, initialThumbnailUrl: cardThumb);
      await tester.pumpAndSettle();

      final SpotGallery gallery = tester.widget<SpotGallery>(
        find.byType(SpotGallery),
      );
      expect(gallery.fallbackImageUrl, cardThumb);
    },
  );

  testWidgets('R8 direct entry without a card thumbnail falls back to the '
      'response thumbnail (AC-25)', (tester) async {
    final repo = FakeSpotRepository(detail: detailSpot('c1'));

    await _pump(tester, repo);
    await tester.pumpAndSettle();

    final SpotGallery gallery = tester.widget<SpotGallery>(
      find.byType(SpotGallery),
    );
    // 넘겨받은 값이 없으면 응답의 썸네일이 첫 장 — 오류가 아니다.
    expect(gallery.fallbackImageUrl, 'https://img/c1.jpg');
  });
}
