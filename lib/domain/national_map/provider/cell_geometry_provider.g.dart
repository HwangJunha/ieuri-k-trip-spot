// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell_geometry_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 161칸의 도형(설계 §3).
///
/// 앱에 내장한 자산이라 세션 내내 바뀌지 않는다 — 한 번 읽고 붙들어 둔다.
/// 파싱에 약 7천 점을 훑으므로 화면을 드나들 때마다 다시 하지 않는다.

@ProviderFor(cellGeometries)
const cellGeometriesProvider = CellGeometriesProvider._();

/// 161칸의 도형(설계 §3).
///
/// 앱에 내장한 자산이라 세션 내내 바뀌지 않는다 — 한 번 읽고 붙들어 둔다.
/// 파싱에 약 7천 점을 훑으므로 화면을 드나들 때마다 다시 하지 않는다.

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
  /// 161칸의 도형(설계 §3).
  ///
  /// 앱에 내장한 자산이라 세션 내내 바뀌지 않는다 — 한 번 읽고 붙들어 둔다.
  /// 파싱에 약 7천 점을 훑으므로 화면을 드나들 때마다 다시 하지 않는다.
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

String _$cellGeometriesHash() => r'a3d1c18fe4b179d0a3e71ab06c4a5cbace8251f2';
