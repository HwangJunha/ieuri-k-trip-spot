import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/spot_gallery.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_image.dart';

/// 상세 갤러리의 이미지 맞춤(SPEC-0025 R13).
///
/// **스와이프 카드와 같은 규칙을 써야 한다.** 갤러리는 오랫동안 `[TBD-1]` 확정 전까지
/// 전부 `cover`로 두었는데, 그 사이 행사 포스터의 제목이 위쪽에서 잘려 나갔다(사용자
/// 지적 2026-08-18). 같은 사진이 카드에서는 온전한데 상세에서는 잘리면 안 된다.
void main() {
  SpotImage imageWith(String url, CopyrightType copyright) => SpotImage(
    imageUrl: url,
    copyright: copyright,
    attributionText: '출처: 한국관광공사',
  );

  /// 갤러리를 세우고 첫 장 이미지의 `fit`을 읽는다.
  Future<BoxFit?> firstFitOf(
    WidgetTester tester, {
    required List<SpotImage> images,
    required String fallbackUrl,
    CopyrightType? fallbackCopyright,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SpotGallery(
            images: images,
            fallbackImageUrl: fallbackUrl,
            fallbackCopyright: fallbackCopyright,
          ),
        ),
      ),
    );

    final Iterable<Image> rendered = tester.widgetList<Image>(
      find.byType(Image),
    );
    return rendered.isEmpty ? null : rendered.last.fit;
  }

  /// TYPE1은 변형이 허용되므로 영역을 채운다.
  testWidgets('TYPE1은 채운다', (WidgetTester tester) async {
    expect(
      await firstFitOf(
        tester,
        images: <SpotImage>[
          imageWith('https://e.com/a.jpg', CopyrightType.type1),
        ],
        fallbackUrl: 'https://e.com/a.jpg',
      ),
      BoxFit.cover,
    );
  });

  /// **핵심**: TYPE3은 잘리면 안 된다 — 포스터 제목이 날아가던 자리다.
  testWidgets('TYPE3은 잘리지 않는다', (WidgetTester tester) async {
    expect(
      await firstFitOf(
        tester,
        images: <SpotImage>[
          imageWith('https://e.com/a.jpg', CopyrightType.type3),
        ],
        fallbackUrl: 'https://e.com/a.jpg',
      ),
      BoxFit.contain,
    );
  });

  /// 첫 장은 리스트에서 넘어온 썸네일이라 갤러리에 없을 수 있다. 그때는 호출부가
  /// 준 저작권을 쓴다.
  testWidgets('갤러리에 없는 첫 장은 넘겨받은 저작권을 따른다', (WidgetTester tester) async {
    expect(
      await firstFitOf(
        tester,
        images: const <SpotImage>[],
        fallbackUrl: 'https://e.com/thumb.jpg',
        fallbackCopyright: CopyrightType.type3,
      ),
      BoxFit.contain,
    );
  });

  /// 근거가 하나도 없으면 **크롭하지 않는다** — 변형해도 되는지 모르는 이미지를
  /// 자르는 것보다 여백을 남기는 편이 안전하다.
  testWidgets('저작권을 모르면 크롭하지 않는다', (WidgetTester tester) async {
    expect(
      await firstFitOf(
        tester,
        images: const <SpotImage>[],
        fallbackUrl: 'https://e.com/thumb.jpg',
      ),
      BoxFit.contain,
    );
  });
}
