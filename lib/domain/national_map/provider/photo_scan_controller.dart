import 'dart:async';

import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/cell_geometry.dart';
import '../model/coordinate_reduction.dart';
import '../model/district_resolver.dart';
import '../model/map_cell.dart';
import '../model/national_map_config.dart';
import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../model/photo_scan_progress.dart';
import '../repository/photo_scan_checkpoint_store.dart';
import '../service/photo_library_service.dart';
import 'district_resolver_provider.dart';
import 'national_map_providers.dart';
import 'photo_scan_checkpoint_provider.dart';
import '../../auth/provider/session_scope.dart';

part 'photo_scan_controller.g.dart';

@riverpod
PhotoLibraryService photoLibraryService(Ref ref) => const PhotoLibraryService();

/// 사진첩을 훑어 방문한 시군구를 찾는다(R25~R30).
///
/// **좌표는 기기를 떠나지 않는다.** 판정까지 로컬에서 끝내고 서버에는 시군구
/// 코드만 보낸다.
///
/// 흐름:
/// ```
/// 권한 요청 -> 배치로 좌표 읽기 -> 한국 밖 버림 -> 1km 격자 축약
///          -> 로컬 판정 -> 이미 방문한 시군구 제외 -> recordVisits
/// ```
///
/// 스펙 R30은 등록 전 별도 확인을 요구했으나 **없앴다**(사용자 결정,
/// 2026-08-22) — 스캔을 사용자가 직접 시작하므로 그 행위가 곧 동의다.
///
/// 배치마다 상태를 갱신해 중단·재개할 수 있다(R28). 스캔 중에도 앱의 다른 기능을
/// 쓸 수 있다(R29) — 이 컨트롤러는 UI를 막지 않는다.
@Riverpod(keepAlive: true)
class PhotoScanController extends _$PhotoScanController {
  @override
  PhotoScanProgress build() {
    // 로그아웃하면 스캔 결과를 버린다 — 이전 사용자의 사진에서 나온 지역이다.
    if (!ref.watchSignedIn()) return const PhotoScanProgress();

    // 앱이 내려갈 때 스캔을 **스스로** 멈춘다.
    //
    // iOS는 백그라운드 실행을 허락하지 않아 어차피 곧 정지된다. 그냥 정지당하면
    // 배치 중간에 끊기지만, 여기서 멈추면 루프가 중단 지점을 온전히 적고 끝낸다.
    //
    // **시트가 아니라 여기에 둔다** — 시트는 모달이라 닫으면 사라지는데 스캔은
    // `keepAlive`라 계속 돈다. 시트에 두면 닫고 홈으로 나간 경우를 놓친다.
    final AppLifecycleListener listener = AppLifecycleListener(
      onPause: () {
        if (state.isRunning) stop();
      },
    );
    ref.onDispose(listener.dispose);

    // 앱이 죽었어도 이어 갈 수 있게 디스크에 적어 둔 지점을 되살린다(R28).
    // 지점이 메모리에만 있으면 사진이 많은 사용자는 매번 처음부터 훑게 된다.
    final PhotoScanCheckpoint? saved = ref
        .read(photoScanCheckpointStoreProvider)
        .read();
    return saved?.toProgress() ?? const PhotoScanProgress();
  }

  /// 스캔을 멈추라는 신호. `stop()`이 세우고 루프가 본다.
  bool _cancelled = false;

  /// 판정 몇 건마다 진행률을 올릴지. 너무 촘촘하면 리빌드가 판정보다 비싸진다.
  static const int _progressStride = 8;

