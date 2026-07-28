import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';

import '../spot_test_doubles.dart';

void main() {
  test(
    'recommendedSpots emits loading then data from the repository',
    () async {
      final container = ProviderContainer(
        overrides: [
          spotRepositoryProvider.overrideWithValue(FakeSpotRepository()),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(recommendedSpotsProvider),
        const AsyncLoading<List<TouristSpot>>(),
      );

      final List<TouristSpot> spots = await container.read(
        recommendedSpotsProvider.future,
      );

      expect(spots, isNotEmpty);
      expect(spots.first.name, 'Gyeongbokgung Palace');
    },
  );

  test('popularSpots resolves to the fake repository data', () async {
    final container = ProviderContainer(
      overrides: [
        spotRepositoryProvider.overrideWithValue(FakeSpotRepository()),
      ],
    );
    addTearDown(container.dispose);

    final List<TouristSpot> spots = await container.read(
      popularSpotsProvider.future,
    );

    expect(spots.single.rating, isNotNull);
  });
}
