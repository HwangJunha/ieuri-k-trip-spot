import 'dart:async';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';

import '../model/cell_geometry.dart';
import '../model/coordinate_reduction.dart';
import '../model/district_resolver.dart';
import '../model/map_cell.dart';
import '../model/national_map_config.dart';
import '../../../common/log/app_log.dart';
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
  static final Logger _log = appLogger('PhotoScanController');

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
      // **설정에서 돌아오면 권한이 올라갔는지 본다**(2026-08-26).
      //
      // 설정으로 보내 접근을 넓혀도 돌아왔을 때 아무 일도 일어나지 않으면
      // 막다른 길이 된다 — 앱을 껐다 켜야 반영됐다. 돌아온 시점에 등급이
      // 넓어졌으면 스스로 다시 훑고, 그대로면 아무것도 하지 않는다.
      onRestart: _rescanIfAccessWidened,
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
    // 새 스캔이다 — 이전 등록의 가드가 남아 있으면 이번 결과를 등록하지 못한다.
    _registering = false;

    final PhotoLibraryService library = ref.read(photoLibraryServiceProvider);
    final PhotoScanCheckpointStore checkpoints = ref.read(
      photoScanCheckpointStoreProvider,
    );

    // 1) 권한(R31). 거부해도 오류가 아니다 — 안내만 하고 끝낸다(R32).
    state = state.copyWith(stage: PhotoScanStage.requestingPermission);
    final PhotoAccess access = await library.requestAccess();
    // 설정에서 돌아왔을 때의 비교 기준이다(`_rescanIfAccessWidened`).
    _lastKnownAccess = access;
    // **`PermissionController`를 지나지 않는 경로다.** `photo_manager`를 직접
    // 부르므로 여기 심지 않으면 사진 권한 결과가 통째로 빠진다.
    AppAnalytics.logEvent(AnalyticsEvents.permissionResult, <String, Object>{
      AnalyticsParams.permission: 'photo',
      // **`limited`를 따로 센다** — 허용/거부로만 뭉치면 "일부만 허용"이 얼마나
      // 흔한지 알 수 없고, 그것이 곧 "왜 몇 장만 훑였나"의 답이다.
      AnalyticsParams.granted: access.name,
    });
    if (access == PhotoAccess.denied) {
      state = state.copyWith(stage: PhotoScanStage.permissionDenied);
      return;
    }
    // **"일부만 허용"을 상태에 남긴다.** 훑는 흐름은 같지만 대상이 사진첩 전체가
    // 아니라는 것을 화면이 알려 줘야 한다.
    state = state.copyWith(limitedAccess: access == PhotoAccess.limited);

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
    //
    // **끝까지 훑은 상태면 처음부터 다시 한다**(실기기 확인 2026-08-26).
    // 완료 시 `processed = total`이 남는데, 그대로 이어받으면 `from == total`이
    // 되어 `while (processed < total)`이 한 번도 돌지 않는다 — **두 번째 실행부터
    // 아무것도 스캔하지 않고 "지도를 채웠어요"만 뜬다.** 사용자는 사진을 더
    // 찍었는데도 아무 반응이 없는 것으로 겪는다.
    //
    // 이어하기가 성립하는 조건은 [PhotoScanProgress.isResumable]이 이미 알고
    // 있다 — 중간에 멈춘 상태(`processed < total`)일 때만이다.
    final int from = state.isResumable && state.processed <= total
        ? state.processed
        : 0;
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
    //
    // **표시용 수도 이 표로 센다**(SPEC-0034 R5). 예전에는 이 변환 결과가
    // 낙관적 색칠에만 쓰이고 버려져, 시트는 시군구 코드 수를 세고 지도는 칸을
    // 칠했다 — 그래서 지도는 맞고 숫자만 틀렸다.
    final Map<String, String> cellIdOf = <String, String>{
      for (final MapCell c in cells)
        for (final String code in c.districtCodes) code: c.id,
    };

    // **처음부터 다시 훑으면 이전 결과를 이어받지 않는다.** 이어하기(`from > 0`)일
    // 때만 누적한다 — 안 그러면 이미 등록을 마친 코드를 다시 모아 보내게 된다.
    final bool resuming = from > 0;
    final Set<String> found = <String>{
      if (resuming) ...state.resolvedDistrictCodes,
    };
    // 사진에서 찾았으나 **이미 지도에 있던** 지역. 등록 대상은 아니지만 "몇 곳을
    // 확인했는가"를 말하려면 이것도 세야 한다. 시군구 코드로 모으고 셀 때 접는다.
    final Set<String> alreadyOnMap = <String>{};
    int processed = from;
    int withCoordinates = resuming ? state.foundCoordinates : 0;

    while (processed < total) {
      if (_cancelled) {
        // 멈춘 자리를 남긴다 — 다음 start()가 여기서 이어 간다.
        state = state.copyWith(
          stage: PhotoScanStage.idle,
          processed: processed,
          foundCoordinates: withCoordinates,
          resolvedDistrictCodes: found.toList()..sort(),
          newCellCount: foldToCellIds(found, cellIdOf).length,
        );
        await checkpoints.write(
          PhotoScanCheckpoint(
            processed: processed,
            total: total,
            foundCoordinates: withCoordinates,
            resolvedDistrictCodes: found.toList()..sort(),
          ),
        );
        return;
      }

      final int size = NationalMapConfig.photoScanBatchSize;
      final int batchStart = processed;
      final int batchEnd = (processed + size) > total
          ? total
          : processed + size;

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
        if (code == null) continue;
        // **이미 등록된 지역도 센다**(2026-08-26). 여기서 그냥 건너뛰면 "1장에서
        // 0곳을 찾았어요"가 되어 실패로 읽힌다 — 실제로는 좌표를 찾았고 그 지역이
        // 이미 지도에 있었을 뿐이다(사용자 지적).
        if (alreadyVisited.contains(code)) {
          alreadyOnMap.add(code);
          continue;
        }
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
        resolvedDistrictCodes: found.toList()..sort(),
        // 진행 중 문구가 쓰는 잠정값이다 — 칸 단위로 접어 센다(R5).
        newCellCount: foldToCellIds(found, cellIdOf).length,
      );

      // **배치마다 디스크에 적는다.** 홈 버튼을 눌러 앱이 정지·종료돼도 여기서
      // 이어 간다(R28). iOS가 백그라운드 실행을 막으므로 이것이 유일한 보험이다.
      await checkpoints.write(
        PhotoScanCheckpoint(
          processed: processed,
          total: total,
          foundCoordinates: withCoordinates,
          resolvedDistrictCodes: found.toList()..sort(),
        ),
      );
    }

    // 찾은 것이 있으면 확인 단계로 넘긴다. **화면이 곧바로 등록한다** —
    // 스캔을 사용자가 직접 시작했으므로 그 행위가 곧 동의라는 결정이다
    // (사용자 결정, 2026-08-22. 스펙 R30의 별도 확인 단계를 없앤다).
    //
    // 단계 자체는 남긴다 — 등록이 도는 동안 보여줄 상태가 필요하다.
    //
    // **칸으로 접은 뒤 신규에서 기존을 뺀다**(SPEC-0034 R6). 순서가 중요하다 —
    // 시군구 단위로 세면 같은 칸이 신규와 기존으로 갈려 이중 계상된다. 예컨대
    // 서울 강남구를 이미 방문했고 사진에서 서초구가 나오면, 둘은 같은 칸이므로
    // 새로 칠해지는 칸은 없는데 예전 셈으로는 신규 1 + 기존 1 = 2가 됐다.
    final Set<String> alreadyOnMapCells = foldToCellIds(alreadyOnMap, cellIdOf);
    final Set<String> newCells = foldToCellIds(
      found,
      cellIdOf,
    )..removeAll(alreadyOnMapCells);

    state = state.copyWith(
      stage: found.isEmpty
          ? PhotoScanStage.completed
          : PhotoScanStage.awaitingConfirmation,
      processed: total,
      foundCoordinates: withCoordinates,
      resolvedDistrictCodes: found.toList()..sort(),
      newCellCount: newCells.length,
      alreadyOnMapCellCount: alreadyOnMapCells.length,
      // 아직 등록 전이다 — 완료 문구가 쓸 수는 등록 응답이 정한다(R7).
      clearRegisteredCellCount: true,
    );
    // **무엇을 훑고 무엇이 걸러졌는지 남긴다**(2026-08-26). "왜 두 곳만
    // 찾았나"를 판단하려면 세 수가 다 필요하다 — 훑은 장수, 좌표가 있던 장수,
    // 그리고 새로 찾은 칸 수(이미 방문한 시군구는 R27에 따라 빠진다).
    _log.i(
      '사진 스캔 완료: 훑음 $total장 · 좌표 있음 $withCoordinates장 · '
      '새 칸 ${newCells.length}곳(시군구 ${found.length}개) · '
      '이미 있던 칸 ${alreadyOnMapCells.length}곳',
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

  /// 설정에서 돌아왔을 때 **사진 접근 등급이 넓어졌으면** 처음부터 다시 훑는다.
  ///
  /// 훑을 대상이 늘어났을 때만 의미가 있다 — 같은 사진을 다시 훑어야 결과는
  /// 같으므로, 등급이 그대로면 아무것도 하지 않는다.
  ///
  /// **`limitedAccess`가 아니라 등급 변화를 본다**(사용자 지적 2026-08-26).
  /// 예전에는 `state.limitedAccess`가 참일 때만 다시 훑었는데, 그러면 **거부에서
  /// 허용으로 바꾼 경우와 좌표를 못 찾고 끝난 경우가 통째로 빠진다.** 실제로
  /// "위치 정보가 있는 사진을 찾지 못했어요" 화면에서 설정만 바꾸고 돌아오면
  /// 화면이 그대로 굳어 있었다 — 그 화면에는 다시 채우기 버튼도 없어 앱을 껐다
  /// 켜는 수밖에 없었다.
  /// [_rescanIfAccessWidened]를 테스트에서 부르기 위한 진입점.
  ///
  /// 실제 계기는 `AppLifecycleListener.onRestart`라 위젯 없이는 흉내 낼 수 없다.
  @visibleForTesting
  Future<void> handleAppRestart() => _rescanIfAccessWidened();

  Future<void> _rescanIfAccessWidened() async {
    if (state.isRunning) return;

    final PhotoAccess access = await ref
        .read(photoLibraryServiceProvider)
        .currentAccess();
    final PhotoAccess? before = _lastKnownAccess;
    _lastKnownAccess = access;

    // 아직 한 번도 물어본 적 없으면 비교할 것이 없다 — 시작 자체를 사용자가 한다.
    if (before == null || !_widened(from: before, to: access)) return;

    _log.i('사진 접근이 ${before.name} → ${access.name}으로 넓어졌다 — 다시 훑는다');
    reset();
    _cancelled = false;
    await start();
  }

  /// 마지막으로 확인한 사진 접근 등급. 설정에서 돌아왔을 때 비교 기준이 된다.
  PhotoAccess? _lastKnownAccess;

  /// 접근 등급이 넓어졌는지. `denied < limited < granted` 순으로 본다.
  static bool _widened({required PhotoAccess from, required PhotoAccess to}) =>
      _accessRank(to) > _accessRank(from);

  static int _accessRank(PhotoAccess a) => switch (a) {
    PhotoAccess.denied => 0,
    PhotoAccess.limited => 1,
    PhotoAccess.granted => 2,
  };

  /// 진행 중인 스캔을 멈춘다. 처리 지점은 남는다(R28).
  void stop() => _cancelled = true;

  /// "일부만 허용"일 때 사진을 다시 고르게 한다(2026-08-26).
  ///
  /// 시스템 화면에서 사진을 더 고르면 **훑을 대상이 늘어난다.** 돌아온 뒤 스캔을
  /// 처음부터 다시 돌린다 — 이전 진행 지점은 예전 목록 기준이라 그대로 이어받으면
  /// 새로 고른 사진을 건너뛴다.
  Future<void> reselectPhotos() async {
    await ref.read(photoLibraryServiceProvider).presentLimitedPicker();
    // 진행 지점을 지운다. `isResumable`이 거짓이 되어 [start]가 처음부터 훑는다.
    state = state.copyWith(
      stage: PhotoScanStage.idle,
      processed: 0,
      total: 0,
      foundCoordinates: 0,
      resolvedDistrictCodes: const <String>[],
      newCellCount: 0,
      alreadyOnMapCellCount: 0,
      clearRegisteredCellCount: true,
    );
    await ref.read(photoScanCheckpointStoreProvider).clear();
    await start();
  }

  /// 등록 요청이 도는 중인지. **시트가 아니라 여기가 들고 있다**(2026-08-26).
  ///
  /// 예전에는 시트 파일의 전역 `bool`이었는데, 그것을 푸는 자리가 idle/failed
  /// 분기의 버튼뿐이었다. `awaitingConfirmation` 단계에는 그 버튼이 없으므로
  /// 플래그가 true로 남은 채 이 단계에 들어오면 **등록 콜백이 아예 걸리지 않고
  /// 스피너만 영원히 돈다** — 화면에 탈출구가 없다(실기기 확인).
  ///
  /// 상태와 가드를 한 곳에 두면 어긋날 수 없다. [beginRegistration]이 세우고
  /// [confirmed]·[registrationFailed]·[reset]이 푼다.
  bool _registering = false;

  /// 등록을 시작해도 되는지 묻고, 되면 표시한다.
  ///
  /// 리빌드마다 콜백이 걸리므로 이 가드가 없으면 등록이 여러 번 나간다.
  bool beginRegistration() {
    if (_registering) return false;
    _registering = true;
    return true;
  }

  /// 등록이 끝났다. 등록 자체는 화면이 `VisitController`로 한다.
  ///
  /// [updatedCellIds]는 서버가 **실제로 갱신했다고 알려준 칸**이다(SPEC-0034 R7).
  /// 완료 문구의 수가 여기서 나온다 — 지도에 칠해진 것과 정의상 일치하는 유일한
  /// 값이다. 로컬 추정([PhotoScanProgress.newCellCount])은 스캔 중에만 쓴다.
  void confirmed(Iterable<String> updatedCellIds) {
    _registering = false;
    // 갱신된 칸과 이미 있던 칸을 합친 것이 "이번 스캔이 확인한 곳"이다.
    // 서버가 갱신했다고 한 칸은 신규이므로 기존 집합과 겹치지 않는다.
    final int confirmedCells =
        updatedCellIds.toSet().length + state.alreadyOnMapCellCount;
    state = state.copyWith(
      stage: PhotoScanStage.completed,
      registeredCellCount: confirmedCells,
    );
  }

  /// 등록이 실패했다(2026-08-26).
  ///
  /// **이 창구가 없어서 스피너가 영원히 돌았다.** 화면이 `VisitController.record`를
  /// 부르는데 그것이 던지면 [confirmed]에 닿지 못하고, 단계가 `awaitingConfirmation`에
  /// 머물러 "N곳을 찾았어요" 아래 스피너만 계속 돈다(실기기 확인).
  ///
  /// 스캔 결과는 그대로 두고 단계만 실패로 돌린다 — 다시 찾을 필요 없이 등록만
  /// 다시 시도하면 된다.
  void registrationFailed() {
    _registering = false;
    state = state.copyWith(
      stage: PhotoScanStage.failed,
      retryCount: state.retryCount + 1,
      // **실패했으면 수를 표시하지 않는다**(SPEC-0034 R7). 등록이 실패했는데
      // "N곳을 확인했어요"가 뜨면 거짓이다.
      clearRegisteredCellCount: true,
    );
  }

  /// 처음부터 다시 훑는다.
  void reset() {
    _cancelled = true;
    _registering = false;
    state = const PhotoScanProgress();
    // 디스크에 남은 지점도 지운다 — 안 지우면 다시 켰을 때 되살아난다.
    unawaited(ref.read(photoScanCheckpointStoreProvider).clear());
  }
}
