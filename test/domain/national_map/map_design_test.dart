import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_category_tint.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_color_mapper.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_icon_role.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/landmark_category.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/landmark_icon_binding.dart';

void main() {
  group('아이콘 결합 테이블', () {
    test('161칸이 빠짐없이 등록돼 있다', () {
      expect(landmarkIconBindings, hasLength(161));
      for (int id = 1; id <= 161; id++) {
        expect(
          landmarkIconBindingOf(id),
          isNotNull,
          reason: '$id번 칸에 결합이 없다',
        );
      }
    });

    test('slug가 서로 다르다', () {
      // 두 칸이 같은 아이콘을 쓰면 지도에서 같은 그림이 두 번 보인다.
      final Set<String> slugs = <String>{
        for (final LandmarkIconBinding b in landmarkIconBindings.values) b.slug,
      };
      expect(slugs, hasLength(161));
    });

    test('미등록 칸은 null이고 목록에서 빠지지 않는다', () {
      // R19: 결합이 없는 칸도 면은 칠한다. 부르는 쪽이 아이콘만 생략한다.
      expect(landmarkIconBindingOf(0), isNull);
      expect(landmarkIconBindingOf(999), isNull);
    });

    test('에셋 경로를 slug로 만든다', () {
      expect(
        landmarkIconAssetOf('bulguksa-temple'),
        'asset/icon/landmark/bulguksa-temple.svg',
      );
    });

    test('카테고리 분포가 기획 산출물과 같다', () {
      final Map<LandmarkCategory, int> counts = <LandmarkCategory, int>{};
      for (final LandmarkIconBinding b in landmarkIconBindings.values) {
        counts[b.category] = (counts[b.category] ?? 0) + 1;
      }
      expect(counts[LandmarkCategory.nature], 66);
      expect(counts[LandmarkCategory.heritage], 64);
      expect(counts[LandmarkCategory.culture], 14);
      expect(counts[LandmarkCategory.park], 13);
      expect(counts[LandmarkCategory.specialty], 4);
    });
  });

  group('카테고리 틴트', () {
    test('5종에 색이 있다', () {
      expect(LandmarkCategoryTint.definedCount, 5);
    });

    test('모르는 카테고리는 폴백이다', () {
      // R19: 결합이 없는 칸도 칠해야 한다.
      const Color fallback = Color(0xFF123456);
      expect(LandmarkCategoryTint.of(null, fallback: fallback), fallback);
    });

    test('틴트가 서로 구분된다', () {
      // 두 카테고리가 같은 색이면 면 색이 정보를 주지 못한다.
      final List<Color> all = LandmarkCategoryTint.all.toList();
      final Set<int> used = <int>{for (final Color c in all) c.toARGB32()};
      expect(used, hasLength(all.length));

      // **색상(hue)이 갈려야 한다.** 틴트는 전부 밝아서 RGB 거리는 작을 수밖에
      // 없다 — 아이콘이 얹히므로 밝아야 하고, 그래서 거리로 재면 모두 가깝게
      // 나온다. 실제로 눈에 보이는 차이는 색 기울기다(heritage는 분홍 쪽,
      // specialty는 노랑 쪽).
      for (int i = 0; i < all.length; i++) {
        for (int j = i + 1; j < all.length; j++) {
          expect(
            _hueDistance(all[i], all[j]),
            greaterThan(12),
            reason: '$i번과 $j번 틴트의 색 기울기가 너무 비슷하다',
          );
        }
      }
    });

    test('미방문 면보다 뚜렷이 진하다', () {
      // 칸을 채워도 채운 티가 나지 않으면 이 화면의 재미가 사라진다.
      // 처음 값들은 미방문(0.79)과 비슷하거나 오히려 밝아서 실제 렌더에서
      // 방문·미방문이 구분되지 않았다.
      const Color unvisited = Color(0xFFEDE4E2); // scheme.surfaceDim
      final double unvisitedY = relativeLuminance(unvisited);
      for (final Color c in LandmarkCategoryTint.all) {
        expect(
          relativeLuminance(c),
          lessThan(unvisitedY - 0.03),
          reason: '$c가 미방문 면과 너무 비슷하다',
        );
      }
    });

    test('아이콘이 묻히지 않게 충분히 밝다', () {
      // 면이 진하면 그 위에 얹는 아이콘이 읽히지 않는다. 위 검사와 함께
      // 틴트를 좁은 구간에 묶는다.
      for (final Color c in LandmarkCategoryTint.all) {
        expect(relativeLuminance(c), greaterThan(0.55));
      }
    });
  });

  group('역할 색표', () {
    test('18역할이 서로 다른 폴백값을 갖는다', () {
      // ColorMapper가 **색값으로** 역할을 찾으므로 폴백이 겹치면 역할이 섞인다.
      expect(landmarkRoleVariants, hasLength(18));
    });

    test('무채색 변형은 채도가 0이다', () {
      // R8: 미방문은 색상이 아니라 채도·명도로 구분한다.
      for (final LandmarkRoleVariants v in landmarkRoleVariants.values) {
        expect(v.grey.r, v.grey.g, reason: '${v.grey}가 무채색이 아니다');
        expect(v.grey.g, v.grey.b, reason: '${v.grey}가 무채색이 아니다');
      }
    });

    test('투명한 면이 없다', () {
      // R7: 미방문도 선화가 아니라 무채색 면이다.
      for (final LandmarkRoleVariants v in landmarkRoleVariants.values) {
        expect(v.full.a, 1.0);
        expect(v.grey.a, 1.0);
      }
    });

    test('무채색이 전채색의 명도 순서를 보존한다', () {
      // R9: 밝은 면이 무채색에서 어두워지면 아이콘의 입체가 뒤집힌다.
      final List<LandmarkRoleVariants> sorted =
          landmarkRoleVariants.values.toList()
            ..sort(
              (LandmarkRoleVariants a, LandmarkRoleVariants b) =>
                  relativeLuminance(
                    a.full,
                  ).compareTo(relativeLuminance(b.full)),
            );
      for (int i = 1; i < sorted.length; i++) {
        expect(
          relativeLuminance(sorted[i].grey),
          greaterThanOrEqualTo(relativeLuminance(sorted[i - 1].grey) - 1e-9),
          reason: '$i번에서 명도 순서가 뒤집혔다',
        );
      }
    });

    test('색표의 무채색이 휘도 환산식과 일치한다', () {
      // 표가 손으로 수정돼 식과 크게 어긋나는 것을 막는다.
      //
      // 허용 오차 2는 반올림 몫이다 — 표는 기획 하네스가 만들었고 이 식과
      // 반올림 자릿수가 다를 수 있다(foliage-light가 196 대 197). 자릿수까지
      // 맞추는 것은 이 검사의 목적이 아니다.
      for (final LandmarkRoleVariants v in landmarkRoleVariants.values) {
        final Color computed = desaturateByLuminance(v.full);
        expect(
          (computed.r * 255 - v.grey.r * 255).abs(),
          lessThanOrEqualTo(2),
          reason: '${v.full} → 기대 $computed, 표에는 ${v.grey}',
        );
      }
    });
  });

  group('ColorMapper', () {
    const VisitedLandmarkColorMapper visited = VisitedLandmarkColorMapper();
    const UnvisitedLandmarkColorMapper unvisited =
        UnvisitedLandmarkColorMapper();

    test('외곽선은 어떤 변형에서도 바뀌지 않는다', () {
      // R10: stroke를 손대지 않는 것이 구조로 보장된다.
      for (final ColorMapperCase c in <ColorMapperCase>[
        ColorMapperCase(visited.substitute, landmarkOutline),
        ColorMapperCase(unvisited.substitute, landmarkOutline),
      ]) {
        expect(c.run('stroke'), c.color);
      }
    });

    test('방문은 폴백값을 전채색으로 바꾼다', () {
      const int roofFallback = 0xFFC4633A;
      final LandmarkRoleVariants roof = landmarkRoleVariants[roofFallback]!;
      expect(
        visited.substitute(null, 'path', 'fill', const Color(roofFallback)),
        roof.full,
      );
    });

    test('미방문은 폴백값을 무채색으로 바꾼다', () {
      const int roofFallback = 0xFFC4633A;
      final LandmarkRoleVariants roof = landmarkRoleVariants[roofFallback]!;
      expect(
        unvisited.substitute(null, 'path', 'fill', const Color(roofFallback)),
        roof.grey,
      );
    });

    test('두 변형이 서로 다르다', () {
      // R7: 같은 SVG에서 두 상태가 실제로 갈려야 한다.
      const Color roof = Color(0xFFC4633A);
      expect(
        visited.substitute(null, 'path', 'fill', roof),
        isNot(unvisited.substitute(null, 'path', 'fill', roof)),
      );
    });

    test('역할표에 없는 색은 그대로 통과한다', () {
      // 알 수 없는 색을 임의로 바꾸면 아이콘이 조용히 망가진다.
      const Color unknown = Color(0xFF010203);
      expect(visited.substitute(null, 'path', 'fill', unknown), unknown);
      expect(unvisited.substitute(null, 'path', 'fill', unknown), unknown);
    });

    test('폴백값이 조정된 5역할도 각각 제 색을 찾는다', () {
      // stone·sand·rock·snow·sun은 파랑 채널을 옮겨 유일하게 만든 값이다.
      // 이 구분이 깨지면 두 역할이 같은 색으로 칠해진다.
      const Map<int, int> adjusted = <int, int>{
        0xFFFFE4E2: 0xFFFFE4E1, // stone
        0xFFFFE4E3: 0xFFFFE4E1, // sand
        0xFF5A6B8D: 0xFF5A6B8C, // rock
        0xFFFFF6F1: 0xFFFFF6F0, // snow
        0xFFF5A624: 0xFFF5A623, // sun
      };
      adjusted.forEach((int fallback, int full) {
        expect(
          visited
              .substitute(null, 'path', 'fill', Color(fallback))
              .toARGB32(),
          full,
          reason: '${fallback.toRadixString(16)}가 역할을 찾지 못했다',
        );
      });
    });
  });

  group('경계 자산이 리포에 있다', () {
    test('판정용 원본이 유효한 GeoJSON이다', () {
      // 자산이 빠지면 앱이 지도를 아예 못 그린다.
      final File f = File('asset/geo/district-boundaries.geojson');
      expect(f.existsSync(), isTrue);

      final Map<String, dynamic> d =
          json.decode(f.readAsStringSync()) as Map<String, dynamic>;
      expect((d['features'] as List).length, 252);
    });

    test('직접 만든 칸 도형 자산은 더 이상 없다', () {
      // 묶음 규칙은 서버 소유다. 자산을 되살리면 코드 체계가 다시 어긋난다.
      expect(File('asset/geo/korea_cells.json').existsSync(), isFalse);
    });

    test('161개 아이콘 파일이 전부 있다', () {
      // 결합 테이블이 가리키는 에셋이 없으면 그 칸만 조용히 아이콘을 잃는다.
      final List<String> missing = <String>[
        for (final LandmarkIconBinding b in landmarkIconBindings.values)
          if (!File(landmarkIconAssetOf(b.slug)).existsSync()) b.slug,
      ];
      expect(missing, isEmpty, reason: '에셋이 없다: ${missing.join(', ')}');
    });
  });
}

/// 두 색의 **기울기** 차이.
///
/// 밝기를 뺀 채널 비율만 비교한다 — 밝은 틴트끼리는 절대 거리가 작아도 색
/// 기울기(어느 채널이 더 센가)는 뚜렷이 다르다.
double _hueDistance(Color a, Color b) {
  ({double r, double g, double b}) tilt(Color c) {
    final double sum = c.r + c.g + c.b;
    if (sum == 0) return (r: 0, g: 0, b: 0);
    return (r: c.r / sum, g: c.g / sum, b: c.b / sum);
  }

  final ({double r, double g, double b}) x = tilt(a);
  final ({double r, double g, double b}) y = tilt(b);
  return ((x.r - y.r).abs() + (x.g - y.g).abs() + (x.b - y.b).abs()) * 1000;
}

/// 외곽선 불변 검사를 두 매퍼에 같은 모양으로 돌리기 위한 묶음.
class ColorMapperCase {
  ColorMapperCase(this._substitute, this.color);

  final Color Function(String?, String, String, Color) _substitute;
  final Color color;

  Color run(String attributeName) =>
      _substitute(null, 'path', attributeName, color);
}
