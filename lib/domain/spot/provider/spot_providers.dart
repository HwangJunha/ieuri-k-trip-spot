import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/tourist_spot.dart';
import '../repository/spot_repository.dart';
import '../repository/spot_repository_impl.dart';

part 'spot_providers.g.dart';

/// Exposes the [SpotRepository]. Widgets never construct it (CLAUDE.md §5);
/// section providers read it from here, and tests override this one provider to
/// inject a fake. Swapping the mock impl for a GraphQL one changes only this
/// line.
@riverpod
SpotRepository spotRepository(Ref ref) => const SpotRepositoryImpl();

/// "Recommended for You" spots as an `AsyncValue` for the UI boundary.
@riverpod
Future<List<TouristSpot>> recommendedSpots(Ref ref) =>
    ref.watch(spotRepositoryProvider).fetchRecommendedSpots();

/// "Popular Spots" as an `AsyncValue` for the UI boundary.
@riverpod
Future<List<TouristSpot>> popularSpots(Ref ref) =>
    ref.watch(spotRepositoryProvider).fetchPopularSpots();
