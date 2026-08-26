import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_category_tint.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_color_mapper.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_icon_role.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_luminance.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/landmark_category.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/landmark_icon_binding.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/service/photo_library_service.dart';
import 'package:photo_manager/photo_manager.dart' show RequestType;

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
    test('그림에 쓰인 색이 빠짐없이 등록돼 있다', () {
      // ColorMapper가 **색값으로** 역할을 찾고, 표에 없는 색은 그대로 통과한다
      // — 즉 빠진 색은 미방문 칸에서 혼자 원색으로 남는다. 표는 이제 손으로
      // 고르는 18역할이 아니라 `genroles.py`가 실제 SVG에서 훑어 만든다.
      expect(landmarkRoleVariants.length, greaterThanOrEqualTo(30));
    });

    test('무채색 변형은 색이 남지 않는다', () {
      // R8: 미방문은 색상이 아니라 채도·명도로 구분한다.
      //
      // **완전한 회색(R=G=B)이 아니라 아주 옅은 웜 그레이다.** 순회색은 웜 톤인
      // 앱 안에서 파랗게 떠 보여, 전 색을 R>G>B 쪽으로 한 톱니만 기울였다.
      for (final LandmarkRoleVariants v in landmarkRoleVariants.values) {
        if (v.grey == v.full) continue; // 외곽선 등 변환 제외 색
        final List<double> ch = <double>[v.grey.r, v.grey.g, v.grey.b];
        final double spread =
            ch.reduce((double a, double b) => a > b ? a : b) -
            ch.reduce((double a, double b) => a < b ? a : b);
        expect(spread * 255, lessThanOrEqualTo(8), reason: '${v.grey}');
        expect(v.grey.r, greaterThanOrEqualTo(v.grey.b), reason: '${v.grey}');
      }
    });

    test('투명한 면이 없다', () {
      // R7: 미방문도 선화가 아니라 무채색 면이다.
      for (final LandmarkRoleVariants v in landmarkRoleVariants.values) {
        expect(v.full.a, 1.0);
        expect(v.grey.a, 1.0);
      }
    });

    test('무채색이 전채색의 명도 순서를 크게 뒤집지 않는다', () {
      // R9: 밝은 면이 무채색에서 어두워지면 아이콘의 입체가 뒤집힌다.
      //
      // **엄격한 단조 증가는 요구하지 않는다.** 표는 감마 보정 없는 가중합으로
      // 회색을 뽑고 이 검사는 sRGB 상대휘도로 재므로, 척도가 달라 원색 휘도가
      // 거의 같은 색끼리 미세하게 순서가 갈린다. 척도를 맞춰 봤더니 역전은
      // 사라졌지만 어두운 면이 통째로 밝아져 실기기에서 그림이 흐려졌다 —
      // 보이지 않는 0.02 를 고치려고 보이는 것을 잃는 거래다.
      final List<LandmarkRoleVariants> sorted =
          landmarkRoleVariants.values
              .where((LandmarkRoleVariants v) => v.grey != v.full)
              .toList()
            ..sort(
              (LandmarkRoleVariants a, LandmarkRoleVariants b) =>
                  relativeLuminance(
                    a.full,
                  ).compareTo(relativeLuminance(b.full)),
            );
      // 직전 항목이 아니라 여기까지의 최대값과 견준다 — 이웃끼리만 보면 미세한
      // 어긋남이 줄줄이 통과해 전체로는 크게 뒤집힐 수 있다.
      double peak = 0;
      for (int i = 0; i < sorted.length; i++) {
        final double y = relativeLuminance(sorted[i].grey);
        expect(
          y,
          greaterThanOrEqualTo(peak - 0.08),
          reason: '$i번에서 명도 순서가 눈에 띄게 뒤집혔다',
        );
        if (y > peak) peak = y;
      }
    });

    test('무채색이 밑그림 구간 안에 들어온다', () {
      // 표는 순수 휘도를 그대로 옮기지 않는다. 그러면 161칸이 한 화면에서
      // 시멘트 덩어리가 돼 형태가 사라진다. 어두운 쪽을 들어 올려 밝은 구간으로
      // 압축해 '밑그림'처럼 보이게 한다.
      for (final LandmarkRoleVariants v in landmarkRoleVariants.values) {
        if (v.grey == v.full) continue; // 외곽선 등 변환 제외 색
        expect(
          v.grey.r * 255,
          inInclusiveRange(60, 250),
          reason: '${v.full} → ${v.grey}가 밑그림 구간을 벗어났다',
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

    // 표는 `genroles.py`가 실제 SVG에서 훑어 만드므로 특정 색을 적어 두면
    // 다시 그릴 때마다 깨진다. **표에서 뽑아 쓴다.**
    final MapEntry<int, LandmarkRoleVariants> sample = landmarkRoleVariants
        .entries
        .firstWhere(
          (MapEntry<int, LandmarkRoleVariants> e) =>
              e.value.grey != e.value.full,
        );

    test('방문은 등록된 색을 전채색으로 바꾼다', () {
      expect(
        visited.substitute(null, 'path', 'fill', Color(sample.key)),
        sample.value.full,
      );
    });

    test('미방문은 등록된 색을 무채색으로 바꾼다', () {
      expect(
        unvisited.substitute(null, 'path', 'fill', Color(sample.key)),
        sample.value.grey,
      );
    });

    test('두 변형이 서로 다르다', () {
      // R7: 같은 SVG에서 두 상태가 실제로 갈려야 한다.
      final Color c = Color(sample.key);
      expect(
        visited.substitute(null, 'path', 'fill', c),
        isNot(unvisited.substitute(null, 'path', 'fill', c)),
      );
    });

    test('역할표에 없는 색은 그대로 통과한다', () {
      // 알 수 없는 색을 임의로 바꾸면 아이콘이 조용히 망가진다.
      const Color unknown = Color(0xFF010203);
      expect(visited.substitute(null, 'path', 'fill', unknown), unknown);
      expect(unvisited.substitute(null, 'path', 'fill', unknown), unknown);
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

  // 전체 허용을 한 안드로이드 기기가 "일부만 허용"으로 안내됐다(사용자 지적
  // 2026-08-26). 권한 요청 타입과 매니페스트 선언이 어긋난 것이 원인이다.
  group('사진 권한 요청이 매니페스트와 맞는다', () {
    test('이미지만 요청한다', () {
      // 기본값 `RequestType.common`은 이미지+동영상이다. 매니페스트에
      // `READ_MEDIA_VIDEO`가 없으므로 Android 14+에서 동영상이 거부로 잡히고,
      // photo_manager가 "허용+거부"를 `Limited`로 합쳐 버린다.
      final RequestType type =
          PhotoManagerLibraryService.permissionOption.androidPermission.type;

      expect(type.containsImage(), isTrue);
      expect(
        type.containsVideo(),
        isFalse,
        reason: '동영상을 함께 요청하면 전체 허용이 limited로 잡힌다',
      );
      expect(type.containsAudio(), isFalse);
    });

    test('요청하는 권한이 전부 매니페스트에 있다', () {
      final String manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();

      expect(manifest, contains('android.permission.READ_MEDIA_IMAGES'));

      // `mediaLocation: true`로 요청하므로 이 선언이 없으면 EXIF 좌표를 못 읽는다.
      expect(
        PhotoManagerLibraryService.permissionOption.androidPermission
            .mediaLocation,
        isTrue,
      );
      expect(manifest, contains('android.permission.ACCESS_MEDIA_LOCATION'));
    });

    test('부분 허용을 알아볼 수 있게 선언한다', () {
      // 이 선언이 없으면 시스템이 호환 모드로 돌려 "사진 선택" 상태를 앱이
      // 구분하지 못한다 — 안드로이드에서만 재선택 버튼이 안 나온 원인이다.
      final String manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();

      expect(
        manifest,
        contains('android.permission.READ_MEDIA_VISUAL_USER_SELECTED'),
      );
    });

    test('동영상 권한은 선언하지 않는다', () {
      // 선언하면 스토어에 불필요한 권한이 노출되고, 위 요청 타입과도 어긋난다.
      final String manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();

      expect(manifest, isNot(contains('android.permission.READ_MEDIA_VIDEO')));
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
