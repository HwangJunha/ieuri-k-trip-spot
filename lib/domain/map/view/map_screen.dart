import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

import '../../../common/config/map_sdk_initializer.dart';
import '../../../common/location/coordinates.dart';
import 'package:logger/logger.dart';

import '../../../common/log/app_log.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/navigation/picked_place.dart';
import '../../../common/navigation/spot_detail_route.dart';
import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/area_info_card.dart';
import '../component/congestion_legend.dart';
import '../component/map_overlay_painter.dart';
import '../component/map_search_bar.dart';
import '../component/map_zoom_controls.dart';
import '../component/my_location_button.dart';
import '../component/region_recommendation_button.dart';
import '../component/search_this_area_button.dart';
import '../model/congestion_area.dart';
import '../model/congestion_layer_state.dart';
import '../model/congestion_overlay.dart';
import '../model/map_bounds.dart';
import '../model/map_marker.dart';
import '../model/map_tuning.dart';
import '../model/map_viewport_result.dart';
import '../model/seoul_congestion_result.dart';
import '../provider/map_marker_controller.dart';
import '../provider/map_providers.dart';
import 'region_recommendation_screen.dart';

/// 지도 탭(R18). 관광지·문화행사를 지도 위에서 탐색하고 서울 실시간 혼잡도를
/// 겹쳐 본다.
///
/// 지도가 멈추면 디바운스 뒤 1회 조회하고(R19), 화면보다 넓게 받아 작은 이동에는
/// 재조회하지 않는다(R20).
///
/// **마커와 혼잡도는 서로 기다리지 않는다**(설계 §6.3). 별개 최상위 필드라 한쪽이
/// 느리거나 실패해도 다른 쪽은 그려져야 한다 — 혼잡도가 죽어도 마커와 지도 조작은
/// 그대로다(R29).
/// "이 지역 재검색" 버튼을 상단 오버레이 아래로 내리는 거리.
///
/// 상단 Column의 구성과 묶인 값이다 — 검색창(위 여백 8 + 높이 약 46) 아래로
/// 내린다. 검색창의 높이나 여백이 바뀌면 여기도 함께 움직여야 한다. 상수로 뺀
/// 이유는 그 사실을 이름으로 남기기 위해서다 — 예전에는 62라는 숫자만 있어
/// 무언가를 끼울 때마다 버튼이 그 위에 겹쳤다.
///
/// **지도에는 카테고리 필터를 두지 않는다**(사용자 결정, 2026-08-16). 오버레이가
/// 가장 많은 화면이라 바를 하나 더 얹으면 가독성이 떨어진다.
const double _searchThisAreaTop = 8 + 46 + 8;

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  static String get routeName => 'map';

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static final Logger _log = appLogger('MapScreen');

  KakaoMapController? _controller;

  /// 지도 위 오버레이를 그리고 지우는 책임. SDK 호출을 화면에서 떼어 둔다.
  MapOverlayPainter? _painter;

  /// 진행 중인 조회의 세대 번호. 뷰포트가 바뀌면 올라간다.
  ///
  /// **늦게 도착한 응답이 현재 뷰포트를 덮어쓰지 않게 한다**(설계 §3.3). 조회를
  /// 시작할 때의 번호를 들고 있다가, 돌아왔을 때 최신이 아니면 결과를 버린다.
  ///
  /// **마커와 혼잡도가 세대를 따로 쓴다.** 하나를 공유했더니 첫 진입에서 혼잡도를
  /// 띄운 직후 마커 조회가 세대를 올려, 방금 시작한 혼잡도 결과가 구세대로 버려졌다 —
  /// 지도를 한 번 움직여야 폴리곤이 나타나던 원인이다.
  int _markerGeneration = 0;
  int _congestionGeneration = 0;

  /// 유휴 판정 타이머(R19). **dispose에서 반드시 취소한다** — 화면을 벗어난 뒤에도
  /// 살아 있으면 폐기된 상태에 결과가 도착한다(설계 §3.1).
  Timer? _idleTimer;

  /// 마커를 받아 둔 영역. 여기를 벗어나면 "이 지역 재검색" 버튼이 뜬다.
  MapBounds? _lastMarkerArea;

  /// "이 지역 재검색"을 띄울 것인가. 마커를 받아 둔 영역을 벗어났을 때 참이 된다.
  bool _canSearchHere = false;

  /// 그 버튼으로 조회하는 중인가. 연타로 요청이 겹치면 나중 응답이 먼저 온 것을
  /// 덮어 마커가 튄다.
  bool _isSearchingArea = false;

  /// 조회 뒤 버튼을 다시 띄우는 타이머(사용자 요청).
  ///
  /// 지도를 옮기지 않고 같은 화면에 머물러도 [MapTuning.searchAgainDelay]가 지나면
  /// 다시 눌러 볼 수 있게 한다 — 마커 상한에 걸려 못 들어온 장소가 그때 들어온다.
  ///
  /// **dispose와 재조회 시점에 취소한다** — 살아 있으면 폐기된 화면에서 setState가
  /// 불린다.
  Timer? _searchAgainTimer;

  /// 마커를 받아 둔 줌. 영역이 같아도 줌이 바뀌면 다시 조회한다 — 보는 범위가
  /// 달라지면 서버가 고르는 spot도 달라진다.
  int? _lastMarkerZoom;

  /// 현재 위치를 얻는 중인가. 버튼이 진행 표시로 바뀌고 중복 요청을 막는다.
  bool _isLocating = false;

  /// 지도를 처음 띄운 위치. **한 번 정해지면 바뀌지 않는다.**
  ///
  /// 매 build에서 위치 provider를 watch했더니, 조회가 setState를 부를 때마다 위치가
  /// 재평가되고 그게 다시 조회를 부르는 순환이 생겨 통신이 멈추지 않았다. 초기 위치는
  /// 진입 시 한 번만 필요하므로 여기 붙잡아 둔다 — 이후 이동은 지도 제스처와 현재
  /// 위치 버튼이 맡는다.
  Coordinates? _origin;

  /// 혼잡도 레이어 상태(R25·R29·R30). 출처 표기·범례·실패 안내가 **모두 이 하나를
  /// 본다** — 셋이 각자 조건을 따지면 어긋난 조합(색은 없는데 범례만 뜬 상태 등)이
  /// 생긴다.
  ///
  /// 조회가 붙기 전까지는 줌 게이트만으로 정해진다. 서버가 오면 `CongestionShown`·
  /// `CongestionDegraded`가 이 자리에 들어간다.
  CongestionLayerState _congestionState = const CongestionHiddenByZoom();

  /// 선택된 구역. null이면 말풍선을 띄우지 않는다.
  CongestionArea? _selectedArea;

  /// 하단 네비 바가 실제로 가리는 높이.
  ///
  /// 셸이 바를 `SafeArea` **바깥**에 두므로(`floating_bottom_nav_scaffold.dart`),
  /// 가려지는 높이는 `barExtent`만이 아니라 거기에 하단 인셋을 더한 값이다.
  ///
  /// `SafeArea`로 감싸는 대신 직접 더하는 이유는, `Stack`의 `Positioned` 안에서
  /// `SafeArea`를 쓰면 인셋이 **이중으로** 먹어 오버레이가 화면 중앙까지 떠오르기
  /// 때문이다. 세 오버레이(컨트롤·출처·말풍선)가 같은 값을 쓰도록 여기 모은다.
  /// 실측 결과 이 화면에서 `viewPadding.bottom`은 0이다 — 셸의 `SafeArea`가 이미
  /// 소비해 body에는 남지 않는다. 그래도 더해 두는 것은 홈 인디케이터가 있는 기기를
  /// 대비한 것이며, 0이면 `barExtent`만 쓰이므로 해가 없다.
  double _bottomInset(BuildContext context) =>
      FloatingBottomNavScaffold.barExtent +
      MediaQuery.viewPaddingOf(context).bottom;

  /// 혼잡도 색이 실제로 화면에 있는가.
  ///
  /// **출처 표기(R30)와 범례(R24)가 같은 판정을 쓴다.** 둘이 각자 조건을 따지면
  /// 폴리곤은 없는데 범례만 뜨거나, 아무것도 안 그리면서 출처만 떠 있는 조합이
  /// 생긴다 — 후자는 실제로 한 번 났던 문제다.
  bool get _showsCongestionLayer => _congestionState.showsAttribution;

  @override
  void dispose() {
    _idleTimer?.cancel();
    _searchAgainTimer?.cancel();
    // 세대를 올려 진행 중인 조회의 결과가 폐기된 상태를 건드리지 않게 한다.
    _markerGeneration++;
    _congestionGeneration++;
    // 오버레이 정리는 기다리지 않는다 — dispose는 동기이고, 지도 뷰 자체가 함께
    // 사라지므로 남은 마커가 화면에 보일 일은 없다.
    // 실패해도 무시한다 — 화면이 이미 사라지는 중이라 할 수 있는 일이 없고, 놓치면
    // 받아 줄 곳이 없어 앱이 죽는다.
    unawaited(
      (_painter?.dispose() ?? Future<void>.value()).catchError((Object _) {}),
    );
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
      // SDK의 `moveCamera`도 이 안에 있어 `Error`가 올 수 있다 — `Object`로 받는다.
    } on Object {
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
      if (!mounted || generation != _congestionGeneration) return;
      setState(() {
        _congestionState = const CongestionHiddenByZoom();
        _selectedArea = null;
      });
      return;
    }

    setState(() => _congestionState = const CongestionLoading());

    try {
      // **경계와 혼잡도를 따로 기다린다.** `.wait`로 묶었더니 한쪽이 실패했을 때
      // 어느 쪽인지 알 수 없는 채로 레이어 전체가 degraded로 떨어졌다 — 실기기에서
      // 혼잡도 데이터는 정상으로 왔는데 폴리곤이 하나도 안 그려진 원인이 여기였다.
      final List<CongestionAreaBoundary> boundaries = await ref.read(
        currentCongestionBoundariesProvider.future,
      );
      if (!mounted || generation != _congestionGeneration) return;

      final SeoulCongestionResult live = await ref.read(
        seoulCongestionProvider(bbox).future,
      );
      if (!mounted || generation != _congestionGeneration) return;

      if (live.degraded) {
        // 업스트림 장애. **폴리곤만 지우고 마커는 건드리지 않는다**(R29).
        await _painter?.clearCongestion();
        if (!mounted || generation != _congestionGeneration) return;
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

      // 혼잡도는 왔는데 경계가 없어 버려진 구역을 남긴다.
      //
      // **일부만 빠지는 경우도 잡는다.** 예전에는 조인 결과가 통째로 빌 때만
      // 남겼는데, 그러면 3곳 중 1곳이 조용히 사라지는 것을 알 수 없다(실기기
      // 2026-08-25: 서버가 3곳을 줬지만 2개만 그려졌고 로그는 조용했다). 어느
      // id가 경계 캐시에 없는지가 원인을 짚는 유일한 단서다.
      if (live.areas.length != overlays.length) {
        final Set<String> joined = overlays
            .map((CongestionOverlay o) => o.area.id)
            .toSet();
        final List<String> missing = live.areas
            .map((CongestionArea a) => a.id)
            .where((String id) => !joined.contains(id))
            .toList();
        _log.w(
          '혼잡도 ${live.areas.length}곳 중 ${missing.length}곳이 경계와 '
          '조인되지 않았다 (경계 캐시 ${boundaries.length}건). '
          '빠진 id: ${missing.take(10).toList()}',
        );
      }

      await _painter?.drawCongestion(overlays);
      if (!mounted || generation != _congestionGeneration) return;
      setState(() => _congestionState = CongestionShown(overlays));
      // **`Exception`이 아니라 `Object`를 받는다.** SDK는 오버레이 등록 실패를
      // `OverlayRegistrationFailedError`처럼 `Error` 계열로 던지는데, `on Exception`은
      // 그것을 놓친다. 이 조회는 `unawaited`로 띄우므로 받아 줄 곳이 여기뿐이고,
      // 놓치면 앱이 통째로 죽는다("Lost connection to device").
    } on Object catch (error, stackTrace) {
      // 혼잡도 실패는 지도 전체의 실패가 아니다 — 마커는 그대로 두고 이 레이어만
      // 안내로 대체한다(R29).
      _log.w('혼잡도 레이어 실패', error: error, stackTrace: stackTrace);
      await _painter?.clearCongestion();
      if (!mounted || generation != _congestionGeneration) return;
      setState(() {
        _congestionState = const CongestionDegraded();
        _selectedArea = null;
      });
    }
  }

  /// 뷰포트 안의 마커를 조회해 그린다(R1·R2·R3·R12).
  /// [bbox]는 **조회할 넓은 영역**(최소 20km), [visible]은 **화면에 보이는 영역**이다.
  /// 잘림 안내는 화면 기준으로 판정해야 확대했을 때 실제로 사라진다.
  Future<void> _loadMarkers(
    MapBounds bbox,
    MapBounds visible,
    int zoomLevel,
    int generation, {

    /// "이 지역 재검색"으로 부른 것인가. 참이면 화면 안의 마커를 새 장소로 **교체**한다 —
    /// 자리가 차 있다고 아무것도 안 바뀌면 버튼이 동작하지 않는 것으로 보인다.
    bool replaceShown = false,
  }) async {
    try {
      // **서버가 받는 줌으로 접어서 보낸다.** SDK 줌은 21까지 가지만 계약은 1~14라,
      // 그대로 보내면 확대할수록 `INVALID_ZOOM`으로 거절되어 마커가 하나도 안 온다.
      // 화면 판정(마커 게이트)은 접지 않은 실제 줌을 쓴다.
      final int serverZoom = MapTuning.clampForServer(zoomLevel);
      // **조회는 한 번이다**(SPEC-0029). 서버가 활성 언어의 장소만 주므로 원문을
      // 그린 뒤 번역본으로 자리를 채우던 두 번째 왕복이 사라졌다.
      final MapViewportResult result = await ref.read(
        mapViewportProvider(bbox, serverZoom).future,
      );
      if (!mounted || generation != _markerGeneration) return;

      // **마커는 controller가 소유한다.** 조회 결과로 통째로 갈아 끼우지 않고 보태는
      // 방식이라, 지도를 옮겨도 보고 있던 장소가 사라졌다 나타나지 않는다.
      // **화면 영역을 넘긴다.** 조회는 그보다 넓게 하지만, 마커를 고르는 기준은
      // 사용자가 보고 있는 곳이어야 한다 — 조회 영역으로 격자를 나누면 칸 대부분이
      // 화면 밖이라 열 개를 뽑아도 화면에는 예닐곱만 남는다.
      ref
          .read(mapMarkerControllerProvider.notifier)
          .absorb(result, visible, replaceShown: replaceShown);

      // 여기까지 왔을 때만 "받아 뒀다"로 기록한다 — 실패했는데 기록하면 재조회가
      // 영영 막힌다.
      _lastMarkerArea = bbox;
      _lastMarkerZoom = zoomLevel;
      if (!mounted || generation != _markerGeneration) return;

      await _painter?.drawMarkers(
        markers: ref.read(mapMarkerControllerProvider),
        onMarkerTap: _onMarkerTap,
      );
      if (!mounted || generation != _markerGeneration) return;

      // **잘림 안내(R23)를 띄우지 않는다**(사용자 결정, 2026-08-10).
      //
      // 서버는 뷰포트에 걸리는 spot을 상한까지 주므로 도심에서는 `truncated`가 거의
      // 항상 참이고, 우리는 그와 별개로 스무 개만 그린다. 어느 기준으로 판정해도
      // 배너가 상시 떠 있어 안내가 아니라 방해물이 됐다.
      //
      // "더 있으니 확대하라"는 정보 자체가 이 화면에서 쓸모가 적다 — 확대하면 자연히
      // 주변 것이 보이고, 사용자는 그걸 이미 안다.
      // 혼잡도 쪽과 같은 이유로 `Object`를 받는다 — SDK가 던지는 `Error` 계열을
      // 놓치면 앱이 죽는다.
    } on Object catch (error, stackTrace) {
      // 마커 조회 실패는 화면에 알리지 않는다. 실패할 때마다 배너를 띄우면 이동
      // 중에 안내가 깜빡인다 — 다만 원인은 볼 수 있어야 한다.
      _log.w('마커 조회 실패', error: error, stackTrace: stackTrace);
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
    // `common/navigation`의 헬퍼를 쓴다 — 인자 규약이 거기 모여 있어, 직접
    // pushNamed하면 그 규약을 여기서 다시 지켜야 한다.
    //
    // **카테고리는 넘기지 않는다**(SPEC-0020). 서버가 상세를 spot 자신의 카테고리로
    // 해석하므로 인자가 사라졌다 — 마커가 실어 온 `categoryName`(=서버 `code`)은
    // 지도 위 표현에만 쓴다.
    openSpotDetail(context, id: marker.id);
  }

  /// 클러스터 탭(R22)은 없다 — 서버가 클러스터 필드를 제거했다(2026-08-10).

  /// 현재 뷰포트를 산출해 조회한다.
  ///
  /// **경계는 SDK가 주지 않는다**(설계 §2.1). `CameraPosition`은 중심과 정수 줌만
  /// 담으므로, 화면 두 모서리를 `fromScreenPoint`로 되돌려 bbox를 만든다.
  Future<void> _queryViewport(int zoomLevel) async {
    final MapBounds? visible = await _visibleBounds();
    if (visible == null || !mounted) return;

    // **혼잡도는 자동으로 따라간다.** 폴리곤은 지도의 배경 정보에 가까워 옮길 때마다
    // 갱신되는 편이 자연스럽고, 조회도 걸치는 구역만 오므로 가볍다.
    //
    // **최소 반경을 보장한 뒤 격자에 맞춘다.**
    //
    // 최소 반경(→[MapTuning.congestionMinRadiusKm])이 없으면 확대했을 때 구역
    // 중심점이 하나도 안 걸려 폴리곤이 통째로 사라지고, 격자
    // (→[MapTuning.congestionGridCell])가 없으면 캐시 키가 매번 달라져 지도를
    // 옮길 때마다 요청이 나간다. 순서가 중요하다 — 격자를 먼저 맞추면 그 뒤 반경
    // 확장이 다시 임의의 좌표를 만들어 캐시가 어긋난다.
    final int generation = ++_congestionGeneration;
    unawaited(
      _loadCongestion(
        visible
            .expanded()
            .withMinRadius(MapTuning.congestionMinRadiusKm)
            .snappedToGrid(MapTuning.congestionGridCell),
        zoomLevel,
        generation,
      ),
    );

    // **마커는 자동으로 갱신하지 않는다**(사용자 요청, 2026-08-10).
    //
    // 지도를 멈출 때마다 조회했더니 조금만 움직여도 마커가 바뀌어, 보고 있던 장소가
    // 사라지고 화면이 계속 흔들렸다. 언제 새로 받을지를 사용자가 정하게 두면 그
    // 흔들림이 없어진다 — 카카오맵·구글맵이 쓰는 "이 지역 재검색"이다.
    //
    // **화면이 비어 있으면 자동으로 받는다.**
    //
    // 버튼으로만 받게 했더니, 멀리 이동하면 마커가 하나도 없는 채로 남아 기능이
    // 죽은 것처럼 보였다(실기기 지적 — 반포까지 갔는데 화면이 텅 빔). 버튼의 취지는
    // "보고 있던 마커가 갑자기 바뀌는 것"을 막는 것이라, **보이는 게 없을 때는 그
    // 취지가 성립하지 않는다.**
    //
    // 첫 진입도 같은 경로를 탄다 — 그때도 화면이 비어 있다.
    final bool nothingVisible = !ref
        .read(mapMarkerControllerProvider)
        .any(
          (MapMarker m) =>
              m.latitude >= visible.minLat &&
              m.latitude <= visible.maxLat &&
              m.longitude >= visible.minLng &&
              m.longitude <= visible.maxLng,
        );
    if (nothingVisible) {
      await _searchMarkersHere(visible, zoomLevel);
      return;
    }

    // 옮기기 전 영역을 벗어났으면 버튼을 띄운다. 그 안이면 이미 보여 준 것으로
    // 충분하다.
    final bool moved =
        _lastMarkerArea == null ||
        !_lastMarkerArea!.contains(visible) ||
        _lastMarkerZoom != zoomLevel;
    if (moved) {
      // 이동으로 이미 띄웠으면 대기 중인 재노출 타이머는 필요 없다 — 남겨 두면
      // 5초 뒤에 같은 상태를 한 번 더 덮어쓴다.
      _searchAgainTimer?.cancel();
    }
    if (moved != _canSearchHere) {
      setState(() => _canSearchHere = moved);
    }
  }

  /// 검색창을 눌렀을 때. 기존 검색 화면을 열고, 고른 장소의 좌표로 지도를 옮긴다.
  ///
  /// **`pick=1`로 연다** — 그래야 결과를 골랐을 때 상세로 가지 않고 그 spot을
  /// 돌려주고 닫는다(`routes.dart` 주석 참조).
  ///
  /// 돌아온 값의 타입을 `TouristSpot`으로 단언하지 않는다. 그 타입은 `domain/spot`이
  /// 소유해 여기서 import하면 교차 feature 의존이 생긴다(CLAUDE.md §3) — 필요한 것은
  /// 좌표뿐이라 공용 `Coordinates`만 꺼내 쓴다.
  Future<void> _onSearchTap() async {
    final Object? picked = await context.pushNamed<Object?>(
      searchRouteName,
      queryParameters: <String, String>{'pick': '1'},
    );
    if (!mounted) return;

    final MapMarker? found = _markerOf(picked);
    if (found == null) return;

    final KakaoMapController? controller = _controller;
    if (controller == null) return;

    // **찾은 곳을 마커로 남긴다.** 이동만 하고 표시가 없으면 사용자는 검색이 제대로
    // 됐는지 알 수 없다(사용자 지적, 2026-08-10) — 지도 한복판에 아무것도 없으면
    // "여기가 그 장소인가?"를 확인할 방법이 없다.
    //
    // 화면 갱신으로 밀려나지 않도록 controller에 **고정 마커**로 넣는다.
    ref.read(mapMarkerControllerProvider.notifier).pin(found);

    // 검색으로 찾은 곳은 **충분히 확대해서** 보여 준다 — 넓게 열면 무엇을 찾았는지
    // 알 수 없다.
    await controller.moveCamera(
      CameraUpdate.newCenterPosition(
        LatLng(found.latitude, found.longitude),
        zoomLevel: MapTuning.searchResultZoom,
      ),
      animation: const CameraAnimation(500),
    );
    if (!mounted) return;

    // 옮긴 자리를 "받아 두지 않은 곳"으로 표시해, 이어지는 조회가 주변 장소를
    // 채우게 한다. 고정한 마커는 그 조회에서도 지워지지 않는다(`pin` 참조).
    _lastMarkerArea = null;

    // **여기서 한 번 그린다.**
    //
    // 앞서 "곧 덮이니 그리지 말자"고 뺐는데, 그 결과 아무도 안 그려 검색 마커가
    // 영영 안 보였다. 덮이는 문제는 `drawMarkers`의 세대 토큰이 막으므로 — 나중
    // 호출이 이기고 그 호출도 같은 목록을 그린다 — 여기서 그리는 편이 맞다.
    await _painter?.drawMarkers(
      markers: ref.read(mapMarkerControllerProvider),
      onMarkerTap: _onMarkerTap,
    );
  }

  /// 추천 지역 목록을 열고, 고른 지역으로 카메라를 옮긴다(SPEC-0015 §3).
  ///
  /// **새 카메라 이동 로직을 만들지 않는다** — 검색 결과 이동과 같은
  /// `CameraUpdate.newCenterPosition` 경로를 그대로 탄다. 옮긴 뒤의 spot 조회는
  /// SPEC-0014의 유휴 판정이 알아서 실행하므로(§3.2) 여기서 따로 조회하지 않는다.
  ///
  /// 줌은 [MapTuning.searchResultZoom] 고정이다(§3.1). 시군구 면적 편차가 커서
  /// 지역마다 맞추려면 서버가 bbox를 내려줘야 하는데 현재 계약은 대표 좌표만 준다 —
  /// 실사용에서 편차가 문제되면 `[AMEND]`로 계약에 bbox를 요청한다.
  Future<void> _onRecommendationsTap() async {
    // **지금 보고 있는 중심을 함께 넘긴다.** 추천 화면이 "내 위치 / 지도 중심"을
    // 토글하는데, 지도를 떠난 뒤에는 컨트롤러를 물어볼 수 없어 여기서 미리 읽는다.
    final KakaoMapController? mapController = _controller;
    final CameraPosition? camera = await mapController?.getCameraPosition();
    if (!mounted) return;

    final Object? picked = await context.pushNamed<Object?>(
      RegionRecommendationScreen.routeName,
      extra: camera == null
          ? null
          : Coordinates(
              latitude: camera.position.latitude,
              longitude: camera.position.longitude,
            ),
    );
    if (!mounted) return;

    // 고르지 않고 닫았으면(뒤로 가기) 지도는 그대로 둔다.
    if (picked is! Coordinates) return;

    final KakaoMapController? controller = _controller;
    if (controller == null) return;

    await controller.moveCamera(
      CameraUpdate.newCenterPosition(
        LatLng(picked.latitude, picked.longitude),
        zoomLevel: MapTuning.searchResultZoom,
      ),
      animation: const CameraAnimation(500),
    );
    if (!mounted) return;

    // 옮긴 자리를 "받아 두지 않은 곳"으로 표시해, 이어지는 유휴 조회가 그 지역의
    // 장소를 채우게 한다 — 검색 이동과 같은 처리다.
    _lastMarkerArea = null;
  }

  /// 검색 화면이 돌려준 값을 지도 마커로 옮긴다. 좌표가 없는 장소이거나 취소했으면
  /// null이다.
  ///
  /// 동적 접근을 쓰는 이유는 위 주석과 같다 — `TouristSpot`을 import하지 않는다.
  MapMarker? _markerOf(Object? picked) {
    // **타입으로 받는다.** 전에는 `dynamic`으로 필드를 읽었는데, 교차 feature
    // import를 피하려던 그 선택이 런타임에 두 번 깨졌다(`.name`이 확장 게터라
    // 동적 호출에서 없다는 오류). 컴파일러도 테스트도 못 잡는 자리라, 두 기능이
    // 함께 쓰는 값 객체를 `common/`에 두는 쪽으로 바꿨다.
    if (picked is! PickedPlace) return null;

    return MapMarker(
      id: picked.id,
      name: picked.name,
      latitude: picked.coordinates.latitude,
      longitude: picked.coordinates.longitude,
      kind: MapMarkerKind.spot,
      categoryName: picked.categoryName,
      // 검색으로 찾은 곳이라 강조한다 — 마커가 여럿일 때 어느 것이 그것인지
      // 한눈에 갈려야 한다.
      isHighlighted: true,
      // **썸네일이 있어야 사진 마커가 된다** — 없으면 종류별 도형으로 떨어진다.
      thumbnailUrl: picked.thumbnailUrl,
    );
  }

  /// "이 지역 재검색"을 눌렀을 때. 지금 화면을 다시 산출해 그 지역을 조회한다.
  Future<void> _onSearchThisArea() async {
    final KakaoMapController? controller = _controller;
    if (controller == null) return;

    final MapBounds? visible = await _visibleBounds();
    if (visible == null || !mounted) return;

    final CameraPosition position = await controller.getCameraPosition();
    if (!mounted) return;

    await _searchMarkersHere(visible, position.zoomLevel, replaceShown: true);
  }

  /// 지금 보고 있는 지역의 마커를 받는다. 첫 진입과 "이 지역 재검색" 버튼이 부른다.
  ///
  /// [replaceShown]은 버튼으로 부를 때만 참이다 — 같은 자리에서 눌렀는데 화면이
  /// 그대로면 버튼이 동작하지 않는 것으로 보이므로, 그때는 화면 안의 마커를 다른
  /// 장소로 갈아 준다.
  Future<void> _searchMarkersHere(
    MapBounds visible,
    int zoomLevel, {
    bool replaceShown = false,
  }) async {
    if (_isSearchingArea) return;
    // 조회를 시작하면 대기 중인 재노출 타이머는 의미가 없다.
    _searchAgainTimer?.cancel();
    setState(() => _isSearchingArea = true);

    try {
      // 화면보다 조금 넓게 받아, 살짝 밀었을 때 가장자리가 비지 않게 한다(R20).
      await _loadMarkers(
        visible.expanded(),
        visible,
        zoomLevel,
        ++_markerGeneration,
        replaceShown: replaceShown,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSearchingArea = false;
          _canSearchHere = false;
        });

        // 같은 자리에 머물러도 잠시 뒤 다시 눌러 볼 수 있게 한다(사용자 요청).
        // 마커 상한에 걸려 못 들어온 장소가 그때 들어온다.
        _searchAgainTimer = Timer(MapTuning.searchAgainDelay, () {
          if (mounted && !_isSearchingArea) {
            setState(() => _canSearchHere = true);
          }
        });
      }
    }
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

    // 카테고리 최초 상태는 "전체"다(사용자 결정, 2026-08-15) — 다른 화면과 같은
    // 규칙이라 심는 것이 없다.

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

    // 지도를 **사용자가 있는 곳**에서 연다. 위치를 얻는 동안에는 지도를 만들지
    // 않는다 — 임의의 위치로 띄웠다가 옮기면 화면이 튀고, 그 사이 유휴 조회가 한 번
    // 헛돈다.
    //
    // 위치를 못 얻으면(권한 거부·GPS 꺼짐) 서울에서 연다. 이 앱은 한국 관광이 대상이고
    // 혼잡도 121곳이 전부 서울이라, 아무 데도 못 열어 빈 화면을 주는 것보다 낫다.
    //
    // **`watch`가 아니라 한 번 잡고 고정한다.** watch로 두면 조회가 setState를
    // 부를 때마다 build가 돌고, 그때 위치 provider가 재평가되며 또 조회가 나가
    // 통신이 멈추지 않았다(실기기에서 관측). 초기 위치는 진입 시 한 번만 필요하다.
    if (_origin == null) {
      final AsyncValue<Coordinates> location = ref.watch(
        currentCoordinatesProvider,
      );
      if (location.isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      _origin = location.value ?? _seoulFallback;
    }
    final Coordinates origin = _origin!;

    // **실시간 내 위치**(사용자 요청, 2026-08-11). 카카오맵·네이버지도처럼 걸으면
    // 파란 점이 따라 움직인다.
    //
    // `watch`가 아니라 `listen`인 이유는, 이 값이 **위젯 트리에 아무것도 그리지
    // 않기 때문**이다 — 점은 SDK가 지도 위에 직접 찍는다. watch로 두면 좌표가 올
    // 때마다(5m마다) build가 통째로 다시 돌고, 그 build가 `_origin`을 다시 읽고
    // 오버레이를 다시 배치한다. 이 화면에서 build를 위치에 묶었다가 조회가 멈추지
    // 않는 순환을 만든 적이 있어(→[_origin] 주석) 같은 실수를 반복하지 않는다.
    //
    // 구독은 화면이 사라질 때 자동으로 끊기고, 유일한 구독자가 없어지면
    // `liveCoordinatesProvider`(autoDispose)가 GPS 스트림을 닫는다.
    ref.listen<AsyncValue<Coordinates>>(liveCoordinatesProvider, (
      AsyncValue<Coordinates>? _,
      AsyncValue<Coordinates> next,
    ) {
      next.when(
        data: (Coordinates where) => unawaited(
          _painter?.drawMyLocation(where.latitude, where.longitude) ??
              Future<void>.value(),
        ),
        // 권한 거부·위치 꺼짐. **점을 감춘다** — 마지막 좌표를 남겨 두면 사용자가
        // 아직 거기 있는 것으로 읽힌다. 안내는 띄우지 않는다: 위치 버튼을 눌렀을
        // 때와 달리 사용자가 요청한 적이 없어, 지도를 볼 때마다 스낵바가 뜨면
        // 방해가 된다.
        error: (Object error, StackTrace stack) =>
            unawaited(_painter?.hideMyLocation() ?? Future<void>.value()),
        loading: () {},
      );
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          KakaoMap(
            option: KakaoMapOption(
              position: LatLng(origin.latitude, origin.longitude),
              zoomLevel: MapTuning.initialZoom,
            ),
            // 지도판을 탭하면 선택을 푼다 — 말풍선을 닫는 자연스러운 방법이다.
            onTerrainClick: (KPoint _, LatLng position) =>
                _onTerrainTap(position),
            onMapReady: (KakaoMapController controller) {
              _controller = controller;
              final MapOverlayPainter painter = MapOverlayPainter(controller);
              _painter = painter;

              // **지도가 준비되기 전에 온 좌표를 여기서 한 번 그린다.**
              //
              // 위치 스트림은 build에서 바로 구독되는데 `_painter`는 이 콜백에서야
              // 생긴다. 그 사이에 도착한 좌표는 그릴 곳이 없어 버려지고, GPS가
              // 조용하면(가만히 서 있으면 distanceFilter 5m에 걸려 다음 값이 한참
              // 안 온다) 점이 영영 안 나타난다.
              final Coordinates? known = ref
                  .read(liveCoordinatesProvider)
                  .value;
              if (known != null) {
                unawaited(
                  painter.drawMyLocation(known.latitude, known.longitude),
                );
              }

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
          // **하단 인셋을 직접 더한다.** 셸이 네비 바를 `SafeArea` 바깥에 두므로
          // (`floating_bottom_nav_scaffold.dart`), 바가 실제로 차지하는 높이는
          // `barExtent + 하단 인셋`이다. `SafeArea`로 감싸면 Stack 안에서 인셋이
          // 이중으로 먹어 버튼이 화면 중앙까지 떠오르고, 빼면 바에 가린다.
          // **세로 중앙에 붙인다**(사용자 요청, 2026-08-10). 하단 기준으로 띄웠더니
          // 기기 높이에 따라 위치가 흔들렸고, 네비에 가까워 오조작도 났다. 중앙이면
          // 어느 기기에서나 같은 자리이고 엄지도 닿는다.
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Column(
              // `min`을 두면 Column이 내용만큼만 차지해 중앙 정렬이 먹지 않는다.
              mainAxisAlignment: MainAxisAlignment.center,
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
                // 추천 지역 진입(SPEC-0015). **여기에 두는 이유**: 이 화면에는 앱바가
                // 없고, 상단은 검색창과 재검색 버튼이, 좌상단은 혼잡도 범례가 이미
                // 쓰고 있다. 남는 자리는 이 컨트롤 열뿐이고, 셋 다 "지도를 어디로 볼
                // 것인가"를 다루는 조작이라 한 그룹으로 읽혀도 어색하지 않다.
                const SizedBox(height: 12),
                RegionRecommendationButton(onPressed: _onRecommendationsTap),
              ],
            ),
          ),
          // 상단 오버레이. **하나의 세로 흐름으로 쌓는다** — 배너와 범례를 각각
          // Positioned로 두면 고정 오프셋이 어긋나 서로 덮는다.
          //
          // 순서는 혼잡도 실패 → 잘림 → 범례다. 잘림은 "더 볼 게 있다"는 신호에
          // 가깝고 레이어 실패는 기능 제한이라 먼저 알려야 한다(디자인 §6).
          Positioned(
            top: 0,
            left: 12,
            right: 12,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 검색창. 누르면 기존 검색 화면으로 보낸다 — 지도에서 입력을 받지
                  // 않는 이유는 컴포넌트 주석 참조.
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: MapSearchBar(onTap: _onSearchTap),
                  ),
                  // **혼잡도 실패는 배너로 알리지 않는다**(사용자 결정, 2026-08-12).
                  //
                  // 부가 데이터라 없어도 지도는 제 역할을 다 하고, 사용자가 할 수
                  // 있는 일도 없다 — 알려 봐야 검색창 아래 자리만 차지한다. 폴리곤과
                  // 범례가 조용히 빠지는 것으로 충분하다(그 판정은 아래
                  // `_showsCongestionLayer`가 쥔다).
                  // **범례를 검색창 바로 아래 고정한다.**
                  //
                  // 재검색 버튼과 같은 흐름에 두었더니 버튼이 뜰 때마다 범례가 아래로
                  // 밀려 구조가 흔들렸다(실기기 지적). 범례는 늘 같은 자리에 있어야
                  // 눈이 찾기 쉽고, 버튼은 그 아래 가운데에서 따로 뜬다.
                  //
                  // 색이 실제로 그려질 때만 띄운다 — 판정은 레이어 상태 하나가 쥔다.
                  if (_showsCongestionLayer)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: CongestionLegend(),
                      ),
                    ),
                  // 잘림 안내와 마커 종류 범례는 두지 않는다(사용자 결정,
                  // 2026-08-10) — 사진 마커가 어떤 장소인지 이미 보여 주고, 배너는
                  // 상시 떠 있어 방해만 됐다.
                ],
              ),
            ),
          ),
          // "이 지역 재검색"(새로고침). **우상단**, 검색창 바로 아래에 둔다
          //(사용자 요청, 2026-08-10).
          //
          // 하단 중앙에 알약으로 띄웠더니 시선을 뺏고 지도를 가렸다. 우상단은 범례
          // (좌측)와 겹치지 않고, 새로고침이 널리 통하는 기호라 아이콘만으로 충분하다.
          if (_canSearchHere || _isSearchingArea)
            Positioned(
              right: 12,
              top: 0,
              child: SafeArea(
                child: Padding(
                  // 검색창(높이 약 46 + 위 여백 8)과 **카테고리 바**(높이 48 + 위
                  // 여백 8) 아래로 내린다. 값이 상단 Column의 구성과 묶여 있으므로
                  // 둘 중 하나를 바꾸면 여기도 함께 봐야 한다(SPEC-0020 R7).
                  padding: const EdgeInsets.only(top: _searchThisAreaTop),
                  child: SearchThisAreaButton(
                    isSearching: _isSearchingArea,
                    onPressed: _onSearchThisArea,
                  ),
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
          // 출처 표기(R30)는 **범례 안에 있다**(`congestion_legend.dart`). 지도
          // 한복판에 텍스트만 떠 있는 것이 어색해 범례와 한 덩어리로 묶었다.
          //
          // 구역 정보 말풍선(R27·R28). 선택했을 때만 뜬다.
          if (_selectedArea case final CongestionArea area)
            Positioned(
              left: 12,
              right: 12,
              bottom: _bottomInset(context) + 40,
              child: AreaInfoCard(
                area: area,
                onClose: () => setState(() => _selectedArea = null),
              ),
            ),
        ],
      ),
    );
  }
}

/// 현재 위치를 얻지 못했을 때만 쓰는 폴백(서울시청).
///
/// **평소에는 쓰이지 않는다** — 지도는 `currentCoordinatesProvider`가 주는 사용자
/// 위치에서 연다. 권한 거부·GPS 꺼짐으로 좌표가 없을 때, 빈 화면을 주는 대신 여기서
/// 연다. 서울인 이유는 혼잡도 121곳이 전부 서울이라 기능이 바로 드러나기 때문이다.
const Coordinates _seoulFallback = Coordinates(
  latitude: 37.5663,
  longitude: 126.9779,
);
