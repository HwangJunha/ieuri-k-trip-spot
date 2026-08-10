import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

import '../model/congestion_overlay.dart';
import '../model/congestion_palette.dart';
import '../model/map_marker.dart';
import '../model/map_viewport_result.dart';
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

  /// SDK가 레이어를 id로 구분한다. 화면당 하나씩이라 상수면 충분하다.
  static const String _markerLayerId = 'map-markers';
  static const String _polygonLayerId = 'congestion-polygons';

  final KakaoMapController _controller;

  LabelController? _markerLayer;
  ShapeController? _polygonLayer;

  final List<Poi> _markers = <Poi>[];
  final List<Polygon> _polygons = <Polygon>[];

  /// 아이콘 PNG 캐시. 마커마다 다시 그리면 뷰포트 갱신이 느려진다 — 종류·색 조합이
  /// 몇 개뿐이라 캐시가 그대로 유효하다.
  final Map<String, KImage> _iconCache = <String, KImage>{};

  /// 마커와 클러스터를 다시 그린다(R21·R2).
  ///
  /// [onMarkerTap]은 개별 마커, [onClusterTap]은 클러스터를 눌렀을 때다.
  Future<void> drawMarkers(
    MapViewportResult result, {
    required void Function(MapMarker marker) onMarkerTap,
    required void Function(MapCluster cluster) onClusterTap,
    required Color spotColor,
    required Color eventColor,
    required Color clusterColor,
  }) async {
    final LabelController layer = await _ensureMarkerLayer();
    await _clearMarkers();

    for (final MapMarker marker in result.markers) {
      final Color color = marker.kind == MapMarkerKind.spot
          ? spotColor
          : eventColor;
      final KImage icon = await _icon(
        'marker:${marker.kind.name}:${color.toARGB32()}',
        () => MapMarkerIcons.marker(marker.kind, color),
        MapMarkerIcons.markerSize,
      );

      _markers.add(
        await layer.addPoi(
          LatLng(marker.latitude, marker.longitude),
          style: PoiStyle(icon: icon),
          onClick: () => onMarkerTap(marker),
        ),
      );
    }

    for (final MapCluster cluster in result.clusters) {
      final KImage icon = await _icon(
        'cluster:${cluster.count}:${clusterColor.toARGB32()}',
        () => MapMarkerIcons.cluster(cluster.count, clusterColor),
        // 클러스터는 개수에 따라 크기가 달라 캐시 키에 개수가 들어간다.
        MapMarkerIcons.markerSize,
      );

      _markers.add(
        await layer.addPoi(
          LatLng(cluster.centerLatitude, cluster.centerLongitude),
          style: PoiStyle(icon: icon),
          onClick: () => onClusterTap(cluster),
        ),
      );
    }
  }

  /// 혼잡도 폴리곤을 다시 그린다(R24·R26).
  ///
  /// 채색은 `CongestionPalette`가 정한다 — 여기서 색을 새로 고르지 않는다.
  Future<void> drawCongestion(List<CongestionOverlay> overlays) async {
    final ShapeController layer = await _ensurePolygonLayer();
    await _clearPolygons();

    for (final CongestionOverlay overlay in overlays) {
      // 폴리곤 좌표는 [lng, lat] 순서다(GeoJSON 규약) — LatLng 생성자는 반대이므로
      // 여기서 뒤집는다. 이 자리가 좌표를 뒤집어 넣는 사고가 가장 잦은 곳이다.
      final List<LatLng> points = overlay.boundary.polygon
          .map((List<double> p) => LatLng(p[1], p[0]))
          .toList(growable: false);
      if (points.length < 3) continue;

      _polygons.add(
        await layer.addPolygonShape(
          MapPoint(points),
          PolygonStyle(
            Color(CongestionPalette.fillOf(overlay.area.congestion.level)),
            strokeWidth: 1.5,
            strokeColor: Color(
              CongestionPalette.strokeOf(overlay.area.congestion.level),
            ),
          ),
        ),
      );
    }
  }

  /// 폴리곤만 지운다. 줌 게이트에 걸렸거나 혼잡도가 실패했을 때 쓴다 — **마커는
  /// 건드리지 않는다**(R29, 레이어 독립).
  Future<void> clearCongestion() => _clearPolygons();

  /// 화면을 벗어날 때 전부 정리한다.
  Future<void> dispose() async {
    await _clearMarkers();
    await _clearPolygons();
  }

  /// 레이어는 화면당 하나씩만 만든다. `KakaoMapController`가 `OverlayManager`를
  /// 믹스인하므로 컨트롤러에서 바로 부른다.
  Future<LabelController> _ensureMarkerLayer() async =>
      _markerLayer ??= await _controller.addLabelLayer(_markerLayerId);

  Future<ShapeController> _ensurePolygonLayer() async =>
      // 마커보다 아래에 그린다 — 폴리곤이 마커를 덮으면 탭이 막힌다.
      _polygonLayer ??= await _controller.addShapeLayer(
        _polygonLayerId,
        zOrder: 0,
      );

  Future<KImage> _icon(
    String key,
    Future<Uint8List> Function() draw,
    int size,
  ) async {
    final KImage? cached = _iconCache[key];
    if (cached != null) return cached;

    final KImage image = KImage.fromData(await draw(), size, size);
    _iconCache[key] = image;
    return image;
  }

  Future<void> _clearMarkers() async {
    for (final Poi poi in _markers) {
      await poi.remove();
    }
    _markers.clear();
  }

  Future<void> _clearPolygons() async {
    for (final Polygon polygon in _polygons) {
      await polygon.remove();
    }
    _polygons.clear();
  }
}
