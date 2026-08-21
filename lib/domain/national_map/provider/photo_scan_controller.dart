import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/cell_geometry.dart';
import '../model/coordinate_reduction.dart';
import '../model/district_resolver.dart';
import '../model/map_cell.dart';
import '../model/national_map_config.dart';
import '../model/photo_scan_progress.dart';
import '../service/photo_library_service.dart';
import 'district_resolver_provider.dart';
import 'national_map_providers.dart';

part 'photo_scan_controller.g.dart';

@riverpod
PhotoLibraryService photoLibraryService(Ref ref) => const PhotoLibraryService();

/// 사진첩을 훑어 방문한 시군구를 찾는다(R25~R30).
///
/// **좌표는 기기를 떠나지 않는다.** 판정까지 로컬에서 끝내고 서버에는 시군구
/// 코드만 보낸다 — 그것도 사용자가 확인한 뒤에(R30).
///
/// 흐름:
/// ```
/// 권한 요청 -> 배치로 좌표 읽기 -> 한국 밖 버림 -> 1km 격자 축약
///          -> 로컬 판정 -> 이미 방문한 시군구 제외 -> 사용자 확인 -> recordVisits
/// ```
///
/// 배치마다 상태를 갱신해 중단·재개할 수 있다(R28). 스캔 중에도 앱의 다른 기능을
/// 쓸 수 있다(R29) — 이 컨트롤러는 UI를 막지 않는다.
@Riverpod(keepAlive: true)
class PhotoScanController extends _$PhotoScanController {
  @override
  PhotoScanProgress build() => const PhotoScanProgress();

  /// 스캔을 멈추라는 신호. `stop()`이 세우고 루프가 본다.
  bool _cancelled = false;

  /// 스캔을 시작하거나 이어서 한다(R28).
  ///
  /// 이미 돌고 있으면 아무 일도 하지 않는다.
  Future<void> start() async {
    if (state.isRunning) return;
    _cancelled = false;

    final PhotoLibraryService library = ref.read(photoLibraryServiceProvider);

    // 1) 권한(R31). 거부해도 오류가 아니다 — 안내만 하고 끝낸다(R32).
    state = state.copyWith(stage: PhotoScanStage.requestingPermission);
    final bool granted = await library.requestAccess();
    if (!granted) {
      state = state.copyWith(stage: PhotoScanStage.permissionDenied);
      return;
    }

    final int total;
    try {
      total = await library.photoCount();
    } on Object {
      state = state.copyWith(
        stage: PhotoScanStage.failed,
        retryCount: state.retryCount + 1,
      );
      return;
    }

    if (total == 0) {
      state = state.copyWith(
        stage: PhotoScanStage.completed,
        total: 0,
        processed: 0,
      );
      return;
    }

    // 이어서 하는 경우 이미 읽은 지점부터 간다. 사진이 줄었으면 처음부터.
    final int from = state.processed <= total ? state.processed : 0;
    state = state.copyWith(
      stage: PhotoScanStage.scanning,
      total: total,
      processed: from,
    );

    final DistrictResolver resolver = await ref.read(
      districtResolverProvider.future,
    );
    // 이미 방문한 시군구는 다시 판정하지 않는다(R27).
    final List<MapCell> cells = await ref.read(mapCellsProvider.future);
    final Set<String> alreadyVisited = <String>{
      for (final MapCell c in cells)
        if (c.visited) ...c.districtCodes,
    };

    final Set<String> found = <String>{...state.resolvedCellCodes};
    int processed = from;
    int withCoordinates = state.foundCoordinates;

    while (processed < total) {
      if (_cancelled) {
        // 멈춘 자리를 남긴다 — 다음 start()가 여기서 이어 간다.
        state = state.copyWith(
          stage: PhotoScanStage.idle,
          processed: processed,
          foundCoordinates: withCoordinates,
          resolvedCellCodes: found.toList()..sort(),
        );
        return;
      }

      final int size = NationalMapConfig.photoScanBatchSize;
      final List<GeoPoint> raw;
      try {
        raw = await library.coordinatesOf(start: processed, count: size);
      } on Object {
        state = state.copyWith(
          stage: PhotoScanStage.failed,
          processed: processed,
          retryCount: state.retryCount + 1,
        );
        return;
      }

      withCoordinates += raw.length;
      processed = (processed + size) > total ? total : processed + size;

      // 한국 밖 제거 -> 격자 축약. 판정 횟수를 줄이는 최적화다(R25·R26).
      final List<GeoPoint> reduced = CoordinateReduction.reduce(raw);
      for (final GeoPoint p in reduced) {
        final String? code = resolver.districtAt(p)?.code;
        if (code == null) continue;
        if (alreadyVisited.contains(code)) continue;
        found.add(code);
      }

      state = state.copyWith(
        processed: processed,
        foundCoordinates: withCoordinates,
        resolvedCellCodes: found.toList()..sort(),
      );
    }

    // 판정 결과는 **확인을 거쳐야** 등록된다(R30).
    state = state.copyWith(
      stage: found.isEmpty
          ? PhotoScanStage.completed
          : PhotoScanStage.awaitingConfirmation,
      processed: total,
      foundCoordinates: withCoordinates,
      resolvedCellCodes: found.toList()..sort(),
    );
  }

  /// 진행 중인 스캔을 멈춘다. 처리 지점은 남는다(R28).
  void stop() => _cancelled = true;

  /// 사용자가 확인했다. 등록은 화면이 `VisitController`로 한다.
  void confirmed() =>
      state = state.copyWith(stage: PhotoScanStage.completed);

  /// 처음부터 다시 훑는다.
  void reset() {
    _cancelled = true;
    state = const PhotoScanProgress();
  }
}