  /// 스캔을 시작하거나 이어서 한다(R28).
  ///
  /// 이미 돌고 있으면 아무 일도 하지 않는다.
  Future<void> start() async {
    if (state.isRunning) return;
    _cancelled = false;

    final PhotoLibraryService library = ref.read(photoLibraryServiceProvider);
    final PhotoScanCheckpointStore checkpoints = ref.read(
      photoScanCheckpointStoreProvider,
    );

    // 1) 권한(R31). 거부해도 오류가 아니다 — 안내만 하고 끝낸다(R32).
    state = state.copyWith(stage: PhotoScanStage.requestingPermission);
    final bool granted = await library.requestAccess();
    // **`PermissionController`를 지나지 않는 경로다.** `photo_manager`를 직접
    // 부르므로 여기 심지 않으면 사진 권한 결과가 통째로 빠진다.
    AppAnalytics.logEvent(AnalyticsEvents.permissionResult, <String, Object>{
      AnalyticsParams.permission: 'photo',
      AnalyticsParams.granted: granted,
    });
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

    // 시군구 코드 -> 칸 id. 스캔 도중 지도를 칠하려면 이 변환이 필요하다 —
    // 판정 결과는 시군구 코드인데 지도는 칸 id로 칠한다.
    final Map<String, String> cellIdOf = <String, String>{
      for (final MapCell c in cells)
        for (final String code in c.districtCodes) code: c.id,
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
        await checkpoints.write(
          PhotoScanCheckpoint(
            processed: processed,
            total: total,
            foundCoordinates: withCoordinates,
            resolvedCellCodes: found.toList()..sort(),
          ),
        );
        return;
      }

      final int size = NationalMapConfig.photoScanBatchSize;
      final int batchStart = processed;
      final int batchEnd = (processed + size) > total ? total : processed + size;

      // **사진 한 장씩 읽으며 진행률을 올린다.**
      //
      // 좌표는 장당 비동기 호출(`latlngAsync`)로 읽는데 그 대기가 스캔 시간의
      // 대부분이다. 200장을 다 모아서 받으면 그동안 막대가 멈춰 있어 계단처럼
      // 뛴다 — 실기기에서 확인한 문제다. 판정은 순식간이라 여기가 진짜 병목이다.
      final List<GeoPoint> raw = <GeoPoint>[];
      int read = 0;
      try {
        await for (final PhotoCoordinate c in library.streamCoordinates(
          start: batchStart,
          count: batchEnd - batchStart,
        )) {
          read++;
          if (c.point != null) {
            raw.add(c.point!);
            withCoordinates++;
          }

          // 갱신은 몇 장에 한 번이면 충분하다 — 매 장마다 리빌드하면 읽기보다
          // 그리기가 비싸진다.
          if (read % _progressStride == 0) {
            state = state.copyWith(
              processed: batchStart + read,
              foundCoordinates: withCoordinates,
            );
          }

          if (_cancelled) break;
        }
      } on Object {
        state = state.copyWith(
          stage: PhotoScanStage.failed,
          processed: processed,
          retryCount: state.retryCount + 1,
        );
        return;
      }

      // 스트림이 한 장도 못 준 채 끝났다. 사진이 지워졌거나 접근이 막힌 것이라
      // 여기서 멈춘다 — 안 그러면 같은 지점을 무한히 다시 읽는다.
      if (read == 0) {
        processed = total;
        break;
      }
      processed = batchStart + read;

      // 한국 밖 제거 -> 격자 축약. 판정 횟수를 줄이는 최적화다(R25·R26).
      final Set<String> newCellIds = <String>{};
      for (final GeoPoint p in CoordinateReduction.reduce(raw)) {
        final String? code = resolver.districtAt(p)?.code;
        if (code == null || alreadyVisited.contains(code)) continue;
        // 이번에 **새로** 찾은 것만 모은다. 이미 찾은 코드를 다시 칠할 필요는 없다.
        if (found.add(code)) {
          final String? cellId = cellIdOf[code];
          if (cellId != null) newCellIds.add(cellId);
        }
      }

      // **찾는 즉시 지도를 칠한다**(R29). 등록 요청은 여전히 끝날 때 한 번만
      // 보낸다 — 이건 화면만 앞당기는 낙관적 표시다. 서버가 거절하면 스캔이
      // 끝날 때의 응답으로 되돌아온다.
      if (newCellIds.isNotEmpty) {
        ref
            .read(mapCellsProvider.notifier)
            .setVisitedOptimistically(newCellIds, visited: true);
      }

      state = state.copyWith(
        processed: processed,
        foundCoordinates: withCoordinates,
        resolvedCellCodes: found.toList()..sort(),
      );

      // **배치마다 디스크에 적는다.** 홈 버튼을 눌러 앱이 정지·종료돼도 여기서
      // 이어 간다(R28). iOS가 백그라운드 실행을 막으므로 이것이 유일한 보험이다.
      await checkpoints.write(
        PhotoScanCheckpoint(
          processed: processed,
          total: total,
          foundCoordinates: withCoordinates,
          resolvedCellCodes: found.toList()..sort(),
        ),
      );
    }

    // 찾은 것이 있으면 확인 단계로 넘긴다. **화면이 곧바로 등록한다** —
    // 스캔을 사용자가 직접 시작했으므로 그 행위가 곧 동의라는 결정이다
    // (사용자 결정, 2026-08-22. 스펙 R30의 별도 확인 단계를 없앤다).
    //
    // 단계 자체는 남긴다 — 등록이 도는 동안 보여줄 상태가 필요하다.
    state = state.copyWith(
      stage: found.isEmpty
          ? PhotoScanStage.completed
          : PhotoScanStage.awaitingConfirmation,
      processed: total,
      foundCoordinates: withCoordinates,
      resolvedCellCodes: found.toList()..sort(),
    );
    // **좌표가 있던 사진 수를 센다.** 훑은 총량(`total`)은 사진첩 크기에 좌우돼
    // 기능 사용량을 나타내지 못하고, 찾아낸 지역 수는 아래 등록 이벤트가 센다.
    AppAnalytics.logEvent(AnalyticsEvents.nationalMapPhotoAdd, <String, Object>{
      AnalyticsParams.photoCount: withCoordinates,
    });
    // 끝까지 훑었으니 중단 지점은 필요 없다. 남겨 두면 다음에 켰을 때
    // "이어하기"가 뜬다.
    await checkpoints.clear();
  }

  /// 진행 중인 스캔을 멈춘다. 처리 지점은 남는다(R28).
  void stop() => _cancelled = true;

  /// 등록이 끝났다. 등록 자체는 화면이 `VisitController`로 한다.
  void confirmed() =>
      state = state.copyWith(stage: PhotoScanStage.completed);

  /// 등록이 실패했다(2026-08-26).
  ///
  /// **이 창구가 없어서 스피너가 영원히 돌았다.** 화면이 `VisitController.record`를
  /// 부르는데 그것이 던지면 [confirmed]에 닿지 못하고, 단계가 `awaitingConfirmation`에
  /// 머물러 "N곳을 찾았어요" 아래 스피너만 계속 돈다(실기기 확인).
  ///
  /// 스캔 결과는 그대로 두고 단계만 실패로 돌린다 — 다시 찾을 필요 없이 등록만
  /// 다시 시도하면 된다.
  void registrationFailed() => state = state.copyWith(
    stage: PhotoScanStage.failed,
    retryCount: state.retryCount + 1,
  );

  /// 처음부터 다시 훑는다.
  void reset() {
    _cancelled = true;
    state = const PhotoScanProgress();
    // 디스크에 남은 지점도 지운다 — 안 지우면 다시 켰을 때 되살아난다.
    unawaited(ref.read(photoScanCheckpointStoreProvider).clear());
  }
}
