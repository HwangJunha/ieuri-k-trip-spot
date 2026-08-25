import 'dart:ui' show Canvas, Image, Picture, PictureRecorder, Size;

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
  LandmarkIconPicture({required this.picture, required this.size});

  /// `canvas.drawPicture()`로 바로 그려지는 그림.
  final Picture picture;

  /// 그림의 기준 크기(SVG viewBox, 120×120). 칸 크기에 맞출 때 분모가 된다.
  final Size size;

  /// 화면 크기별로 구워 둔 래스터.
  ///
  /// **벡터를 프레임마다 재생하는 것이 버벅임의 절반이다.** 실기기 프로파일에서
  /// raster 23ms 중 `drawPicture` 161회가 15.4ms 였다(saveLayer 를 끄고 잰 값).
  /// 한 번 구워 두면 다음 프레임부터는 합성만 하면 된다.
  ///
  /// **키는 그릴 픽셀 크기다.** 정사각으로 굽거나 한 크기만 굽고 늘려 쓰면
  /// 세로로 긴 칸에서 픽셀이 늘어나 경계가 계단이 된다 — 실제로 그렇게 만들어
  /// 실기기에서 확인됐다. 그리는 크기 그대로 구워 늘리지 않는다.
  final Map<int, Image> _rasters = <int, Image>{};

  /// [width]×[height] 픽셀로 구운 래스터. 없으면 지금 굽는다.
  ///
  /// `toImageSync` 는 핸들을 동기로 돌려주고 래스터화는 뒤에서 한다 — 그래서
  /// `paint()` 안에서 부를 수 있다. GPU 문맥이 있으면 GPU 에 상주하는 이미지가
  /// 되어 그리기가 더 빠르다(dart:ui 문서).
  Image rasterOf(int width, int height) {
    final int key = width * 100000 + height;
    final Image? cached = _rasters[key];
    if (cached != null) return cached;

    final PictureRecorder recorder = PictureRecorder();
    Canvas(recorder)
      ..scale(width / size.width, height / size.height)
      ..drawPicture(picture);
    final Picture scaled = recorder.endRecording();
    final Image image = scaled.toImageSync(width, height);
    scaled.dispose();

    // 줌 단계마다 한 장씩 쌓이므로 상한을 둔다. 오래된 것부터 버린다.
    if (_rasters.length >= _maxRastersPerIcon) {
      final int oldest = _rasters.keys.first;
      _rasters.remove(oldest)?.dispose();
    }
    _rasters[key] = image;
    return image;
  }

  /// 한 아이콘이 들고 있을 래스터 수 상한.
  static const int _maxRastersPerIcon = 5;

  void dispose() {
    for (final Image image in _rasters.values) {
      image.dispose();
    }
    _rasters.clear();
    picture.dispose();
  }
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

  /// 한 번에 몇 장까지 동시에 디코딩할지.
  ///
  /// **무제한으로 발사하면 안 된다.** `flutter_svg`는 릴리스에서 SVG 한 장마다
  /// `compute`(= isolate 스폰)를 쓴다 — 161장을 한꺼번에 던지면 isolate를 그만큼
  /// 만들려 들고, 중저가 안드로이드에서 그 자체가 스파이크가 된다.
  ///
  /// **8에서 16으로 올렸다**(사용자 지적 2026-08-25 — "아이콘 없는 중간 상태가
  /// 길다"). 8은 스파이크를 확실히 없앴지만 161장을 20묶음으로 나눠 지도가
  /// 회색으로 있는 시간이 길었다. 16이면 묶음이 절반으로 줄고, 요즘 기기의 코어
  /// 수를 생각하면 여전히 한꺼번에 터뜨리는 것과는 거리가 멀다.
  static const int _decodeConcurrency = 16;

  /// 여러 칸을 한꺼번에 준비한다. 지도 진입 시 부른다.
  ///
  /// [onBatch]가 있으면 한 묶음이 끝날 때마다 부른다 — 화면이 그때그때 다시
  /// 그리면 아이콘이 **점진적으로 나타난다.** 예전에는 161장이 전부 끝나야 한 번에
  /// 나타나, 그동안 회색 면만 보였다.
  Future<void> preload(
    Iterable<LandmarkIconKey> keys, {
    VoidCallback? onBatch,
  }) async {
    final List<LandmarkIconKey> pending = <LandmarkIconKey>[
      for (final LandmarkIconKey key in keys)
        if (!_pictures.containsKey(key)) key,
    ];
    if (pending.isEmpty) return;

    for (int i = 0; i < pending.length; i += _decodeConcurrency) {
      final int end = (i + _decodeConcurrency).clamp(0, pending.length);
      await Future.wait<void>(pending.sublist(i, end).map(load));
      onBatch?.call();
    }
  }

  /// 캐시를 비우고 그림을 해제한다.
  void dispose() {
    for (final LandmarkIconPicture info in _pictures.values) {
      // 그림과 함께 **구워 둔 래스터도** 놓아 준다.
      info.dispose();
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
