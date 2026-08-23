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
        grey: Color(0xFFA8A8A8),
      ),
      // pillar
      0xFFFFE4E1: LandmarkRoleVariants(
        full: Color(0xFFFFE4E1),
        grey: Color(0xFFC5C5C5),
      ),
      // pillar-dark
      0xFF9E3358: LandmarkRoleVariants(
        full: Color(0xFF9E3358),
        grey: Color(0xFF5B5B5B),
      ),
      // stone
      0xFFFFE4E2: LandmarkRoleVariants(
        full: Color(0xFFFFE4E1),
        grey: Color(0xFFC5C5C5),
      ),
      // stone-top
      0xFFFFF6F0: LandmarkRoleVariants(
        full: Color(0xFFFFF6F0),
        grey: Color(0xFFCFCFCF),
      ),
      // water-deep
      0xFF2E6FD9: LandmarkRoleVariants(
        full: Color(0xFF2E6FD9),
        grey: Color(0xFF727272),
      ),
      // water-shallow
      0xFF7FC4E8: LandmarkRoleVariants(
        full: Color(0xFF7FC4E8),
        grey: Color(0xFFAAAAAA),
      ),
      // sand
      0xFFFFE4E3: LandmarkRoleVariants(
        full: Color(0xFFFFE4E1),
        grey: Color(0xFFC5C5C5),
      ),
      // foliage
      0xFF1F8A5C: LandmarkRoleVariants(
        full: Color(0xFF1F8A5C),
        grey: Color(0xFF797979),
      ),
      // foliage-light
      0xFFA3D45C: LandmarkRoleVariants(
        full: Color(0xFFA3D45C),
        grey: Color(0xFFAFAFAF),
      ),
      // rock
      0xFF5A6B8D: LandmarkRoleVariants(
        full: Color(0xFF5A6B8C),
        grey: Color(0xFF6A6A6A),
      ),
      // snow
      0xFFFFF6F1: LandmarkRoleVariants(
        full: Color(0xFFFFF6F0),
        grey: Color(0xFFCFCFCF),
      ),
      // sun
      0xFFF5A624: LandmarkRoleVariants(
        full: Color(0xFFF5A623),
        grey: Color(0xFFA8A8A8),
      ),
      // accent
      0xFFE8C547: LandmarkRoleVariants(
        full: Color(0xFFE8C547),
        grey: Color(0xFFB1B1B1),
      ),
      // ── 도(道)별 배경색 ─────────────────────────────────────────────
      //
      // 칸 그림이 배경까지 담게 되면서(SPEC-0031) 하늘·땅 색이 그림 안으로
      // 들어왔다. 이 색들이 역할표에 없으면 **미방문 칸에서도 원색 그대로**
      // 남아 지도가 전부 칠해진 것처럼 보인다 — 스크래치 지도의 전제가 깨진다.
      //
      // **팔레트를 바꾸면 여기도 함께 바꿔야 한다.** 9색으로 개편했을 때 이 표를
      // 갱신하지 않아 미방문 칸의 배경만 원색으로 남는 일이 실제로 있었다.
      // 수도권 하늘
      0xFFFFD9A8: LandmarkRoleVariants(
        full: Color(0xFFFFD9A8),
        grey: Color(0xFFBFBFBF),
      ),
      // 수도권 땅
      0xFFEF9B24: LandmarkRoleVariants(
        full: Color(0xFFEF9B24),
        grey: Color(0xFFA4A4A4),
      ),
      // 강원 하늘
      0xFFCFE9FA: LandmarkRoleVariants(
        full: Color(0xFFCFE9FA),
        grey: Color(0xFFC3C3C3),
      ),
      // 강원 땅
      0xFF5AA9E6: LandmarkRoleVariants(
        full: Color(0xFF5AA9E6),
        grey: Color(0xFFA0A0A0),
      ),
      // 충북 하늘
      0xFFFFF0BE: LandmarkRoleVariants(
        full: Color(0xFFFFF0BE),
        grey: Color(0xFFCACACA),
      ),
      // 충북 땅
      0xFFDCB733: LandmarkRoleVariants(
        full: Color(0xFFDCB733),
        grey: Color(0xFFAAAAAA),
      ),
      // 충남 하늘
      0xFFE6DCF7: LandmarkRoleVariants(
        full: Color(0xFFE6DCF7),
        grey: Color(0xFFC0C0C0),
      ),
      // 충남 땅
      0xFF9B7BD4: LandmarkRoleVariants(
        full: Color(0xFF9B7BD4),
        grey: Color(0xFF8B8B8B),
      ),
      // 전북 하늘
      0xFFFFDCE4: LandmarkRoleVariants(
        full: Color(0xFFFFDCE4),
        grey: Color(0xFFC3C3C3),
      ),
      // 전북 땅
      0xFFF2789F: LandmarkRoleVariants(
        full: Color(0xFFF2789F),
        grey: Color(0xFF9F9F9F),
      ),
      // 전남 하늘
      0xFFD3F0DC: LandmarkRoleVariants(
        full: Color(0xFFD3F0DC),
        grey: Color(0xFFC5C5C5),
      ),
      // 전남 땅
      0xFF3EAF7C: LandmarkRoleVariants(
        full: Color(0xFF3EAF7C),
        grey: Color(0xFF9C9C9C),
      ),
      // 경북 하늘
      0xFFFFDCD2: LandmarkRoleVariants(
        full: Color(0xFFFFDCD2),
        grey: Color(0xFFC2C2C2),
      ),
      // 경북 땅
      0xFFE8663D: LandmarkRoleVariants(
        full: Color(0xFFE8663D),
        grey: Color(0xFF8E8E8E),
      ),
      // 경남 하늘
      0xFFCFF0EE: LandmarkRoleVariants(
        full: Color(0xFFCFF0EE),
        grey: Color(0xFFC5C5C5),
      ),
      // 경남 땅
      0xFF3FB8AF: LandmarkRoleVariants(
        full: Color(0xFF3FB8AF),
        grey: Color(0xFFA2A2A2),
      ),
      // 제주 하늘
      0xFFFFE9C2: LandmarkRoleVariants(
        full: Color(0xFFFFE9C2),
        grey: Color(0xFFC7C7C7),
      ),
      // 제주 땅
      0xFFF2B441: LandmarkRoleVariants(
        full: Color(0xFFF2B441),
        grey: Color(0xFFADADAD),
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
