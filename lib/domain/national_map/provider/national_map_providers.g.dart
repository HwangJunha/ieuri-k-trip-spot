// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'national_map_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nationalMapRepository)
const nationalMapRepositoryProvider = NationalMapRepositoryProvider._();

final class NationalMapRepositoryProvider
    extends
        $FunctionalProvider<
          NationalMapRepository,
          NationalMapRepository,
          NationalMapRepository
        >
    with $Provider<NationalMapRepository> {
  const NationalMapRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nationalMapRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nationalMapRepositoryHash();

  @$internal
  @override
  $ProviderElement<NationalMapRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NationalMapRepository create(Ref ref) {
    return nationalMapRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NationalMapRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NationalMapRepository>(value),
    );
  }
}

String _$nationalMapRepositoryHash() =>
    r'9f9dbb2785b6d8a4365f78cefae4b0110d9d6a16';

/// 161칸 + 뷰어의 방문 여부(R6·R20).
///
/// 앱 세션당 한 번 조회하고 붙들어 둔다 — 161칸은 고정이고 방문 등록·해제는
/// 뮤테이션 응답으로 이 캐시를 직접 고친다(재조회하지 않는다).

@ProviderFor(MapCells)
const mapCellsProvider = MapCellsProvider._();

/// 161칸 + 뷰어의 방문 여부(R6·R20).
///
/// 앱 세션당 한 번 조회하고 붙들어 둔다 — 161칸은 고정이고 방문 등록·해제는
/// 뮤테이션 응답으로 이 캐시를 직접 고친다(재조회하지 않는다).
final class MapCellsProvider
    extends $AsyncNotifierProvider<MapCells, List<MapCell>> {
  /// 161칸 + 뷰어의 방문 여부(R6·R20).
  ///
  /// 앱 세션당 한 번 조회하고 붙들어 둔다 — 161칸은 고정이고 방문 등록·해제는
  /// 뮤테이션 응답으로 이 캐시를 직접 고친다(재조회하지 않는다).
  const MapCellsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapCellsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapCellsHash();

  @$internal
  @override
  MapCells create() => MapCells();
}

String _$mapCellsHash() => r'0f108eee3bd8c5228a0a7c8f0b877ae0ed1f597b';

/// 161칸 + 뷰어의 방문 여부(R6·R20).
///
/// 앱 세션당 한 번 조회하고 붙들어 둔다 — 161칸은 고정이고 방문 등록·해제는
/// 뮤테이션 응답으로 이 캐시를 직접 고친다(재조회하지 않는다).

abstract class _$MapCells extends $AsyncNotifier<List<MapCell>> {
  FutureOr<List<MapCell>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<MapCell>>, List<MapCell>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MapCell>>, List<MapCell>>,
              AsyncValue<List<MapCell>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 시도별 진척(R21). **클라이언트가 센다** — 161칸을 이미 갖고 있다.

@ProviderFor(provinceProgress)
const provinceProgressProvider = ProvinceProgressProvider._();

/// 시도별 진척(R21). **클라이언트가 센다** — 161칸을 이미 갖고 있다.

final class ProvinceProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProvinceProgress>>,
          List<ProvinceProgress>,
          FutureOr<List<ProvinceProgress>>
        >
    with
        $FutureModifier<List<ProvinceProgress>>,
        $FutureProvider<List<ProvinceProgress>> {
  /// 시도별 진척(R21). **클라이언트가 센다** — 161칸을 이미 갖고 있다.
  const ProvinceProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'provinceProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$provinceProgressHash();

  @$internal
  @override
  $FutureProviderElement<List<ProvinceProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProvinceProgress>> create(Ref ref) {
    return provinceProgress(ref);
  }
}

String _$provinceProgressHash() => r'b34cf99402be2586db185ca925234e3c95313973';

/// 서버 칸과 렌더링 도형을 이은 인덱스.
///
/// 지도를 그리려면 둘이 다 있어야 하므로 여기서 합쳐 한 번만 계산한다.

@ProviderFor(cellGeometryIndex)
const cellGeometryIndexProvider = CellGeometryIndexProvider._();

/// 서버 칸과 렌더링 도형을 이은 인덱스.
///
/// 지도를 그리려면 둘이 다 있어야 하므로 여기서 합쳐 한 번만 계산한다.

final class CellGeometryIndexProvider
    extends
        $FunctionalProvider<
          AsyncValue<CellGeometryIndex>,
          CellGeometryIndex,
          FutureOr<CellGeometryIndex>
        >
    with
        $FutureModifier<CellGeometryIndex>,
        $FutureProvider<CellGeometryIndex> {
  /// 서버 칸과 렌더링 도형을 이은 인덱스.
  ///
  /// 지도를 그리려면 둘이 다 있어야 하므로 여기서 합쳐 한 번만 계산한다.
  const CellGeometryIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cellGeometryIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cellGeometryIndexHash();

  @$internal
  @override
  $FutureProviderElement<CellGeometryIndex> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CellGeometryIndex> create(Ref ref) {
    return cellGeometryIndex(ref);
  }
}

String _$cellGeometryIndexHash() => r'173ee60986e160c76d00c711f09881b124a9ff1a';

/// 칸 상세(R11·R22). 칸 id로 부르는 family다.

@ProviderFor(cellDetail)
const cellDetailProvider = CellDetailFamily._();

/// 칸 상세(R11·R22). 칸 id로 부르는 family다.

final class CellDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<CellDetail>,
          CellDetail,
          FutureOr<CellDetail>
        >
    with $FutureModifier<CellDetail>, $FutureProvider<CellDetail> {
  /// 칸 상세(R11·R22). 칸 id로 부르는 family다.
  const CellDetailProvider._({
    required CellDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cellDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cellDetailHash();

  @override
  String toString() {
    return r'cellDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CellDetail> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CellDetail> create(Ref ref) {
    final argument = this.argument as String;
    return cellDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CellDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cellDetailHash() => r'ea42fce39590c819e1ad9b30c3a32b00b40e6661';

/// 칸 상세(R11·R22). 칸 id로 부르는 family다.

final class CellDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CellDetail>, String> {
  const CellDetailFamily._()
    : super(
        retry: null,
        name: r'cellDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 칸 상세(R11·R22). 칸 id로 부르는 family다.

  CellDetailProvider call(String cellId) =>
      CellDetailProvider._(argument: cellId, from: this);

  @override
  String toString() => r'cellDetailProvider';
}
