import 'commercial_display_state.dart';
import 'congestion_level.dart';

/// 구역 1곳의 인구 밀집 스냅샷(R7·R8).
class CongestionSnapshot {
  const CongestionSnapshot({
    required this.level,
    required this.populationMin,
    required this.populationMax,
    required this.observedAt,
  });

  final CongestionLevel level;
  final int populationMin;
  final int populationMax;

  /// 이 스냅샷이 만들어진 시각. **현재 시각이 아니다** — 데이터는 약 30분 지연되어
  /// 도착한다(spec §4.2). 표시할 때 "지금"으로 쓰지 않는다(R27).
  final DateTime observedAt;

  @override
  bool operator ==(Object other) =>
      other is CongestionSnapshot &&
      other.level == level &&
      other.populationMin == populationMin &&
      other.populationMax == populationMax &&
      other.observedAt == observedAt;

  @override
  int get hashCode =>
      Object.hash(level, populationMin, populationMax, observedAt);
}

/// 구역 1곳의 실시간 혼잡도(R6~R10).
///
/// **폴리곤 좌표를 담지 않는다.** 경계는 정적이라 [CongestionAreaBoundary]로 따로
/// 받아 캐시하고 [id]로 조인한다(spec §7.3) — 5분마다 121개 폴리곤을 다시 받는 것은
/// 순수한 낭비다.
class CongestionArea {
  const CongestionArea({
    required this.id,
    required this.name,
    required this.congestion,
    this.commercial,
  });

  /// [CongestionAreaBoundary.id]와 같은 조인 키다.
  final String id;

  /// 활성 언어로 표기한 구역명(R31). **서버가 내려준다** — 121건을 클라이언트 번역
  /// 파일에 넣지 않는다(spec §7.10). 활성 언어는 `Accept-Language` 헤더로 간다.
  final String name;

  final CongestionSnapshot congestion;

  /// 상업 활성도(R10). **부재가 정상이다** — 121곳 중 82곳에만 값이 있다.
  /// 해석은 [commercialState]가 한다.
  final CommercialStatus? commercial;

  /// 상권 3상태(R28). 부재·기본값·실측을 한 번만 해석해 화면에 넘긴다.
  CommercialDisplayState get commercialState =>
      commercialDisplayStateOf(commercial);

  @override
  bool operator ==(Object other) =>
      other is CongestionArea &&
      other.id == id &&
      other.name == name &&
      other.congestion == congestion &&
      other.commercial == commercial;

  @override
  int get hashCode => Object.hash(id, name, congestion, commercial);
}

/// 구역 1곳의 정적 폴리곤 경계(R17). 앱 시작 시 1회 조회해 캐시한다(R26).
class CongestionAreaBoundary {
  const CongestionAreaBoundary({
    required this.id,
    required this.name,
    required this.category,
    required this.polygon,
  });

  final String id;

  /// 활성 언어로 표기한 구역명(R31). **캐시 키에 언어를 포함해야 한다** — 이 값이
  /// 언어에 따라 달라지므로, 언어를 무시하고 캐싱하면 언어를 바꿔도 이전 언어의
  /// 이름이 남는다(설계 §5.2).
  final String name;

  /// 구역 분류(관광특구·고궁문화유산·발달상권 등).
  final String category;

  /// 닫힌 단순 다각형. 첫 점과 끝 점이 같다.
  ///
  /// **좌표 순서가 `[lng, lat]`이다** — GeoJSON 규약을 그대로 따른다. 위경도 순서를
  /// 뒤집어 넣는 사고가 잦은 자리라, 위젯으로 넘길 때 반드시 이 순서를 확인한다.
  final List<List<double>> polygon;

  @override
  bool operator ==(Object other) =>
      other is CongestionAreaBoundary && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}
