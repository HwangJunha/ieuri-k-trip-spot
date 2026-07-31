import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/repository/spot_repository_impl.dart';

/// 하나의 정형 [Response]를 돌려주거나(또는 링크 예외를 던져) 실제 네트워크를 대신해
/// repository의 매핑만 검증하는 링크(auth 테스트와 동일 패턴).
class _FakeLink extends Link {
  _FakeLink({this.data, this.errors, this.throwLinkException = false});

  final Map<String, dynamic>? data;
  final List<GraphQLError>? errors;
  final bool throwLinkException;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
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

SpotRepositoryImpl _repo(_FakeLink link) => SpotRepositoryImpl(
  GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      mutate: Policies(fetch: FetchPolicy.noCache),
      query: Policies(fetch: FetchPolicy.noCache),
    ),
  ),
);

Map<String, dynamic> _spotItem({
  String id = 'spot-1',
  String category = 'RESTAURANT',
  String copyright = 'TYPE1',
}) => <String, dynamic>{
  'id': id,
  'title': 'Gwangjang Market',
  'address': '88 Changgyeonggung-ro, Seoul',
  'thumbnailImageUrl': 'https://img/$id.jpg',
  'distanceMeters': 851.6,
  'category': category,
  'copyright': copyright,
  'attributionText': 'KTO',
};

void main() {
  test(
    'fetchSpotPage maps SpotPage to an OffsetPage of domain spots',
    () async {
      final SpotRepositoryImpl repo = _repo(
        _FakeLink(
          data: <String, dynamic>{
            'spots': <String, dynamic>{
              'items': <dynamic>[
                _spotItem(id: 's1', category: 'RESTAURANT', copyright: 'TYPE1'),
                _spotItem(id: 's2', category: 'TRANSPORT', copyright: 'TYPE3'),
              ],
              'page': 0,
              'hasNext': true,
              'totalCount': 120,
            },
          },
        ),
      );

      final OffsetPage<TouristSpot> page = await repo.fetchSpotPage(
        latitude: 37.5,
        longitude: 127.0,
        page: 0,
        size: 100,
      );

      expect(page.page, 0);
      expect(page.hasNext, isTrue);
      expect(page.nextPage, 1);
      expect(page.totalCount, 120);
      expect(page.items, hasLength(2));

      final TouristSpot first = page.items.first;
      expect(first.id, 's1');
      expect(first.name, 'Gwangjang Market');
      expect(first.category, SpotCategory.restaurant);
      expect(first.copyright, CopyrightType.type1);
      // Float 미터 → 반올림 정수.
      expect(first.distanceMeters, 852);
      expect(page.items[1].category, SpotCategory.transport);
      expect(page.items[1].copyright, CopyrightType.type3);
    },
  );

  test('fetchSpotPage with no next page reports exhaustion', () async {
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'spots': <String, dynamic>{
            'items': <dynamic>[_spotItem(id: 'last')],
            'page': 3,
            'hasNext': false,
            'totalCount': 4,
          },
        },
      ),
    );

    final OffsetPage<TouristSpot> page = await repo.fetchSpotPage(
      latitude: 37.5,
      longitude: 127.0,
      page: 3,
      size: 100,
    );

    expect(page.hasNext, isFalse);
    expect(page.nextPage, isNull);
  });

  test('fetchSpotPage surfaces a transport failure as SpotFailure', () async {
    final SpotRepositoryImpl repo = _repo(_FakeLink(throwLinkException: true));

    await expectLater(
      repo.fetchSpotPage(latitude: 37.5, longitude: 127.0, page: 0, size: 100),
      throwsA(isA<SpotFailure>()),
    );
  });

  test(
    'fetchSpotPage surfaces a top-level errors array as SpotFailure',
    () async {
      // GraphQL은 실패에도 HTTP 200을 주고 errors[]로 알린다(spec §7). query 레벨
      // errors 배열도 전송 실패로 번역돼야 한다.
      final SpotRepositoryImpl repo = _repo(
        _FakeLink(errors: const <GraphQLError>[GraphQLError(message: 'boom')]),
      );

      await expectLater(
        repo.fetchSpotPage(
          latitude: 37.5,
          longitude: 127.0,
          page: 0,
          size: 100,
        ),
        throwsA(isA<SpotFailure>()),
      );
    },
  );

  test('fetchAvailableCategories maps server enum tokens', () async {
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'availableSpotCategories': <dynamic>[
            'TOURIST_SPOT',
            'TRAVEL_COURSE',
            'RESTAURANT',
          ],
        },
      ),
    );

    final List<SpotCategory> categories = await repo.fetchAvailableCategories(
      AppLanguage.korean,
    );

    expect(categories, <SpotCategory>[
      SpotCategory.touristSpot,
      SpotCategory.travelCourse,
      SpotCategory.restaurant,
    ]);
  });

  test('reactToSpot resolves on success', () async {
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'reactToSpot': <String, dynamic>{
            'success': true,
            'userErrors': <dynamic>[],
          },
        },
      ),
    );

    await expectLater(repo.reactToSpot('spot-1', SpotReaction.like), completes);
  });

  test('reactToSpot maps a userError to a SpotFailure', () async {
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'reactToSpot': <String, dynamic>{
            'success': false,
            'userErrors': <dynamic>[
              <String, dynamic>{
                'code': 'SPOT_NOT_FOUND',
                'message': 'x',
                'field': 'spotId',
              },
            ],
          },
        },
      ),
    );

    await expectLater(
      repo.reactToSpot('missing', SpotReaction.dislike),
      throwsA(
        isA<SpotFailure>().having(
          (SpotFailure f) => f.code,
          'code',
          'SPOT_NOT_FOUND',
        ),
      ),
    );
  });

  test('Home mock sections stay populated (no server API yet)', () async {
    final SpotRepositoryImpl repo = _repo(_FakeLink());

    expect(await repo.fetchRecommendedSpots(), isNotEmpty);
    final List<TouristSpot> popular = await repo.fetchPopularSpots();
    expect(popular, isNotEmpty);
    for (final TouristSpot spot in popular) {
      expect(spot.rating, isNotNull);
      expect(spot.distanceKm, isNotNull);
    }
  });
}
