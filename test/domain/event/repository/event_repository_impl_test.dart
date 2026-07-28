import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/event/model/tour_event.dart';
import 'package:ieuri_k_trip_spot/domain/event/repository/event_repository_impl.dart';

void main() {
  const EventRepositoryImpl repo = EventRepositoryImpl();

  test('fetchHappeningNowEvents returns populated events', () async {
    final List<TourEvent> events = await repo.fetchHappeningNowEvents();

    expect(events, isNotEmpty);
    for (final TourEvent event in events) {
      expect(event.id, isNotEmpty);
      expect(event.title, isNotEmpty);
    }
  });
}
