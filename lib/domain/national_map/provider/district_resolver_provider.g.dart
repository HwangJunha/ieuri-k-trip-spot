// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_resolver_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 252개 시군구 원본 경계.
///
/// 3.8MB를 파싱하므로 **한 번만 읽는다.** 칸 도형 조립과 좌표 판정이 둘 다 이걸
/// 쓴다.
///
/// 파싱은 isolate에서 한다 — 측정으로는 수십 ms지만 저사양 기기에서 프레임을
/// 떨어뜨릴 이유가 없다. 자산 로딩(`rootBundle`)만 메인에서 하고 무거운
/// 디코딩·객체화를 넘긴다.

@ProviderFor(districtBoundaries)
const districtBoundariesProvider = DistrictBoundariesProvider._();

/// 252개 시군구 원본 경계.
///
/// 3.8MB를 파싱하므로 **한 번만 읽는다.** 칸 도형 조립과 좌표 판정이 둘 다 이걸
/// 쓴다.
///
/// 파싱은 isolate에서 한다 — 측정으로는 수십 ms지만 저사양 기기에서 프레임을
/// 떨어뜨릴 이유가 없다. 자산 로딩(`rootBundle`)만 메인에서 하고 무거운
/// 디코딩·객체화를 넘긴다.

final class DistrictBoundariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DistrictBoundary>>,
          List<DistrictBoundary>,
          FutureOr<List<DistrictBoundary>>
        >
    with
        $FutureModifier<List<DistrictBoundary>>,
        $FutureProvider<List<DistrictBoundary>> {
  /// 252개 시군구 원본 경계.
  ///
  /// 3.8MB를 파싱하므로 **한 번만 읽는다.** 칸 도형 조립과 좌표 판정이 둘 다 이걸
  /// 쓴다.
  ///
  /// 파싱은 isolate에서 한다 — 측정으로는 수십 ms지만 저사양 기기에서 프레임을
  /// 떨어뜨릴 이유가 없다. 자산 로딩(`rootBundle`)만 메인에서 하고 무거운
  /// 디코딩·객체화를 넘긴다.
  const DistrictBoundariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'districtBoundariesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$districtBoundariesHash();

  @$internal
  @override
  $FutureProviderElement<List<DistrictBoundary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DistrictBoundary>> create(Ref ref) {
    return districtBoundaries(ref);
  }
}

String _$districtBoundariesHash() =>
    r'8eb10f9519ff7aa1fdf1853d8a739e270ee68f0f';

/// 좌표 -> 시군구 판정기(SPEC-0030 v1.2 §0).
///
/// 서버의 `resolveDistricts`를 대체한다. 격자 인덱스를 세우므로 한 번만 만든다.

@ProviderFor(districtResolver)
const districtResolverProvider = DistrictResolverProvider._();

/// 좌표 -> 시군구 판정기(SPEC-0030 v1.2 §0).
///
/// 서버의 `resolveDistricts`를 대체한다. 격자 인덱스를 세우므로 한 번만 만든다.

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
  /// 서버의 `resolveDistricts`를 대체한다. 격자 인덱스를 세우므로 한 번만 만든다.
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

String _$districtResolverHash() => r'c537bb95b1466680365f7401f4b7e395633751e2';
