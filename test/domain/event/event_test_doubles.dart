import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/event/model/festival.dart';
import 'package:ieuri_k_trip_spot/domain/event/repository/event_repository.dart';

/// A configurable fake [EventRepository]. Returns whatever the test supplies
/// (defaults to one festival), keeping test setup minimal.
class FakeEventRepository implements EventRepository {
  FakeEventRepository({List<Festival>? festivals, this.failure})
    : festivals = festivals ?? <Festival>[festival('f1')];

  final List<Festival> festivals;

  /// 설정하면 조회가 이 오류를 던진다 — 섹션 실패 경로 검증용.
  final Object? failure;

  /// 마지막 조회에 실린 반경(검증용). null은 인자를 보내지 않은 것.
  int? lastRadiusMeters;

  int callCount = 0;

  @override
  Future<CursorPage<Festival>> fetchOngoingFestivals({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    int? first,
    String? after,
  }) async {
    callCount++;
    lastRadiusMeters = radiusMeters;
    if (failure != null) throw failure!;
    // 활성 언어의 축제만 담는다(SPEC-0029) — 서버가 언어 축으로 이미 갈라 준다.
    final List<Festival> pool = festivals;
    return CursorPage<Festival>(
      items: first == null ? pool : pool.take(first).toList(growable: false),
      hasNextPage: false,
    );
  }
}

/// 축제 한 건을 최소 필드로 만든다(테스트 데이터 생성 편의).
Festival festival(
  String id, {
  String? title,
  DateTime? startDate,
  DateTime? endDate,
}) => Festival(
  id: id,
  title: title ?? 'Festival $id',
  thumbnailImageUrl: 'https://example.test/$id.jpg',
  distanceMeters: 1200,
  attributionText: 'KTO',
  startDate: startDate ?? DateTime(2026, 8, 1),
  endDate: endDate ?? DateTime(2026, 8, 31),
  address: 'Seoul',
);
