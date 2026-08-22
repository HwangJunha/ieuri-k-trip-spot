import 'dart:ui' show Color;

import 'package:flutter_svg/flutter_svg.dart' show ColorMapper;

import 'landmark_icon_role.dart';

/// 방문 칸의 아이콘 색 — 역할 폴백값을 그 역할의 **전채색**으로 바꾼다.
///
/// SVG 한 벌로 두 변형을 만드는 장치다(스펙 §7.1). `ColorFilter`나
/// `SvgTheme.currentColor`로는 안 된다 — 전역 틴트라 역할별로 다른 색을 줄 수 없다.
///
/// `ColorMapper`는 `SvgCacheKey`에 포함되므로 두 변형이 서로를 밀어내지 않는다.
class VisitedLandmarkColorMapper extends ColorMapper {
  const VisitedLandmarkColorMapper();

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) => _substitute(attributeName, color, visited: true);
}

/// 미방문 칸의 아이콘 색 — 역할 폴백값을 그 역할의 **무채색**으로 바꾼다.
class UnvisitedLandmarkColorMapper extends ColorMapper {
  const UnvisitedLandmarkColorMapper();

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) => _substitute(attributeName, color, visited: false);
}

/// 두 매퍼가 공유하는 규칙.
///
/// - `stroke`는 손대지 않는다 → 외곽선 불변이 **구조로** 보장된다(스펙 R10)
/// - 역할표에 없는 색은 **그대로 돌려준다**. 알 수 없는 색을 임의로 바꾸면
///   아이콘이 조용히 망가진다
Color _substitute(String attributeName, Color color, {required bool visited}) {
  if (attributeName == 'stroke') return color;

  final LandmarkRoleVariants? variants =
      landmarkRoleVariants[color.toARGB32()];
  if (variants == null) return color;

  return visited ? variants.full : variants.grey;
}
