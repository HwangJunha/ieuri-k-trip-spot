// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 현재 위치로 등록할 수 있는지 판정한다(R33~R35).
///
/// 사진 동기화와 **같은 경로**다 — 좌표가 1건일 뿐이다. 여기서도 좌표는 기기를
/// 떠나지 않는다.
///
/// 등록을 하지는 않는다. 사용자 확인을 받은 뒤 `VisitController.record`를 부르는
/// 것은 화면의 몫이다(R33: 확인 없이 자동 등록 금지).

@ProviderFor(currentLocationCheck)
const currentLocationCheckProvider = CurrentLocationCheckProvider._();

/// 현재 위치로 등록할 수 있는지 판정한다(R33~R35).
///
/// 사진 동기화와 **같은 경로**다 — 좌표가 1건일 뿐이다. 여기서도 좌표는 기기를
/// 떠나지 않는다.
///
/// 등록을 하지는 않는다. 사용자 확인을 받은 뒤 `VisitController.record`를 부르는
/// 것은 화면의 몫이다(R33: 확인 없이 자동 등록 금지).

final class CurrentLocationCheckProvider
    extends
        $FunctionalProvider<
          AsyncValue<CurrentLocationCheck>,
          CurrentLocationCheck,
          FutureOr<CurrentLocationCheck>
        >
    with
        $FutureModifier<CurrentLocationCheck>,
        $FutureProvider<CurrentLocationCheck> {
  /// 현재 위치로 등록할 수 있는지 판정한다(R33~R35).
  ///
  /// 사진 동기화와 **같은 경로**다 — 좌표가 1건일 뿐이다. 여기서도 좌표는 기기를
  /// 떠나지 않는다.
  ///
  /// 등록을 하지는 않는다. 사용자 확인을 받은 뒤 `VisitController.record`를 부르는
  /// 것은 화면의 몫이다(R33: 확인 없이 자동 등록 금지).
  const CurrentLocationCheckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLocationCheckProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLocationCheckHash();

  @$internal
  @override
  $FutureProviderElement<CurrentLocationCheck> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CurrentLocationCheck> create(Ref ref) {
    return currentLocationCheck(ref);
  }
}

String _$currentLocationCheckHash() =>
    r'1a945722f02256c379c256ab9ee029169575165f';
