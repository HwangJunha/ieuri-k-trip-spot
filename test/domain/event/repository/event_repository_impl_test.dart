import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/event/model/event_failure.dart';
import 'package:ieuri_k_trip_spot/domain/event/model/festival.dart';
import 'package:ieuri_k_trip_spot/domain/event/repository/event_repository_impl.dart';

/// `ongoingFestivals` repository(SPEC-0013 R17). 모킹한 GraphQL 링크로 응답을
/// 주입하고, 도메인 모델로 매핑되는지와 실패가 [EventFailure]로 번역되는지 본다.
class _FakeLink extends Link {
  _FakeLink({this.data, this.errors, this.throwLinkException = false});

  final Map<String, dynamic>? data;
  final List<GraphQLError>? errors;
  final bool throwLinkException;

  Map<String, dynamic>? sentVariables;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    sentVariables = request.variables;
    if (throwLinkException) {
      throw const ServerException(originalException: 'down');
    }
    yield Response(
      data: data,
      errors: errors,
      response: const <String, dynamic>{},
      context: const Context(),
    );
  }
}

EventRepositoryImpl _repo(_FakeLink link) => EventRepositoryImpl(
  GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      query: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
    ),
  ),
);

Map<String, dynamic> _node({
  String id = 'f1',
  String start = '2026-08-01',
  String end = '2026-08-31',
}) => <String, dynamic>{
  'id': id,
  'title': 'Seoul Lantern Festival',
  'address': 'Seoul, Jung-gu',
  'thumbnailImageUrl': 'https://example.test/f.jpg',
  'distanceMeters': 1234.6,
  'attributionText': 'KTO',
  'eventStartDate': start,
  'eventEndDate': end,
};

Map<String, dynamic> _payload(List<Map<String, dynamic>> nodes) =>
    <String, dynamic>{
      'ongoingFestivals': <String, dynamic>{
        'edges': <Map<String, dynamic>>[
          for (final Map<String, dynamic> n in nodes)
            <String, dynamic>{'node': n, 'cursor': 'c-${n['id']}'},
        ],
        'pageInfo': <String, dynamic>{'hasNextPage': false, 'endCursor': null},
      },
    };

void main() {
  test('축제 응답을 도메인 모델로 매핑한다', () async {
    final EventRepositoryImpl repo = _repo(
      _FakeLink(data: _payload(<Map<String, dynamic>>[_node()])),
    );

    final CursorPage<Festival> page = await repo.fetchOngoingFestivals(
      latitude: 37.5,
      longitude: 127.0,
    );

    final Festival f = page.items.single;
    expect(f.id, 'f1');
    expect(f.title, 'Seoul Lantern Festival');
    // 거리는 미터 정수로 반올림한다(다른 표면과 같은 규칙).
    expect(f.distanceMeters, 1235);
    expect(f.startDate, DateTime(2026, 8, 1));
    expect(f.endDate, DateTime(2026, 8, 31));
  });

  test('AC-17.4 · 진행 중 축제가 0건이면 오류가 아니라 빈 결과다', () async {
    final EventRepositoryImpl repo = _repo(
      _FakeLink(data: _payload(const <Map<String, dynamic>>[])),
    );

    final CursorPage<Festival> page = await repo.fetchOngoingFestivals(
      latitude: 37.5,
      longitude: 127.0,
    );

    expect(page.items, isEmpty);
  });

  test('AC-17.5 · 날짜가 비어 있는 행은 제외되고 나머지는 정상 반환된다', () async {
    // 계약이 두 날짜를 non-null로 선언하므로 매핑 불가한 행을 내보낼 수 없다.
    // 그 한 행 때문에 섹션 전체가 실패하지는 않는다.
    final EventRepositoryImpl repo = _repo(
      _FakeLink(
        data: _payload(<Map<String, dynamic>>[
          _node(id: 'broken', start: ''),
          _node(id: 'ok'),
        ]),
      ),
    );

    final CursorPage<Festival> page = await repo.fetchOngoingFestivals(
      latitude: 37.5,
      longitude: 127.0,
    );

    expect(page.items.map((Festival f) => f.id), <String>['ok']);
  });

  test('반경 인자가 서버로 전달된다', () async {
    final _FakeLink link = _FakeLink(
      data: _payload(<Map<String, dynamic>>[_node()]),
    );

    await _repo(link).fetchOngoingFestivals(
      latitude: 37.5,
      longitude: 127.0,
      radiusMeters: 30000,
    );

    expect(link.sentVariables?['radiusMeters'], 30000);
  });

  test('전송 실패는 EventFailure로 번역된다', () async {
    final EventRepositoryImpl repo = _repo(_FakeLink(throwLinkException: true));

    expect(
      () => repo.fetchOngoingFestivals(latitude: 37.5, longitude: 127.0),
      throwsA(isA<EventFailure>()),
    );
  });

  test('최상위 errors[]는 EventFailure로 번역된다', () async {
    final EventRepositoryImpl repo = _repo(
      _FakeLink(
        errors: const <GraphQLError>[
          GraphQLError(message: 'boom', path: <String>['ongoingFestivals']),
        ],
      ),
    );

    expect(
      () => repo.fetchOngoingFestivals(latitude: 37.5, longitude: 127.0),
      throwsA(isA<EventFailure>()),
    );
  });
}
