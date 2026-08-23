import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_color_mapper.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_icon_role.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_luminance.dart';

/// **실제 SVG를 디코딩해 픽셀을 본다.**
///
/// 나머지 단위 테스트는 `ColorMapper.substitute`를 직접 불러 색 치환만 확인한다.
/// 그것은 "함수가 옳은 색을 돌려준다"를 증명할 뿐, **flutter_svg가 그 함수를
/// 실제로 부르는지**는 증명하지 못한다. 이 설계 전체가 그 가정 위에 서 있으므로
/// 한 번은 파이프라인 끝까지 통과시켜 확인한다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// SVG 한 장을 이미지로 굽고 픽셀을 돌려준다.
  Future<ByteData> rasterize(String assetPath, ColorMapper mapper) async {
    // 테스트 환경에서는 rootBundle이 에셋을 읽으므로 문자열로 직접 넘긴다.
    final String svg = await rootBundle.loadString(assetPath);
    final PictureInfo info = await vg.loadPicture(
      SvgStringLoader(svg, colorMapper: mapper),
      null,
    );

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    ui.Canvas(recorder).drawPicture(info.picture);
    final ui.Image image = await recorder.endRecording().toImage(120, 120);
    final ByteData? bytes = await image.toByteData();
    info.picture.dispose();
    image.dispose();
    return bytes!;
  }

  /// (x, y) 픽셀의 ARGB.
  int pixelAt(ByteData data, int x, int y) {
    final int o = (y * 120 + x) * 4;
    return ui.Color.fromARGB(
      data.getUint8(o + 3),
      data.getUint8(o),
      data.getUint8(o + 1),
      data.getUint8(o + 2),
    ).toARGB32();
  }

  /// 이미지에 실제로 쓰인 색들(투명·거의 투명 제외).
  Set<int> colorsIn(ByteData data) {
    final Set<int> out = <int>{};
    for (int y = 0; y < 120; y += 2) {
      for (int x = 0; x < 120; x += 2) {
        final int c = pixelAt(data, x, y);
        if ((c >> 24) & 0xFF > 200) out.add(c);
      }
    }
    return out;
  }

  test('방문 변형은 원색으로 칠해진다', () async {
    // 불국사는 면 6개에 역할 6종을 쓴다 — 폴백값이 제 역할을 찾는지 보기 좋다.
    final ByteData data = await rasterize(
      'asset/icon/landmark/bulguksa-temple.svg',
      const VisitedLandmarkColorMapper(),
    );
    final Set<int> used = colorsIn(data);

    // **표에 등록된 전채색이 실제로 화면에 나온다.** 특정 색을 적어 두면
    // 그림을 다시 그릴 때마다 깨지므로 표와 대조한다.
    final Set<int> fulls = <int>{
      for (final LandmarkRoleVariants v in landmarkRoleVariants.values)
        v.full.toARGB32(),
    };
    expect(
      used.any(fulls.contains),
      isTrue,
      reason: '전채색이 하나도 없다 — ColorMapper가 불리지 않았을 수 있다',
    );
    // 외곽선은 그대로다.
    expect(used, contains(landmarkOutline.toARGB32()));
  });

  test('미방문 변형은 무채색으로 칠해진다', () async {
    final ByteData data = await rasterize(
      'asset/icon/landmark/bulguksa-temple.svg',
      const UnvisitedLandmarkColorMapper(),
    );
    final Set<int> used = colorsIn(data);

    // 표에 등록된 원색은 하나도 남아 있으면 안 된다. 외곽선만 예외다(R10).
    final Set<int> fulls = <int>{
      for (final LandmarkRoleVariants v in landmarkRoleVariants.values)
        if (v.grey != v.full) v.full.toARGB32(),
    };
    expect(used.where(fulls.contains), isEmpty, reason: '미방문인데 원색이 남았다');
    // 대신 표의 무채색이 나타난다.
    final Set<int> greys = <int>{
      for (final LandmarkRoleVariants v in landmarkRoleVariants.values)
        v.grey.toARGB32(),
    };
    expect(used.any(greys.contains), isTrue, reason: '무채색으로 안 바뀌었다');
    // 외곽선은 여전히 그대로다(R10).
    expect(used, contains(landmarkOutline.toARGB32()));
  });

  test('면 색을 뺀 나머지는 무채색뿐이다', () async {
    // R8: 미방문은 채도가 0이어야 한다. 외곽선만 예외다.
    final ByteData data = await rasterize(
      'asset/icon/landmark/maisan-mountain.svg',
      const UnvisitedLandmarkColorMapper(),
    );

    for (final int c in colorsIn(data)) {
      if (c == landmarkOutline.toARGB32()) continue;
      final int r = (c >> 16) & 0xFF;
      final int g = (c >> 8) & 0xFF;
      final int b = c & 0xFF;
      // 안티에일리어싱 경계 픽셀은 외곽선과 면이 섞이므로 여유를 둔다.
      final int spread = <int>[
        (r - g).abs(),
        (g - b).abs(),
        (r - b).abs(),
      ].reduce((int a, int b) => a > b ? a : b);
      expect(
        spread,
        lessThan(40),
        reason: '무채색이 아닌 색이 남았다: ${c.toRadixString(16)}',
      );
    }
  });

  test('두 변형이 실제로 다른 그림이 된다', () async {
    // R7: 같은 SVG 한 벌에서 두 상태가 갈려야 한다.
    final ByteData a = await rasterize(
      'asset/icon/landmark/seomun-market.svg',
      const VisitedLandmarkColorMapper(),
    );
    final ByteData b = await rasterize(
      'asset/icon/landmark/seomun-market.svg',
      const UnvisitedLandmarkColorMapper(),
    );

    int differing = 0;
    for (int y = 0; y < 120; y += 2) {
      for (int x = 0; x < 120; x += 2) {
        if (pixelAt(a, x, y) != pixelAt(b, x, y)) differing++;
      }
    }
    expect(differing, greaterThan(100), reason: '두 변형이 거의 같다');
  });
}
