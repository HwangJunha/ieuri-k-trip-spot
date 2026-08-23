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
///
/// **인증 상태를 watch한다.** `keepAlive`라 로그아웃해도 캐시가 남는데, 여기 담긴
/// `viewerVisited`는 사용자의 것이라 다음 사용자에게 이전 사람의 방문 칸이
/// 보였다(실기기 확인). watch가 그 순간 이 provider를 다시 만든다.

@ProviderFor(MapCells)
const mapCellsProvider = MapCellsProvider._();

/// 161칸 + 뷰어의 방문 여부(R6·R20).
///
/// 앱 세션당 한 번 조회하고 붙들어 둔다 — 161칸은 고정이고 방문 등록·해제는
/// 뮤테이션 응답으로 이 캐시를 직접 고친다(재조회하지 않는다).
///
/// **인증 상태를 watch한다.** `keepAlive`라 로그아웃해도 캐시가 남는데, 여기 담긴
/// `viewerVisited`는 사용자의 것이라 다음 사용자에게 이전 사람의 방문 칸이
/// 보였다(실기기 확인). watch가 그 순간 이 provider를 다시 만든다.
final class MapCellsProvider
    extends $AsyncNotifierProvider<MapCells, List<MapCell>> {
  /// 161칸 + 뷰어의 방문 여부(R6·R20).
  ///
  /// 앱 세션당 한 번 조회하고 붙들어 둔다 — 161칸은 고정이고 방문 등록·해제는
  /// 뮤테이션 응답으로 이 캐시를 직접 고친다(재조회하지 않는다).
  ///
  /// **인증 상태를 watch한다.** `keepAlive`라 로그아웃해도 캐시가 남는데, 여기 담긴
  /// `viewerVisited`는 사용자의 것이라 다음 사용자에게 이전 사람의 방문 칸이
  /// 보였다(실기기 확인). watch가 그 순간 이 provider를 다시 만든다.
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

String _$mapCellsHash() => r'e833cba9894883a72f553aaf1d0211f1effea9ce';

/// 161칸 + 뷰어의 방문 여부(R6·R20).
///
/// 앱 세션당 한 번 조회하고 붙들어 둔다 — 161칸은 고정이고 방문 등록·해제는
/// 뮤테이션 응답으로 이 캐시를 직접 고친다(재조회하지 않는다).
///
/// **인증 상태를 watch한다.** `keepAlive`라 로그아웃해도 캐시가 남는데, 여기 담긴
/// `viewerVisited`는 사용자의 것이라 다음 사용자에게 이전 사람의 방문 칸이
/// 보였다(실기기 확인). watch가 그 순간 이 provider를 다시 만든다.

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

/// 미리 만들어 둔 칸 도형(SPEC-0031 방식 1).
///
/// 없거나 깨졌으면 빈 맵을 준다 — 그러면 [cellGeometries]가 원본 경계로 조립하는
/// 예전 방식으로 돌아간다.

@ProviderFor(cellShapes)
const cellShapesProvider = CellShapesProvider._();

/// 미리 만들어 둔 칸 도형(SPEC-0031 방식 1).
///
/// 없거나 깨졌으면 빈 맵을 준다 — 그러면 [cellGeometries]가 원본 경계로 조립하는
/// 예전 방식으로 돌아간다.

final class CellShapesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<List<GeoPoint>>>>,
          Map<String, List<List<GeoPoint>>>,
          FutureOr<Map<String, List<List<GeoPoint>>>>
        >
    with
        $FutureModifier<Map<String, List<List<GeoPoint>>>>,
        $FutureProvider<Map<String, List<List<GeoPoint>>>> {
  /// 미리 만들어 둔 칸 도형(SPEC-0031 방식 1).
  ///
  /// 없거나 깨졌으면 빈 맵을 준다 — 그러면 [cellGeometries]가 원본 경계로 조립하는
  /// 예전 방식으로 돌아간다.
  const CellShapesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cellShapesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cellShapesHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, List<List<GeoPoint>>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<List<GeoPoint>>>> create(Ref ref) {
    return cellShapes(ref);
  }
}

String _$cellShapesHash() => r'13d63df382f3b43f8af5e13f4a28bfcdf82efb2b';

/// 칸 도형(R20).
///
/// **크기가 고른 다각형을 쓴다**(SPEC-0031). 실제 시군구 경계를 합치면 폰 화면에서
/// 서울 주변이 2~3mm가 되어 칸마다 넣는 랜드마크 그림이 들어가지 않는다. 이유는
/// `CellShapeSource` 문서에 있다.
///
/// 도형 자산이 없으면 **예전 방식(원본 경계 합치기)으로 돌아간다.** 자산 하나로
/// 두 방식을 오갈 수 있어야 화면을 보며 판단할 수 있다.
///
/// 칸 묶음 규칙은 어느 쪽이든 서버 소유다 — 이 자산이 정하는 것은 모양뿐이다.
///
/// 조립 결과는 붙들어 둔다. 방문 여부는 여기 없다(도형은 방문과 무관하다) —
/// 색칠은 [mapCellsProvider]가 정한다.

@ProviderFor(cellGeometries)
const cellGeometriesProvider = CellGeometriesProvider._();

/// 칸 도형(R20).
///
/// **크기가 고른 다각형을 쓴다**(SPEC-0031). 실제 시군구 경계를 합치면 폰 화면에서
/// 서울 주변이 2~3mm가 되어 칸마다 넣는 랜드마크 그림이 들어가지 않는다. 이유는
/// `CellShapeSource` 문서에 있다.
///
/// 도형 자산이 없으면 **예전 방식(원본 경계 합치기)으로 돌아간다.** 자산 하나로
/// 두 방식을 오갈 수 있어야 화면을 보며 판단할 수 있다.
///
/// 칸 묶음 규칙은 어느 쪽이든 서버 소유다 — 이 자산이 정하는 것은 모양뿐이다.
///
/// 조립 결과는 붙들어 둔다. 방문 여부는 여기 없다(도형은 방문과 무관하다) —
/// 색칠은 [mapCellsProvider]가 정한다.

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
  /// **크기가 고른 다각형을 쓴다**(SPEC-0031). 실제 시군구 경계를 합치면 폰 화면에서
  /// 서울 주변이 2~3mm가 되어 칸마다 넣는 랜드마크 그림이 들어가지 않는다. 이유는
  /// `CellShapeSource` 문서에 있다.
  ///
  /// 도형 자산이 없으면 **예전 방식(원본 경계 합치기)으로 돌아간다.** 자산 하나로
  /// 두 방식을 오갈 수 있어야 화면을 보며 판단할 수 있다.
  ///
  /// 칸 묶음 규칙은 어느 쪽이든 서버 소유다 — 이 자산이 정하는 것은 모양뿐이다.
  ///
  /// 조립 결과는 붙들어 둔다. 방문 여부는 여기 없다(도형은 방문과 무관하다) —
  /// 색칠은 [mapCellsProvider]가 정한다.
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

String _$cellGeometriesHash() => r'76f364ebc0c22100bb741ec5890c79d5ec02f076';

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
///
/// 광역시 칸은 장소가 수천 건이라 커서로 이어 읽는다(스펙 §11).

@ProviderFor(CellDetailController)
const cellDetailControllerProvider = CellDetailControllerFamily._();

/// 칸 상세(R11·R22). 칸 id로 부르는 family다.
///
/// 광역시 칸은 장소가 수천 건이라 커서로 이어 읽는다(스펙 §11).
final class CellDetailControllerProvider
    extends $AsyncNotifierProvider<CellDetailController, CellDetail> {
  /// 칸 상세(R11·R22). 칸 id로 부르는 family다.
  ///
  /// 광역시 칸은 장소가 수천 건이라 커서로 이어 읽는다(스펙 §11).
  const CellDetailControllerProvider._({
    required CellDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cellDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cellDetailControllerHash();

  @override
  String toString() {
    return r'cellDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CellDetailController create() => CellDetailController();

  @override
  bool operator ==(Object other) {
    return other is CellDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cellDetailControllerHash() =>
    r'c28e8ad50a207cefcc465f4a7fb66b13c868a041';

/// 칸 상세(R11·R22). 칸 id로 부르는 family다.
///
/// 광역시 칸은 장소가 수천 건이라 커서로 이어 읽는다(스펙 §11).

final class CellDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CellDetailController,
          AsyncValue<CellDetail>,
          CellDetail,
          FutureOr<CellDetail>,
          String
        > {
  const CellDetailControllerFamily._()
    : super(
        retry: null,
        name: r'cellDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 칸 상세(R11·R22). 칸 id로 부르는 family다.
  ///
  /// 광역시 칸은 장소가 수천 건이라 커서로 이어 읽는다(스펙 §11).

  CellDetailControllerProvider call(String cellId) =>
      CellDetailControllerProvider._(argument: cellId, from: this);

  @override
  String toString() => r'cellDetailControllerProvider';
}

/// 칸 상세(R11·R22). 칸 id로 부르는 family다.
///
/// 광역시 칸은 장소가 수천 건이라 커서로 이어 읽는다(스펙 §11).

abstract class _$CellDetailController extends $AsyncNotifier<CellDetail> {
  late final _$args = ref.$arg as String;
  String get cellId => _$args;

  FutureOr<CellDetail> build(String cellId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<CellDetail>, CellDetail>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CellDetail>, CellDetail>,
              AsyncValue<CellDetail>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
