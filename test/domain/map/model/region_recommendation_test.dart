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

  group('강점 항목', () {
    test('value가 가장 높은 항목을 고른다', () {
      // **rank로 고르지 않는다** — 항목마다 모수가 달라 20곳 중 3위와 5곳 중 3위는
      // 같은 뜻이 아니다. value는 같은 정규화 축 위에 있어 비교가 성립한다.
      final RegionRecommendation region = regionWith(const <RegionScore>[
        // rank는 더 좋지만(1위) value는 낮다.
        RegionScore(
          factor: RegionScoreFactor.congestion,
          value: 20,
          rank: 1,
        ),
        RegionScore(
          factor: RegionScoreFactor.stayIntensity,
          value: 95,
          rank: 7,
        ),
      ]);

      expect(region.strongestScore?.factor, RegionScoreFactor.stayIntensity);
    });

    test('값이 같으면 항목 선언 순서로 가른다', () {
      // 서버가 준 배열 순서에 따라 같은 지역의 강점이 조회마다 달라 보이면 안 된다.
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

      // stayIntensity가 spendingIntensity보다 먼저 선언돼 있다.
      expect(region.strongestScore?.factor, RegionScoreFactor.stayIntensity);
    });

    test('모르는 항목은 강점이 되지 않는다', () {
      // 이름도 뜻도 모르는 항목을 강점이라 부를 수 없다.
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.unknown, value: 100, rank: 1),
        RegionScore(factor: RegionScoreFactor.distance, value: 40, rank: 9),
      ]);

      expect(region.strongestScore?.factor, RegionScoreFactor.distance);
    });

    test('항목이 없으면 강점도 없다', () {
      expect(regionWith(const <RegionScore>[]).strongestScore, isNull);
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
