// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mapRepository)
const mapRepositoryProvider = MapRepositoryProvider._();

final class MapRepositoryProvider
    extends $FunctionalProvider<MapRepository, MapRepository, MapRepository>
    with $Provider<MapRepository> {
  const MapRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapRepositoryHash();

  @$internal
  @override
  $ProviderElement<MapRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapRepository create(Ref ref) {
    return mapRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapRepository>(value),
    );
  }
}

String _$mapRepositoryHash() => r'ebd1feef5797a36458540e43a75a28142ac397fa';

/// 뷰포트 안의 마커·클러스터(R1·R2·R3·R12).
///
/// **혼잡도와 별도 provider다**(설계 §6.3). 하나로 묶으면 혼잡도 실패가 마커까지
/// 끌고 내려가 R29를 어긴다 — 지도는 혼잡도가 죽어도 정상 동작해야 한다.
///
/// bbox와 zoom을 인자로 받아 family가 된다. 뷰포트가 바뀌면 새 인자가 되므로 이전
/// 조회는 자동으로 버려진다 — 늦게 도착한 응답이 현재 뷰포트를 덮어쓰지 않는다
/// (설계 §3.3).
/// [hasOrigin]은 원문/번역 구분이다(SPEC-0019). 화면은 원문으로 마커를 채우고 자리가
/// 남으면 번역본으로 한 번 더 채운다 — 두 값이 서로 다른 family 인스턴스가 된다.
/// **카테고리 필터를 받지 않는다**(사용자 결정, 2026-08-16). 서버 인자는 있지만
/// 지도는 오버레이가 가장 많은 화면이라 바를 하나 더 얹으면 가독성이 떨어진다.

@ProviderFor(mapViewport)
const mapViewportProvider = MapViewportFamily._();

/// 뷰포트 안의 마커·클러스터(R1·R2·R3·R12).
///
/// **혼잡도와 별도 provider다**(설계 §6.3). 하나로 묶으면 혼잡도 실패가 마커까지
/// 끌고 내려가 R29를 어긴다 — 지도는 혼잡도가 죽어도 정상 동작해야 한다.
///
/// bbox와 zoom을 인자로 받아 family가 된다. 뷰포트가 바뀌면 새 인자가 되므로 이전
/// 조회는 자동으로 버려진다 — 늦게 도착한 응답이 현재 뷰포트를 덮어쓰지 않는다
/// (설계 §3.3).
/// [hasOrigin]은 원문/번역 구분이다(SPEC-0019). 화면은 원문으로 마커를 채우고 자리가
/// 남으면 번역본으로 한 번 더 채운다 — 두 값이 서로 다른 family 인스턴스가 된다.
/// **카테고리 필터를 받지 않는다**(사용자 결정, 2026-08-16). 서버 인자는 있지만
/// 지도는 오버레이가 가장 많은 화면이라 바를 하나 더 얹으면 가독성이 떨어진다.

