// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [LocationService]를 노출한다. 위젯·다른 provider는 직접 생성하지 않고 이 provider를
/// 통해 접근하며(CLAUDE.md §5), 테스트는 이 한 provider만 오버라이드해 페이크를 주입한다.

@ProviderFor(locationService)
const locationServiceProvider = LocationServiceProvider._();

/// [LocationService]를 노출한다. 위젯·다른 provider는 직접 생성하지 않고 이 provider를
/// 통해 접근하며(CLAUDE.md §5), 테스트는 이 한 provider만 오버라이드해 페이크를 주입한다.

final class LocationServiceProvider
    extends
        $FunctionalProvider<LocationService, LocationService, LocationService>
    with $Provider<LocationService> {
  /// [LocationService]를 노출한다. 위젯·다른 provider는 직접 생성하지 않고 이 provider를
  /// 통해 접근하며(CLAUDE.md §5), 테스트는 이 한 provider만 오버라이드해 페이크를 주입한다.
  const LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'a488c9fe9af45a674a1261fa284a2749723adb24';

/// 디바이스 현재 좌표(SPEC-0002 spots 쿼리 입력). 위치를 얻지 못하면 오류
/// `AsyncValue`가 되어 SPEC-0001 권한 안내/설정 이동 흐름으로 이어진다.
///
/// keepAlive 아님(codegen 기본): 화면을 벗어나면 폐기되고 다시 진입하면 최신 좌표를
/// 다시 얻는다.

@ProviderFor(currentCoordinates)
const currentCoordinatesProvider = CurrentCoordinatesProvider._();

/// 디바이스 현재 좌표(SPEC-0002 spots 쿼리 입력). 위치를 얻지 못하면 오류
/// `AsyncValue`가 되어 SPEC-0001 권한 안내/설정 이동 흐름으로 이어진다.
///
/// keepAlive 아님(codegen 기본): 화면을 벗어나면 폐기되고 다시 진입하면 최신 좌표를
/// 다시 얻는다.

final class CurrentCoordinatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Coordinates>,
          Coordinates,
          FutureOr<Coordinates>
        >
    with $FutureModifier<Coordinates>, $FutureProvider<Coordinates> {
  /// 디바이스 현재 좌표(SPEC-0002 spots 쿼리 입력). 위치를 얻지 못하면 오류
  /// `AsyncValue`가 되어 SPEC-0001 권한 안내/설정 이동 흐름으로 이어진다.
  ///
  /// keepAlive 아님(codegen 기본): 화면을 벗어나면 폐기되고 다시 진입하면 최신 좌표를
  /// 다시 얻는다.
  const CurrentCoordinatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentCoordinatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentCoordinatesHash();

  @$internal
  @override
  $FutureProviderElement<Coordinates> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Coordinates> create(Ref ref) {
    return currentCoordinates(ref);
  }
}

String _$currentCoordinatesHash() =>
    r'1e17d77e928708bb5ee93a16c860fe351b37e043';
