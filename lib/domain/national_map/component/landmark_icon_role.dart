/// 랜드마크 아이콘의 **역할 색표**(SPEC-0031 §2).
///
/// **component에 둔다.** 색은 표현 관심사이고 `model/**`은 순수 Dart로 남긴다
/// (CLAUDE.md §3) — `province_palette.dart`가 같은 이유로 여기 있다.
///
/// SVG 파일은 한 벌이고 변형은 실행 시점에 만든다. 파일에 적힌 fill 값은
/// **표시색이 아니라 역할 식별자**이며, `LandmarkColorMapper`가 그 값으로 역할을
/// 찾아 전채색 또는 무채색으로 바꾼다.
///
/// 폴백값 18개가 서로 달라야 역할이 구분된다. 디자인 시스템 원본은 고유 색이
/// 13개뿐이라 stone·sand·rock·snow·sun 다섯의 파랑 채널을 1~2 옮겨 유일하게
/// 만들었다(기획 하네스 `landmark-icon-roles.json`). 그래서 아래 표에서 키와
/// `full`이 다른 행이 있다 — 오타가 아니다.
library;

import 'dart:math' as math;
import 'dart:ui' show Color;

/// 한 역할의 두 변형.
class LandmarkRoleVariants {
  const LandmarkRoleVariants({required this.full, required this.grey});

  /// 방문 칸에 쓰는 원색.
  final Color full;

  /// 미방문 칸에 쓰는 무채색. `full`의 상대휘도를 회색으로 환산한 값이다.
  final Color grey;
}

/// 폴백값(SVG에 적힌 색) → 두 변형.
const Map<int, LandmarkRoleVariants> landmarkRoleVariants =
    <int, LandmarkRoleVariants>{
      // roof
      0xFFC4633A: LandmarkRoleVariants(
        full: Color(0xFFC4633A),
        grey: Color(0xFF7D7D7D),
      ),
      // roof-under
      0xFFE04068: LandmarkRoleVariants(
        full: Color(0xFFE04068),
        grey: Color(0xFF7C7C7C),
      ),
      // eave
      0xFF5A6B8C: LandmarkRoleVariants(
        full: Color(0xFF5A6B8C),
        grey: Color(0xFF6A6A6A),
      ),
      // wood
      0xFFFF5C6E: LandmarkRoleVariants(
        full: Color(0xFFFF5C6E),
        grey: Color(0xFF949494),
      ),
      // trim
      0xFFF5A623: LandmarkRoleVariants(
        full: Color(0xFFF5A623),
        grey: Color(0xFFB5B5B5),
      ),
      // pillar
      0xFFFFE4E1: LandmarkRoleVariants(
        full: Color(0xFFFFE4E1),
        grey: Color(0xFFE9E9E9),
      ),
      // pillar-dark
      0xFF9E3358: LandmarkRoleVariants(
        full: Color(0xFF9E3358),
        grey: Color(0xFF5B5B5B),
      ),
      // stone
      0xFFFFE4E2: LandmarkRoleVariants(
        full: Color(0xFFFFE4E1),
        grey: Color(0xFFE9E9E9),
      ),
      // stone-top
      0xFFFFF6F0: LandmarkRoleVariants(
        full: Color(0xFFFFF6F0),
        grey: Color(0xFFF7F7F7),
      ),
      // water-deep
      0xFF2E6FD9: LandmarkRoleVariants(
        full: Color(0xFF2E6FD9),
        grey: Color(0xFF727272),
      ),
      // water-shallow
      0xFF7FC4E8: LandmarkRoleVariants(
        full: Color(0xFF7FC4E8),
        grey: Color(0xFFBABABA),
      ),
      // sand
      0xFFFFE4E3: LandmarkRoleVariants(
        full: Color(0xFFFFE4E1),
        grey: Color(0xFFE9E9E9),
      ),
      // foliage
      0xFF1F8A5C: LandmarkRoleVariants(
        full: Color(0xFF1F8A5C),
        grey: Color(0xFF797979),
      ),
      // foliage-light
      0xFFA3D45C: LandmarkRoleVariants(
        full: Color(0xFFA3D45C),
        grey: Color(0xFFC3C3C3),
      ),
      // rock
      0xFF5A6B8D: LandmarkRoleVariants(
        full: Color(0xFF5A6B8C),
        grey: Color(0xFF6A6A6A),
      ),
      // snow
      0xFFFFF6F1: LandmarkRoleVariants(
        full: Color(0xFFFFF6F0),
        grey: Color(0xFFF7F7F7),
      ),
      // sun
      0xFFF5A624: LandmarkRoleVariants(
        full: Color(0xFFF5A623),
        grey: Color(0xFFB5B5B5),
      ),
      // accent
      0xFFE8C547: LandmarkRoleVariants(
        full: Color(0xFFE8C547),
        grey: Color(0xFFC6C6C6),
      ),
    };

/// 아이콘 외곽선. 어떤 변형에서도 바뀌지 않는다(스펙 R10).
const Color landmarkOutline = Color(0xFF2B2B45);

/// sRGB 상대휘도. 0(검정)~1(흰색).
///
/// 무채색 변환의 근거를 코드에 남겨 둔다 — 색표의 `grey` 값이 이 식으로 산출된
/// 것이라 테스트가 두 값을 대조할 수 있다(스펙 R9).
double relativeLuminance(Color color) {
  double channel(double v) =>
      v <= 0.04045 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

/// 같은 휘도의 무채색으로 옮긴다. 채도 0, 투명도 없음(스펙 R8·R9).
///
/// 명도 순서가 보존된다 — 휘도를 그대로 옮기므로 밝은 면이 어두워질 수 없다.
Color desaturateByLuminance(Color color) {
  final double y = relativeLuminance(color);
  final double srgb = y <= 0.0031308
      ? y * 12.92
      : 1.055 * math.pow(y, 1 / 2.4).toDouble() - 0.055;
  final int v = (srgb * 255).round().clamp(0, 255);
  return Color.fromARGB(255, v, v, v);
}
