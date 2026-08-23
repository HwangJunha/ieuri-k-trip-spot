import 'dart:math' as math;
import 'dart:ui' show Color;

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
