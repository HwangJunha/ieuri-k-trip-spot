import 'package:ieuri_k_trip_spot/domain/event/model/tour_event.dart';
import 'package:ieuri_k_trip_spot/domain/event/repository/event_repository.dart';

/// A configurable fake [EventRepository]. Returns whatever the test supplies
/// (defaults to one event), keeping test setup minimal.
class FakeEventRepository implements EventRepository {
  FakeEventRepository({List<TourEvent>? events})
    : events = events ?? const <TourEvent>[_event];

  final List<TourEvent> events;

  static const TourEvent _event = TourEvent(
    id: 'event-1',
    title: 'Myeongdong Food Fest',
    category: EventCategory.festival,
    imageRef: 'myeongdong',
  );

  @override
  Future<List<TourEvent>> fetchHappeningNowEvents() async => events;
}
