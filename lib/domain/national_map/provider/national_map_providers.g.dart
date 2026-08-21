// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'national_map_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 161칸과 뷰어의 방문 여부(R6·R20).
///
/// **아직 서버 계약이 없다.** `mapCells`·`recordVisits`를 비롯한 SPEC-0030의
/// 루트 필드가 서버에 존재하지 않아(슬라이스 1·2가 진행 중) repository를 붙이지
/// 못했다. 추측한 스키마로 오퍼레이션을 쓰면 코드젠은 통과하고 런타임에 깨진다
/// (CLAUDE.md §13) — 그래서 지금은 **앱 자산의 칸 목록을 전부 미방문으로** 낸다.
///
/// 서버가 나오면 이 provider의 본문만 repository 호출로 바꾼다. 화면과 계산은
/// 이미 [MapCell]에 맞춰져 있어 그대로 둔다.

@ProviderFor(mapCells)
const mapCellsProvider = MapCellsProvider._();

/// 161칸과 뷰어의 방문 여부(R6·R20).
///
/// **아직 서버 계약이 없다.** `mapCells`·`recordVisits`를 비롯한 SPEC-0030의
/// 루트 필드가 서버에 존재하지 않아(슬라이스 1·2가 진행 중) repository를 붙이지
/// 못했다. 추측한 스키마로 오퍼레이션을 쓰면 코드젠은 통과하고 런타임에 깨진다
/// (CLAUDE.md §13) — 그래서 지금은 **앱 자산의 칸 목록을 전부 미방문으로** 낸다.
///
/// 서버가 나오면 이 provider의 본문만 repository 호출로 바꾼다. 화면과 계산은
/// 이미 [MapCell]에 맞춰져 있어 그대로 둔다.

final class MapCellsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MapCell>>,
          List<MapCell>,
          FutureOr<List<MapCell>>
        >
    with $FutureModifier<List<MapCell>>, $FutureProvider<List<MapCell>> {
  /// 161칸과 뷰어의 방문 여부(R6·R20).
  ///
  /// **아직 서버 계약이 없다.** `mapCells`·`recordVisits`를 비롯한 SPEC-0030의
  /// 루트 필드가 서버에 존재하지 않아(슬라이스 1·2가 진행 중) repository를 붙이지
  /// 못했다. 추측한 스키마로 오퍼레이션을 쓰면 코드젠은 통과하고 런타임에 깨진다
  /// (CLAUDE.md §13) — 그래서 지금은 **앱 자산의 칸 목록을 전부 미방문으로** 낸다.
  ///
  /// 서버가 나오면 이 provider의 본문만 repository 호출로 바꾼다. 화면과 계산은
  /// 이미 [MapCell]에 맞춰져 있어 그대로 둔다.
  const MapCellsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapCellsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapCellsHash();

  @$internal
  @override
  $FutureProviderElement<List<MapCell>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MapCell>> create(Ref ref) {
    return mapCells(ref);
  }
}

String _$mapCellsHash() => r'cd39a51019f1eb6a8dc49df68972b89bd1123e11';

/// 이 기기에서 방문으로 표시한 칸.
///
/// **서버가 붙기 전까지의 임시 저장소다.** 앱을 껐다 켜면 사라진다 — 영속화하지
/// 않는 이유는, 서버가 나오면 이 provider 자체가 없어지기 때문이다. 지금 로컬 DB에
/// 스키마를 만들어 두면 그때 마이그레이션할 것이 생긴다.

@ProviderFor(LocalVisitedCells)
const localVisitedCellsProvider = LocalVisitedCellsProvider._();

/// 이 기기에서 방문으로 표시한 칸.
///
/// **서버가 붙기 전까지의 임시 저장소다.** 앱을 껐다 켜면 사라진다 — 영속화하지
/// 않는 이유는, 서버가 나오면 이 provider 자체가 없어지기 때문이다. 지금 로컬 DB에
/// 스키마를 만들어 두면 그때 마이그레이션할 것이 생긴다.
final class LocalVisitedCellsProvider
    extends $NotifierProvider<LocalVisitedCells, Set<String>> {
  /// 이 기기에서 방문으로 표시한 칸.
  ///
  /// **서버가 붙기 전까지의 임시 저장소다.** 앱을 껐다 켜면 사라진다 — 영속화하지
  /// 않는 이유는, 서버가 나오면 이 provider 자체가 없어지기 때문이다. 지금 로컬 DB에
  /// 스키마를 만들어 두면 그때 마이그레이션할 것이 생긴다.
  const LocalVisitedCellsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localVisitedCellsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localVisitedCellsHash();

  @$internal
  @override
  LocalVisitedCells create() => LocalVisitedCells();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$localVisitedCellsHash() => r'289fd883ba3d6db084241390c3dc51c26621eb3e';

/// 이 기기에서 방문으로 표시한 칸.
///
/// **서버가 붙기 전까지의 임시 저장소다.** 앱을 껐다 켜면 사라진다 — 영속화하지
/// 않는 이유는, 서버가 나오면 이 provider 자체가 없어지기 때문이다. 지금 로컬 DB에
/// 스키마를 만들어 두면 그때 마이그레이션할 것이 생긴다.

abstract class _$LocalVisitedCells extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 시도별 진척(R21). 칸 목록에서 계산한다 — 서버가 다시 내려주지 않는다.

@ProviderFor(provinceProgress)
const provinceProgressProvider = ProvinceProgressProvider._();

/// 시도별 진척(R21). 칸 목록에서 계산한다 — 서버가 다시 내려주지 않는다.

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
  /// 시도별 진척(R21). 칸 목록에서 계산한다 — 서버가 다시 내려주지 않는다.
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
