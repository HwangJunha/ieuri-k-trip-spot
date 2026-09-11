import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/repository/community_repository_impl.dart';

/// 장소 선택 시트 「주변」 매핑(SPEC-0035 AC-31.2). `location { spots }` 응답 →
/// `CursorPage<NearbySpot>`.
void main() {
  Map<String, dynamic> page({
    required List<String> ids,
    required bool hasNextPage,
    String? endCursor,
    String thumbnail = 'https://img/x.jpg',
  }) => <String, dynamic>{
    'location': <String, dynamic>{
      'spots': <String, dynamic>{
        'edges': ids
            .map(
              (String id) => <String, dynamic>{
                'node': <String, dynamic>{
                  'id': id,
                  'title': 'Spot $id',
                  'address': 'Seoul',
                  'thumbnailImageUrl': thumbnail,
                  'distanceMeters': 42.0,
                },
              },
            )
            .toList(),
        'pageInfo': <String, dynamic>{
          'hasNextPage': hasNextPage,
          'endCursor': endCursor,
        },
      },
    },
  };

  test('AC-31.2 · 주변 응답을 CursorPage<NearbySpot>로 매핑한다', () async {
    final _RecordingLink link = _RecordingLink(
      data: page(ids: <String>['1', '2'], hasNextPage: true, endCursor: 'c2'),
    );

    final CursorPage<NearbySpot> result = await _impl(link).fetchNearbySpots(
      latitude: 37.5,
      longitude: 127.0,
      radiusMeters: 5000,
      first: 50,
    );

    expect(result.items.map((NearbySpot s) => s.id), <String>['1', '2']);
    expect(result.items.first.distanceMeters, 42.0);
    expect(result.hasNextPage, isTrue);
    expect(result.endCursor, 'c2');
  });

  test('빈 썸네일은 null로 접는다', () async {
    final _RecordingLink link = _RecordingLink(
      data: page(ids: <String>['1'], hasNextPage: false, thumbnail: ''),
    );

    final CursorPage<NearbySpot> result = await _impl(
      link,
    ).fetchNearbySpots(latitude: 37.5, longitude: 127.0);

    expect(result.items.single.thumbnailImageUrl, isNull);
  });

  test('반경·카테고리·first·after를 그대로 싣는다', () async {
    final _RecordingLink link = _RecordingLink(
      data: page(ids: <String>[], hasNextPage: false),
    );

    await _impl(link).fetchNearbySpots(
      latitude: 37.5,
      longitude: 127.0,
      radiusMeters: 5000,
      category: NearbySpotCategory.restaurant,
      first: 50,
      after: 'c1',
    );

    final Map<String, dynamic> vars = link.requests.single;
    expect(vars['radiusMeters'], 5000);
    expect(vars['categories'], <String>['RESTAURANT']);
    expect(vars['first'], 50);
    expect(vars['after'], 'c1');
  });

  test('결과 필드 자리의 오류는 매핑에서 터지지 않고 CommunityFailure로 온다', () async {
    final _RecordingLink link = _RecordingLink(
      errors: const <GraphQLError>[
        GraphQLError(
          message: 'cursor',
          path: <dynamic>['location', 'spots'],
          extensions: <String, dynamic>{'code': 'INVALID_CURSOR'},
        ),
      ],
    );

    await expectLater(
      _impl(
        link,
      ).fetchNearbySpots(latitude: 37.5, longitude: 127.0, after: 'stale'),
      throwsA(isA<CommunityFailure>()),
    );
  });
}

/// 나간 요청의 변수를 기록하는 링크. 실제 전송 대신 "무엇이 서버로 갔는가"만 본다.
class _RecordingLink extends Link {
  _RecordingLink({this.data, this.errors});

  final Map<String, dynamic>? data;
  final List<GraphQLError>? errors;

  final List<Map<String, dynamic>> requests = <Map<String, dynamic>>[];

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    requests.add(request.variables);
    yield Response(
      data: data,
      errors: errors,
      response: const <String, dynamic>{},
      context: const Context(),
    );
  }
}

CommunityRepositoryImpl _impl(Link link) => CommunityRepositoryImpl(
  GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      query: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
    ),
  ),
);
