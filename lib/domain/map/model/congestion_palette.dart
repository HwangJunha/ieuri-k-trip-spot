import 'congestion_level.dart';

/// 혼잡도 4단계의 폴리곤 채색(R24, 설계 §5.3).
///
/// **`Color`가 아니라 ARGB 정수를 준다.** `model/`은 순수 Dart라 프레임워크 타입을
/// 들이지 않는다(CLAUDE.md §3). 위젯 쪽에서 `Color(...)`로 감싼다.
///
/// ## 왜 신호등 배색이 아닌가
///
/// 흔한 초록–노랑–빨강은 적록색맹(남성 약 8%) 사용자에게 [CongestionLevel.relaxed]와
/// [CongestionLevel.crowded]가 비슷하게 보인다. **가장 구분돼야 할 두 값이 가장 안
/// 구분되는** 배색이다.
///
/// 그래서 색상환 대신 **순차형(sequential) 스케일**을 쓴다 — 색상이 노랑에서 짙은
/// 자주로 옮겨가며 **명도가 단조 감소**한다. 색을 전혀 구분하지 못해도 밝기만으로
/// 순서를 읽을 수 있고, 4단계가 순서 있는 값이므로 의미상으로도 순차형이 맞다.
/// (ColorBrewer YlOrRd 계열을 기준으로 골랐다.)
abstract final class CongestionPalette {
  /// 폴리곤 채우기 색(ARGB). 알파 0x66(40%)으로 두어 아래 지도와 마커가 비친다
  /// (설계 §5.3).
  static int fillOf(CongestionLevel level) => switch (level) {
    CongestionLevel.relaxed => 0x66FFEDA0,
    CongestionLevel.normal => 0x66FEB24C,
    CongestionLevel.slightlyCrowded => 0x66F03B20,
    CongestionLevel.crowded => 0x66BD0026,
  };

  /// 폴리곤 테두리 색(ARGB). 채우기와 같은 색상을 불투명하게 써서 인접한 구역끼리
  /// 경계가 뭉개지지 않게 한다.
  static int strokeOf(CongestionLevel level) => switch (level) {
    CongestionLevel.relaxed => 0xFFE8C63A,
    CongestionLevel.normal => 0xFFFEB24C,
    CongestionLevel.slightlyCrowded => 0xFFF03B20,
    CongestionLevel.crowded => 0xFFBD0026,
  };

  /// 범례·말풍선의 단계 표시 점 색(ARGB). 불투명하다 — 작은 도형이라 반투명하면
  /// 배경에 묻힌다.
  static int dotOf(CongestionLevel level) => strokeOf(level);
}
