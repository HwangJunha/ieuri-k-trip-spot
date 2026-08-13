import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_search_result.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/recent_searches_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/search_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// 검색 화면의 최근 검색어 여닫기.
///
/// 이전에는 **빈 입력으로 엔터를 눌러야만** 최근 검색어가 떴다(초기 상태로 되돌아
/// 가는 부수효과였다). 명시적인 버튼과 닫기를 붙였고, 그것이 결과를 지우지 않는지
/// 여기서 고정한다.
void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();
  });

  SpotSearchResult resultWith(List<String> ids) => SpotSearchResult(
    page: OffsetPage<TouristSpot>(
      items: ids.map(homeSpot).toList(growable: false),
      page: 0,
      hasNext: false,
    ),
    totalCount: ids.length,
  );

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    required FakeSpotRepository repo,
  }) async {
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        locationServiceProvider.overrideWithValue(FakeLocationService()),
        spotRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: <LocalizationsDelegate<Object>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: SearchScreen(),
        ),
      ),
    );
    return container;
  }

  testWidgets('기록이 없으면 최근 검색어 버튼을 보여주지 않는다', (tester) async {
    await pump(tester, repo: FakeSpotRepository());
    await tester.pumpAndSettle();

    // 눌러도 빈 목록이 뜨는 버튼을 두지 않는다.
    expect(find.widgetWithText(TextButton, 'Recent searches'), findsNothing);
  });

  testWidgets('검색하면 버튼이 나타나고, 눌러 최근 검색어를 연다', (tester) async {
    final repo = FakeSpotRepository()..searchResult = resultWith(<String>['a']);
    final container = await pump(tester, repo: repo);

    await tester.enterText(find.byType(TextField), '경복궁');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    // 결과가 떴고 기록도 생겼다.
    expect(find.text('Spot a'), findsOneWidget);
    expect(container.read(recentSearchesProvider), <String>['경복궁']);

    await tester.tap(find.widgetWithText(TextButton, 'Recent searches'));
    await tester.pumpAndSettle();

    // 패널이 열려 기록을 보여준다.
    expect(find.text('경복궁'), findsWidgets);
  });

  testWidgets('패널을 닫으면 보던 결과가 그대로 남는다', (tester) async {
    final repo = FakeSpotRepository()..searchResult = resultWith(<String>['a']);
    await pump(tester, repo: repo);

    await tester.enterText(find.byType(TextField), '경복궁');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Recent searches'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    // **결과가 살아 있다** — 패널은 화면 로컬 상태라 검색 상태를 건드리지 않는다.
    expect(find.text('Spot a'), findsOneWidget);
    // 조회도 늘지 않았다.
    expect(repo.searchCallCount, 1);
  });

  testWidgets('패널에서 항목을 고르면 그 질의로 다시 검색한다', (tester) async {
    final repo = FakeSpotRepository()..searchResult = resultWith(<String>['a']);
    await pump(tester, repo: repo);

    await tester.enterText(find.byType(TextField), '경복궁');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Recent searches'));
    await tester.pumpAndSettle();

    // 패널 안의 기록 항목을 짚는다. `Icons.history`는 여는 버튼에도 있으므로
    // 아이콘이 아니라 목록 타일을 대상으로 한다.
    await tester.tap(find.widgetWithText(ListTile, '경복궁'));
    await tester.pumpAndSettle();

    expect(repo.lastSearchQuery, '경복궁');
    expect(repo.searchCallCount, 2);
    // 고르면 패널이 닫힌다 — 결과를 가리지 않는다.
    expect(find.byTooltip('Close'), findsNothing);
  });
  // 스크린샷에서 주소가 긴 줄은 `· 8.7km`가 잘려 거리를 아예 못 봤다.
  // 주소와 거리를 두 줄로 나눠 둘 다 보이게 했다.
  testWidgets('결과에 주소와 거리가 각각 보인다', (tester) async {
    final repo = FakeSpotRepository()..searchResult = resultWith(<String>['a']);
    await pump(tester, repo: repo);

    await tester.enterText(find.byType(TextField), '경복궁');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    // homeSpot('a')는 location 'Seoul', distanceMeters 1200이다.
    expect(find.text('Seoul'), findsOneWidget);
    // 거리는 별도 줄이라 주소 길이에 잘리지 않는다.
    expect(find.textContaining('1.2'), findsOneWidget);
  });
}
