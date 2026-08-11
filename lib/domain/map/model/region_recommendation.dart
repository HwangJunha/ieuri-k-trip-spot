import 'region_score.dart';

/// 추천된 시군구 1건(SPEC-0015 §2.1).
///
/// 카메라 이동의 목적지이자 카드 하나의 내용이다. 생성 타입은 repository 밖으로 나오지
/// 않으므로(POL-020) 화면과 provider는 이 모델만 본다.
class RegionRecommendation {
  const RegionRecommendation({
    required this.code,
    required this.name,
    required this.provinceName,
    required this.totalScore,
    required this.scores,
    required this.scoreFactorCount,
    required this.centerLat,
    required this.centerLng,
  });

  /// 시군구 행정표준코드 5자리(예: 11110). 목록의 안정적인 키다.
  final String code;

  /// 활성 언어 표기. 서버가 Accept-Language로 골라 준다(POL-039).
  final String name;

  /// 상위 시도 표기.
  ///
  /// **카드에 반드시 함께 보여준다**(§2.1) — 같은 이름의 시군구가 실제로 여럿이라
  /// (중구·남구·동구) 지역명만으로는 어디인지 알 수 없다.
  final String provinceName;

  /// 가중합 총점(0~100). 목록 정렬 기준이다.
  final double totalScore;

  /// 항목별 점수. **결측 항목은 빠진 채로 온다**(§2.2).
  final List<RegionScore> scores;

  /// 총점 산출에 쓰인 항목 수.
  ///
  /// 총점은 존재하는 항목의 가중치 합으로 나눈 값이라, 항목 3개로 나온 80점과 5개로
  /// 나온 80점은 **근거의 두께가 다르다**. 이 값이 작을수록 근거가 얕다(R31 · §2.2).
  final int scoreFactorCount;

  /// 지도를 이 지역으로 옮길 때 쓰는 대표 좌표. 경계 폴리곤 내부의 점이 보장된다.
  final double centerLat;
  final double centerLng;

  /// 해당 항목이 산출되지 않았는지. 화면은 이때 막대를 그리지 않고 부재로 표기한다.
  bool lacks(RegionScoreFactor factor) =>
      scores.every((score) => score.factor != factor);

  /// 위치 없이 받은 결과인지(R27). 거리 항목이 없으면 위치를 주지 않았다는 뜻이다.
  bool get lacksDistance => lacks(RegionScoreFactor.distance);

  /// 항목들의 기준일 중 **가장 오래된 것**. 하나도 없으면 null이다.
  ///
  /// **최신이 아니라 가장 오래된 값을 고른다**(R24). 항목마다 신선도가 달라서
  /// (집중률은 오늘, 월 지표는 해당 월 1일) 최신 날짜를 적으면 카드 전체가 그만큼
  /// 새것처럼 읽힌다. 가장 오래된 값이 이 추천이 최소한 얼마나 묵은 근거 위에 서
  /// 있는지를 정직하게 말해 준다.
  ///
  /// [RegionScoreFactor.distance]는 기준일이라는 개념이 없어(요청 시점 계산) 자연히
  /// 빠진다.
  DateTime? get oldestBasisAt {
    DateTime? oldest;
    for (final RegionScore score in scores) {
      final DateTime? at = score.basisAt;
      if (at == null) continue;
      if (oldest == null || at.isBefore(oldest)) oldest = at;
    }
    return oldest;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegionRecommendation &&
          other.code == code &&
          other.name == name &&
          other.provinceName == provinceName &&
          other.totalScore == totalScore &&
          other.scoreFactorCount == scoreFactorCount &&
          other.centerLat == centerLat &&
          other.centerLng == centerLng &&
          _sameScores(other.scores);

  bool _sameScores(List<RegionScore> other) {
    if (other.length != scores.length) return false;
    for (var i = 0; i < scores.length; i++) {
      if (other[i] != scores[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    code,
    name,
    provinceName,
    totalScore,
    scoreFactorCount,
    centerLat,
    centerLng,
    Object.hashAll(scores),
  );
}

/// 추천 조회 1회의 결과(SPEC-0015 §5.1).
///
/// **빈 목록은 오류가 아니다.** 서버가 빈 목록을 주는 경우는 여럿이다 — 바다·해외처럼
/// 어느 시군구에도 속하지 않는 좌표, 시군구가 3개 미만인 시도(세종·제주), 관광지가
/// 충분치 않아 후보에서 빠진 지역만 남은 시도. 어느 쪽도 오류가 아니며 재시도로
/// 해결되지도 않는다.
class RegionRecommendationResult {
  const RegionRecommendationResult({required this.regions});

  /// 총점 내림차순(R22).
  final List<RegionRecommendation> regions;

  bool get isEmpty => regions.isEmpty;
}
