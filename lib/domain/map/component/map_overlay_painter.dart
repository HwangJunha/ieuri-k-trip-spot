import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

import '../model/congestion_level.dart';
import '../model/congestion_overlay.dart';
import '../model/congestion_palette.dart';
import '../model/map_marker.dart';
import 'map_marker_icons.dart';

/// 지도 위에 마커와 폴리곤을 그리고 지운다.
///
/// **SDK 호출을 화면에서 떼어 낸다.** 오버레이 갱신은 "이전 것을 지우고 새로 그린다"의
/// 반복이라 상태가 꼬이기 쉬운데, 그 관리를 화면의 build와 섞으면 어느 시점에 무엇이
/// 지도에 남아 있는지 추적하기 어려워진다.
///
/// 컨트롤러 계층이 아니라 component에 두는 이유는 이것이 **그리기**이기 때문이다 —
/// 데이터를 가져오지 않으므로 repository가 아니다.
class MapOverlayPainter {
  MapOverlayPainter(this._controller);

  final KakaoMapController _controller;

  /// 폴리곤 그리기 세대. 겹쳐 호출됐을 때 최신 것만 그리게 한다 — 지우는 도중에
  /// 다른 호출이 그리면 폴리곤이 남아 겹쳐 쌓인다.
  int _polygonDrawToken = 0;

  /// 마커 그리기 세대. 사진을 내려받는 동안 다음 요청이 들어오면 두 그리기가 같은
  /// 풀을 건드려 마커가 뒤섞인다.
  int _markerDrawToken = 0;

  /// 혼잡도 단계별 폴리곤 스타일. **단계마다 하나만 만들어 재사용한다.**
  ///
  /// 폴리곤마다 새 `PolygonStyle`을 넘겼더니 SDK가 그때마다 스타일을 새로 등록했고
  /// (`addPolygonShapeStyle`), 도형을 지워도 **등록된 스타일은 지워지지 않아** 계속
  /// 쌓였다. 반투명 채우기가 겹쳐 지도를 옮길 때마다 구역이 진해지던 원인이다.
  ///
  /// 같은 인스턴스를 재사용하면 SDK가 이미 등록된 id를 그대로 쓴다.
  final Map<CongestionLevel, _IntStrokePolygonStyle> _polygonStyles =
      <CongestionLevel, _IntStrokePolygonStyle>{};

  _IntStrokePolygonStyle _styleFor(CongestionLevel level) =>
      _polygonStyles[level] ??= _IntStrokePolygonStyle(
        Color(CongestionPalette.fillOf(level)),
        strokeWidth: 2,
        strokeColor: Color(CongestionPalette.strokeOf(level)),
      );

  final List<Poi> _markers = <Poi>[];

  /// 만들어 둔 폴리곤 풀. **지우지 않고 재사용한다**(→[drawCongestion]).
  ///
  /// `addPolygonShape`가 `Polygon<BasePoint>`를 돌려주므로 그 타입으로 들고, 좌표를
  /// 갈아 끼울 때만 `MapPoint`를 넘긴다.
  final List<Polygon<BasePoint>> _polygons = <Polygon<BasePoint>>[];

  /// 아이콘 PNG 캐시. 마커마다 다시 그리면 뷰포트 갱신이 느려진다 — 종류·색 조합이
  /// 몇 개뿐이라 캐시가 그대로 유효하다.
  final Map<String, KImage> _iconCache = <String, KImage>{};

  /// 내려받아 디코드한 썸네일. 화면을 옮길 때마다 같은 관광지가 다시 잡히므로,
  /// 캐시가 없으면 조회보다 이미지 왕복이 더 느려진다.
  final Map<String, ui.Image> _photoCache = <String, ui.Image>{};

  /// 받기에 실패한 URL. **다시 시도하지 않는다** — 뷰포트를 옮길 때마다 같은 URL로
  /// 재시도하면 실패한 이미지 수만큼 매번 느려진다.
  final Set<String> _photoFailures = <String>{};

