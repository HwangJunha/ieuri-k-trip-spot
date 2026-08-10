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
    CongestionLevel.relaxed => 0x66A8D8B9,
    CongestionLevel.normal => 0x66F2C879,
    CongestionLevel.slightlyCrowded => 0x66E8734A,
    CongestionLevel.crowded => 0x66B5283F,
  };

  /// 폴리곤 테두리 색(ARGB). 채우기와 같은 색상을 불투명하게 써서 인접한 구역끼리
  /// 경계가 뭉개지지 않게 한다.
  static int strokeOf(CongestionLevel level) => switch (level) {
    // 여유는 보통보다 **밝아야 한다** — 명도가 단조 감소해야 색을 못 봐도 순서가
    // 읽힌다(아래 명도 표 참고). 처음 고른 진한 초록(#6BAE86, 명도 149)은 주황보다
    // 어두워 그 규칙을 깨뜨렸다.
    CongestionLevel.relaxed => 0xFF9ECFAE,
    CongestionLevel.normal => 0xFFDDA544,
    CongestionLevel.slightlyCrowded => 0xFFE8734A,
    CongestionLevel.crowded => 0xFFB5283F,
  };

  /// 범례·말풍선의 단계 표시 점 색(ARGB). 불투명하다 — 작은 도형이라 반투명하면
  /// 배경에 묻힌다.
  static int dotOf(CongestionLevel level) => strokeOf(level);
}

/// 지도 마커 색(ARGB). **혼잡도 팔레트와 섞이지 않는 색만 쓴다.**
///
/// 처음에는 브랜드 코랄(`colorScheme.primary`)을 썼는데, 그 색이 [CongestionPalette]의
/// `crowded`(짙은 자주빨강)와 비슷해 **관광지 마커가 전부 "붐빔"으로 읽혔다.** 실기기에서
/// 지적받은 문제다 — 지도 위에서 색은 곧 의미라, 두 레이어가 같은 색조를 쓰면 사용자가
/// 구분할 방법이 없다.
///
/// 그래서 마커는 **무채색에 가까운 남색 계열**로 고정한다. 혼잡도의 노랑–주황–빨강–자주
/// 스케일과 색상환에서 멀고, 채색된 폴리곤 위에 얹혀도 읽힌다.
///
/// 테마에서 읽지 않고 상수로 두는 이유는, 테마 색이 바뀌면 이 분리가 조용히 깨지기
/// 때문이다. 색이 의미를 지는 자리라 우연에 맡기지 않는다.
abstract final class MapMarkerPalette {
  /// 관광지. 짙은 남색 — 배경 지도와 혼잡도 양쪽에서 구분된다.
  static const int spot = 0xFF2E4A6B;

  /// 문화행사. 보라 — 남색과 명확히 다르면서 혼잡도 스케일에는 없는 색상이다.
  /// 모양(다이아몬드)이 1차 구분이고 색은 보조다(R21).
  static const int culturalEvent = 0xFF6A4C93;

  /// 클러스터 배지. 개별 마커보다 진해 무리로 읽힌다.
  static const int cluster = 0xFF1F3450;

  /// 검색으로 찾은 마커의 테두리. 브랜드 빨강이라 다른 마커와 확실히 갈린다.
  ///
  /// 혼잡도 팔레트의 `crowded`(0xFFB5283F)와 가깝지만 문제되지 않는다 — 그건 넓은
  /// 폴리곤 채우기이고 이건 마커 테두리라 크기와 맥락이 다르다.
  static const int highlight = 0xFFEA4A3F;
}
