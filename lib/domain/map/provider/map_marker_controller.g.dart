// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_marker_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 지도에 떠 있는 마커를 소유한다.
///
/// **화면이 아니라 provider가 마커를 들고 있는 이유**: 지도를 옮길 때마다 마커를
/// 통째로 갈아 끼우면 이미 보고 있던 장소가 사라졌다 다시 나타나 화면이 깜빡인다.
/// 여기서 누적해 두면 지도를 움직여도 **이전 마커가 살아남는다**.
///
/// **`keepAlive`다.** 지도에서 검색 화면으로 넘어가는 동안 화면이 잠시 사라지는데,
/// autoDispose면 그때 provider가 폐기되어 마커가 통째로 비워진다 — 검색하고 돌아오면
/// 고정한 마커 하나만 남고 나머지가 사라졌다(실측: "고정: 삼성 강남 (총 1개)").
///
/// 지도 탭을 벗어나도 유지되지만, 다시 들어오면 그 위치를 조회해 채우므로 낡은 마커가
/// 오래 남지는 않는다.

@ProviderFor(MapMarkerController)
const mapMarkerControllerProvider = MapMarkerControllerProvider._();

/// 지도에 떠 있는 마커를 소유한다.
///
/// **화면이 아니라 provider가 마커를 들고 있는 이유**: 지도를 옮길 때마다 마커를
/// 통째로 갈아 끼우면 이미 보고 있던 장소가 사라졌다 다시 나타나 화면이 깜빡인다.
/// 여기서 누적해 두면 지도를 움직여도 **이전 마커가 살아남는다**.
///
/// **`keepAlive`다.** 지도에서 검색 화면으로 넘어가는 동안 화면이 잠시 사라지는데,
/// autoDispose면 그때 provider가 폐기되어 마커가 통째로 비워진다 — 검색하고 돌아오면
/// 고정한 마커 하나만 남고 나머지가 사라졌다(실측: "고정: 삼성 강남 (총 1개)").
///
/// 지도 탭을 벗어나도 유지되지만, 다시 들어오면 그 위치를 조회해 채우므로 낡은 마커가
/// 오래 남지는 않는다.
final class MapMarkerControllerProvider
    extends $NotifierProvider<MapMarkerController, List<MapMarker>> {
  /// 지도에 떠 있는 마커를 소유한다.
  ///
  /// **화면이 아니라 provider가 마커를 들고 있는 이유**: 지도를 옮길 때마다 마커를
  /// 통째로 갈아 끼우면 이미 보고 있던 장소가 사라졌다 다시 나타나 화면이 깜빡인다.
  /// 여기서 누적해 두면 지도를 움직여도 **이전 마커가 살아남는다**.
  ///
  /// **`keepAlive`다.** 지도에서 검색 화면으로 넘어가는 동안 화면이 잠시 사라지는데,
  /// autoDispose면 그때 provider가 폐기되어 마커가 통째로 비워진다 — 검색하고 돌아오면
  /// 고정한 마커 하나만 남고 나머지가 사라졌다(실측: "고정: 삼성 강남 (총 1개)").
  ///
  /// 지도 탭을 벗어나도 유지되지만, 다시 들어오면 그 위치를 조회해 채우므로 낡은 마커가
  /// 오래 남지는 않는다.
  const MapMarkerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapMarkerControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapMarkerControllerHash();

  @$internal
  @override
  MapMarkerController create() => MapMarkerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MapMarker> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MapMarker>>(value),
    );
  }
}

String _$mapMarkerControllerHash() =>
    r'53bacdaf724798f1cc901bbbb4e0330dd97f76d2';

/// 지도에 떠 있는 마커를 소유한다.
///
/// **화면이 아니라 provider가 마커를 들고 있는 이유**: 지도를 옮길 때마다 마커를
/// 통째로 갈아 끼우면 이미 보고 있던 장소가 사라졌다 다시 나타나 화면이 깜빡인다.
/// 여기서 누적해 두면 지도를 움직여도 **이전 마커가 살아남는다**.
///
/// **`keepAlive`다.** 지도에서 검색 화면으로 넘어가는 동안 화면이 잠시 사라지는데,
/// autoDispose면 그때 provider가 폐기되어 마커가 통째로 비워진다 — 검색하고 돌아오면
/// 고정한 마커 하나만 남고 나머지가 사라졌다(실측: "고정: 삼성 강남 (총 1개)").
///
/// 지도 탭을 벗어나도 유지되지만, 다시 들어오면 그 위치를 조회해 채우므로 낡은 마커가
/// 오래 남지는 않는다.

abstract class _$MapMarkerController extends $Notifier<List<MapMarker>> {
  List<MapMarker> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<MapMarker>, List<MapMarker>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MapMarker>, List<MapMarker>>,
              List<MapMarker>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
