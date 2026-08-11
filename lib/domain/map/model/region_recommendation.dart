import '../../../common/location/coordinates.dart';
import 'region_score.dart';

/// 강점 라벨을 붙이는 순위 기준. 시·도 안에서 이 순위 이내면 라벨이 붙는다.
const int topRankThreshold = 3;

/// 추천된 시군구 1건(SPEC-0015 §2.1).
///
/// 카메라 이동의 목적지이자 카드 하나의 내용이다. 생성 타입은 repository 밖으로 나오지
/// 않으므로(POL-020) 화면과 provider는 이 모델만 본다.
class RegionRecommendation {
  const RegionRecommendation({
    required this.code,
    required this.name,
    required this.provinceName,
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

  /// 항목별 점수. **결측 항목은 빠진 채로 온다**(§2.2).
  final List<RegionScore> scores;

  /// 산출에 쓰인 항목 수(= [scores]의 길이).
  ///
  /// **이 값이 작을수록 근거가 얕다**(R31 · §2.2) — 항목 3개로 매겨진 순위와 5개로
  /// 매겨진 순위는 근거의 두께가 다르다. 신뢰도 표현에 쓴다.
  final int scoreFactorCount;

  /// 지도를 이 지역으로 옮길 때 쓰는 대표 좌표. 경계 폴리곤 내부의 점이 보장된다.
  final double centerLat;
  final double centerLng;

  /// 해당 항목이 산출되지 않았는지. 화면은 이때 막대를 그리지 않고 부재로 표기한다.
  bool lacks(RegionScoreFactor factor) =>
      scores.every((score) => score.factor != factor);

  /// 위치 없이 받은 결과인지(R27). 거리 항목이 없으면 위치를 주지 않았다는 뜻이다.
  bool get lacksDistance => lacks(RegionScoreFactor.distance);

  /// 시·도 안에서 **3위 안에 든 항목들**. 순위가 좋은 순으로 정렬된다.
  ///
  /// 화면은 이것으로 강점 라벨을 붙인다 — "가까운 곳", "오래 머무는 곳"처럼 항목마다
  /// 하나씩이며 여러 개일 수 있다.
  ///
  /// **상위권만 라벨을 붙이는 이유**는, 모든 지역에 무언가를 붙이면 라벨이 변별력을
  /// 잃기 때문이다. 실제로 3위 안에 드는 항목이 하나도 없는 지역이 나오며(실측: 10곳
  /// 중 2곳) 그때는 라벨 없이 둔다 — 없는 강점을 지어내지 않는다.
  ///
  /// [RegionScoreFactor.unknown]은 제외한다 — 이름도 뜻도 모르는 항목을 강점이라
  /// 부를 수 없다.
  List<RegionScore> get topRankedScores {
    final List<RegionScore> top = scores
        .where(
          (RegionScore s) =>
              s.factor != RegionScoreFactor.unknown &&
              s.rank <= topRankThreshold,
        )
        .toList();
    // 순위가 좋은 것부터. 동순위는 항목 선언 순서로 갈라 조회마다 순서가 흔들리지
    // 않게 한다.
    top.sort((RegionScore a, RegionScore b) {
      final int byRank = a.rank.compareTo(b.rank);
      return byRank != 0 ? byRank : a.factor.index.compareTo(b.factor.index);
    });
    return top;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegionRecommendation &&
          other.code == code &&
          other.name == name &&
          other.provinceName == provinceName &&
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
  const RegionRecommendationResult({required this.regions, this.origin});

  /// **배열 순서가 곧 추천 순위다**(R22) — `regions[0]`이 1위다. 서버가 정한 순서를
  /// 그대로 두며 클라이언트가 다시 정렬하지 않는다.
  ///
  /// 총점(`totalScore`)은 계약에서 삭제됐다. 가중평균 구조상 총점은 늘 항목 점수들
  /// 사이 값이라 1위가 60점으로 나왔고, 절대 점수를 보여주는 것 자체가 이 데이터에
  /// 맞지 않는다.
  final List<RegionRecommendation> regions;

  /// **이번 조회에 실제로 쓰인 기준 좌표.**
  ///
  /// 화면이 거리를 그리려면 이 값이 필요한데, "내 위치" 기준일 때는 좌표를 provider가
  /// 얻으므로 화면이 알 방법이 없다 — 결과에 실어 돌려준다. 화면이 위치 provider를
  /// 따로 watch하면 둘이 각자 좌표를 얻어 어긋날 수 있다(조회에 쓴 좌표와 거리를 잰
  /// 좌표가 다른 상태).
  final Coordinates? origin;

  bool get isEmpty => regions.isEmpty;
}
