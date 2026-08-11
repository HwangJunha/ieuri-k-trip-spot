import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/region_recommendation.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/region_score.dart';

/// SPEC-0015 지역 추천 도메인 모델.
void main() {
  RegionRecommendation regionWith(List<RegionScore> scores) =>
      RegionRecommendation(
        code: '11110',
        name: 'Jongno-gu',
        provinceName: 'Seoul',
        scores: scores,
        scoreFactorCount: scores.length,
        centerLat: 37.5735,
        centerLng: 126.9790,
      );

  group('결측 항목', () {
    test('빠진 항목을 0점으로 채우지 않는다', () {
      // 서버가 산출 불가 항목을 빼서 준다(§2.2). 0으로 채우면 서버가 피한 왜곡을
      // 클라이언트가 되살린다.
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(
          factor: RegionScoreFactor.congestion,
          value: 90,
          rank: 2,
        ),
      ]);

      expect(region.scores, hasLength(1));
      expect(region.lacks(RegionScoreFactor.visitorVolume), isTrue);
    });

    test('거리 항목이 없으면 위치 없이 받은 결과다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.congestion, value: 90, rank: 1),
      ]);

      expect(region.lacksDistance, isTrue);
    });

    test('거리 항목이 있으면 위치를 반영한 결과다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.distance, value: 70, rank: 3),
      ]);

      expect(region.lacksDistance, isFalse);
    });
  });

  group('점수 막대 비율', () {
    test('0~100을 0.0~1.0으로 옮긴다', () {
      const RegionScore score = RegionScore(
        factor: RegionScoreFactor.stayIntensity,
        value: 75,
        rank: 4,
      );

      expect(score.fraction, closeTo(0.75, 1e-9));
    });

    test('범위를 벗어난 값이 와도 막대가 넘치지 않는다', () {
      const RegionScore over = RegionScore(
        factor: RegionScoreFactor.congestion,
        value: 140,
        rank: 1,
      );
      const RegionScore under = RegionScore(
        factor: RegionScoreFactor.congestion,
        value: -20,
        rank: 30,
      );

      expect(over.fraction, 1.0);
      expect(under.fraction, 0.0);
    });
  });

  group('강점 라벨 (시·도 3위 이내)', () {
    test('3위 안에 든 항목만 고른다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.distance, value: 90, rank: 1),
        RegionScore(factor: RegionScoreFactor.congestion, value: 80, rank: 3),
        // 4위는 라벨을 붙이지 않는다.
        RegionScore(factor: RegionScoreFactor.stayIntensity, value: 70, rank: 4),
      ]);

      expect(
        region.topRankedScores.map((RegionScore s) => s.factor).toList(),
        <RegionScoreFactor>[
          RegionScoreFactor.distance,
          RegionScoreFactor.congestion,
        ],
      );
    });

    test('순위가 좋은 것부터 나온다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.congestion, value: 50, rank: 3),
        RegionScore(factor: RegionScoreFactor.distance, value: 40, rank: 1),
      ]);

      expect(region.topRankedScores.first.factor, RegionScoreFactor.distance);
    });

    test('3위 안에 든 항목이 없으면 라벨도 없다', () {
      // 실측상 10곳 중 2곳이 이렇다. 없는 강점을 지어내지 않는다.
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.congestion, value: 90, rank: 4),
        RegionScore(factor: RegionScoreFactor.distance, value: 80, rank: 12),
      ]);

      expect(region.topRankedScores, isEmpty);
    });

    test('모르는 항목은 라벨이 되지 않는다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.unknown, value: 100, rank: 1),
        RegionScore(factor: RegionScoreFactor.distance, value: 40, rank: 2),
      ]);

      expect(
        region.topRankedScores.map((RegionScore s) => s.factor).toList(),
        <RegionScoreFactor>[RegionScoreFactor.distance],
      );
    });

    test('동순위는 항목 선언 순서로 가른다', () {
      // 서버가 준 배열 순서에 따라 라벨 순서가 흔들리면 안 된다.
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(
          factor: RegionScoreFactor.spendingIntensity,
          value: 100,
          rank: 1,
        ),
        RegionScore(
          factor: RegionScoreFactor.stayIntensity,
          value: 100,
          rank: 1,
        ),
      ]);

      expect(
        region.topRankedScores.first.factor,
        RegionScoreFactor.stayIntensity,
      );
    });
  });

  group('빈 결과(§5.1)', () {
    test('목록이 비면 빈 결과다', () {
      // 바다·해외 좌표, 시군구 3개 미만인 시도(세종·제주), 후보 없음이 모두 이렇게
      // 온다. 어느 경우에도 오류가 아니다.
      const RegionRecommendationResult result = RegionRecommendationResult(
        regions: <RegionRecommendation>[],
      );

      expect(result.isEmpty, isTrue);
    });

    test('목록이 차 있으면 빈 결과가 아니다', () {
      final RegionRecommendationResult result = RegionRecommendationResult(
        regions: <RegionRecommendation>[regionWith(const <RegionScore>[])],
      );

      expect(result.isEmpty, isFalse);
    });
  });
}
