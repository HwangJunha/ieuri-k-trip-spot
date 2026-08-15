import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../../../common/pagination/page.dart';
import '../model/event_failure.dart';
import '../model/festival.dart';
import 'event_operations.graphql.dart';
import 'event_repository.dart';

/// GraphQL 기반 [EventRepository](SPEC-0013 R17). 생성된 `*.graphql.dart` 타입은
/// 이 파일 밖으로 나가지 않는다(CLAUDE.md §3).
///
/// SPEC-0013 이전에는 하드코딩한 행사 3건을 돌려주는 목이었다. 서버에
/// `ongoingFestivals`가 생기면서 실데이터로 교체됐다.
class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl(this._client);

  final GraphQLClient _client;

  @override
  Future<CursorPage<Festival>> fetchOngoingFestivals({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    bool? hasOrigin,
    int? first,
    String? after,
  }) async {
    // 언어는 인자로 보내지 않는다 — Accept-Language 헤더로 전달된다(기존 규약).
    final Map<String, dynamic> data = await _query(
      documentNodeQueryOngoingFestivals,
      Variables$Query$OngoingFestivals(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        // null이면 변수를 보내지 않아 서버가 원문·번역을 모두 준다(SPEC-0019).
        hasOrigin: hasOrigin,
        first: first,
        after: after,
      ).toJson(),
      'ongoingFestivals',
    );
    final Query$OngoingFestivals$ongoingFestivals result =
        Query$OngoingFestivals.fromJson(data).ongoingFestivals;

    return CursorPage<Festival>(
      // 날짜를 파싱하지 못한 행은 **제외한다**(AC-17.5) — 계약이 두 날짜를 non-null로
      // 선언하므로 매핑 불가한 행을 도메인으로 내보낼 수 없다. 한 행이 이상해도
      // 나머지 축제는 정상적으로 돌아간다.
      items: result.edges
          .map(
            (Query$OngoingFestivals$ongoingFestivals$edges e) =>
                _festivalFromNode(e.node),
          )
          .whereType<Festival>()
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  /// 생성 타입 → 도메인 [Festival]. 날짜가 비었거나 형식이 어긋나면 null을 돌려
  /// 호출부가 그 행을 걸러 내게 한다(AC-17.5).
  Festival? _festivalFromNode(
    Query$OngoingFestivals$ongoingFestivals$edges$node n,
  ) {
    final DateTime? start = DateTime.tryParse(n.eventStartDate);
    final DateTime? end = DateTime.tryParse(n.eventEndDate);
    if (start == null || end == null) return null;

    return Festival(
      id: n.id,
      // 제목·주소는 TourAPI 원문이라 엔티티가 섞여 올 수 있다. spot 쪽 정리 함수는
      // 그 도메인 소유라 여기서 쓰지 않는다 — 서버가 축제 행에는 정리된 값을 준다.
      title: n.title,
      thumbnailImageUrl: n.thumbnailImageUrl,
      distanceMeters: n.distanceMeters.round(),
      attributionText: n.attributionText,
      startDate: start,
      endDate: end,
      address: n.address,
    );
  }

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) async {
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await _client.query(
        QueryOptions(document: document, variables: variables),
      );
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      throw EventFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    // 범위 판별은 `path`로 한다(다른 도메인과 동일) — 하위 필드 실패까지 전체
    // 실패로 뭉개지 않는다.
    if (hasRootFailure(result, operation)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw EventFailure(_rootErrorCode(result, operation));
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw EventFailure.network;
    return data;
  }

  /// 전체 실패로 판정된 오류의 코드(있으면). 없으면 null이라 네트워크 실패로 본다.
  String? _rootErrorCode(QueryResult<Object?> result, String rootField) {
    final GraphQLError? error = firstRootError(result, rootField);
    if (error == null) return null;
    final Object? code = error.extensions?['code'];
    return code is String && code.isNotEmpty ? code : null;
  }
}
