import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/region_recommendation.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/region_score.dart';

/// SPEC-0015 지역 추천 도메인 모델. 여기서 지는 기준은 §7의 표다.
void main() {
  RegionRecommendation regionWith(List<RegionScore> scores) =>
      RegionRecommendation(
        code: '11110',
        name: 'Jongno-gu',
        provinceName: 'Seoul',
        totalScore: 80,
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
        RegionScore(factor: RegionScoreFactor.congestion, value: 90),
      ]);

      expect(region.scores, hasLength(1));
      expect(region.lacks(RegionScoreFactor.visitorVolume), isTrue);
    });

    test('거리 항목이 없으면 위치 없이 받은 결과다', () {
      // R27 — 위치 권한이 없으면 거리 항목이 부재로 표기된다.
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.congestion, value: 90),
      ]);

      expect(region.lacksDistance, isTrue);
    });

    test('거리 항목이 있으면 위치를 반영한 결과다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.distance, value: 70),
      ]);

      expect(region.lacksDistance, isFalse);
    });
  });

  group('점수 막대 비율', () {
    test('0~100을 0.0~1.0으로 옮긴다', () {
      const RegionScore score = RegionScore(
        factor: RegionScoreFactor.stayIntensity,
        value: 75,
      );

      expect(score.fraction, closeTo(0.75, 1e-9));
    });

    test('범위를 벗어난 값이 와도 막대가 넘치지 않는다', () {
      const RegionScore over = RegionScore(
        factor: RegionScoreFactor.congestion,
        value: 140,
      );
      const RegionScore under = RegionScore(
        factor: RegionScoreFactor.congestion,
        value: -20,
      );

      expect(over.fraction, 1.0);
      expect(under.fraction, 0.0);
    });
  });

  group('빈 결과의 두 상태(§5.1)', () {
    test('기준 시점이 없으면 아직 데이터를 모으는 중이다', () {
      const RegionRecommendationResult result = RegionRecommendationResult(
        regions: <RegionRecommendation>[],
        dataBasisAt: null,
      );

      expect(result.isAwaitingData, isTrue);
      expect(result.hasNoMatch, isFalse);
    });

    test('기준 시점이 있는데 목록이 비면 조건에 맞는 지역이 없는 것이다', () {
      final RegionRecommendationResult result = RegionRecommendationResult(
        regions: const <RegionRecommendation>[],
        dataBasisAt: DateTime(2026, 8, 11, 4),
      );

      expect(result.hasNoMatch, isTrue);
      expect(result.isAwaitingData, isFalse);
    });

    test('목록이 차 있으면 어느 빈 상태도 아니다', () {
      final RegionRecommendationResult result = RegionRecommendationResult(
        regions: <RegionRecommendation>[regionWith(const <RegionScore>[])],
        dataBasisAt: DateTime(2026, 8, 11, 4),
      );

      expect(result.isEmpty, isFalse);
      expect(result.isAwaitingData, isFalse);
      expect(result.hasNoMatch, isFalse);
    });
  });
}
