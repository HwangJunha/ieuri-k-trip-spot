import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_icon_cache.dart';

void main() {
  /// 디코딩 횟수를 세는 가짜 디코더.
  ///
  /// 캐시가 `flutter_svg`를 직접 부르면 이 검사를 할 수 없다 — 그래서 디코더를
  /// 생성자로 받는다(스펙 §8).
  late List<LandmarkIconKey> decoded;

  Future<LandmarkIconPicture> fakeDecoder(LandmarkIconKey key) async {
    decoded.add(key);
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    ui.Canvas(recorder);
    return LandmarkIconPicture(
      picture: recorder.endRecording(),
      size: const ui.Size(120, 120),
    );
  }

  setUp(() => decoded = <LandmarkIconKey>[]);

  test('같은 키를 두 번 요청해도 한 번만 디코딩한다', () async {
    // R16: 161칸을 매 프레임 디코딩하면 지도가 멈춘다.
    final LandmarkIconCache cache = LandmarkIconCache(decoder: fakeDecoder);
    const LandmarkIconKey key = LandmarkIconKey('bulguksa-temple', visited: true);

    await cache.load(key);
    await cache.load(key);

    expect(decoded, hasLength(1));
    expect(cache.pictureOf(key), isNotNull);
    cache.dispose();
  });

  test('동시에 요청해도 한 번만 디코딩한다', () async {
    // 프리로드가 겹쳐 들어와도 중복 디코딩이 없어야 한다.
    final LandmarkIconCache cache = LandmarkIconCache(decoder: fakeDecoder);
    const LandmarkIconKey key = LandmarkIconKey('maisan-mountain', visited: false);

    await Future.wait<void>(<Future<void>>[cache.load(key), cache.load(key)]);

    expect(decoded, hasLength(1));
    cache.dispose();
  });

  test('두 변형은 별개 항목이다', () async {
    // 같은 slug라도 방문·미방문은 다른 그림이다.
    final LandmarkIconCache cache = LandmarkIconCache(decoder: fakeDecoder);
    const String slug = 'seomun-market';

    await cache.preload(<LandmarkIconKey>[
      const LandmarkIconKey(slug, visited: true),
      const LandmarkIconKey(slug, visited: false),
    ]);

    expect(decoded, hasLength(2));
    expect(cache.length, 2);
    expect(
      cache.pictureOf(const LandmarkIconKey(slug, visited: true)),
      isNot(cache.pictureOf(const LandmarkIconKey(slug, visited: false))),
    );
    cache.dispose();
  });

  test('준비되지 않은 키는 null이다', () {
    // paint()는 이 값이 null이면 아이콘을 생략한다. await하지 않는다.
    final LandmarkIconCache cache = LandmarkIconCache(decoder: fakeDecoder);
    expect(
      cache.pictureOf(const LandmarkIconKey('hallasan', visited: true)),
      isNull,
    );
    cache.dispose();
  });

  test('디코딩이 실패해도 다른 칸을 막지 않는다', () async {
    // 에셋 하나가 깨져도 지도 전체가 실패하면 안 된다.
    final LandmarkIconCache cache = LandmarkIconCache(
      decoder: (LandmarkIconKey key) async {
        if (key.slug == 'broken') throw Exception('없는 에셋');
        return fakeDecoder(key);
      },
    );

    await cache.preload(<LandmarkIconKey>[
      const LandmarkIconKey('broken', visited: true),
      const LandmarkIconKey('hallasan', visited: true),
    ]);

    expect(
      cache.pictureOf(const LandmarkIconKey('broken', visited: true)),
      isNull,
    );
    expect(
      cache.pictureOf(const LandmarkIconKey('hallasan', visited: true)),
      isNotNull,
    );
    cache.dispose();
  });

  test('키는 slug와 변형으로 같음을 판단한다', () {
    expect(
      const LandmarkIconKey('a', visited: true),
      const LandmarkIconKey('a', visited: true),
    );
    expect(
      const LandmarkIconKey('a', visited: true),
      isNot(const LandmarkIconKey('a', visited: false)),
    );
    expect(
      const LandmarkIconKey('a', visited: true),
      isNot(const LandmarkIconKey('b', visited: true)),
    );
  });
}
