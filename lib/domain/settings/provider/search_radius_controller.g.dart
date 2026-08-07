// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_radius_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 검색 반경(km) 설정을 들고 있는 컨트롤러(SPEC-0011 R13).
///
/// **서버 상태가 아니다** — 로컬 [AppPreferences]에만 산다. 이 값을 실제 조회에
/// 반영하는 것은 이 스펙의 인수 기준에 없고, 저장과 복원까지가 범위다.
///
/// `autoDispose`(codegen 기본)로 둔다. 값을 지키는 것은 이 provider가 아니라
/// SharedPreferences이므로 화면을 벗어나 버려져도 다음에 같은 값이 복원되고,
/// `build()`는 이미 로드된 인스턴스에서 동기로 읽는 한 줄이라 되살리는 비용이
/// 사실상 없다. 살려 둘 이유가 생기기 전에 살려 두지 않는다(CLAUDE.md §5).

@ProviderFor(SearchRadiusController)
const searchRadiusControllerProvider = SearchRadiusControllerProvider._();

/// 검색 반경(km) 설정을 들고 있는 컨트롤러(SPEC-0011 R13).
///
/// **서버 상태가 아니다** — 로컬 [AppPreferences]에만 산다. 이 값을 실제 조회에
/// 반영하는 것은 이 스펙의 인수 기준에 없고, 저장과 복원까지가 범위다.
///
/// `autoDispose`(codegen 기본)로 둔다. 값을 지키는 것은 이 provider가 아니라
/// SharedPreferences이므로 화면을 벗어나 버려져도 다음에 같은 값이 복원되고,
/// `build()`는 이미 로드된 인스턴스에서 동기로 읽는 한 줄이라 되살리는 비용이
/// 사실상 없다. 살려 둘 이유가 생기기 전에 살려 두지 않는다(CLAUDE.md §5).
final class SearchRadiusControllerProvider
    extends $NotifierProvider<SearchRadiusController, double> {
  /// 검색 반경(km) 설정을 들고 있는 컨트롤러(SPEC-0011 R13).
  ///
  /// **서버 상태가 아니다** — 로컬 [AppPreferences]에만 산다. 이 값을 실제 조회에
  /// 반영하는 것은 이 스펙의 인수 기준에 없고, 저장과 복원까지가 범위다.
  ///
  /// `autoDispose`(codegen 기본)로 둔다. 값을 지키는 것은 이 provider가 아니라
  /// SharedPreferences이므로 화면을 벗어나 버려져도 다음에 같은 값이 복원되고,
  /// `build()`는 이미 로드된 인스턴스에서 동기로 읽는 한 줄이라 되살리는 비용이
  /// 사실상 없다. 살려 둘 이유가 생기기 전에 살려 두지 않는다(CLAUDE.md §5).
  const SearchRadiusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchRadiusControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchRadiusControllerHash();

  @$internal
  @override
  SearchRadiusController create() => SearchRadiusController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$searchRadiusControllerHash() =>
    r'e13b8e9aca654d6d10398fa41cc1fdf6fc1d5ffb';

/// 검색 반경(km) 설정을 들고 있는 컨트롤러(SPEC-0011 R13).
///
/// **서버 상태가 아니다** — 로컬 [AppPreferences]에만 산다. 이 값을 실제 조회에
/// 반영하는 것은 이 스펙의 인수 기준에 없고, 저장과 복원까지가 범위다.
///
/// `autoDispose`(codegen 기본)로 둔다. 값을 지키는 것은 이 provider가 아니라
/// SharedPreferences이므로 화면을 벗어나 버려져도 다음에 같은 값이 복원되고,
/// `build()`는 이미 로드된 인스턴스에서 동기로 읽는 한 줄이라 되살리는 비용이
/// 사실상 없다. 살려 둘 이유가 생기기 전에 살려 두지 않는다(CLAUDE.md §5).

abstract class _$SearchRadiusController extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
