import 'dart:ui' show Color;

import 'province_palette.dart';

/// 방문 칸의 **면 색** — 시도색을 밝게 눌러 쓴다(SPEC-0031).
///
/// 참조(스크래치 아트맵)가 "전국 8도에 포인트 색상을 입혀 도장 깨기하듯이 색을
/// 정복해 나가는 재미"라고 명시한 그 색 체계다. 카테고리 5색을 쓰다가 되돌렸다 —
/// 161칸에 5색뿐이면 **어디를** 채웠는지가 아니라 무엇을 채웠는지만 말해 준다.
///
/// **[ProvincePalette]를 그대로 쓰지 않는다.** 그쪽은 휘도 0.19~0.35로 어둡다.
/// SPEC-0030에서는 그 위에 흰색 아이콘을 얹었으니 맞는 값이었지만, 이제 컬러
/// 그림이 올라가므로 면이 어두우면 그림이 묻힌다. 여기서는 흰색과 섞어 0.59~0.69로
/// 올린다 — 미방문 면(0.79)보다는 낮아 채운 티가 나고, 그림은 살아 있다.
///
/// 원본 팔레트는 진행률 바 등이 계속 쓰므로 건드리지 않는다.
class ProvinceCellTint {
  const ProvinceCellTint._();

  /// 시도색을 흰색과 섞는 비율. 클수록 밝다.
  ///
  /// 0.62로 두니 휘도가 0.54~0.69라 미방문 면(0.79)과 차이가 작아 **채운 티가
  /// 나지 않았다**(실기기 확인). 0.48이면 0.45~0.60으로 내려와 확실히 구분되면서
  /// 위에 얹는 그림도 아직 읽힌다.
  static const double _lighten = 0.48;

  static final Map<String, Color> _cache = <String, Color>{};

  /// 시도 코드에 해당하는 방문 칸 면 색.
  static Color of(String provinceCode, {required Color fallback}) {
    final Color? hit = _cache[provinceCode];
    if (hit != null) return hit;

    final Color base = ProvincePalette.of(provinceCode, fallback: fallback);
    final Color tint = _lightened(base);
    _cache[provinceCode] = tint;
    return tint;
  }

  /// 흰색과 섞어 밝기를 올린다.
  static Color _lightened(Color c) => Color.fromARGB(
    255,
    _mix(c.r),
    _mix(c.g),
    _mix(c.b),
  );

  static int _mix(double channel) {
    final double v = channel + (1 - channel) * _lighten;
    return (v * 255).round().clamp(0, 255);
  }
}
