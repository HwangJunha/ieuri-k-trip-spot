import 'dart:ui' show Color;

/// 시도별 칸 색(SPEC-0030 디자인).
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
    // 도 단위. **인접 그래프를 놓고 배정했다** — 눈대중으로 고르면 맞닿은 곳이
    // 비슷해진다(경북·경남이 RGB 거리 9로 거의 같았다). 지금은 맞닿은 어떤
    // 쌍도 거리 58 이상이며 그 사실을 테스트가 지킨다.
    '41': Color(0xFFE4572E), // 경기 — 주홍(브랜드색에 가장 가깝다)
    '51': Color(0xFF7B6BC9), // 강원 — 보라
    '43': Color(0xFF5FA85A), // 충북 — 초록
    '44': Color(0xFF4E8FD0), // 충남 — 파랑
    '52': Color(0xFFC455A0), // 전북 — 자주
    '46': Color(0xFFB5651D), // 전남 — 갈색
    '47': Color(0xFFE08B2E), // 경북 — 주황
    '48': Color(0xFF3E9E6E), // 경남 — 청록초록
    '50': Color(0xFF2E9B96), // 제주 — 청록

    // 광역시는 1칸뿐이라 도 안에서 묻히지 않게 채도를 한 단 올렸다.
    '11': Color(0xFFC63F2E), // 서울
    '26': Color(0xFF2E86C6), // 부산
    '27': Color(0xFFC68A1E), // 대구
    '28': Color(0xFF1F7A8C), // 인천
    '29': Color(0xFF7E52B8), // 광주
    '30': Color(0xFFB85C8A), // 대전
    '31': Color(0xFF2E9E9A), // 울산
    '36': Color(0xFF8A6A3E), // 세종
  };

  /// 시도 코드에 해당하는 색. 모르는 코드는 [fallback]이다.
  ///
  /// 서버가 시도를 늘려도(경기 분도 등) 화면이 깨지지 않게 폴백을 둔다.
  static Color of(String provinceCode, {required Color fallback}) =>
      _byProvinceCode[provinceCode] ?? fallback;

  /// 색이 정의된 시도 수. 테스트가 커버리지를 확인한다.
  static int get definedCount => _byProvinceCode.length;
}
