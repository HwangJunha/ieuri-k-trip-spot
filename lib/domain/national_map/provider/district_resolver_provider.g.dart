// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_resolver_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 좌표 -> 시군구 판정기(SPEC-0030 v1.2 §0).
///
/// 3.8MB 자산을 파싱하고 격자 인덱스를 세우므로 **한 번만 만든다.** 화면을
/// 드나들 때마다 다시 하면 안 된다.
///
/// 사진 동기화를 시작할 때까지 필요 없으므로 미리 읽지 않는다 — 지도 탭에
/// 들어왔다고 3.8MB를 파싱하지는 않는다.

@ProviderFor(districtResolver)
const districtResolverProvider = DistrictResolverProvider._();

/// 좌표 -> 시군구 판정기(SPEC-0030 v1.2 §0).
///
/// 3.8MB 자산을 파싱하고 격자 인덱스를 세우므로 **한 번만 만든다.** 화면을
/// 드나들 때마다 다시 하면 안 된다.
///
/// 사진 동기화를 시작할 때까지 필요 없으므로 미리 읽지 않는다 — 지도 탭에
/// 들어왔다고 3.8MB를 파싱하지는 않는다.

final class DistrictResolverProvider
    extends
        $FunctionalProvider<
          AsyncValue<DistrictResolver>,
          DistrictResolver,
          FutureOr<DistrictResolver>
        >
    with $FutureModifier<DistrictResolver>, $FutureProvider<DistrictResolver> {
  /// 좌표 -> 시군구 판정기(SPEC-0030 v1.2 §0).
  ///
  /// 3.8MB 자산을 파싱하고 격자 인덱스를 세우므로 **한 번만 만든다.** 화면을
  /// 드나들 때마다 다시 하면 안 된다.
  ///
  /// 사진 동기화를 시작할 때까지 필요 없으므로 미리 읽지 않는다 — 지도 탭에
  /// 들어왔다고 3.8MB를 파싱하지는 않는다.
  const DistrictResolverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'districtResolverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$districtResolverHash();

  @$internal
  @override
  $FutureProviderElement<DistrictResolver> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DistrictResolver> create(Ref ref) {
    return districtResolver(ref);
  }
}

String _$districtResolverHash() => r'924a50fbf8667d053d0c43714997f5cddf89cf37';
