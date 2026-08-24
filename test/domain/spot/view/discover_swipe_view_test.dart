import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/search_radius_controller.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/drag_feedback_overlay.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/swipe_card.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/discover_swipe_view.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  required FakeSpotRepository repo,
  double? radiusKm,
}) async {
  if (radiusKm != null) {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'search_radius_km': radiusKm,
    });
  }
  final prefs = await SharedPreferences.getInstance();
  final ProviderContainer container = ProviderContainer(
    overrides: [
      spotRepositoryProvider.overrideWithValue(repo),
      sharedPreferencesProvider.overrideWithValue(prefs),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
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
        home: Scaffold(body: DiscoverSwipeView()),
      ),
    ),
  );
  return container;
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
    // 카드 2장 — 스택은 클라이언트에서 섞이므로(같은 장소의 사용자들이 다른 순서를
    // 보도록) 어느 카드가 맨 위인지는 고정할 수 없다. 확인하려는 건 "맨 위가 다음
    // 카드로 교체된다"이지 특정 id가 아니므로, 남는 장수로 검증한다.
    await _pump(tester, repo: FakeSpotRepository(feed: _spots(2)));
    await tester.pumpAndSettle();

    expect(find.textContaining('Spot s'), findsNWidgets(2));

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

    // 맨 위 카드가 사라지고 다음(마지막) 카드만 남는다.
    expect(find.textContaining('Spot s'), findsOneWidget);
  });

  testWidgets('왼쪽으로 밀면 패스로 카드가 소비된다', (tester) async {
    await _pump(tester, repo: FakeSpotRepository(feed: _spots(2)));
    await tester.pumpAndSettle();

    expect(find.textContaining('Spot s'), findsNWidgets(2));

    final Offset start = tester.getCenter(find.byType(SwipeCard).first);
    final TestGesture gesture = await tester.startGesture(start);
    await gesture.moveBy(const Offset(-20, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-130, 0));
    await tester.pump();
    expect(find.text('NOPE'), findsOneWidget);

    await gesture.moveBy(const Offset(-300, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.textContaining('Spot s'), findsOneWidget);
  });

  // 상하는 판정하지 않는다(사용자 결정 2026-08-24) — 카드는 손가락을 따라
  // 움직이지만 좋아요/패스를 가르는 것은 좌우뿐이다.
  testWidgets('위아래로만 밀면 확정되지 않고 카드가 남는다', (tester) async {
    await _pump(tester, repo: FakeSpotRepository(feed: _spots(2)));
    await tester.pumpAndSettle();

    final Offset start = tester.getCenter(find.byType(SwipeCard).first);
    final TestGesture gesture = await tester.startGesture(start);
    await gesture.moveBy(const Offset(0, -20));
    await tester.pump();
    await gesture.moveBy(const Offset(0, -300));
    await tester.pump();
    // 세로로 아무리 밀어도 라벨이 뜨지 않는다 — 확정 축이 아니다.
    expect(find.text('LIKE'), findsNothing);
    expect(find.text('NOPE'), findsNothing);

    await gesture.up();
    await tester.pumpAndSettle();

    // 두 장 모두 그대로다.
    expect(find.textContaining('Spot s'), findsNWidgets(2));
  });

  testWidgets('임계에 못 미치면 스프링백으로 되돌아가 카드가 남는다', (tester) async {
    await _pump(tester, repo: FakeSpotRepository(feed: _spots(2)));
    await tester.pumpAndSettle();

    final Offset start = tester.getCenter(find.byType(SwipeCard).first);
    final TestGesture gesture = await tester.startGesture(start);
    // 탭 슬롭은 넘겨 드래그로 인식시키되(그러지 않으면 탭=상세 진입이 된다),
    // 확정 임계(폭 28%)에는 못 미치는 거리에서 손을 뗀다.
    await gesture.moveBy(const Offset(30, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(20, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    // 두 장 모두 그대로 — 소비되지 않았다.
    expect(find.textContaining('Spot s'), findsNWidgets(2));
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
        categories: const <SpotCategory>[catTouristSpot, catTransport],
      ),
    );
    await tester.pumpAndSettle();

    // 반환된 카테고리는 보이고, 반환되지 않은 것(여행코스)은 없다.
    expect(find.text('Transport'), findsOneWidget);
    expect(find.text('Tourist Spots'), findsOneWidget);
    expect(find.text('Travel Courses'), findsNothing);
  });

  // "반경 넓히기"는 오랫동안 빈 콜백이라 눌러도 아무 일이 없었다(사용자 보고).
  // 렌더링만 확인하는 위 테스트는 그 상태에서도 통과했다.
  testWidgets('반경 넓히기를 누르면 반경이 실제로 넓어진다', (tester) async {
    final ProviderContainer container = await _pump(
      tester,
      repo: FakeSpotRepository(feed: const <TouristSpot>[]),
      radiusKm: 20,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Widen radius'));
    await tester.pumpAndSettle();

    expect(container.read(searchRadiusControllerProvider), 30);
  });

  testWidgets('반경 넓히기가 새 반경으로 피드를 다시 받는다', (tester) async {
    final FakeSpotRepository repo = FakeSpotRepository(
      feed: const <TouristSpot>[],
    );
    await _pump(tester, repo: repo, radiusKm: 20);
    await tester.pumpAndSettle();
    // 원문이 비어 번역본 조회가 뒤따르므로 조회 수는 하나가 아니다(SPEC-0019).
    // 요지는 **어느 반경이 실렸는가**다.
    expect(repo.requestedRadiiMeters, everyElement(20000));

    await tester.tap(find.text('Widen radius'));
    await tester.pumpAndSettle();

    // 넓힌 뒤의 조회는 전부 새 반경으로 나간다.
    expect(repo.requestedRadiiMeters, contains(30000));
    expect(repo.requestedRadiiMeters.last, 30000);
  });

  testWidgets('이미 상한이면 더 넓힐 수 없다고 알린다', (tester) async {
    final ProviderContainer container = await _pump(
      tester,
      repo: FakeSpotRepository(feed: const <TouristSpot>[]),
      radiusKm: 100,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Widen radius'));
    await tester.pumpAndSettle();

    expect(container.read(searchRadiusControllerProvider), 100);
    expect(
      find.text("You're already at the maximum radius (100 km)."),
      findsOneWidget,
    );
  });
}
