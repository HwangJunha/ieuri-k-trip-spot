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

String _$mapCellsHash() => r'160afc8f7ffae37f92568cc43b3d0b99c41cfcb9';

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

/// 칸 도형(R20).
///
/// **서버가 정한 칸 정의로 원본 경계를 런타임에 합친다.** 별도의 도형 자산을 두지
/// 않는 이유는 묶음 규칙이 서버 소유이기 때문이다 — 클라이언트가 규칙을 따로
/// 가지면 서버가 바꿀 때 조용히 어긋난다.
///
/// 조립에 ~250ms가 들어 한 번만 하고 붙들어 둔다. 방문 여부는 여기 없다
/// (도형은 방문과 무관하게 그대로다) — 색칠은 [mapCellsProvider]가 정한다.

@ProviderFor(cellGeometries)
const cellGeometriesProvider = CellGeometriesProvider._();

/// 칸 도형(R20).
///
/// **서버가 정한 칸 정의로 원본 경계를 런타임에 합친다.** 별도의 도형 자산을 두지
/// 않는 이유는 묶음 규칙이 서버 소유이기 때문이다 — 클라이언트가 규칙을 따로
/// 가지면 서버가 바꿀 때 조용히 어긋난다.
///
/// 조립에 ~250ms가 들어 한 번만 하고 붙들어 둔다. 방문 여부는 여기 없다
/// (도형은 방문과 무관하게 그대로다) — 색칠은 [mapCellsProvider]가 정한다.

final class CellGeometriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CellGeometry>>,
          List<CellGeometry>,
          FutureOr<List<CellGeometry>>
        >
    with
        $FutureModifier<List<CellGeometry>>,
        $FutureProvider<List<CellGeometry>> {
  /// 칸 도형(R20).
  ///
  /// **서버가 정한 칸 정의로 원본 경계를 런타임에 합친다.** 별도의 도형 자산을 두지
  /// 않는 이유는 묶음 규칙이 서버 소유이기 때문이다 — 클라이언트가 규칙을 따로
  /// 가지면 서버가 바꿀 때 조용히 어긋난다.
  ///
  /// 조립에 ~250ms가 들어 한 번만 하고 붙들어 둔다. 방문 여부는 여기 없다
  /// (도형은 방문과 무관하게 그대로다) — 색칠은 [mapCellsProvider]가 정한다.
  const CellGeometriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cellGeometriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cellGeometriesHash();

  @$internal
  @override
  $FutureProviderElement<List<CellGeometry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CellGeometry>> create(Ref ref) {
    return cellGeometries(ref);
  }
}

String _$cellGeometriesHash() => r'5b12add6d27f734c2cadf476c9214da707e77dbb';

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
