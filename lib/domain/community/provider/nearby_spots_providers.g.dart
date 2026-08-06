// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_spots_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 장소 선택 시트가 입력한 이름 필터.
///
/// **서버에 이름 검색 인자가 없다** — `spots`는 좌표 기반이다. 그래서 이 값은 이미
/// 받아 둔 목록만 좁히며, 시트가 그 사실을 문구로 알린다.
///
/// 필터는 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다 — 시트를
/// 닫으면 사라지는 것이 맞다.

@ProviderFor(NearbySpotQuery)
const nearbySpotQueryProvider = NearbySpotQueryProvider._();

/// 장소 선택 시트가 입력한 이름 필터.
///
/// **서버에 이름 검색 인자가 없다** — `spots`는 좌표 기반이다. 그래서 이 값은 이미
/// 받아 둔 목록만 좁히며, 시트가 그 사실을 문구로 알린다.
///
/// 필터는 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다 — 시트를
/// 닫으면 사라지는 것이 맞다.
final class NearbySpotQueryProvider
    extends $NotifierProvider<NearbySpotQuery, String> {
  /// 장소 선택 시트가 입력한 이름 필터.
  ///
  /// **서버에 이름 검색 인자가 없다** — `spots`는 좌표 기반이다. 그래서 이 값은 이미
  /// 받아 둔 목록만 좁히며, 시트가 그 사실을 문구로 알린다.
  ///
  /// 필터는 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다 — 시트를
  /// 닫으면 사라지는 것이 맞다.
  const NearbySpotQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbySpotQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbySpotQueryHash();

  @$internal
  @override
  NearbySpotQuery create() => NearbySpotQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$nearbySpotQueryHash() => r'63e79ee800d2432273edd5098c4b24db16eecd17';

/// 장소 선택 시트가 입력한 이름 필터.
///
/// **서버에 이름 검색 인자가 없다** — `spots`는 좌표 기반이다. 그래서 이 값은 이미
/// 받아 둔 목록만 좁히며, 시트가 그 사실을 문구로 알린다.
///
/// 필터는 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다 — 시트를
/// 닫으면 사라지는 것이 맞다.

abstract class _$NearbySpotQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 컴포저 장소 선택 시트의 목록.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라오고 **시트가 사유와 재시도를
/// 보여준다** — 빈 시트나 무한 스피너로 두지 않는다. 그 상태에서도 장소 없이 글을
/// 등록하는 길은 그대로 열려 있다(가이드 §5).

@ProviderFor(NearbySpotsController)
const nearbySpotsControllerProvider = NearbySpotsControllerProvider._();

/// 컴포저 장소 선택 시트의 목록.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라오고 **시트가 사유와 재시도를
/// 보여준다** — 빈 시트나 무한 스피너로 두지 않는다. 그 상태에서도 장소 없이 글을
/// 등록하는 길은 그대로 열려 있다(가이드 §5).
final class NearbySpotsControllerProvider
    extends $AsyncNotifierProvider<NearbySpotsController, NearbySpotsState> {
  /// 컴포저 장소 선택 시트의 목록.
  ///
  /// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
  /// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라오고 **시트가 사유와 재시도를
  /// 보여준다** — 빈 시트나 무한 스피너로 두지 않는다. 그 상태에서도 장소 없이 글을
  /// 등록하는 길은 그대로 열려 있다(가이드 §5).
  const NearbySpotsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: communityRetryPolicy,
        name: r'nearbySpotsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbySpotsControllerHash();

  @$internal
  @override
  NearbySpotsController create() => NearbySpotsController();
}

String _$nearbySpotsControllerHash() =>
    r'8836d55ed3c00d8e6dc3036de3cfa1ad35212261';

/// 컴포저 장소 선택 시트의 목록.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라오고 **시트가 사유와 재시도를
/// 보여준다** — 빈 시트나 무한 스피너로 두지 않는다. 그 상태에서도 장소 없이 글을
/// 등록하는 길은 그대로 열려 있다(가이드 §5).

abstract class _$NearbySpotsController
    extends $AsyncNotifier<NearbySpotsState> {
  FutureOr<NearbySpotsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<NearbySpotsState>, NearbySpotsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NearbySpotsState>, NearbySpotsState>,
              AsyncValue<NearbySpotsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
