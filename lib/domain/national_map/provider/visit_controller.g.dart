// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 방문 등록·해제(R3·R4·R30·R33).
///
/// **낙관적 업데이트를 한다** — 누르면 즉시 칠하고 실패하면 되돌린다. 서버가
/// 변경된 칸을 돌려주므로 성공 시에는 그 값으로 캐시를 고친다(재조회 없음).

@ProviderFor(VisitController)
const visitControllerProvider = VisitControllerProvider._();

/// 방문 등록·해제(R3·R4·R30·R33).
///
/// **낙관적 업데이트를 한다** — 누르면 즉시 칠하고 실패하면 되돌린다. 서버가
/// 변경된 칸을 돌려주므로 성공 시에는 그 값으로 캐시를 고친다(재조회 없음).
final class VisitControllerProvider
    extends $NotifierProvider<VisitController, bool> {
  /// 방문 등록·해제(R3·R4·R30·R33).
  ///
  /// **낙관적 업데이트를 한다** — 누르면 즉시 칠하고 실패하면 되돌린다. 서버가
  /// 변경된 칸을 돌려주므로 성공 시에는 그 값으로 캐시를 고친다(재조회 없음).
  const VisitControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visitControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visitControllerHash();

  @$internal
  @override
  VisitController create() => VisitController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$visitControllerHash() => r'b03e6e1d45dde3e27a6dd0f6eb4dc774b0a550cf';

/// 방문 등록·해제(R3·R4·R30·R33).
///
/// **낙관적 업데이트를 한다** — 누르면 즉시 칠하고 실패하면 되돌린다. 서버가
/// 변경된 칸을 돌려주므로 성공 시에는 그 값으로 캐시를 고친다(재조회 없음).

abstract class _$VisitController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
