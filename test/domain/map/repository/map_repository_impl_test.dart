import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/location/coordinates.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_failure.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/region_recommendation.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/region_score.dart';
import 'package:ieuri_k_trip_spot/domain/map/repository/map_repository_impl.dart';

/// 정형 [Response] 하나를 돌려주는 링크. 실제 네트워크 대신 매핑과 실패 판정만
/// 검증한다(settings·community 테스트와 같은 패턴).
class _FakeLink extends Link {
  _FakeLink({this.data, this.errors});

  final Map<String, dynamic>? data;
  final List<GraphQLError>? errors;

  /// 마지막으로 서버에 나간 변수(전송 내용 검증용).
  Map<String, dynamic>? sentVariables;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    sentVariables = request.variables;
    yield Response(
      data: data,
      errors: errors,
      response: const <String, dynamic>{},
      context: const Context(),
    );
  }
}

MapRepositoryImpl _repo(Link link) => MapRepositoryImpl(
  GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      query: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
    ),
  ),
);

/// **실 서버(localhost:8888) 응답을 그대로 옮긴 것이다**(2026-08-12 채취).
///
/// 손으로 지어낸 모양이 아니라 서버가 실제로 준 값이라, 매핑이 실전에서 도는지를
/// 검증한다 — 특히 `basisAt`이 항목마다 다르고 DISTANCE만 null인 부분.
Map<String, dynamic> _liveResponse() => <String, dynamic>{
  'recommendedRegions': <String, dynamic>{
    'regions': <dynamic>[
      <String, dynamic>{
        'code': '11680',
        'name': 'Gangnam-gu',
        'provinceName': 'Seoul',
        'scoreFactorCount': 5,
        'center': <String, dynamic>{
          'lat': 37.5238962764,
          'lng': 127.0396358978,
        },
        'scores': <dynamic>[
          <String, dynamic>{
            'factor': 'CONGESTION',
            'value': 15.017708782550542,
            'rank': 22,
          },
          <String, dynamic>{
            'factor': 'VISITOR_VOLUME',
            'value': 48.51563763748991,
            'rank': 1,
          },
          <String, dynamic>{
            'factor': 'STAY_INTENSITY',
            'value': 100.0,
            'rank': 1,
          },
          <String, dynamic>{
            'factor': 'SPENDING_INTENSITY',
            'value': 100.0,
            'rank': 1,
          },
          <String, dynamic>{
            'factor': 'DISTANCE',
            'value': 80.62547357523549,
            'rank': 9,
          },
        ],
      },
    ],
  },
};

void main() {
  const Coordinates seoul = Coordinates(latitude: 37.5665, longitude: 126.9780);

  group('fetchRecommendedRegions', () {
    test('실 서버 응답을 도메인 모델로 옮긴다', () async {
      final _FakeLink link = _FakeLink(data: _liveResponse());

      final RegionRecommendationResult result = await _repo(
        link,
      ).fetchRecommendedRegions(origin: seoul);

      final RegionRecommendation region = result.regions.single;
      expect(region.code, '11680');
      expect(region.name, 'Gangnam-gu');
      expect(region.provinceName, 'Seoul');
      expect(region.scoreFactorCount, 5);
      expect(region.centerLat, closeTo(37.5238962764, 1e-9));
      expect(region.centerLng, closeTo(127.0396358978, 1e-9));
    });

    test('항목별 순위를 그대로 싣는다', () async {
      // **목록이 아니라 시·도 전체 후보 기준이다** — CONGESTION의 22위처럼 반환된
      // 지역 수보다 큰 값이 정상이다.
      final _FakeLink link = _FakeLink(data: _liveResponse());

      final RegionRecommendationResult result = await _repo(
        link,
      ).fetchRecommendedRegions(origin: seoul);
      final RegionRecommendation region = result.regions.single;

      expect(
        region.scores
            .firstWhere(
              (RegionScore s) => s.factor == RegionScoreFactor.congestion,
            )
            .rank,
        22,
      );
    });

    test('강점 라벨은 3위 이내 항목만 뽑는다', () async {
      // 실 응답의 강남구: VISITOR_VOLUME·STAY_INTENSITY·SPENDING_INTENSITY가 1위,
      // DISTANCE는 9위, CONGESTION은 22위다.
      final _FakeLink link = _FakeLink(data: _liveResponse());

      final RegionRecommendationResult result = await _repo(
        link,
      ).fetchRecommendedRegions(origin: seoul);

      expect(
        result.regions.single.topRankedScores
            .map((RegionScore s) => s.factor)
            .toList(),
        <RegionScoreFactor>[
          RegionScoreFactor.visitorVolume,
          RegionScoreFactor.stayIntensity,
          RegionScoreFactor.spendingIntensity,
        ],
      );
    });

    test('조회에 쓴 좌표를 결과에 담아 돌려준다', () async {
      // 화면이 거리를 재는 데 쓴다. 내 위치 기준일 때는 provider가 좌표를 얻으므로
      // 화면이 알 방법이 없어, 결과에 실려 오지 않으면 거리가 통째로 사라진다
      // (실기기에서 그 상태였다).
      final _FakeLink link = _FakeLink(data: _liveResponse());

      final RegionRecommendationResult result = await _repo(
        link,
      ).fetchRecommendedRegions(origin: seoul);

      expect(result.origin, seoul);
    });

    test('좌표와 limit을 요청에 싣는다', () async {
      final _FakeLink link = _FakeLink(data: _liveResponse());

      await _repo(link).fetchRecommendedRegions(origin: seoul, limit: 5);

      expect(link.sentVariables?['origin'], <String, dynamic>{
        'lat': 37.5665,
        'lng': 126.9780,
      });
      expect(link.sentVariables?['limit'], 5);
    });

    test('빈 목록은 오류가 아니다', () async {
      // 바다·해외 좌표, 시군구 3개 미만인 시도가 이렇게 온다(§5.1).
      final _FakeLink link = _FakeLink(
        data: <String, dynamic>{
          'recommendedRegions': <String, dynamic>{'regions': <dynamic>[]},
        },
      );

      final RegionRecommendationResult result = await _repo(
        link,
      ).fetchRecommendedRegions(origin: seoul);

      expect(result.isEmpty, isTrue);
    });

    test('errors 배열이 차 있으면 실패로 올린다', () async {
      // GraphQL은 실패해도 HTTP 200이라 errors를 봐야 한다(CLAUDE.md §4).
      final _FakeLink link = _FakeLink(
        errors: const <GraphQLError>[GraphQLError(message: '좌표가 올바르지 않습니다.')],
      );

      expect(
        () => _repo(link).fetchRecommendedRegions(origin: seoul),
        throwsA(isA<MapFailure>()),
      );
    });
  });
}
