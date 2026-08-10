import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/liked_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/popular_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_search_result.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_suggestion.dart';
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
    // 프로덕션 클라이언트와 같은 정책이어야 부분 실패 경로가 실제와 같게 검증된다
    // (ErrorPolicy.all — errors[]가 있어도 data를 버리지 않는다, SPEC-0008 §2.1).
    defaultPolicies: DefaultPolicies(
      mutate: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
      query: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
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
  // 지도(SPEC-0014)가 검색 결과로 지도를 옮기는 데 쓴다. **mapX가 경도, mapY가
  // 위도다** — 이름이 직관과 반대다.
  'mapX': 127.0,
  'mapY': 37.5,
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

  // 인증 실패를 네트워크 실패로 뭉개면 재시도 상한이 그것까지 계상해 버려 AC-14가
  // 깨진다. 이 매핑이 SPEC-0006 재시도 계상의 유일한 근거이므로 두 형태 모두 검증한다.
  test(
    'fetchSpotPage maps UNAUTHENTICATED in extensions to an auth failure (AC-14)',
    () async {
      final SpotRepositoryImpl repo = _repo(
        _FakeLink(
          errors: const <GraphQLError>[
            GraphQLError(
              message: 'not allowed',
              extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
            ),
          ],
        ),
      );

      await expectLater(
        repo.fetchSpotPage(
          latitude: 37.5,
          longitude: 127.0,
          page: 0,
          size: 100,
        ),
        throwsA(
          isA<SpotFailure>().having(
            (SpotFailure f) => f.kind,
            'kind',
            SpotFailureKind.unauthenticated,
          ),
        ),
      );
    },
  );

  test(
    'fetchSpotPage maps a bare UNAUTHENTICATED message to an auth failure (AC-14)',
    () async {
      // extensions에 코드가 없을 때의 폴백(코드 최종 포맷 미확정, `[TBD-2]`).
      final SpotRepositoryImpl repo = _repo(
        _FakeLink(
          errors: const <GraphQLError>[
            GraphQLError(message: 'UNAUTHENTICATED'),
          ],
        ),
      );

      await expectLater(
        repo.fetchSpotPage(
          latitude: 37.5,
          longitude: 127.0,
          page: 0,
          size: 100,
        ),
        throwsA(
          isA<SpotFailure>().having(
            (SpotFailure f) => f.kind,
            'kind',
            SpotFailureKind.unauthenticated,
          ),
        ),
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

  test('swipe card text is cleaned of TourAPI markup at mapping', () async {
    // 카드와 상세가 같은 값을 다르게 보여주지 않도록 매핑 시점에 정리한다.
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'spots': <String, dynamic>{
            'items': <dynamic>[
              <String, dynamic>{
                'id': 's1',
                'title': '롯데월드 &amp; 매직아일랜드',
                'address': '서울<br>송파구',
                'thumbnailImageUrl': 'https://img/s1.jpg',
                'distanceMeters': 100.0,
                'category': 'TOURIST_SPOT',
                'copyright': 'TYPE1',
                'attributionText': 'KTO',
              },
            ],
            'page': 0,
            'hasNext': false,
            'totalCount': 1,
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

    expect(page.items.first.name, '롯데월드 & 매직아일랜드');
    expect(page.items.first.address, '서울\n송파구');
  });

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

  // --- SPEC-0013 검색 (R1~R8) -------------------------------------------------

  // **오프셋 페이징이다** — 서버가 커서에서 전환했다(items/page/hasNext).
  Map<String, dynamic> searchPayload({
    List<Map<String, dynamic>> nodes = const <Map<String, dynamic>>[],
    List<Map<String, dynamic>> userErrors = const <Map<String, dynamic>>[],
    bool success = true,
    int page = 0,
    bool hasNext = false,
    int? totalCount,
  }) => <String, dynamic>{
    'searchSpots': <String, dynamic>{
      'success': success,
      'userErrors': userErrors,
      'connection': <String, dynamic>{
        'items': nodes,
        'page': page,
        'hasNext': hasNext,
        'totalCount': totalCount ?? nodes.length,
      },
    },
  };

  test('검색 결과를 도메인 모델로 매핑한다', () async {
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: searchPayload(
          nodes: <Map<String, dynamic>>[_spotItem()],
          hasNext: true,
          totalCount: 42,
        ),
      ),
    );

    final SpotSearchResult result = await repo.searchSpots(
      query: '경복궁',
      latitude: 37.5,
      longitude: 127.0,
    );

    expect(result.spots.single.id, 'spot-1');
    expect(result.totalCount, 42);
    // 다음 장은 `page + 1`로 요청한다(오프셋 페이징).
    expect(result.hasNextPage, isTrue);
    expect(result.pageNumber, 0);
  });

  /// 지도(SPEC-0014)가 검색 결과로 지도를 옮기는 데 쓴다. `mapX`가 경도, `mapY`가
  /// 위도라 **이름이 직관과 반대**이고, 뒤집어 넣으면 엉뚱한 곳으로 이동한다.
  test('검색 결과의 좌표를 뒤집지 않고 매핑한다', () async {
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: searchPayload(nodes: <Map<String, dynamic>>[_spotItem()]),
      ),
    );

    final SpotSearchResult result = await repo.searchSpots(
      query: '경복궁',
      latitude: 37.5,
      longitude: 127.0,
    );

    // fixture는 mapX=127.0(경도), mapY=37.5(위도)다.
    expect(result.spots.single.coordinates?.longitude, 127.0);
    expect(result.spots.single.coordinates?.latitude, 37.5);
  });

  test('AC-1.3 · 결과 0건은 오류가 아니라 빈 결과다', () async {
    final SpotRepositoryImpl repo = _repo(_FakeLink(data: searchPayload()));

    final SpotSearchResult result = await repo.searchSpots(
      query: '없는장소',
      latitude: 37.5,
      longitude: 127.0,
    );

    expect(result.isEmpty, isTrue);
    expect(result.totalCount, 0);
  });

  test('R8 · userErrors는 SpotFailure로 번역된다 (HTTP는 200)', () async {
    // 입력 검증 실패는 최상위 errors[]가 아니라 payload로 온다(POL-015).
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: searchPayload(
          success: false,
          userErrors: <Map<String, dynamic>>[
            <String, dynamic>{'code': 'EMPTY_QUERY', 'field': 'query'},
          ],
        ),
      ),
    );

    await expectLater(
      repo.searchSpots(query: '   ', latitude: 37.5, longitude: 127.0),
      throwsA(
        isA<SpotFailure>()
            .having(
              (SpotFailure f) => f.kind,
              'kind',
              SpotFailureKind.userError,
            )
            .having((SpotFailure f) => f.code, 'code', 'EMPTY_QUERY'),
      ),
    );
  });

  test('검색 인자가 서버로 전달된다', () async {
    final _FakeLink link = _FakeLink(data: searchPayload());

    await _repo(link).searchSpots(
      query: '경복궁',
      latitude: 37.5,
      longitude: 127.0,
      radiusMeters: 30000,
      page: 2,
      size: 20,
    );

    expect(link.sentVariables?['query'], '경복궁');
    expect(link.sentVariables?['radiusMeters'], 30000);
    expect(link.sentVariables?['page'], 2);
    expect(link.sentVariables?['size'], 20);
  });

  test('R9 · 자동완성은 제안 목록을 돌려준다', () async {
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'spotSearchSuggestions': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 's1',
              'title': '경복궁',
              'category': 'TOURIST_SPOT',
            },
          ],
        },
      ),
    );

    final List<SpotSuggestion> suggestions = await repo.spotSearchSuggestions(
      query: '경복',
      latitude: 37.5,
      longitude: 127.0,
    );

    expect(suggestions.single.title, '경복궁');
    expect(suggestions.single.category, SpotCategory.touristSpot);
  });

  test('R18 · 인기 spot은 likeCount와 함께 매핑된다', () async {
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: <String, dynamic>{
          'popularSpots': <String, dynamic>{
            'edges': <Map<String, dynamic>>[
              <String, dynamic>{
                'node': _spotItem(),
                'cursor': 'c1',
                'likeCount': 37,
              },
            ],
            'pageInfo': <String, dynamic>{
              'hasNextPage': false,
              'endCursor': null,
            },
          },
        },
      ),
    );

    final CursorPage<PopularSpot> page = await repo.fetchPopularSpots(
      latitude: 37.5,
      longitude: 127.0,
    );

    expect(page.items.single.spot.id, 'spot-1');
    // 랭킹 근거는 노드가 아니라 edge에 실려 온다.
    expect(page.items.single.likeCount, 37);
  });

  // --- 부분 실패 / 축약 (SPEC-0008 R-7 ~ R-11) --------------------------------

  test('gallery·infoItems가 null이면 빈 배열로 접힌다 (AC-28·AC-29)', () async {
    // 서버가 하위 조회 실패를 필드 null로 내린다. 도메인 모델은 "조회 실패"와
    // "정상적으로 없음"을 구분하지 않는다 — 둘 다 섹션을 숨기기 때문이다.
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(data: _detailData(gallery: null, infoItems: null)),
    );

    final SpotDetail detail = await repo.fetchSpotDetail(
      'c1',
      SpotCategory.touristSpot,
    );

    expect(detail.gallery, isEmpty);
    expect(detail.infoItems, isEmpty);
    // 섹션은 숨겨지되 전체는 정상 상태다 — 오류로 번역되지 않는다(AC-23).
    expect(detail.hasInfoItems, isFalse);
    expect(detail.title, 'T');
  });

  test('본문까지 없으면 축약 상태가 되지만 실패가 아니다 (AC-31·AC-34)', () async {
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: _detailData(gallery: null, infoItems: null, overview: null),
      ),
    );

    final SpotDetail detail = await repo.fetchSpotDetail(
      'c1',
      SpotCategory.touristSpot,
    );

    expect(detail.hasOverview, isFalse);
    expect(detail.hasIntro, isFalse);
    // 목록이 이미 준 값은 남는다 — 축약 화면이 보여주는 전부다.
    expect(detail.thumbnailImageUrl, isNotEmpty);
    expect(detail.likeCount, 0);
  });

  test('하위 필드만 가리키는 errors[]는 전체 실패가 아니다 (AC-25)', () async {
    // `path`가 ["spotDetail","gallery"]면 갤러리만 실패한 것이다. errors[]가
    // 비어있지 않다는 사실만으로 전체 실패로 단정하면 R-7이 무너진다.
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        data: _detailData(gallery: null),
        errors: const <GraphQLError>[
          GraphQLError(
            message: 'gallery lookup failed',
            path: <dynamic>['spotDetail', 'gallery'],
          ),
        ],
      ),
    );

    final SpotDetail detail = await repo.fetchSpotDetail(
      'c1',
      SpotCategory.touristSpot,
    );

    // 던지지 않고 본문을 돌려준다.
    expect(detail.id, 'c1');
    expect(detail.gallery, isEmpty);
  });

  test('최상위 필드를 가리키는 errors[]는 전체 실패다 (AC-24)', () async {
    // path가 ["spotDetail"] 한 칸이면 그 필드의 해소 자체가 실패한 것이다.
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        errors: const <GraphQLError>[
          GraphQLError(
            message: 'SPOT_NOT_FOUND',
            path: <dynamic>['spotDetail'],
          ),
        ],
      ),
    );

    await expectLater(
      repo.fetchSpotDetail('c1', SpotCategory.touristSpot),
      throwsA(isA<SpotFailure>()),
    );
  });

  test('부분 실패가 앞에 와도 루트 오류 코드를 놓치지 않는다', () async {
    // ErrorPolicy.all 이후로는 부분 실패와 전체 실패가 **같은 배열에** 실려 온다.
    // errors.first만 보면 갤러리 실패에서 코드를 못 찾아 UNAUTHENTICATED가
    // network로 둔갑하고, 그러면 재시도 상한에 계상되어 SPEC-0006 R5가 깨진다.
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        errors: const <GraphQLError>[
          GraphQLError(
            message: 'gallery lookup failed',
            path: <dynamic>['spotDetail', 'gallery'],
          ),
          GraphQLError(
            message: 'unauthorized',
            path: <dynamic>['spotDetail'],
            extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
          ),
        ],
      ),
    );

    await expectLater(
      repo.fetchSpotDetail('c1', SpotCategory.touristSpot),
      throwsA(
        isA<SpotFailure>().having(
          (SpotFailure f) => f.kind,
          'kind',
          SpotFailureKind.unauthenticated,
        ),
      ),
    );
  });

  // --- 좋아요 목록 (SPEC-0008 R-18) -------------------------------------------

  test('fetchLikedSpots가 커넥션을 CursorPage로 매핑한다', () async {
    final _FakeLink link = _FakeLink(
      data: <String, dynamic>{
        'likedSpots': <String, dynamic>{
          'edges': <dynamic>[
            <String, dynamic>{
              'cursor': 'c1',
              'node': <String, dynamic>{
                'id': 'spot-1',
                'title': 'Gyeongbokgung',
                'thumbnailImageUrl': 'https://img/1.jpg',
                'address': 'Seoul',
                'category': 'TOURIST_SPOT',
                'copyright': 'TYPE1',
                'attributionText': 'KTO',
              },
            },
          ],
          'pageInfo': <String, dynamic>{'hasNextPage': true, 'endCursor': 'c1'},
          'totalCount': 10,
        },
      },
    );

    final CursorPage<LikedSpot> page = await _repo(
      link,
    ).fetchLikedSpots(first: 20);

    expect(page.items.single.id, 'spot-1');
    expect(page.items.single.category, SpotCategory.touristSpot);
    expect(page.hasNextPage, isTrue);
    expect(page.endCursor, 'c1');
    expect(link.sentVariables?['first'], 20);
  });

  test('fetchLikedSpots가 카테고리를 서버 enum으로 실어 보낸다', () async {
    final _FakeLink link = _FakeLink(
      data: <String, dynamic>{
        'likedSpots': <String, dynamic>{
          'edges': <dynamic>[],
          'pageInfo': <String, dynamic>{
            'hasNextPage': false,
            'endCursor': null,
          },
        },
      },
    );

    await _repo(link).fetchLikedSpots(category: SpotCategory.restaurant);

    expect(link.sentVariables?['category'], 'RESTAURANT');
  });

  test('카테고리가 null이면 필터를 보내지 않는다 (전체)', () async {
    final _FakeLink link = _FakeLink(
      data: <String, dynamic>{
        'likedSpots': <String, dynamic>{
          'edges': <dynamic>[],
          'pageInfo': <String, dynamic>{
            'hasNextPage': false,
            'endCursor': null,
          },
        },
      },
    );

    await _repo(link).fetchLikedSpots();

    expect(link.sentVariables?['category'], isNull);
  });

  test('fetchLikedSpots는 after 커서를 그대로 보낸다', () async {
    final _FakeLink link = _FakeLink(
      data: <String, dynamic>{
        'likedSpots': <String, dynamic>{
          'edges': <dynamic>[],
          'pageInfo': <String, dynamic>{
            'hasNextPage': false,
            'endCursor': null,
          },
          'totalCount': 0,
        },
      },
    );

    final CursorPage<LikedSpot> page = await _repo(
      link,
    ).fetchLikedSpots(first: 20, after: 'cursor-2');

    expect(link.sentVariables?['after'], 'cursor-2');
    expect(page.items, isEmpty);
    expect(page.hasNextPage, isFalse);
  });

  test('fetchLikedSpots의 UNAUTHENTICATED는 실패로 번역된다', () async {
    final SpotRepositoryImpl repo = _repo(
      _FakeLink(
        errors: const <GraphQLError>[
          GraphQLError(
            message: 'unauthorized',
            extensions: <String, dynamic>{'code': 'UNAUTHENTICATED'},
          ),
        ],
      ),
    );

    await expectLater(repo.fetchLikedSpots(), throwsA(isA<SpotFailure>()));
  });
}

/// 상세 응답 한 벌. 부분 실패를 표현하려고 [gallery]·[infoItems]를 null로 줄 수 있다
/// (서버 nullability 완화 후의 실제 형태).
Map<String, dynamic> _detailData({
  List<dynamic>? gallery = const <dynamic>[],
  List<dynamic>? infoItems = const <dynamic>[],
  String? overview = 'An overview.',
}) => <String, dynamic>{
  'spotDetail': <String, dynamic>{
    'id': 'c1',
    'title': 'T',
    'category': 'TOURIST_SPOT',
    'thumbnailImageUrl': 'https://img/t.jpg',
    'overview': overview,
    'address': 'Seoul',
    'homepage': null,
    'tel': null,
    'copyright': 'TYPE1',
    'attributionText': 'KTO',
    'gallery': gallery,
    'likeCount': 0,
    'intro': null,
    'infoItems': infoItems,
  },
};
