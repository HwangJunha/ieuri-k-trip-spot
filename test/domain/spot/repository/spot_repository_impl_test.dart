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

  /// 마지막으로 서버에 나간 변수(전송 내용 검증용).
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

  test(
    'fetchSpotDetail maps SpotDetail incl. gallery to a domain model',
    () async {
      final SpotRepositoryImpl repo = _repo(
        _FakeLink(
          data: <String, dynamic>{
            'spotDetail': <String, dynamic>{
              'id': 'c1',
              'title': 'Gyeongbokgung',
              'category': 'TOURIST_SPOT',
              'thumbnailImageUrl': 'https://img/thumb.jpg',
              'overview': 'A palace.',
              'address': 'Seoul',
              'homepage': 'https://example.com',
              'tel': '02-000',
              'copyright': 'TYPE1',
              'attributionText': 'Source: KTO',
              'gallery': <dynamic>[
                <String, dynamic>{
                  'imageUrl': 'https://img/g1.jpg',
                  'thumbnailUrl': 'https://img/g1-s.jpg',
                  'caption': 'front',
                  'copyright': 'TYPE3',
                  'attributionText': 'Photo: KTO',
                },
              ],
              'likeCount': 42,
              'intro': <String, dynamic>{
                'businessHours': '09:00 ~ 18:00',
                'closedDays': '화요일',
                // 이 카테고리에 없는 개념은 서버가 null로 준다.
                'parking': null,
                'inquiryPhone': '02-111',
                'fee': '3,000원',
                'petAllowed': null,
                'creditCardAccepted': null,
              },
              'infoItems': <dynamic>[
                <String, dynamic>{'name': '입장료', 'text': '성인 3,000원'},
              ],
            },
          },
        ),
      );

      final detail = await repo.fetchSpotDetail('c1', SpotCategory.touristSpot);

      expect(detail.id, 'c1');
      expect(detail.category, SpotCategory.touristSpot);
      expect(detail.overview, 'A palace.');
      expect(detail.likeCount, 42);
      expect(detail.gallery, hasLength(1));
      expect(detail.gallery.first.imageUrl, 'https://img/g1.jpg');
      // 저작권은 이미지별 — 부모 TYPE1과 별개로 갤러리 아이템은 TYPE3.
      expect(detail.gallery.first.copyright, CopyrightType.type3);
      // 운영 정보는 서버가 카테고리별 필드를 공통 이름으로 정규화해 준 값이다.
      expect(detail.intro?.businessHours, '09:00 ~ 18:00');
      expect(detail.intro?.closedDays, '화요일');
      expect(detail.intro?.parking, isNull);
      expect(detail.infoItems, hasLength(1));
      expect(detail.infoItems.first.name, '입장료');
      expect(detail.infoItems.first.text, '성인 3,000원');
    },
  );

  test(
    'fetchSpotDetail keeps nullable fields null and gallery empty',
    () async {
      final SpotRepositoryImpl repo = _repo(
        _FakeLink(
          data: <String, dynamic>{
            'spotDetail': <String, dynamic>{
              'id': 'c2',
              'title': 'Sparse Spot',
              'category': 'RESTAURANT',
              'thumbnailImageUrl': 'https://img/t.jpg',
              'overview': null,
              'address': null,
              'homepage': null,
              'tel': null,
              'copyright': 'UNSPECIFIED',
              'attributionText': 'KTO',
              'gallery': <dynamic>[],
              'likeCount': 0,
              // 운영 정보가 아예 없는 카테고리는 intro 자체가 null이다.
              'intro': null,
              'infoItems': <dynamic>[],
            },
          },
        ),
      );

      final detail = await repo.fetchSpotDetail('c2', SpotCategory.restaurant);

      expect(detail.overview, isNull);
      expect(detail.homepage, isNull);
      expect(detail.tel, isNull);
      expect(detail.gallery, isEmpty);
      // intro가 null이어도 터지지 않고, 두 섹션 모두 숨김 대상이 된다.
      expect(detail.intro, isNull);
      expect(detail.hasIntro, isFalse);
      expect(detail.infoItems, isEmpty);
      expect(detail.hasInfoItems, isFalse);
    },
  );

  test('fetchSpotDetail sends the category the server requires', () async {
    // intro/infoItems는 category를 필수 인자로 요구한다 — 변수로 실려 나가지 않으면
    // 서버가 MissingFieldArgument로 쿼리를 거절한다.
    final _FakeLink link = _FakeLink(
      data: <String, dynamic>{
        'spotDetail': <String, dynamic>{
          'id': 'c1',
          'title': 'T',
          'category': 'RESTAURANT',
          'thumbnailImageUrl': 'https://img/t.jpg',
          'overview': null,
          'address': null,
          'homepage': null,
          'tel': null,
          'copyright': 'TYPE1',
          'attributionText': 'KTO',
          'gallery': <dynamic>[],
          'likeCount': 0,
          'intro': null,
          'infoItems': <dynamic>[],
        },
      },
    );

    await _repo(link).fetchSpotDetail('c1', SpotCategory.restaurant);

    expect(link.sentVariables?['id'], 'c1');
    expect(link.sentVariables?['category'], 'RESTAURANT');
  });

  test(
    'fetchSpotDetail translates SPOT_NOT_FOUND from extensions.code',
    () async {
      final SpotRepositoryImpl repo = _repo(
        _FakeLink(
          errors: const <GraphQLError>[
            GraphQLError(
              message: 'not found',
              extensions: <String, dynamic>{'code': 'SPOT_NOT_FOUND'},
            ),
          ],
        ),
      );

      await expectLater(
        repo.fetchSpotDetail('missing', SpotCategory.touristSpot),
        throwsA(
          isA<SpotFailure>().having(
            (SpotFailure f) => f.kind,
            'kind',
            SpotFailureKind.notFound,
          ),
        ),
      );
    },
  );

  test(
    'fetchSpotDetail falls back to the message code when no extensions',
    () async {
      final SpotRepositoryImpl repo = _repo(
        _FakeLink(
          errors: const <GraphQLError>[
            GraphQLError(message: 'UPSTREAM_RATE_LIMITED'),
          ],
        ),
      );

      await expectLater(
        repo.fetchSpotDetail('c1', SpotCategory.touristSpot),
        throwsA(
          isA<SpotFailure>().having(
            (SpotFailure f) => f.kind,
            'kind',
            SpotFailureKind.rateLimited,
          ),
        ),
      );
    },
  );

  test(
    'fetchSpotDetail surfaces a link exception as network failure',
    () async {
      final SpotRepositoryImpl repo = _repo(
        _FakeLink(throwLinkException: true),
      );

      await expectLater(
        repo.fetchSpotDetail('c1', SpotCategory.touristSpot),
        throwsA(
          isA<SpotFailure>().having(
            (SpotFailure f) => f.kind,
            'kind',
            SpotFailureKind.network,
          ),
        ),
      );
    },
  );

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
