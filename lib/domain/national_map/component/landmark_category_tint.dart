import 'dart:ui' show Color;

import '../model/landmark_category.dart';

/// 카테고리별 칸 면 색(SPEC-0031 §1).
///
/// SPEC-0030의 시도별 18색을 대체한다. 색이 시도를 말하던 것을 **칸의 성격**을
/// 말하게 바꾼 것이다 — 아이콘이 랜드마크를 그리므로 면은 그 랜드마크가 어떤
/// 종류인지 거들어야 한다.
///
/// **틴트지만 미방문보다 뚜렷이 진해야 한다.** 처음엔 디자인 시스템의 "20~25%
/// 틴트"를 그대로 썼는데, 실제로 렌더해 보니 휘도가 미방문 면(0.79)과 비슷하거나
/// 오히려 높아(park 0.83) 칸을 채워도 채운 티가 나지 않았다. 채우는 재미가 이
/// 화면의 전부이므로 한 단 눌렀다 — 지금은 0.62~0.75로 미방문보다 확실히 어둡고,
/// 그러면서도 위에 얹는 아이콘이 묻히지 않을 만큼 밝다.
class LandmarkCategoryTint {
  const LandmarkCategoryTint._();

  static const Map<LandmarkCategory, Color> _byCategory =
      <LandmarkCategory, Color>{
        // heritage — terracotta 계열을 눌렀다. 기와·단청의 따뜻한 흙색.
        LandmarkCategory.heritage: Color(0xFFF0CDB8),
        // nature — forest 계열. 산·숲·물이 모두 여기 들어온다.
        LandmarkCategory.nature: Color(0xFFC3DFCA),
        // culture — plum·crimson 계열을 눌렀다.
        LandmarkCategory.culture: Color(0xFFE4C6D3),
        // park — lime 계열. nature보다 한 단 밝아 둘이 갈린다.
        LandmarkCategory.park: Color(0xFFD6E7B8),
        // specialty — amber·mustard 계열.
        LandmarkCategory.specialty: Color(0xFFF2DFAF),
      };

  /// 카테고리에 해당하는 방문 칸 면 색.
  ///
  /// 결합 테이블에 없는 칸은 [fallback]으로 칠하고 아이콘만 생략한다 —
  /// **칸이 목록에서 빠지지는 않는다**(스펙 R19).
  static Color of(LandmarkCategory? category, {required Color fallback}) =>
      category == null ? fallback : _byCategory[category] ?? fallback;

  /// 색이 정의된 카테고리 수. 테스트가 커버리지를 확인한다.
  static int get definedCount => _byCategory.length;

  /// 정의된 틴트 전부. 테스트가 서로 구분되는지 확인한다.
  static Iterable<Color> get all => _byCategory.values;
}