  /// 마커와 클러스터를 다시 그린다(R21·R2).
  ///
  /// [onMarkerTap]은 개별 마커, [onClusterTap]은 클러스터를 눌렀을 때다.
  /// 마커와 클러스터를 다시 그린다(R21·R2).
  ///
  /// **무엇을 그릴지는 정하지 않는다** — 솎아내기와 누적은 `MapMarkerController`가
  /// 맡고, 여기서는 받은 목록을 그대로 그린다. 그리기와 고르기를 한곳에 두면 지도를
  /// 옮길 때마다 마커가 통째로 갈아 끼워져 화면이 깜빡인다.
  /// ## 폴리곤과 같은 이유로 **지우지 않고 재사용한다**
  ///
  /// `Poi.remove()`도 Dart 목록에서만 지우고 네이티브에는 남는다 — 지도를 옮길 때마다
  /// 새로 그리면 이전 마커가 쌓여 새것을 가린다(실기기: "10개 등록 완료"인데 이전
  /// 것이 그대로 보이고 새것이 안 보임).
  ///
  /// 만들어 둔 `Poi`를 풀에 두고 좌표·아이콘·탭 콜백만 갈아 끼운다. 남는 것은
  /// `hide()`로 감춘다.
  Future<void> drawMarkers({
    required List<MapMarker> markers,
    required void Function(MapMarker marker) onMarkerTap,
  }) async {
    final int token = ++_markerDrawToken;
    final LabelController layer = _markerLayer;

    for (int i = 0; i < markers.length; i++) {
      if (token != _markerDrawToken) return;

      final MapMarker marker = markers[i];
      // 색은 `MapMarkerPalette`가 정한다 — 테마에서 읽으면 브랜드 색이 혼잡도
      // 채색과 섞여 마커가 "붐빔"으로 읽힌다(실기기에서 실제로 났던 문제).
      final Color color = Color(
        marker.kind == MapMarkerKind.spot
            ? MapMarkerPalette.spot
            : MapMarkerPalette.culturalEvent,
      );

      // **한 마커가 실패해도 나머지는 그린다.** 아이콘 디코드나 오버레이 등록이
      // 실패하면 SDK가 `Error`를 던지는데, 놓치면 앱이 통째로 죽는다.
      try {
        final KImage icon = await _markerIcon(marker, color);

        if (i < _markers.length) {
          final Poi poi = _markers[i];
          await poi.changeStyles(PoiStyle(icon: icon));
          await poi.move(LatLng(marker.latitude, marker.longitude));
          poi.onClick = () => onMarkerTap(marker);
          await poi.show();
        } else {
          _markers.add(
            await layer.addPoi(
              LatLng(marker.latitude, marker.longitude),
              style: PoiStyle(icon: icon),
              onClick: () => onMarkerTap(marker),
            ),
          );
        }
      } on Object catch (error) {
        if (kDebugMode) {
          debugPrint('[Map] 마커 갱신 실패(${marker.name}): $error');
        }
      }
    }

    // 남는 것은 숨긴다 — 지우면 네이티브에 남아 새것을 가린다.
    for (int i = markers.length; i < _markers.length; i++) {
      try {
        await _markers[i].hide();
      } on Object catch (error) {
        if (kDebugMode) debugPrint('[Map] 마커 숨김 실패: $error');
      }
    }

    if (kDebugMode) {
      debugPrint('[Map] 마커 ${markers.length}개 표시 (풀 ${_markers.length}개)');
    }

    // 클러스터는 그리지 않는다 — 서버가 필드를 제거했다(2026-08-10).
    // 저줌에서 마커가 몰리는 문제는 격자 솎아내기가 맡는다.
  }

  /// 실시간 내 위치 점. **마커 풀과 따로 둔다.**
  ///
  /// 같은 풀에 넣으면 조회 결과가 들어올 때마다 인덱스가 밀려 내 위치가 관광지
  /// 아이콘으로 바뀌거나, 상한(10개)에 밀려 사라진다. 성격이 다른 오버레이라
  /// 수명도 따로다 — 이것은 조회와 무관하게 GPS만 따라간다.
  Poi? _myLocation;

