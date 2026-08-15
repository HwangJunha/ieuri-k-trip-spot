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

  /// 호출마다 실린 `hasOrigin`(원문 우선 조회가 실제로 나가는지 확인용, SPEC-0019).
  final List<bool?> requestedHasOrigin = <bool?>[];

  /// `hasOrigin: false`(번역본)로 조회했을 때 돌려줄 축제(SPEC-0019). 비워 두면
  /// 기존 테스트와 동작이 같다.
  List<Festival> translatedFestivals = const <Festival>[];

  int callCount = 0;

  @override
  Future<CursorPage<Festival>> fetchOngoingFestivals({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    bool? hasOrigin,
    int? first,
    String? after,
  }) async {
    callCount++;
    lastRadiusMeters = radiusMeters;
    requestedHasOrigin.add(hasOrigin);
    if (failure != null) throw failure!;
    final List<Festival> pool = switch (hasOrigin) {
      true => festivals,
      false => translatedFestivals,
      null => <Festival>[...festivals, ...translatedFestivals],
    };
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