final class MapViewportProvider
    extends
        $FunctionalProvider<
          AsyncValue<MapViewportResult>,
          MapViewportResult,
          FutureOr<MapViewportResult>
        >
    with
        $FutureModifier<MapViewportResult>,
        $FutureProvider<MapViewportResult> {
  /// 뷰포트 안의 마커·클러스터(R1·R2·R3·R12).
  ///
  /// **혼잡도와 별도 provider다**(설계 §6.3). 하나로 묶으면 혼잡도 실패가 마커까지
  /// 끌고 내려가 R29를 어긴다 — 지도는 혼잡도가 죽어도 정상 동작해야 한다.
  ///
  /// bbox와 zoom을 인자로 받아 family가 된다. 뷰포트가 바뀌면 새 인자가 되므로 이전
  /// 조회는 자동으로 버려진다 — 늦게 도착한 응답이 현재 뷰포트를 덮어쓰지 않는다
  /// (설계 §3.3).
  /// [hasOrigin]은 원문/번역 구분이다(SPEC-0019). 화면은 원문으로 마커를 채우고 자리가
  /// 남으면 번역본으로 한 번 더 채운다 — 두 값이 서로 다른 family 인스턴스가 된다.
  /// **카테고리 필터를 받지 않는다**(사용자 결정, 2026-08-16). 서버 인자는 있지만
  /// 지도는 오버레이가 가장 많은 화면이라 바를 하나 더 얹으면 가독성이 떨어진다.
  const MapViewportProvider._({
    required MapViewportFamily super.from,
    required (MapBounds, int, {bool? hasOrigin}) super.argument,
  }) : super(
         retry: null,
         name: r'mapViewportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mapViewportHash();

  @override
  String toString() {
    return r'mapViewportProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<MapViewportResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MapViewportResult> create(Ref ref) {
    final argument = this.argument as (MapBounds, int, {bool? hasOrigin});
    return mapViewport(
      ref,
      argument.$1,
      argument.$2,
      hasOrigin: argument.hasOrigin,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MapViewportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mapViewportHash() => r'cd68ff20f411cccd64c4c450e18efde70074ba5f';

/// 뷰포트 안의 마커·클러스터(R1·R2·R3·R12).
///
/// **혼잡도와 별도 provider다**(설계 §6.3). 하나로 묶으면 혼잡도 실패가 마커까지
/// 끌고 내려가 R29를 어긴다 — 지도는 혼잡도가 죽어도 정상 동작해야 한다.
///
/// bbox와 zoom을 인자로 받아 family가 된다. 뷰포트가 바뀌면 새 인자가 되므로 이전
/// 조회는 자동으로 버려진다 — 늦게 도착한 응답이 현재 뷰포트를 덮어쓰지 않는다
/// (설계 §3.3).
/// [hasOrigin]은 원문/번역 구분이다(SPEC-0019). 화면은 원문으로 마커를 채우고 자리가
/// 남으면 번역본으로 한 번 더 채운다 — 두 값이 서로 다른 family 인스턴스가 된다.
/// **카테고리 필터를 받지 않는다**(사용자 결정, 2026-08-16). 서버 인자는 있지만
/// 지도는 오버레이가 가장 많은 화면이라 바를 하나 더 얹으면 가독성이 떨어진다.

final class MapViewportFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<MapViewportResult>,
          (MapBounds, int, {bool? hasOrigin})
        > {
  const MapViewportFamily._()
    : super(
        retry: null,
        name: r'mapViewportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 뷰포트 안의 마커·클러스터(R1·R2·R3·R12).
  ///
  /// **혼잡도와 별도 provider다**(설계 §6.3). 하나로 묶으면 혼잡도 실패가 마커까지
  /// 끌고 내려가 R29를 어긴다 — 지도는 혼잡도가 죽어도 정상 동작해야 한다.
  ///
  /// bbox와 zoom을 인자로 받아 family가 된다. 뷰포트가 바뀌면 새 인자가 되므로 이전
  /// 조회는 자동으로 버려진다 — 늦게 도착한 응답이 현재 뷰포트를 덮어쓰지 않는다
  /// (설계 §3.3).
  /// [hasOrigin]은 원문/번역 구분이다(SPEC-0019). 화면은 원문으로 마커를 채우고 자리가
  /// 남으면 번역본으로 한 번 더 채운다 — 두 값이 서로 다른 family 인스턴스가 된다.
  /// **카테고리 필터를 받지 않는다**(사용자 결정, 2026-08-16). 서버 인자는 있지만
  /// 지도는 오버레이가 가장 많은 화면이라 바를 하나 더 얹으면 가독성이 떨어진다.

  MapViewportProvider call(MapBounds bbox, int zoom, {bool? hasOrigin}) =>
      MapViewportProvider._(
        argument: (bbox, zoom, hasOrigin: hasOrigin),
        from: this,
      );

  @override
  String toString() => r'mapViewportProvider';
}

/// 뷰포트에 걸치는 구역의 실시간 혼잡도(R6~R11).
///
/// **줌 게이트를 통과했을 때만 이 provider를 watch한다**(R25). 게이트 미만에서
/// 호출하지 않는 것이 일일 쿼터 1000건을 지키는 실질적 장치다(설계 §5.1) —
/// 게이트를 렌더링에만 두면 의미가 없다.

@ProviderFor(seoulCongestion)
const seoulCongestionProvider = SeoulCongestionFamily._();

/// 뷰포트에 걸치는 구역의 실시간 혼잡도(R6~R11).
///
/// **줌 게이트를 통과했을 때만 이 provider를 watch한다**(R25). 게이트 미만에서
/// 호출하지 않는 것이 일일 쿼터 1000건을 지키는 실질적 장치다(설계 §5.1) —
/// 게이트를 렌더링에만 두면 의미가 없다.

final class SeoulCongestionProvider
    extends
        $FunctionalProvider<
          AsyncValue<SeoulCongestionResult>,
          SeoulCongestionResult,
          FutureOr<SeoulCongestionResult>
        >
    with
        $FutureModifier<SeoulCongestionResult>,
        $FutureProvider<SeoulCongestionResult> {
  /// 뷰포트에 걸치는 구역의 실시간 혼잡도(R6~R11).
  ///
  /// **줌 게이트를 통과했을 때만 이 provider를 watch한다**(R25). 게이트 미만에서
  /// 호출하지 않는 것이 일일 쿼터 1000건을 지키는 실질적 장치다(설계 §5.1) —
  /// 게이트를 렌더링에만 두면 의미가 없다.
  const SeoulCongestionProvider._({
    required SeoulCongestionFamily super.from,
    required MapBounds super.argument,
  }) : super(
         retry: null,
         name: r'seoulCongestionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seoulCongestionHash();

  @override
  String toString() {
    return r'seoulCongestionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SeoulCongestionResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SeoulCongestionResult> create(Ref ref) {
    final argument = this.argument as MapBounds;
    return seoulCongestion(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeoulCongestionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seoulCongestionHash() => r'4aad3320ba4730f1d057f990278a616cf65ee38a';

/// 뷰포트에 걸치는 구역의 실시간 혼잡도(R6~R11).
///
/// **줌 게이트를 통과했을 때만 이 provider를 watch한다**(R25). 게이트 미만에서
/// 호출하지 않는 것이 일일 쿼터 1000건을 지키는 실질적 장치다(설계 §5.1) —
/// 게이트를 렌더링에만 두면 의미가 없다.

final class SeoulCongestionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SeoulCongestionResult>, MapBounds> {
  const SeoulCongestionFamily._()
    : super(
        retry: null,
        name: r'seoulCongestionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 뷰포트에 걸치는 구역의 실시간 혼잡도(R6~R11).
  ///
  /// **줌 게이트를 통과했을 때만 이 provider를 watch한다**(R25). 게이트 미만에서
  /// 호출하지 않는 것이 일일 쿼터 1000건을 지키는 실질적 장치다(설계 §5.1) —
  /// 게이트를 렌더링에만 두면 의미가 없다.

  SeoulCongestionProvider call(MapBounds bbox) =>
      SeoulCongestionProvider._(argument: bbox, from: this);

  @override
  String toString() => r'seoulCongestionProvider';
}

/// 121곳의 정적 폴리곤 경계(R17·R26).
///
/// **앱 수명 동안 유지한다**(`keepAlive`). 경계는 서울시가 구역을 재획정하지 않는 한
/// 바뀌지 않는데, 121개 폴리곤을 지도에 들어올 때마다 다시 받는 것은 낭비다
/// (spec §7.3).
///
/// **언어를 인자로 받아 캐시 키에 포함한다**(R31). 구역명이 활성 언어로 오므로,
/// 언어를 무시하고 캐싱하면 설정에서 언어를 바꿔도 이전 언어 이름이 그대로 남는다
/// (설계 §5.2). 언어별로 따로 보관되고, 전환하면 그 언어의 캐시가 새로 채워진다.
///
/// 좌표만 공유하고 이름만 다시 받는 방식도 가능하지만, 121건 한 번의 왕복이라
/// 복잡도를 더할 이득이 없다.

@ProviderFor(congestionBoundaries)
const congestionBoundariesProvider = CongestionBoundariesFamily._();

/// 121곳의 정적 폴리곤 경계(R17·R26).
///
/// **앱 수명 동안 유지한다**(`keepAlive`). 경계는 서울시가 구역을 재획정하지 않는 한
/// 바뀌지 않는데, 121개 폴리곤을 지도에 들어올 때마다 다시 받는 것은 낭비다
/// (spec §7.3).
///
/// **언어를 인자로 받아 캐시 키에 포함한다**(R31). 구역명이 활성 언어로 오므로,
/// 언어를 무시하고 캐싱하면 설정에서 언어를 바꿔도 이전 언어 이름이 그대로 남는다
/// (설계 §5.2). 언어별로 따로 보관되고, 전환하면 그 언어의 캐시가 새로 채워진다.
///
/// 좌표만 공유하고 이름만 다시 받는 방식도 가능하지만, 121건 한 번의 왕복이라
/// 복잡도를 더할 이득이 없다.

final class CongestionBoundariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CongestionAreaBoundary>>,
          List<CongestionAreaBoundary>,
          FutureOr<List<CongestionAreaBoundary>>
        >
    with
        $FutureModifier<List<CongestionAreaBoundary>>,
        $FutureProvider<List<CongestionAreaBoundary>> {
  /// 121곳의 정적 폴리곤 경계(R17·R26).
  ///
  /// **앱 수명 동안 유지한다**(`keepAlive`). 경계는 서울시가 구역을 재획정하지 않는 한
  /// 바뀌지 않는데, 121개 폴리곤을 지도에 들어올 때마다 다시 받는 것은 낭비다
  /// (spec §7.3).
  ///
  /// **언어를 인자로 받아 캐시 키에 포함한다**(R31). 구역명이 활성 언어로 오므로,
  /// 언어를 무시하고 캐싱하면 설정에서 언어를 바꿔도 이전 언어 이름이 그대로 남는다
  /// (설계 §5.2). 언어별로 따로 보관되고, 전환하면 그 언어의 캐시가 새로 채워진다.
  ///
  /// 좌표만 공유하고 이름만 다시 받는 방식도 가능하지만, 121건 한 번의 왕복이라
  /// 복잡도를 더할 이득이 없다.
  const CongestionBoundariesProvider._({
    required CongestionBoundariesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'congestionBoundariesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$congestionBoundariesHash();

  @override
  String toString() {
    return r'congestionBoundariesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CongestionAreaBoundary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CongestionAreaBoundary>> create(Ref ref) {
    final argument = this.argument as String;
    return congestionBoundaries(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CongestionBoundariesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$congestionBoundariesHash() =>
    r'6f6a893f5a0c73a185b0abb93cec6a4a3c17577b';

/// 121곳의 정적 폴리곤 경계(R17·R26).
///
/// **앱 수명 동안 유지한다**(`keepAlive`). 경계는 서울시가 구역을 재획정하지 않는 한
/// 바뀌지 않는데, 121개 폴리곤을 지도에 들어올 때마다 다시 받는 것은 낭비다
/// (spec §7.3).
///
/// **언어를 인자로 받아 캐시 키에 포함한다**(R31). 구역명이 활성 언어로 오므로,
/// 언어를 무시하고 캐싱하면 설정에서 언어를 바꿔도 이전 언어 이름이 그대로 남는다
/// (설계 §5.2). 언어별로 따로 보관되고, 전환하면 그 언어의 캐시가 새로 채워진다.
///
/// 좌표만 공유하고 이름만 다시 받는 방식도 가능하지만, 121건 한 번의 왕복이라
/// 복잡도를 더할 이득이 없다.

final class CongestionBoundariesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<CongestionAreaBoundary>>,
          String
        > {
  const CongestionBoundariesFamily._()
    : super(
        retry: null,
        name: r'congestionBoundariesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 121곳의 정적 폴리곤 경계(R17·R26).
  ///
  /// **앱 수명 동안 유지한다**(`keepAlive`). 경계는 서울시가 구역을 재획정하지 않는 한
  /// 바뀌지 않는데, 121개 폴리곤을 지도에 들어올 때마다 다시 받는 것은 낭비다
  /// (spec §7.3).
  ///
  /// **언어를 인자로 받아 캐시 키에 포함한다**(R31). 구역명이 활성 언어로 오므로,
  /// 언어를 무시하고 캐싱하면 설정에서 언어를 바꿔도 이전 언어 이름이 그대로 남는다
  /// (설계 §5.2). 언어별로 따로 보관되고, 전환하면 그 언어의 캐시가 새로 채워진다.
  ///
  /// 좌표만 공유하고 이름만 다시 받는 방식도 가능하지만, 121건 한 번의 왕복이라
  /// 복잡도를 더할 이득이 없다.

  CongestionBoundariesProvider call(String languageTag) =>
      CongestionBoundariesProvider._(argument: languageTag, from: this);

  @override
  String toString() => r'congestionBoundariesProvider';
}

/// 현재 활성 언어로 경계를 조회한다. 화면은 이 provider만 보면 된다 — 언어가 바뀌면
/// 인자가 바뀌어 자동으로 새 캐시를 탄다.

@ProviderFor(currentCongestionBoundaries)
const currentCongestionBoundariesProvider =
    CurrentCongestionBoundariesProvider._();

/// 현재 활성 언어로 경계를 조회한다. 화면은 이 provider만 보면 된다 — 언어가 바뀌면
/// 인자가 바뀌어 자동으로 새 캐시를 탄다.

final class CurrentCongestionBoundariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CongestionAreaBoundary>>,
          List<CongestionAreaBoundary>,
          FutureOr<List<CongestionAreaBoundary>>
        >
    with
        $FutureModifier<List<CongestionAreaBoundary>>,
        $FutureProvider<List<CongestionAreaBoundary>> {
  /// 현재 활성 언어로 경계를 조회한다. 화면은 이 provider만 보면 된다 — 언어가 바뀌면
  /// 인자가 바뀌어 자동으로 새 캐시를 탄다.
  const CurrentCongestionBoundariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentCongestionBoundariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentCongestionBoundariesHash();

  @$internal
  @override
  $FutureProviderElement<List<CongestionAreaBoundary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CongestionAreaBoundary>> create(Ref ref) {
    return currentCongestionBoundaries(ref);
  }
}

String _$currentCongestionBoundariesHash() =>
    r'7081eb31313555e81cf97816a2f66491e807a4c5';
