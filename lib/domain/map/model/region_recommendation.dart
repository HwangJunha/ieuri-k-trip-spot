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
/// **빈 목록은 오류가 아니다.** 배치가 데이터를 쌓기 전에는 추천이 성립하지 않으며,
/// 오류 화면으로 그리면 사용자가 해결되지 않는 재시도를 반복한다.
class RegionRecommendationResult {
  const RegionRecommendationResult({
    required this.regions,
    required this.dataBasisAt,
  });

  /// 총점 내림차순(R22).
  final List<RegionRecommendation> regions;

  /// 점수 산출에 쓰인 데이터의 기준 시점.
  ///
  /// **null은 "적재된 데이터가 하나도 없다"는 뜻**이며 이때 [regions]도 비어 있다.
  /// 화면에 반드시 표시한다(R24 · POL-038) — 이 값이 "실시간이 아님"을 드러내는
  /// 유일한 장치다.
  final DateTime? dataBasisAt;

  bool get isEmpty => regions.isEmpty;

  /// 빈 결과의 두 상태를 가른다(§5.1).
  ///
  /// 기준 시점이 없으면 아직 모으는 중이고, 있으면 데이터는 있으나 조건을 만족한 지역이
  /// 없는 것이다. 둘을 같은 문구로 뭉뚱그리면 사용자가 **기다려야 하는 상황인지 조건을
  /// 바꿔야 하는 상황인지** 알 수 없다.
  bool get isAwaitingData => regions.isEmpty && dataBasisAt == null;

  /// 데이터는 쌓였으나 추천 조건을 만족한 지역이 없는 상태.
  bool get hasNoMatch => regions.isEmpty && dataBasisAt != null;
}
