import 'dart:convert';

import 'cell_geometry.dart';

/// 미리 만들어 둔 칸 도형을 읽는다(SPEC-0031 방식 1).
///
/// **왜 실제 행정구역 경계를 쓰지 않는가.**
///
/// 시군구 경계를 그대로 합치면 칸 크기가 극단적으로 벌어진다 — 폰 화면에서
/// 서울 주변은 2~3mm, 강원 군은 그 열 배다. 칸마다 랜드마크 그림을 넣는 것이
/// 이 화면의 전부인데, 쌀알만 한 칸에는 그림이 들어가지 않는다.
///
/// 참조(스크래치 아트맵)도 같은 문제를 같은 방식으로 풀었다 — 실제 경계를 버리고
/// **크기가 고른 볼록 다각형**으로 재구성했다. 서울 근처 작은 구도, 강원 큰 군도
/// 비슷한 크기로 그린다. 지리적 정확도가 아니라 "채운 기록"을 보여주는 것이
/// 목적이기 때문이다(SPEC-0030 §3의 칸 정의도 같은 말을 한다).
///
/// 도형은 서버가 준 칸 중심을 씨앗으로 삼아 보로노이 + Lloyd 완화로 만들었고,
/// 남한 실루엣으로 잘라냈다. 생성기는 저장소 밖 도구이며 결과물만 커밋한다.
///
/// **칸 묶음 규칙은 여전히 서버 소유다.** 이 파일이 정하는 것은 각 칸의 *모양*
/// 뿐이고, 어떤 시군구가 한 칸인지는 서버 `MapCell.districtCodes`가 정한다.
class CellShapeSource {
  const CellShapeSource._();

  /// 도형 자산 경로.
  static const String assetPath = 'asset/geo/cell-shapes.json';

  /// JSON 문자열을 `칸 id → 외곽 링 목록`으로 읽는다.
  ///
  /// 형식: `{"version":1,"cells":{"2":[[[lng,lat],...], ...], ...}}`
  ///
  /// **칸 하나가 여러 조각일 수 있다.** 포항·대구처럼 본토와 떨어진 지역을
  /// 함께 가진 칸이 있는데, 가장 큰 조각만 남기면 나머지 자리에 빈 구멍이
  /// 생긴다(실측 19.4pt). 조각을 다 담아 그 구멍을 없앤다.
  static Map<String, List<List<GeoPoint>>> parse(String source) {
    final Map<String, dynamic> root =
        json.decode(source) as Map<String, dynamic>;
    final Map<String, dynamic> cells =
        root['cells'] as Map<String, dynamic>? ?? const <String, dynamic>{};

    final Map<String, List<List<GeoPoint>>> out =
        <String, List<List<GeoPoint>>>{};
    for (final MapEntry<String, dynamic> e in cells.entries) {
      final List<List<GeoPoint>> parts = <List<GeoPoint>>[];
      for (final dynamic raw in e.value as List<dynamic>) {
        final List<dynamic> ring = raw as List<dynamic>;
        if (ring.length < 3) continue;
        parts.add(<GeoPoint>[
          for (final dynamic p in ring)
            GeoPoint(
              ((p as List<dynamic>)[0] as num).toDouble(),
              (p[1] as num).toDouble(),
            ),
        ]);
      }
      if (parts.isNotEmpty) out[e.key] = parts;
    }
    return out;
  }
}
