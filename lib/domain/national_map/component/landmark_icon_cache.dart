import 'dart:ui' show Picture, Size;

import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/landmark_icon_binding.dart';
import 'landmark_color_mapper.dart';

/// 그림의 상세 단계.
///
/// **지금은 한 단계뿐이다.** 확대하면 다른 그림으로 갈아타는 방식을 만들어
/// 봤지만, 칸 모양이던 그림이 갑자기 네모 카드로 바뀌어 지도가 무너져 보였다.
/// 상세 화면에는 별도 파일(`<slug>@hero.svg`)을 쓰므로 여기서는 필요 없다.
enum LandmarkDetail {
  /// 지도에 그리는 그림. 칸 윤곽으로 잘린다.
  simple;

  /// 에셋 파일명에 붙는 꼬리표.
  String get suffix => '';
}

/// (slug × 변형 × 상세단계) 하나를 가리키는 캐시 키.
@immutable
class LandmarkIconKey {
  const LandmarkIconKey(
    this.slug, {
    required this.visited,
    this.detail = LandmarkDetail.simple,
  });

  final String slug;
  final bool visited;
  final LandmarkDetail detail;

  @override
  bool operator ==(Object other) =>
      other is LandmarkIconKey &&
      other.slug == slug &&
      other.visited == visited &&
      other.detail == detail;

  @override
  int get hashCode => Object.hash(slug, visited, detail);

  @override
  String toString() =>
      'LandmarkIconKey($slug, visited: $visited, detail: ${detail.name})';
}

/// 그려질 준비가 된 아이콘 한 장.
///
/// `PictureInfo`를 그대로 쓰지 않는다 — 생성자가 private이라 테스트에서 만들 수
/// 없다. 캐시가 실제로 필요로 하는 것은 그림과 그 기준 크기 둘뿐이다.
@immutable
class LandmarkIconPicture {
  const LandmarkIconPicture({required this.picture, required this.size});

  /// `canvas.drawPicture()`로 바로 그려지는 그림.
  final Picture picture;

  /// 그림의 기준 크기(SVG viewBox, 120×120). 칸 크기에 맞출 때 분모가 된다.
  final Size size;
}

/// SVG 한 장을 그릴 수 있는 [LandmarkIconPicture]로 만든다.
///
/// 캐시가 `flutter_svg`를 직접 부르지 않고 이 함수를 생성자로 받는다 — 그래야
/// 테스트에서 디코딩 횟수를 셀 수 있다(스펙 §8, R16).
typedef LandmarkIconDecoder =
    Future<LandmarkIconPicture> Function(LandmarkIconKey key);

/// 아이콘을 미리 디코딩해 들고 있는 캐시(스펙 §4).
///
/// `CustomPainter.paint()`는 동기 함수라 그 안에서 `await`할 수 없다. 그래서
/// **지도 진입 시 미리 채우고**, `paint()`는 [pictureOf]로 꺼내 `drawPicture`만
/// 한다. 캐시에 없으면 그 칸은 이번 프레임에 아이콘을 생략한다.
///
/// 161칸 전부가 대상이다 — 미방문 칸도 무채색 아이콘을 그리므로 방문 여부는
/// **어느 변형이 필요한지**만 가른다.
///
/// 매 프레임 디코딩하면 안 되는 이유는 이 저장소에 선례가 있다.
/// `map_overlay_painter.dart`가 스타일 인스턴스 재사용 문제를 주석으로 남겼는데,
/// 161개를 매 프레임 디코딩하면 같은 문제가 훨씬 큰 규모로 재현된다.
class LandmarkIconCache {
  LandmarkIconCache({LandmarkIconDecoder? decoder})
    : _decode = decoder ?? _decodeFromAsset;

  final LandmarkIconDecoder _decode;
  final Map<LandmarkIconKey, LandmarkIconPicture> _pictures =
      <LandmarkIconKey, LandmarkIconPicture>{};

  /// 진행 중인 디코딩. 같은 키를 두 번 요청해도 한 번만 디코딩한다(R16).
  final Map<LandmarkIconKey, Future<void>> _inFlight =
      <LandmarkIconKey, Future<void>>{};

  /// 캐시에 올라온 그림 수. 테스트와 디버깅용.
  int get length => _pictures.length;

  /// 이미 준비된 그림. 없으면 null이고, 부르는 쪽은 아이콘을 생략한다.
  LandmarkIconPicture? pictureOf(LandmarkIconKey key) => _pictures[key];

  /// 키 하나를 채운다. 이미 있으면 아무것도 하지 않는다.
  Future<void> load(LandmarkIconKey key) {
    if (_pictures.containsKey(key)) return Future<void>.value();

    final Future<void>? running = _inFlight[key];
    if (running != null) return running;

    final Future<void> task = _decode(key)
        .then((LandmarkIconPicture info) {
          _pictures[key] = info;
        })
        .catchError((Object _) {
          // 에셋이 없거나 깨졌으면 그 칸만 아이콘을 생략한다. 지도 전체를
          // 실패시키지 않는다.
        })
        .whenComplete(() {
          _inFlight.remove(key);
        });

    _inFlight[key] = task;
    return task;
  }

  /// 여러 칸을 한꺼번에 준비한다. 지도 진입 시 부른다.
  Future<void> preload(Iterable<LandmarkIconKey> keys) =>
      Future.wait<void>(keys.map(load)).then((_) {});

  /// 캐시를 비우고 그림을 해제한다.
  void dispose() {
    for (final LandmarkIconPicture info in _pictures.values) {
      info.picture.dispose();
    }
    _pictures.clear();
  }
}

/// 기본 디코더 — 에셋에서 읽어 `PictureInfo`를 만든다.
///
/// `SvgPicture`는 위젯이라 `CustomPainter.paint()` 안에서 합성할 수 없다.
/// `PictureInfo.picture`가 `dart:ui`의 `Picture`이며 `canvas.drawPicture()`로
/// 직접 그려진다.
Future<LandmarkIconPicture> _decodeFromAsset(LandmarkIconKey key) async {
  final ColorMapper mapper = key.visited
      ? const VisitedLandmarkColorMapper()
      : const UnvisitedLandmarkColorMapper();

  Future<LandmarkIconPicture> load(String suffix) async {
    final PictureInfo info = await vg.loadPicture(
      SvgAssetLoader(
        landmarkIconAssetOf(key.slug, suffix: suffix),
        colorMapper: mapper,
      ),
      null,
    );
    return LandmarkIconPicture(picture: info.picture, size: info.size);
  }

  try {
    return await load(key.detail.suffix);
  } on Object {
    // **상세본이 아직 없으면 기본본으로 돌아간다.** 322장을 한 번에 그릴 수
    // 없으므로 둘이 섞인 상태로도 지도가 온전해야 한다.
    if (key.detail == LandmarkDetail.simple) rethrow;
    return load('');
  }
}
