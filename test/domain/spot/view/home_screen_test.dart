import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/event/provider/event_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/congestion_badge.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/home_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import '../../event/event_test_doubles.dart';
import '../spot_test_doubles.dart';

Future<void> _pump(WidgetTester tester, {required FakeSpotRepository repo}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        spotRepositoryProvider.overrideWithValue(repo),
        eventRepositoryProvider.overrideWithValue(FakeEventRepository()),
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
        home: HomeScreen(),
      ),
    ),
  );
}

void main() {
  testWidgets('renders the three section headers', (tester) async {
    await _pump(tester, repo: FakeSpotRepository());
    await tester.pumpAndSettle();

    expect(find.text('Recommended for You'), findsOneWidget);
    expect(find.text('Happening Now'), findsOneWidget);

    // Popular Spots sits below the fold; drag the page up to build it.
    await tester.dragUntilVisible(
      find.text('Popular Spots'),
      find.byType(HomeScreen),
      const Offset(0, -200),
    );
    expect(find.text('Popular Spots'), findsOneWidget);
  });

  testWidgets('spot card shows its congestion badge label', (tester) async {
    await _pump(
      tester,
      repo: FakeSpotRepository(
        recommended: const <TouristSpot>[
          TouristSpot(
            id: 's1',
            name: 'Test Spot',
            imageRef: 'ref',
            location: 'Seoul',
            congestion: CongestionLevel.high,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // The badge widget renders and shows the localized "High" label.
    expect(find.byType(CongestionBadge), findsWidgets);
    expect(find.text('High'), findsWidgets);
  });
}