  /// 내 위치 점을 [coordinates]로 옮긴다. 없으면 만든다.
  ///
  /// **매번 새로 만들지 않는다.** 5m마다 좌표가 오는데 그때마다 `addPoi`를 하면
  /// 네이티브에 점이 쌓여 지나온 길이 파란 점으로 그려진다(마커·폴리곤에서 이미
  /// 겪은 문제 — `remove()`가 네이티브를 지우지 않는다).
  Future<void> drawMyLocation(double latitude, double longitude) async {
    try {
      final Poi? existing = _myLocation;
      if (existing != null) {
        await existing.move(LatLng(latitude, longitude));
        await existing.show();
        return;
      }

      final KImage icon = await _icon(
        'my-location',
        MapMarkerIcons.myLocationDot,
        MapMarkerIcons.myLocationSize,
      );
      _myLocation = await _markerLayer.addPoi(
        LatLng(latitude, longitude),
        style: PoiStyle(icon: icon),
      );
      // 위치 갱신 하나가 실패해도 지도는 계속 돌아야 한다 — 다음 좌표에서 다시
      // 시도한다.
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Map] 내 위치 표시 실패: $error');
    }
  }

  /// 내 위치 점을 감춘다. 권한이 끊기거나 위치가 꺼졌을 때 쓴다 — 마지막 좌표를
  /// 그대로 두면 사용자가 그 자리에 있는 것으로 읽힌다.
  Future<void> hideMyLocation() async {
    try {
      await _myLocation?.hide();
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Map] 내 위치 숨김 실패: $error');
    }
  }

  /// 혼잡도 폴리곤을 다시 그린다(R24·R26).
  ///
  /// 채색은 `CongestionPalette`가 정한다 — 여기서 색을 새로 고르지 않는다.
  /// ## 지우지 않고 **재사용한다**
  ///
  /// `removePolygonShape`가 Dart 목록에서는 지우면서 **네이티브에서는 실제로 지우지
  /// 않는다**(실측: "4/4개 제거" 뒤 3개만 그렸는데도 화면은 계속 진해졌다). 반투명
  /// 채우기라 남은 것 위에 겹칠수록 구역이 어두워져 지도가 안 보이게 된다.
  ///
  /// 그래서 만든 폴리곤을 **풀에 두고 좌표·스타일만 갈아 끼운다**. 남는 것은 지우는
  /// 대신 `hide()`로 감춘다 — 그건 네이티브에서 정상 동작한다.
  Future<void> drawCongestion(List<CongestionOverlay> overlays) async {
    // 겹쳐 호출되면 최신 것만 반영한다.
    final int token = ++_polygonDrawToken;
    final ShapeController layer = _polygonLayer;

    final List<CongestionOverlay> drawable = overlays
        .where((CongestionOverlay o) => o.boundary.polygon.length >= 3)
        .toList();

    for (int i = 0; i < drawable.length; i++) {
      if (token != _polygonDrawToken) return;

      final CongestionOverlay overlay = drawable[i];
      // 폴리곤 좌표는 [lng, lat] 순서다(GeoJSON 규약) — LatLng 생성자는 반대이므로
      // 여기서 뒤집는다. 이 자리가 좌표를 뒤집어 넣는 사고가 가장 잦은 곳이다.
      final MapPoint points = MapPoint(
        overlay.boundary.polygon
            .map((List<double> p) => LatLng(p[1], p[0]))
            .toList(growable: false),
      );
      final _IntStrokePolygonStyle style = _styleFor(
        overlay.area.congestion.level,
      );

      try {
        if (i < _polygons.length) {
          // 이미 만들어 둔 것을 재사용한다.
          final Polygon<BasePoint> polygon = _polygons[i];
          await polygon.changeStyle(style);
          await polygon.changePosition(points);
          await polygon.show();
        } else {
          _polygons.add(await layer.addPolygonShape(points, style));
        }
      } on Object catch (error) {
        if (kDebugMode) {
          debugPrint('[Map] 폴리곤 갱신 실패(${overlay.name}): $error');
        }
      }
    }

    // 남는 것은 숨긴다 — 지우면 네이티브에 남아 겹친다.
    for (int i = drawable.length; i < _polygons.length; i++) {
      try {
        await _polygons[i].hide();
      } on Object catch (error) {
        if (kDebugMode) debugPrint('[Map] 폴리곤 숨김 실패: $error');
      }
    }

    if (kDebugMode) {
      debugPrint('[Map] 폴리곤 ${drawable.length}개 표시 (풀 ${_polygons.length}개)');
    }
  }

  /// 폴리곤만 감춘다. 줌 게이트에 걸렸거나 혼잡도가 실패했을 때 쓴다 — **마커는
  /// 건드리지 않는다**(R29, 레이어 독립).
  ///
  /// 지우지 않고 감추는 이유는 위와 같다.
  Future<void> clearCongestion() => drawCongestion(const <CongestionOverlay>[]);

  /// 화면을 벗어날 때 전부 정리한다.
  Future<void> dispose() async {
    await _clearMarkers();
    await _clearPolygons();

    // 내 위치는 풀 밖이라 따로 지운다.
    try {
      await _myLocation?.remove();
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Map] 내 위치 제거 실패: $error');
    }
    _myLocation = null;

    // 디코드된 이미지는 GC 대상이 아니라 명시적으로 놓아야 한다.
    for (final ui.Image photo in _photoCache.values) {
      photo.dispose();
    }
    _photoCache.clear();
  }

  /// **SDK가 이미 만들어 둔 기본 레이어를 쓴다.**
  ///
  /// 처음에는 `addLabelLayer`/`addShapeLayer`로 레이어를 새로 만들었는데, 폴리곤이
  /// "등록 완료"까지 찍히면서도 화면에 나타나지 않았다 — 만든 레이어가 지도에 붙지
  /// 않은 것으로 보인다. 공식 예제(pub.dev)는 `controller.shapeLayer`를 그대로
  /// 쓰므로 그쪽을 따른다.
  LabelController get _markerLayer => _controller.labelLayer;

  ShapeController get _polygonLayer => _controller.shapeLayer;

  /// 마커 하나의 아이콘. 썸네일이 있으면 사진 마커, 없으면 종류별 도형이다.
  ///
  /// 사진은 네트워크에서 받아야 해서 실패할 수 있다 — 그때는 도형으로 떨어진다.
  /// 마커 하나 때문에 지도 전체가 멈추면 안 된다.
  Future<KImage> _markerIcon(MapMarker marker, Color color) async {
    final String? url = marker.thumbnailUrl;
    if (url != null) {
      final ui.Image? photo = await _photo(url);
      if (photo != null) {
        return _icon(
          // **강조 여부를 캐시 키에 넣는다** — 같은 사진이라도 테두리가 달라
          // 다른 이미지다. 빼면 먼저 그린 쪽 모양이 재사용된다.
          'photo:$url:${marker.kind.name}:${marker.isHighlighted}',
          () => MapMarkerIcons.photoMarker(
            photo,
            color,
            highlighted: marker.isHighlighted,
          ),
          MapMarkerIcons.photoMarkerSize,
          // 꼬리가 붙어 세로가 더 길다.
          height: MapMarkerIcons.photoMarkerSize + 6,
        );
      }
    }
    return _icon(
      'shape:${marker.kind.name}',
      () => MapMarkerIcons.marker(marker.kind, color),
      MapMarkerIcons.markerSize,
    );
  }

  /// 썸네일을 받아 디코드한다. **실패하면 null** — 호출부가 도형으로 떨어진다.
  ///
  /// 같은 URL을 여러 번 받지 않도록 캐시한다. 화면을 옮길 때마다 같은 관광지가 다시
  /// 잡히는데, 매번 내려받으면 조회보다 이미지가 더 느려진다.
  Future<ui.Image?> _photo(String url) async {
    final ui.Image? cached = _photoCache[url];
    if (cached != null) return cached;
    if (_photoFailures.contains(url)) return null;

    try {
      final http.Response response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 6));
      if (response.statusCode != 200) {
        _photoFailures.add(url);
        return null;
      }
      final ui.Codec codec = await ui.instantiateImageCodec(
        response.bodyBytes,
        // 마커 크기로만 쓰므로 원본을 다 디코드할 이유가 없다 — 다만 캔버스가
        // 화면 밀도만큼 촘촘히 그리므로(→ `MapMarkerIcons`), 그 배율을 곱한 크기로
        // 디코드해야 사진이 흐려지지 않는다. 여기서 작게 받으면 캔버스를 아무리
        // 촘촘히 그려도 원본이 없어 선명해지지 않는다.
        targetWidth: MapMarkerIcons.photoDecodeWidth,
      );
      final ui.Image image = (await codec.getNextFrame()).image;
      _photoCache[url] = image;
      return image;
      // 디코드 실패는 `Error`로 오기도 한다 — `Object`로 받는다.
    } on Object {
      // 네트워크 실패·잘못된 URL·디코드 실패. 다시 시도하지 않도록 기록한다 —
      // 뷰포트를 옮길 때마다 같은 URL로 재시도하면 그만큼 느려진다.
      _photoFailures.add(url);
      return null;
    }
  }

  Future<KImage> _icon(
    String key,
    Future<Uint8List> Function() draw,
    int size, {
    int? height,
  }) async {
    final KImage? cached = _iconCache[key];
    if (cached != null) return cached;

    // **선언 크기가 실제 PNG와 같아야 한다** — 다르면 아이콘이 눌리거나 늘어난다.
    // 사진 마커는 아래 꼬리 때문에 세로가 더 길다.
    final KImage image = KImage.fromData(await draw(), size, height ?? size);
    _iconCache[key] = image;
    return image;
  }

  /// 폴리곤과 같은 이유로 하나가 실패해도 나머지를 계속 지운다.
  Future<void> _clearMarkers() async {
    final List<Poi> targets = List<Poi>.of(_markers);
    _markers.clear();

    for (final Poi poi in targets) {
      try {
        await poi.remove();
      } on Object catch (error) {
        if (kDebugMode) debugPrint('[Map] 마커 제거 실패: $error');
      }
    }
  }

  /// **하나가 실패해도 나머지를 계속 지운다.**
  ///
  /// 예외가 루프를 끊으면 남은 폴리곤이 지도에 그대로 남고, `_polygons.clear()`에도
  /// 닿지 못해 목록마저 남는다. 그 뒤 새로 그리면 같은 자리에 겹쳐 쌓이고, 반투명
  /// 채우기라 겹칠수록 진해진다 — 실기기에서 구역이 점점 어두워지던 원인이다.
  ///
  /// 목록은 `finally`로 반드시 비운다. 지우지 못한 것을 계속 들고 있어 봐야 다음
  /// 시도에서도 같은 실패를 반복할 뿐이다.
  Future<void> _clearPolygons() async {
    final List<Polygon> targets = List<Polygon>.of(_polygons);
    _polygons.clear();
    if (targets.isEmpty) return;

    int removed = 0;
    for (final Polygon polygon in targets) {
      try {
        await polygon.remove();
        removed++;
      } on Object catch (error) {
        if (kDebugMode) debugPrint('[Map] 폴리곤 제거 실패: $error');
      }
    }

    if (kDebugMode) {
      debugPrint('[Map] 폴리곤 $removed/${targets.length}개 제거');
    }
  }
}

