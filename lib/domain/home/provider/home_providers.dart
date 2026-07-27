import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/tour_event.dart';
import '../model/tourist_spot.dart';
import '../repository/home_repository.dart';
import '../repository/home_repository_impl.dart';

part 'home_providers.g.dart';

/// Exposes the [HomeRepository]. Widgets never construct it (CLAUDE.md §5);
/// section providers read it from here, and tests override this one provider to
/// inject a fake. Swapping the mock impl for a GraphQL one changes only this
/// line.
@riverpod
HomeRepository homeRepository(Ref ref) => const HomeRepositoryImpl();

/// "Recommended for You" spots as an `AsyncValue` for the UI boundary.
@riverpod
Future<List<TouristSpot>> recommendedSpots(Ref ref) =>
    ref.watch(homeRepositoryProvider).fetchRecommendedSpots();

/// "Happening Now" events as an `AsyncValue` for the UI boundary.
@riverpod
Future<List<TourEvent>> happeningNowEvents(Ref ref) =>
    ref.watch(homeRepositoryProvider).fetchHappeningNowEvents();

/// "Popular Spots" as an `AsyncValue` for the UI boundary.
@riverpod
Future<List<TouristSpot>> popularSpots(Ref ref) =>
    ref.watch(homeRepositoryProvider).fetchPopularSpots();
