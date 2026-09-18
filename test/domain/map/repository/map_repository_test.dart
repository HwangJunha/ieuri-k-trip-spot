import 'package:flutter_test/flutter_test.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_bounds.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_failure.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_marker.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_recommendation_result.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_viewport_result.dart';
import 'package:ieuri_k_trip_spot/domain/map/repository/map_repository_impl.dart';

/// 지도 영역 기준 추천 조회(SPEC-0036)를 도메인 모델로 옮기는 규칙.
///
/// GraphQL은 실패해도 HTTP 200이므로, `errors` 배열이 실린 응답이 성공으로 통과하지
/// 않는지 함께 본다(CLAUDE.md §8).
/// 정해진 응답 하나만 돌려주는 클라이언트. 실제 전송을 세우지 않는다.
///
/// 마지막에 실린 변수를 남겨 둔다 — 「제외 목록을 실제로 보냈는가」(FR-004)와
/// 「요청한 수」(FR-009)가 이 테스트의 관심사다.
final class FakeClient implements GraphQLClient {
  FakeClient(this.response);

  final QueryResult<Object?> response;
  Map<String, dynamic>? lastVariables;

  @override
  Future<QueryResult<TParsed>> query<TParsed>(
    QueryOptions<TParsed> options,
  ) async {
    lastVariables = options.variables;
    return response as QueryResult<TParsed>;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  const MapBounds bbox = MapBounds(
    minLat: 37.50,
    minLng: 127.00,
    maxLat: 37.52,
    maxLng: 127.02,
  );

  QueryResult<Object?> success(List<Map<String, dynamic>> spots) =>
      QueryResult<Object?>(
        options: QueryOptions<Object?>(document: DocumentNode()),
        data: <String, dynamic>{'mapRecommendedSpots': spots},
        source: QueryResultSource.network,
      );

  Map<String, dynamic> spotJson(String id, {String? thumbnail}) =>
      <String, dynamic>{
        'id': id,
        'title': 'spot $id',
        'thumbnailImageUrl': thumbnail ?? 'https://t/$id',
        'category': <String, dynamic>{
          'code': 'TOURIST_SPOT',
          'label': '관광지',
          'iconUrl': null,
        },
        'lng': 127.01,
        'lat': 37.51,
      };

  test('추천 응답을 마커로 옮긴다', () async {
    final FakeClient client = FakeClient(
      success(<Map<String, dynamic>>[spotJson('1'), spotJson('2')]),
    );

    final MapRecommendationResult result = await MapRepositoryImpl(client)
        .fetchRecommendedSpots(
          bbox: bbox,
          excludedIds: const <String>[],
          first: 2,
        );

    expect(result.markers.map((MapMarker m) => m.id), <String>['1', '2']);
    expect(result.markers.first.kind, MapMarkerKind.spot);
    expect(result.markers.first.name, 'spot 1');
    // 라우터가 Dart enum 이름이 아니라 서버 `code`와 견준다(SPEC-0020).
    expect(result.markers.first.categoryName, 'TOURIST_SPOT');
  });

  /// 빈 문자열을 URL로 쓰면 이미지 로드가 실패한다.
  test('썸네일이 빈 문자열이면 없는 것으로 본다', () async {
    final FakeClient client = FakeClient(
      success(<Map<String, dynamic>>[spotJson('1', thumbnail: '')]),
    );

    final MapRecommendationResult result = await MapRepositoryImpl(client)
        .fetchRecommendedSpots(
          bbox: bbox,
          excludedIds: const <String>[],
          first: 1,
        );

    expect(result.markers.single.thumbnailUrl, isNull);
  });

  /// FR-004. 세션을 들고 있는 쪽이 클라이언트이므로 서버에 실어 보내야 한다.
  test('제외 목록과 요청 수를 그대로 보낸다', () async {
    final FakeClient client = FakeClient(success(<Map<String, dynamic>>[]));

    await MapRepositoryImpl(client).fetchRecommendedSpots(
      bbox: bbox,
      excludedIds: const <String>['7', '8'],
      first: 10,
    );

    expect(client.lastVariables?['excludedIds'], <String>['7', '8']);
    expect(client.lastVariables?['first'], 10);
    expect(client.lastVariables?['bbox'], <String, dynamic>{
      'minLat': 37.50,
      'minLng': 127.00,
      'maxLat': 37.52,
      'maxLng': 127.02,
    });
  });

  /// SPEC-0036 AC-014 (FR-012 개정 2026-09-18). 문화행사 마커를 없앴으므로 operation이
  /// `events`를 아예 요청하지 않는다 — 받아서 거르는 것이 아니라 받지 않는다.
  test('뷰포트 조회가 문화행사를 요청하지 않는다', () async {
    final FakeClient client = FakeClient(
      QueryResult<Object?>(
        options: QueryOptions<Object?>(document: DocumentNode()),
        data: <String, dynamic>{
          'mapViewport': <String, dynamic>{
            'spots': <Map<String, dynamic>>[],
            'truncated': false,
          },
        },
        source: QueryResultSource.network,
      ),
    );

    final MapViewportResult result = await MapRepositoryImpl(
      client,
    ).fetchViewport(bbox: bbox, zoom: 13);

    // `events` 없이도 응답이 파싱된다 — operation에 그 필드가 없다는 뜻이다.
    expect(result.markers, isEmpty);
  });

  group('소진 판정 (FR-009)', () {
    /// 요청한 만큼 꽉 채워 왔다면 영역 안에 아직 후보가 있다.
    test('요청한 수만큼 오면 소진이 아니다', () async {
      final FakeClient client = FakeClient(
        success(<Map<String, dynamic>>[spotJson('1'), spotJson('2')]),
      );

      final MapRecommendationResult result = await MapRepositoryImpl(client)
          .fetchRecommendedSpots(
            bbox: bbox,
            excludedIds: const <String>[],
            first: 2,
          );

      expect(result.exhausted, isFalse);
    });

    test('요청한 수보다 적게 오면 소진이다', () async {
      final FakeClient client = FakeClient(
        success(<Map<String, dynamic>>[spotJson('1')]),
      );

      final MapRecommendationResult result = await MapRepositoryImpl(client)
          .fetchRecommendedSpots(
            bbox: bbox,
            excludedIds: const <String>[],
            first: 10,
          );

      expect(result.exhausted, isTrue);
    });

    /// AC-012. 영역 안에 장소가 없는 것은 오류가 아니다.
    test('빈 결과는 오류가 아니라 소진이다', () async {
      final FakeClient client = FakeClient(success(<Map<String, dynamic>>[]));

      final MapRecommendationResult result = await MapRepositoryImpl(client)
          .fetchRecommendedSpots(
            bbox: bbox,
            excludedIds: const <String>[],
            first: 10,
          );

      expect(result.markers, isEmpty);
      expect(result.exhausted, isTrue);
    });
  });

  /// GraphQL은 실패해도 HTTP 200이라, `errors` 배열을 보지 않으면 실패가 성공으로
  /// 통과한다.
  group('오류 응답', () {
    QueryResult<Object?> withErrors(List<GraphQLError> errors) =>
        QueryResult<Object?>(
          options: QueryOptions<Object?>(document: DocumentNode()),
          data: null,
          source: QueryResultSource.network,
          exception: OperationException(graphqlErrors: errors),
        );

    test('errors 배열이 실리면 실패로 올린다', () async {
      final FakeClient client = FakeClient(
        withErrors(<GraphQLError>[
          const GraphQLError(
            message: 'bbox too large',
            path: <String>['mapRecommendedSpots'],
            extensions: <String, dynamic>{'code': 'BBOX_TOO_LARGE'},
          ),
        ]),
      );

      expect(
        () => MapRepositoryImpl(client).fetchRecommendedSpots(
          bbox: bbox,
          excludedIds: const <String>[],
          first: 10,
        ),
        throwsA(
          isA<MapFailure>().having(
            (MapFailure f) => f.code,
            'code',
            'BBOX_TOO_LARGE',
          ),
        ),
      );
    });

    /// 인증이 필요한 조회이므로(계약상 UNAUTHENTICATED) 재시도 정책이 이 값을 보고
    /// 멈춰야 한다 — 같은 토큰으로 상한까지 두드리면 안 된다.
    test('인증 실패는 갱신이 필요한 실패로 표시된다', () async {
      final FakeClient client = FakeClient(
        withErrors(<GraphQLError>[
          const GraphQLError(
            message: 'unauthenticated',
            path: <String>['mapRecommendedSpots'],
            extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
          ),
        ]),
      );

      await expectLater(
        () => MapRepositoryImpl(client).fetchRecommendedSpots(
          bbox: bbox,
          excludedIds: const <String>[],
          first: 10,
        ),
        throwsA(
          isA<MapFailure>().having(
            (MapFailure f) => f.isUnauthenticated,
            'isUnauthenticated',
            isTrue,
          ),
        ),
      );
    });
  });
}
