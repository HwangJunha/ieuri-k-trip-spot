// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(photoLibraryService)
const photoLibraryServiceProvider = PhotoLibraryServiceProvider._();

final class PhotoLibraryServiceProvider
    extends
        $FunctionalProvider<
          PhotoLibraryService,
          PhotoLibraryService,
          PhotoLibraryService
        >
    with $Provider<PhotoLibraryService> {
  const PhotoLibraryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoLibraryServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoLibraryServiceHash();

  @$internal
  @override
  $ProviderElement<PhotoLibraryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PhotoLibraryService create(Ref ref) {
    return photoLibraryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoLibraryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoLibraryService>(value),
    );
  }
}

String _$photoLibraryServiceHash() =>
    r'a6f94f0800b78754faa74769efc604080830cbf0';

/// 사진첩을 훑어 방문한 시군구를 찾는다(R25~R30).
///
/// **좌표는 기기를 떠나지 않는다.** 판정까지 로컬에서 끝내고 서버에는 시군구
/// 코드만 보낸다.
///
/// 흐름:
/// ```
/// 권한 요청 -> 배치로 좌표 읽기 -> 한국 밖 버림 -> 1km 격자 축약
///          -> 로컬 판정 -> 이미 방문한 시군구 제외 -> recordVisits
/// ```
///
/// 스펙 R30은 등록 전 별도 확인을 요구했으나 **없앴다**(사용자 결정,
/// 2026-08-22) — 스캔을 사용자가 직접 시작하므로 그 행위가 곧 동의다.
///
/// 배치마다 상태를 갱신해 중단·재개할 수 있다(R28). 스캔 중에도 앱의 다른 기능을
/// 쓸 수 있다(R29) — 이 컨트롤러는 UI를 막지 않는다.

@ProviderFor(PhotoScanController)
const photoScanControllerProvider = PhotoScanControllerProvider._();

/// 사진첩을 훑어 방문한 시군구를 찾는다(R25~R30).
///
/// **좌표는 기기를 떠나지 않는다.** 판정까지 로컬에서 끝내고 서버에는 시군구
/// 코드만 보낸다.
///
/// 흐름:
/// ```
/// 권한 요청 -> 배치로 좌표 읽기 -> 한국 밖 버림 -> 1km 격자 축약
///          -> 로컬 판정 -> 이미 방문한 시군구 제외 -> recordVisits
/// ```
///
/// 스펙 R30은 등록 전 별도 확인을 요구했으나 **없앴다**(사용자 결정,
/// 2026-08-22) — 스캔을 사용자가 직접 시작하므로 그 행위가 곧 동의다.
///
/// 배치마다 상태를 갱신해 중단·재개할 수 있다(R28). 스캔 중에도 앱의 다른 기능을
/// 쓸 수 있다(R29) — 이 컨트롤러는 UI를 막지 않는다.
final class PhotoScanControllerProvider
    extends $NotifierProvider<PhotoScanController, PhotoScanProgress> {
  /// 사진첩을 훑어 방문한 시군구를 찾는다(R25~R30).
  ///
  /// **좌표는 기기를 떠나지 않는다.** 판정까지 로컬에서 끝내고 서버에는 시군구
  /// 코드만 보낸다.
  ///
  /// 흐름:
  /// ```
  /// 권한 요청 -> 배치로 좌표 읽기 -> 한국 밖 버림 -> 1km 격자 축약
  ///          -> 로컬 판정 -> 이미 방문한 시군구 제외 -> recordVisits
  /// ```
  ///
  /// 스펙 R30은 등록 전 별도 확인을 요구했으나 **없앴다**(사용자 결정,
  /// 2026-08-22) — 스캔을 사용자가 직접 시작하므로 그 행위가 곧 동의다.
  ///
  /// 배치마다 상태를 갱신해 중단·재개할 수 있다(R28). 스캔 중에도 앱의 다른 기능을
  /// 쓸 수 있다(R29) — 이 컨트롤러는 UI를 막지 않는다.
  const PhotoScanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoScanControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoScanControllerHash();

  @$internal
  @override
  PhotoScanController create() => PhotoScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoScanProgress value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoScanProgress>(value),
    );
  }
}

String _$photoScanControllerHash() =>
    r'25fe47f19538d08a9d362e9e38fab14151cd4d32';

/// 사진첩을 훑어 방문한 시군구를 찾는다(R25~R30).
///
/// **좌표는 기기를 떠나지 않는다.** 판정까지 로컬에서 끝내고 서버에는 시군구
/// 코드만 보낸다.
///
/// 흐름:
/// ```
/// 권한 요청 -> 배치로 좌표 읽기 -> 한국 밖 버림 -> 1km 격자 축약
///          -> 로컬 판정 -> 이미 방문한 시군구 제외 -> recordVisits
/// ```
///
/// 스펙 R30은 등록 전 별도 확인을 요구했으나 **없앴다**(사용자 결정,
/// 2026-08-22) — 스캔을 사용자가 직접 시작하므로 그 행위가 곧 동의다.
///
/// 배치마다 상태를 갱신해 중단·재개할 수 있다(R28). 스캔 중에도 앱의 다른 기능을
/// 쓸 수 있다(R29) — 이 컨트롤러는 UI를 막지 않는다.

abstract class _$PhotoScanController extends $Notifier<PhotoScanProgress> {
  PhotoScanProgress build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PhotoScanProgress, PhotoScanProgress>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhotoScanProgress, PhotoScanProgress>,
              PhotoScanProgress,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