/// 테두리 굵기를 **정수로** 실어 보내는 [PolygonStyle].
///
/// ## 왜 필요한가 — iOS에서 앱이 죽는다
///
/// kakao_map_sdk 1.2.6의 iOS 플러그인은 스타일 payload의 숫자를 `v as! UInt`로 강제
/// 캐스팅한다(`PrimitiveTypeConverter.swift`). 그런데 `PolygonStyle.strokeWidth`는
/// Dart 타입이 `double`이라 Flutter의 메시지 코덱이 NSNumber(double)로 실어 보내고,
/// 그 캐스팅이 실패하며 앱이 통째로 죽는다:
///
/// ```
/// Foundation/NSNumber.swift: Fatal error: Unable to bridge NSNumber to UInt
/// ```
///
/// **값과 무관하다** — `2`를 넘겨도 Dart에서 `2.0`이 되므로 소용없다. 실기기에서
/// 재현했고, 폴리곤을 그리려면 반드시 지나는 길이라 iOS에서 혼잡도 레이어 자체가
/// 불가능한 상태였다.
///
/// ## 왜 이 방법인가
///
/// SDK 소스를 저장소로 복사해 고치는 방법(vendor + `dependency_overrides`)도 되지만,
/// 그러면 업스트림이 고쳐질 때까지 SDK 사본을 우리가 관리해야 한다 — 빌드마다 패치본을
/// 받아야 하고 버전을 올릴 때마다 패치를 다시 얹어야 한다. 그 비용이 이 문제에 비해
/// 크다.
///
/// `toMessageable()`은 SDK가 payload를 만들 때 다형적으로 호출하므로
/// (`addMultiplePolygonShapeStyle`), 상속해서 그 한 값만 정수로 바꾸면 SDK를 건드리지
/// 않고 끝난다. 고쳐진 버전이 나오면 이 클래스를 지우고 `PolygonStyle`로 되돌린다.
class _IntStrokePolygonStyle extends PolygonStyle {
  _IntStrokePolygonStyle(super.color, {super.strokeWidth, super.strokeColor});

  @override
  Map<String, dynamic> toMessageable() {
    final Map<String, dynamic> payload = super.toMessageable();
    payload['strokeWidth'] = strokeWidth.round();
    return payload;
  }
}
