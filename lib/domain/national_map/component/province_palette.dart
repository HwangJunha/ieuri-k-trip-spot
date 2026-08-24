import 'dart:ui' show Color;

/// 시도별 칸 색(SPEC-0030 디자인).
///
/// **model이 아니라 component에 둔다.** 색은 표현 관심사이고 `model/**`은 순수
/// Dart로 남긴다(CLAUDE.md §3) — `Color`는 `dart:ui` 타입이다.
///
/// 레퍼런스(스크래치 지도 포스터)의 핵심은 채운 칸이 **알록달록하다**는 것이다.
/// 방문 칸을 브랜드색 하나로만 칠하면 20칸을 채우든 100칸을 채우든 빨간 얼룩으로
/// 보여 "채우는 재미"가 사라진다.
///
/// **인접한 시도가 서로 다른 계열이 되게 손으로 배정했다.** 색상환을 기계적으로
/// 나누면 경기(주황)와 경북(주황)처럼 맞닿은 두 곳이 비슷해진다.
///
/// 채도는 앱의 웜 톤에서 크게 벗어나지 않게 눌렀다 — 형광에 가까운 원색을 쓰면
/// 이 화면만 앱에서 떠 보인다.
class ProvincePalette {
  const ProvincePalette._();

  static const Map<String, Color> _byProvinceCode = <String, Color>{
    // 도 단위. **색상환에 고르게 벌려 배정했다** — 눈대중으로 고르면 맞닿은
    // 곳이 비슷해진다(경북·전남이 색상 3° 차이로 거의 같았고, 경남·충북도
    // 34°였다). 지금은 어떤 두 도도 25° 이상 벌어져 있다.
    //
    // **참조 지도(스크래치 아트맵)의 구조를 그대로 따른다.** 배경은 도별 한
    // 색이고 일러스트는 각자 고유색이다 — 그림까지 도색으로 물들였더니 강원이
    // 통째로 보라가 되어 "상한 것 같은" 색이 됐다.
    //
    // 값 자체는 형광을 피해 채도 0.62 로 두고, 칸을 칠할 때 [ProvinceCellTint]가
    // 흰색과 30% 섞어 밝힌다. 이 색은 진행률 바 등 다른 곳에서도 쓰이므로
    // 원색이 너무 튀면 안 된다.
    '41': Color(0xFFE06C55), // 경기 — 산호(브랜드색에 가장 가깝다)
    '51': Color(0xFF6C55E0), // 강원 — 보라
    '43': Color(0xFF8FE055), // 충북 — 연두
    '44': Color(0xFF55A6E0), // 충남 — 하늘
    '52': Color(0xFFE055B2), // 전북 — 분홍
    '46': Color(0xFF55E08F), // 전남 — 초록
    '47': Color(0xFFE0BE55), // 경북 — 노랑
    '48': Color(0xFF55E0B9), // 경남 — 초록청록
    '50': Color(0xFF55C5E0), // 제주 — 바다 청록

    // 광역시는 1칸뿐이라 도 안에서 묻히지 않게 채도를 한 단 올렸다.
    '11': Color(0xFFD67C40), // 서울
    '26': Color(0xFF40D6CF), // 부산
    '27': Color(0xFFD6D440), // 대구
    '28': Color(0xFFD6404F), // 인천
    '29': Color(0xFF40D6A7), // 광주
    '30': Color(0xFF4070D6), // 대전
    '31': Color(0xFF40D689), // 울산
    '36': Color(0xFF57D640), // 세종
  };

  /// 시도 코드에 해당하는 색. 모르는 코드는 [fallback]이다.
  ///
  /// 서버가 시도를 늘려도(경기 분도 등) 화면이 깨지지 않게 폴백을 둔다.
  static Color of(String provinceCode, {required Color fallback}) =>
      _byProvinceCode[provinceCode] ?? fallback;

  /// 색이 정의된 시도 수. 테스트가 커버리지를 확인한다.
  static int get definedCount => _byProvinceCode.length;
}
