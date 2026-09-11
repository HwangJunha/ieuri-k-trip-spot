import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/repository/spot_repository_impl.dart';

/// 추천 피드 매핑(SPEC-0035 AC-31.1). 생성 응답 → `CursorPage<TouristSpot>`,
/// 최상위 `errors[]`의 커서 코드 → `SpotFailure.cursorInvalid`.
///
/// 결과가 `location { recommendedSpots }` 두 칸 아래에 실리므로 오류 `path`도 두
/// 칸이다 — 그 깊이를 전체 실패로 보지 않으면 매핑이 null에서 터진다.
void main() {
  Map<String, dynamic> node(String id) => <String, dynamic>{
    'id': id,
    'title': 'Spot &amp; Co $id',
    'address': 'Seoul',
    'thumbnailImageUrl': 'https://img/$id.jpg',
    'distanceMeters': 1234.6,
    'category': <String, dynamic>{
      'code': 'TOURIST_SPOT',
      'label': 'Tourist Spots',
      'iconUrl': null,
    },
    'copyright': 'TYPE1',
    'attributionText': 'KTO',
  };

  Map<String, dynamic> page({
    required List<String> ids,
    required bool hasNextPage,
    String? endCursor,
  }) => <String, dynamic>{
    'location': <String, dynamic>{
      'recommendedSpots': <String, dynamic>{
        'edges': ids
            .map(
              (String id) => <String, dynamic>{
                'node': node(id),
                'cursor': 'cur-$id',
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

  test('AC-31.1 · 추천 응답을 CursorPage<TouristSpot>로 매핑한다', () async {
    final _RecordingLink link = _RecordingLink(
      data: page(
        ids: <String>['a', 'b'],
        hasNextPage: true,
        endCursor: 'cur-b',
      ),
    );

    final CursorPage<TouristSpot> result = await _impl(
      link,
    ).fetchRecommendedSpots(latitude: 37.5, longitude: 127.0, first: 10);

    expect(result.items.map((TouristSpot s) => s.id), <String>['a', 'b']);
    expect(result.hasNextPage, isTrue);
    expect(result.endCursor, 'cur-b');
    final TouristSpot first = result.items.first;
    // TourAPI 엔티티 정리·거리 반올림·카테고리 객체 매핑은 다른 조회와 같다.
    expect(first.name, 'Spot & Co a');
    expect(first.distanceMeters, 1235);
    expect(first.category?.code, 'TOURIST_SPOT');
    expect(first.copyright, CopyrightType.type1);
  });

  test('첫 요청은 after 없이, 이어 받기는 endCursor를 실어 보낸다', () async {
    final _RecordingLink link = _RecordingLink(
      data: page(ids: <String>['a'], hasNextPage: false),
    );
    final SpotRepositoryImpl repository = _impl(link);

    await repository.fetchRecommendedSpots(
      latitude: 37.5,
      longitude: 127.0,
      first: 100,
    );
    await repository.fetchRecommendedSpots(
      latitude: 37.5,
      longitude: 127.0,
      radiusMeters: 20000,
      categoryCodes: <String>['RESTAURANT'],
      first: 100,
      after: 'cur-a',
    );

    expect(link.requests[0]['first'], 100);
    expect(link.requests[0]['after'], isNull);
    expect(link.requests[1]['after'], 'cur-a');
    expect(link.requests[1]['radiusMeters'], 20000);
    expect(link.requests[1]['categories'], <String>['RESTAURANT']);
  });

  test('빈 카테고리 목록은 보내지 않는다 — 서버가 EMPTY_CATEGORY_SET으로 거절한다', () async {
    final _RecordingLink link = _RecordingLink(
      data: page(ids: <String>[], hasNextPage: false),
    );

    await _impl(link).fetchRecommendedSpots(
      latitude: 37.5,
      longitude: 127.0,
      categoryCodes: const <String>[],
    );

    expect(link.requests.single['categories'], isNull);
  });

  group('커서 오류 (AC-28 · 도메인 표현)', () {
    for (final String code in <String>['CURSOR_EXPIRED', 'INVALID_CURSOR']) {
      test('$code는 cursorInvalid로 온다', () async {
        final _RecordingLink link = _RecordingLink(
          errors: <GraphQLError>[
            GraphQLError(
              message: 'cursor',
              path: const <dynamic>['location', 'recommendedSpots'],
              extensions: <String, dynamic>{'code': code},
            ),
          ],
        );

        await expectLater(
          _impl(link).fetchRecommendedSpots(
            latitude: 37.5,
            longitude: 127.0,
            after: 'stale',
          ),
          throwsA(
            isA<SpotFailure>().having(
              (SpotFailure f) => f.kind,
              'kind',
              SpotFailureKind.cursorInvalid,
            ),
          ),
        );
      });
    }
  });

  test('다른 최상위 코드는 기존 매핑 그대로다', () async {
    final _RecordingLink link = _RecordingLink(
      errors: const <GraphQLError>[
        GraphQLError(
          message: 'auth',
          path: <dynamic>['location', 'recommendedSpots'],
          extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
        ),
      ],
    );

    await expectLater(
      _impl(link).fetchRecommendedSpots(latitude: 37.5, longitude: 127.0),
      throwsA(SpotFailure.unauthenticated),
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

SpotRepositoryImpl _impl(Link link) => SpotRepositoryImpl(
  GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      query: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
    ),
  ),
);
