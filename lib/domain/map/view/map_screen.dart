import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

import '../../../common/config/map_sdk_initializer.dart';
import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/area_info_card.dart';
import '../component/congestion_attribution.dart';
import '../component/congestion_legend.dart';
import '../component/map_notice_banner.dart';
import '../component/map_zoom_controls.dart';
import '../component/my_location_button.dart';
import '../model/congestion_area.dart';
import '../model/congestion_layer_state.dart';
import '../model/congestion_overlay.dart';
import '../model/map_bounds.dart';
import '../model/map_tuning.dart';

/// 지도 탭(R18). 관광지·문화행사를 지도 위에서 탐색하고 서울 실시간 혼잡도를
/// 겹쳐 본다.
///
/// **현재는 지도 표시와 유휴 판정까지다.** 마커·폴리곤은 서버의 `mapViewport`·
/// `seoulCongestion`이 라이브 스키마에 올라온 뒤에 붙인다(설계 §9.1) — 없는 스키마에
/// 맞춰 repository를 쓰면 재작업이 난다.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  static String get routeName => 'map';

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  KakaoMapController? _controller;

  /// 유휴 판정 타이머(R19). **dispose에서 반드시 취소한다** — 화면을 벗어난 뒤에도
  /// 살아 있으면 폐기된 상태에 결과가 도착한다(설계 §3.1).
  Timer? _idleTimer;

  /// 직전에 조회한 영역(R20). 새 뷰포트가 이 안에 완전히 들어오면 재조회하지 않는다.
  MapBounds? _lastQueried;

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
  void _applyCongestionGate(int zoomLevel) {
    if (!shouldShowCongestion(zoomLevel)) {
      if (_congestionState is! CongestionHiddenByZoom) {
        setState(() {
          _congestionState = const CongestionHiddenByZoom();
          // 폴리곤이 사라지면 그 구역의 말풍선도 근거를 잃는다.
          _selectedArea = null;
        });
      }
      return;
    }

    // TODO(SPEC-0014): 게이트를 통과했으니 여기서 seoulCongestion을 조회한다.
    // 서버 구현 전까지는 그릴 데이터가 없어 숨김 상태를 유지한다 — 빈 폴리곤 레이어를
    // 띄우면 출처 표기와 범례만 떠서 무엇의 출처인지 알 수 없게 된다.
  }

  /// 현재 뷰포트를 산출해 조회한다.
  ///
  /// **경계는 SDK가 주지 않는다**(설계 §2.1). `CameraPosition`은 중심과 정수 줌만
  /// 담으므로, 화면 두 모서리를 `fromScreenPoint`로 되돌려 bbox를 만든다.
  Future<void> _queryViewport(int zoomLevel) async {
    // 줌 게이트가 먼저다(R25). 뷰포트가 그대로여도 줌이 임계값을 넘나들면 혼잡도
    // 레이어의 상태는 바뀐다.
    _applyCongestionGate(zoomLevel);

    final MapBounds? visible = await _visibleBounds();
    if (visible == null || !mounted) return;

    // 이미 받아 둔 영역 안이면 재조회하지 않는다(R20).
    final MapBounds? queried = _lastQueried;
    if (queried != null && queried.contains(visible)) return;

    _lastQueried = visible.expanded();

    // TODO(SPEC-0014): 서버의 mapViewport가 라이브 스키마에 올라오면 여기서
    // provider를 통해 마커·클러스터를 조회하고 `truncated`를 받는다.
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
            onMapReady: (KakaoMapController controller) {
              _controller = controller;
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
