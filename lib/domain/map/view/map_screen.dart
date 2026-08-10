import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

import '../../../common/config/map_sdk_initializer.dart';
import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/navigation/spot_detail_route.dart';
import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/area_info_card.dart';
import '../component/congestion_attribution.dart';
import '../component/congestion_legend.dart';
import '../component/map_notice_banner.dart';
import '../component/map_overlay_painter.dart';
import '../component/map_zoom_controls.dart';
import '../component/my_location_button.dart';
import '../model/congestion_area.dart';
import '../model/congestion_layer_state.dart';
import '../model/congestion_overlay.dart';
import '../model/map_bounds.dart';
import '../model/map_marker.dart';
import '../model/map_tuning.dart';
import '../model/map_viewport_result.dart';
import '../model/seoul_congestion_result.dart';
import '../provider/map_providers.dart';

/// 지도 탭(R18). 관광지·문화행사를 지도 위에서 탐색하고 서울 실시간 혼잡도를
/// 겹쳐 본다.
///
/// 지도가 멈추면 디바운스 뒤 1회 조회하고(R19), 화면보다 넓게 받아 작은 이동에는
/// 재조회하지 않는다(R20).
///
/// **마커와 혼잡도는 서로 기다리지 않는다**(설계 §6.3). 별개 최상위 필드라 한쪽이
/// 느리거나 실패해도 다른 쪽은 그려져야 한다 — 혼잡도가 죽어도 마커와 지도 조작은
/// 그대로다(R29).
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  static String get routeName => 'map';

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  KakaoMapController? _controller;

  /// 지도 위 오버레이를 그리고 지우는 책임. SDK 호출을 화면에서 떼어 둔다.
  MapOverlayPainter? _painter;

  /// 진행 중인 조회의 세대 번호. 뷰포트가 바뀌면 올라간다.
  ///
  /// **늦게 도착한 응답이 현재 뷰포트를 덮어쓰지 않게 한다**(설계 §3.3). 조회를
  /// 시작할 때의 번호를 들고 있다가, 돌아왔을 때 최신이 아니면 결과를 버린다.
  int _queryGeneration = 0;

  /// 유휴 판정 타이머(R19). **dispose에서 반드시 취소한다** — 화면을 벗어난 뒤에도
  /// 살아 있으면 폐기된 상태에 결과가 도착한다(설계 §3.1).
  Timer? _idleTimer;

  /// 직전에 조회한 영역(R20). 새 뷰포트가 이 안에 완전히 들어오면 재조회하지 않는다.
  MapBounds? _lastQueried;

  /// 직전에 조회한 줌. 영역이 같아도 줌이 바뀌면 다시 조회한다 — 클러스터/개별 마커가
  /// 갈리고 혼잡도 게이트도 줌으로 판정된다.
  int? _lastZoom;

  /// 현재 위치를 얻는 중인가. 버튼이 진행 표시로 바뀌고 중복 요청을 막는다.
  bool _isLocating = false;

  /// 혼잡도 레이어 상태(R25·R29·R30). 출처 표기·범례·실패 안내가 **모두 이 하나를
  /// 본다** — 셋이 각자 조건을 따지면 어긋난 조합(색은 없는데 범례만 뜬 상태 등)이
  /// 생긴다.
  ///
  /// 조회가 붙기 전까지는 줌 게이트만으로 정해진다. 서버가 오면 `CongestionShown`·
  /// `CongestionDegraded`가 이 자리에 들어간다.
  CongestionLayerState _congestionState = const CongestionHiddenByZoom();

  /// 선택된 구역. null이면 말풍선을 띄우지 않는다.
  CongestionArea? _selectedArea;

  /// 잘림 안내를 닫았는가(R23). 세션 내 일시적이며, 새 조회 결과가 다시 잘리면
  /// 그때 다시 뜬다.
  bool _truncatedDismissed = false;

  /// 결과가 상한에 걸렸는가(R23). 서버 응답의 `truncated`가 들어올 자리다.
  ///
  /// 아직 대입하는 곳이 없어 분석기가 `final`을 권하지만, 서버가 붙으면 조회 결과가
  /// 여기 들어온다 — `final`로 바꾸면 그때 되돌려야 한다.
  // ignore: prefer_final_fields
  bool _truncated = false;

  /// 혼잡도 색이 실제로 화면에 있는가.
  ///
  /// **출처 표기(R30)와 범례(R24)가 같은 판정을 쓴다.** 둘이 각자 조건을 따지면
  /// 폴리곤은 없는데 범례만 뜨거나, 아무것도 안 그리면서 출처만 떠 있는 조합이
  /// 생긴다 — 후자는 실제로 한 번 났던 문제다.
  bool get _showsCongestionLayer => _congestionState.showsAttribution;

  @override
  void dispose() {
    _idleTimer?.cancel();
    // 세대를 올려 진행 중인 조회의 결과가 폐기된 상태를 건드리지 않게 한다.
    _queryGeneration++;
    // 오버레이 정리는 기다리지 않는다 — dispose는 동기이고, 지도 뷰 자체가 함께
    // 사라지므로 남은 마커가 화면에 보일 일은 없다.
    unawaited(_painter?.dispose() ?? Future<void>.value());
    super.dispose();
  }

  /// 줌을 한 단계 조정한다.
  ///
  /// 조정 뒤 카메라가 멈추면 `onCameraMoveEnd`가 불려 **기존 유휴 판정 경로를 그대로
  /// 탄다**(디자인 §1) — 버튼 전용 조회 분기를 따로 두지 않는다.
  Future<void> _zoom({required bool zoomIn}) async {
    final KakaoMapController? controller = _controller;
    if (controller == null) return;
    await controller.moveCamera(
      zoomIn ? CameraUpdate.zoomIn() : CameraUpdate.zoomOut(),
    );
  }

  /// 현재 위치로 지도를 옮긴다.
  ///
  /// `refresh`를 쓰는 이유는 이 버튼의 주 용도가 **이동한 뒤 다시 누르는 것**이기
  /// 때문이다. 캐시된 좌표를 그대로 쓰면 두 번째 탭이 아무 데도 데려가지 않는다.
  Future<void> _moveToCurrentLocation() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);

    try {
      final Coordinates coordinates = await ref.refresh(
        currentCoordinatesProvider.future,
      );
      final KakaoMapController? controller = _controller;
      if (controller == null || !mounted) return;

      // **줌을 반드시 함께 넘긴다.** `newCenterPosition`의 zoomLevel 기본값은 -1이고
      // 그 값이 네이티브까지 그대로 가서 전국이 보일 만큼 축소된다. 위치 버튼은
      // 위치만 옮기는 것이 맞다 — 배율까지 바꾸면 보던 맥락이 날아간다.
      final CameraPosition current = await controller.getCameraPosition();
      await controller.moveCamera(
        CameraUpdate.newCenterPosition(
          LatLng(coordinates.latitude, coordinates.longitude),
          zoomLevel: current.zoomLevel,
        ),
        animation: const CameraAnimation(500),
      );
    } on Exception {
      // 권한 거부·위치 서비스 꺼짐 모두 여기로 온다. 사용자가 할 수 있는 일은
      // 설정을 켜는 것 하나뿐이라 유형을 나누지 않고 한 문구로 안내한다.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).mapLocationUnavailable),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  /// 지도가 움직이기 시작하면 대기 중인 조회를 취소한다(R19).
  ///
  /// 이동 중에는 조회하지 않는다 — 매 프레임 조회하면 뷰포트가 바뀔 때마다 요청이
  /// 나가고 대부분은 도착 전에 무의미해진다.
  void _onCameraMoveStart(GestureType _) => _idleTimer?.cancel();

  /// 지도가 멈추면 디바운스를 걸고, 만료되면 1회 조회한다(R19).
  void _onCameraMoveEnd(CameraPosition position, GestureType _) {
    _idleTimer?.cancel();
    _idleTimer = Timer(
      MapTuning.idleDebounce,
      () => _queryViewport(position.zoomLevel),
    );
  }

  /// 줌 게이트를 적용해 혼잡도 레이어 상태를 정한다(R25).
  ///
  /// **게이트는 렌더링이 아니라 조회 단계에 있다.** 임계 줌 미만이면
  /// `seoulCongestion`을 호출조차 하지 않는다 — 이것이 일일 쿼터 1000건을 지키는
  /// 실질적 장치다(설계 §5.1). 그리기만 막고 조회를 계속하면 아무 의미가 없다.
  Future<void> _loadCongestion(
    MapBounds bbox,
    int zoomLevel,
    int generation,
  ) async {
    if (!shouldShowCongestion(zoomLevel)) {
      // 게이트 미만 — **조회하지 않고** 폴리곤도 지운다. 말풍선은 근거를 잃으므로
      // 함께 닫는다.
      await _painter?.clearCongestion();
      if (!mounted || generation != _queryGeneration) return;
      setState(() {
        _congestionState = const CongestionHiddenByZoom();
        _selectedArea = null;
      });
      return;
    }

    setState(() => _congestionState = const CongestionLoading());

    try {
      // 경계(정적·캐시)와 혼잡도(실시간)를 함께 기다린다 — 서로 독립이라 순차로
      // 기다릴 이유가 없다.
      final (
        List<CongestionAreaBoundary> boundaries,
        SeoulCongestionResult live,
      ) = await (
        ref.read(currentCongestionBoundariesProvider.future),
        ref.read(seoulCongestionProvider(bbox).future),
      ).wait;
      if (!mounted || generation != _queryGeneration) return;

      if (live.degraded) {
        // 업스트림 장애. **폴리곤만 지우고 마커는 건드리지 않는다**(R29).
        await _painter?.clearCongestion();
        if (!mounted || generation != _queryGeneration) return;
        setState(() {
          _congestionState = const CongestionDegraded();
          _selectedArea = null;
        });
        return;
      }

      final List<CongestionOverlay> overlays = joinCongestionOverlays(
        areas: live.areas,
        boundaries: <String, CongestionAreaBoundary>{
          for (final CongestionAreaBoundary b in boundaries) b.id: b,
        },
      );
      await _painter?.drawCongestion(overlays);
      if (!mounted || generation != _queryGeneration) return;
      setState(() => _congestionState = CongestionShown(overlays));
    } on Exception {
      // 혼잡도 실패는 지도 전체의 실패가 아니다 — 마커는 그대로 두고 이 레이어만
      // 안내로 대체한다(R29).
      await _painter?.clearCongestion();
      if (!mounted || generation != _queryGeneration) return;
      setState(() {
        _congestionState = const CongestionDegraded();
        _selectedArea = null;
      });
    }
  }

  /// 뷰포트 안의 마커를 조회해 그린다(R1·R2·R3·R12).
  Future<void> _loadMarkers(
    MapBounds bbox,
    int zoomLevel,
    int generation,
  ) async {
    try {
      final MapViewportResult result = await ref.read(
        mapViewportProvider(bbox, zoomLevel).future,
      );
      if (!mounted || generation != _queryGeneration) return;

      final ColorScheme colors = Theme.of(context).colorScheme;
      await _painter?.drawMarkers(
        result,
        onMarkerTap: _onMarkerTap,
        onClusterTap: _onClusterTap,
        spotColor: colors.primary,
        eventColor: colors.tertiary,
        clusterColor: colors.primary,
      );
      if (!mounted || generation != _queryGeneration) return;

      setState(() {
        // 새 결과가 잘렸으면 안내를 다시 띄운다 — 이전에 닫았어도 새 상황이다.
        if (result.truncated && !_truncated) _truncatedDismissed = false;
        _truncated = result.truncated;
      });
    } on Exception {
      // 마커 조회 실패는 조용히 넘긴다. 다음 유휴에서 다시 시도되고, 실패할 때마다
      // 배너를 띄우면 이동 중에 안내가 깜빡인다.
    }
  }

  /// 지도판을 탭했을 때. 그 자리에 혼잡도 구역이 있으면 말풍선을 띄우고, 없으면
  /// 선택을 푼다(R27).
  ///
  /// 폴리곤 자체에 탭 콜백을 다는 대신 좌표로 판정하는 이유는, SDK의 도형이 클릭
  /// 이벤트를 주지 않기 때문이다 — 판정은 순수 계산이라 model이 맡는다.
  void _onTerrainTap(LatLng position) {
    final CongestionLayerState state = _congestionState;
    if (state is! CongestionShown) {
      if (_selectedArea != null) setState(() => _selectedArea = null);
      return;
    }

    final CongestionOverlay? hit = overlayAt(
      latitude: position.latitude,
      longitude: position.longitude,
      overlays: state.overlays,
    );
    setState(() => _selectedArea = hit?.area);
  }

  /// 마커를 탭했을 때. 상세 화면으로 보낸다 — **id만 넘긴다**(CLAUDE.md §6).
  void _onMarkerTap(MapMarker marker) {
    // 문화행사는 아직 상세 화면이 없다 — 계약이 주는 것은 외부 링크뿐이다(spec §7.9).
    if (marker.kind != MapMarkerKind.spot) return;
    // `common/navigation`의 헬퍼를 쓴다. 인자 규약(category가 서버 필수 인자라는 것)이
    // 거기 모여 있어, 직접 pushNamed하면 그 규약을 여기서 다시 지켜야 한다.
    openSpotDetail(context, id: marker.id, category: marker.categoryName);
  }

  /// 클러스터를 탭하면 그 중심으로 확대한다(R22).
  ///
  /// 확대 후 유휴가 되면 기존 조회 경로를 그대로 타 개별 마커로 바뀐다 — 별도 분기를
  /// 두지 않는다(설계 §4.2).
  Future<void> _onClusterTap(MapCluster cluster) async {
    final KakaoMapController? controller = _controller;
    if (controller == null) return;

    final CameraPosition current = await controller.getCameraPosition();
    await controller.moveCamera(
      CameraUpdate.newCenterPosition(
        LatLng(cluster.centerLatitude, cluster.centerLongitude),
        zoomLevel: current.zoomLevel + MapTuning.clusterTapZoomStep,
      ),
      animation: const CameraAnimation(400),
    );
  }

  /// 현재 뷰포트를 산출해 조회한다.
  ///
  /// **경계는 SDK가 주지 않는다**(설계 §2.1). `CameraPosition`은 중심과 정수 줌만
  /// 담으므로, 화면 두 모서리를 `fromScreenPoint`로 되돌려 bbox를 만든다.
  Future<void> _queryViewport(int zoomLevel) async {
    final MapBounds? visible = await _visibleBounds();
    if (visible == null || !mounted) return;

    // 이미 받아 둔 영역 안이면 재조회하지 않는다(R20). **줌이 바뀌면 예외다** —
    // 같은 영역이라도 줌에 따라 클러스터/개별 마커가 갈리고 혼잡도 게이트도 바뀐다.
    final MapBounds? queried = _lastQueried;
    if (queried != null &&
        queried.contains(visible) &&
        _lastZoom == zoomLevel) {
      return;
    }

    // 화면보다 넓게 받아 둬 작은 이동에 재조회가 걸리지 않게 한다(R20).
    final MapBounds expanded = visible.expanded();
    _lastQueried = expanded;
    _lastZoom = zoomLevel;

    // 이 시점 이후 도착하는 이전 세대의 응답은 버려진다(설계 §3.3).
    final int generation = ++_queryGeneration;

    // 마커와 혼잡도는 **서로 기다리지 않는다**(설계 §6.3) — 한쪽이 느리거나 실패해도
    // 다른 쪽은 그려져야 한다(R29).
    await (
      _loadMarkers(expanded, zoomLevel, generation),
      _loadCongestion(expanded, zoomLevel, generation),
    ).wait;
  }

  /// 화면에 보이는 영역을 위경도 bbox로 되돌린다.
  ///
  /// 좌상단과 우하단 두 점이면 사각형이 정해진다. 회전을 쓰지 않으므로 축에 나란한
  /// 사각형으로 충분하다 — 회전을 허용하면 네 모서리의 min/max를 취해야 한다.
  Future<MapBounds?> _visibleBounds() async {
    final KakaoMapController? controller = _controller;
    if (controller == null) return null;

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;

    final Size size = box.size;
    final LatLng? topLeft = await controller.fromScreenPoint(0, 0);
    final LatLng? bottomRight = await controller.fromScreenPoint(
      size.width.round(),
      size.height.round(),
    );
    if (topLeft == null || bottomRight == null) return null;

    // 화면 위쪽이 북(위도 큼), 왼쪽이 서(경도 작음)다.
    final MapBounds bounds = MapBounds(
      minLat: bottomRight.latitude,
      minLng: topLeft.longitude,
      maxLat: topLeft.latitude,
      maxLng: bottomRight.longitude,
    );
    return bounds.isValid ? bounds : null;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    // 키가 없거나 SDK 인증에 실패하면 지도를 띄울 수 없다. 앱을 죽이지 않고 이
    // 화면만 안내로 대체한다(설계 §10).
    if (!MapSdkInitializer.isReady) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.navMap)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(l10n.mapKeyMissing, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          KakaoMap(
            option: const KakaoMapOption(
              position: _seoulCityHall,
              zoomLevel: MapTuning.initialZoom,
            ),
            // 지도판을 탭하면 선택을 푼다 — 말풍선을 닫는 자연스러운 방법이다.
            onTerrainClick: (KPoint _, LatLng position) =>
                _onTerrainTap(position),
            onMapReady: (KakaoMapController controller) {
              _controller = controller;
              _painter = MapOverlayPainter(controller);
              // 첫 진입도 유휴와 같은 경로를 타게 한다 — 분기를 하나로 둔다.
              _idleTimer?.cancel();
              _idleTimer = Timer(
                MapTuning.idleDebounce,
                () => _queryViewport(MapTuning.initialZoom),
              );
            },
            onCameraMoveStart: _onCameraMoveStart,
            onCameraMoveEnd: _onCameraMoveEnd,
          ),
          // 줌·현재 위치 컨트롤(디자인 §1). 우측에 세로로 쌓되 둘을 떨어뜨린다 —
          // 줌은 지도 조작이고 위치 이동은 별개 액션이라 하나의 그룹으로 읽히면
          // 안 된다.
          //
          // 셸이 `extendBody: true`라 body가 하단 네비바 아래까지 그려진다. 그래서
          // 화면이 직접 barExtent만큼 띄운다 — 안 그러면 버튼이 바에 가린다.
          Positioned(
            right: 12,
            bottom: FloatingBottomNavScaffold.barExtent + 16,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MapZoomControls(
                    onZoomIn: () => _zoom(zoomIn: true),
                    onZoomOut: () => _zoom(zoomIn: false),
                  ),
                  const SizedBox(height: 12),
                  MyLocationButton(
                    isLocating: _isLocating,
                    onPressed: _moveToCurrentLocation,
                  ),
                ],
              ),
            ),
          ),
          // 상단 안내. 혼잡도 실패가 잘림보다 위다 — 잘림은 "더 볼 게 있다"는 신호에
          // 가깝고 레이어 실패는 기능 제한이라 먼저 알려야 한다(디자인 §6).
          Positioned(
            top: 0,
            left: 12,
            right: 12,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  if (_congestionState is CongestionDegraded)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: CongestionDegradedNotice(),
                    ),
                  if (_truncated && !_truncatedDismissed)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TruncatedNoticeBanner(
                        onDismiss: () =>
                            setState(() => _truncatedDismissed = true),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // 범례(R24). 색이 실제로 그려질 때만 띄운다 — 판정은 레이어 상태 하나가
          // 쥔다.
          if (_showsCongestionLayer)
            const Positioned(
              top: 0,
              left: 12,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 56),
                  child: CongestionLegend(),
                ),
              ),
            ),
          // 줌·현재 위치 컨트롤(디자인 §1). 우측에 세로로 쌓되 둘을 떨어뜨린다 —
          // 줌은 지도 조작이고 위치 이동은 별개 액션이라 하나의 그룹으로 읽히면
          // 안 된다.
          //
          // 셸이 `extendBody: true`라 body가 하단 네비바 아래까지 그려진다. 그래서
          // 화면이 직접 barExtent만큼 띄운다 — 안 그러면 버튼이 바에 가린다.
          // 출처 표기(R30). **혼잡도 레이어가 보이는 동안만 노출한다** — 공공누리
          // 1유형의 출처 표시 의무는 그 데이터를 쓸 때 생긴다. 폴리곤이 하나도 없는데
          // 표기만 떠 있으면 무엇의 출처인지 알 수 없다.
          if (_showsCongestionLayer)
            const Positioned(
              left: 8,
              bottom: FloatingBottomNavScaffold.barExtent + 8,
              child: SafeArea(child: CongestionAttribution()),
            ),
          // 구역 정보 말풍선(R27·R28). 선택했을 때만 뜬다.
          if (_selectedArea case final CongestionArea area)
            Positioned(
              left: 12,
              right: 12,
              bottom: FloatingBottomNavScaffold.barExtent + 8,
              child: SafeArea(
                child: AreaInfoCard(
                  area: area,
                  onClose: () => setState(() => _selectedArea = null),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 지도 첫 진입 위치. 서울시청 — 혼잡도 121곳이 서울에 몰려 있어 여기서 시작하면
/// 기능이 바로 드러난다. SDK 기본값(판교)은 이 앱의 맥락과 맞지 않는다.
const LatLng _seoulCityHall = LatLng(37.5663, 126.9779);
