import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/drag_feedback_overlay.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/swipe_card.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/discover_swipe_view.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

Future<void> _pump(
  WidgetTester tester, {
  required FakeSpotRepository repo,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        spotRepositoryProvider.overrideWithValue(repo),
        sharedPreferencesProvider.overrideWithValue(prefs),
        locationServiceProvider.overrideWithValue(FakeLocationService()),
      ],
      child: const MaterialApp(
        localizationsDelegates: <LocalizationsDelegate<Object>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(body: DiscoverSwipeView()),
      ),
    ),
  );
}

List<TouristSpot> _spots(int n) =>
    List<TouristSpot>.generate(n, (int i) => swipeSpot('s$i'));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  testWidgets('renders the top swipe card once loaded', (tester) async {
    await _pump(tester, repo: FakeSpotRepository(feed: _spots(3)));
    await tester.pumpAndSettle();

    expect(find.byType(SwipeCard), findsWidgets);
  });

  testWidgets('swiping right removes the top card and shows the LIKE label', (
    tester,
  ) async {
    await _pump(tester, repo: FakeSpotRepository(feed: _spots(3)));
    await tester.pumpAndSettle();

    expect(find.text('Spot s0'), findsOneWidget);

    // 오른쪽으로 카드 폭 이상 드래그 → 확정(LIKE). 위젯 상태가 변위를 따라오도록
    // 각 이동 후 pump 하여, drag-end 시점의 dragX가 임계값을 확실히 넘게 한다.
    final Offset start = tester.getCenter(find.byType(SwipeCard).first);
    final TestGesture gesture = await tester.startGesture(start);
    // 카드는 이제 탭(상세 진입)과 수평 드래그를 함께 받는다. 작은 이동으로 먼저 수평
    // 드래그 인식기가 제스처 아레나를 확보하게 한 뒤 크게 민다.
    await gesture.moveBy(const Offset(20, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(130, 0));
    await tester.pump();
    // 드래그 중에는 LIKE 피드백이 보인다.
    expect(find.byType(DragFeedbackOverlay), findsWidgets);
    expect(find.text('LIKE'), findsOneWidget);

    await gesture.moveBy(const Offset(300, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    // 맨 위 카드가 사라지고 다음 카드가 올라온다.
    expect(find.text('Spot s0'), findsNothing);
    expect(find.text('Spot s1'), findsOneWidget);
  });

  testWidgets('empty state renders widen-radius and change-category CTAs', (
    tester,
  ) async {
    await _pump(tester, repo: FakeSpotRepository(feed: const <TouristSpot>[]));
    await tester.pumpAndSettle();

    expect(find.text('Widen radius'), findsOneWidget);
    expect(find.text('Change category'), findsOneWidget);
  });

  testWidgets('category bar renders only the returned categories', (
    tester,
  ) async {
    await _pump(
      tester,
      repo: FakeSpotRepository(
        feed: _spots(2),
        categories: const <SpotCategory>[
          SpotCategory.touristSpot,
          SpotCategory.transport,
        ],
      ),
    );
    await tester.pumpAndSettle();

    // 반환된 카테고리는 보이고, 반환되지 않은 것(여행코스)은 없다.
    expect(find.text('Transport'), findsOneWidget);
    expect(find.text('Tourist Spots'), findsOneWidget);
    expect(find.text('Travel Courses'), findsNothing);
  });
}
