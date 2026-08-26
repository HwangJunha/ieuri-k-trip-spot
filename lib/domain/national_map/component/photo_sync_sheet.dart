import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../common/permission/component/permission_blocked_notice.dart';
import '../../../common/permission/model/permission_kind.dart';
import '../../../common/log/app_log.dart';
import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/photo_scan_progress.dart';
import '../provider/photo_scan_controller.dart';
import '../provider/visit_controller.dart';
import 'map_sheet.dart';

/// 사진 동기화 시트를 연다(R29·R30).
///
/// 하단 탭에 가리지 않도록 `showMapSheet`을 쓴다 — 직접 `showModalBottomSheet`을
/// 부르면 버튼이 탭 바 뒤로 들어간다.
Future<void> showPhotoSyncSheet(BuildContext context) =>
    showMapSheet<void>(context, builder: (_) => const PhotoSyncSheet());

/// 사진첩을 훑어 방문 지역을 찾는 시트.
///
/// **스캔 중에도 시트를 닫고 앱을 쓸 수 있다**(R29) — 진행 상태는 provider가
/// 들고 있어 다시 열면 이어서 보인다.
class PhotoSyncSheet extends ConsumerWidget {
  const PhotoSyncSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final PhotoScanProgress progress = ref.watch(photoScanControllerProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.photoSyncTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          l10n.photoSyncBody,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        _Content(progress: progress, l10n: l10n),
      ],
    );
  }
}

class _Content extends ConsumerWidget {
  static final Logger _log = appLogger('PhotoSyncSheet');

  const _Content({required this.progress, required this.l10n});

  final PhotoScanProgress progress;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final PhotoScanController controller = ref.read(
      photoScanControllerProvider.notifier,
    );

    switch (progress.stage) {
      case PhotoScanStage.idle:
      case PhotoScanStage.failed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (progress.stage == PhotoScanStage.failed)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.photoSyncFailed,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            FilledButton(
              onPressed: controller.start,
              child: Text(
                progress.isResumable
                    ? l10n.photoSyncResume
                    : l10n.photoSyncStart,
              ),
            ),
          ],
        );

      case PhotoScanStage.requestingPermission:
        return const Center(child: CircularProgressIndicator());

      case PhotoScanStage.permissionDenied:
        // **오류가 아니다**(R31·R32) — 안내만 하고 다른 기능은 그대로 쓴다.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(l10n.photoSyncPermissionDenied),
            const SizedBox(height: 12),
            const PermissionBlockedNotice(kind: PermissionKind.photos),
          ],
        );

      case PhotoScanStage.scanning:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress.ratio,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.photoSyncProgress(progress.processed, progress.total),
              style: theme.textTheme.bodySmall,
            ),
            if (progress.resolvedCellCodes.isNotEmpty) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                l10n.photoSyncFoundSoFar(progress.resolvedCellCodes.length),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: controller.stop,
              child: Text(l10n.photoSyncStop),
            ),
          ],
        );

      case PhotoScanStage.awaitingConfirmation:
        // **묻지 않고 바로 등록한다**(사용자 결정, 2026-08-22). 스캔을 직접
        // 시작한 것이 곧 동의라고 본다 — 한 번 더 묻는 것은 군더더기다.
        //
        // build 중에 상태를 바꿀 수 없으므로 프레임 뒤로 미룬다.
        //
        // **한 번만 보낸다.** 리빌드마다 콜백이 걸리므로 가드가 없으면 등록이
        // 여러 번 나간다(멱등이라 서버는 버티지만 요청이 낭비된다).
        // 가드는 **컨트롤러가 들고 있다.** 시트의 전역 플래그였을 때는 푸는 자리가
        // idle/failed 버튼뿐이라, 그대로 이 단계에 들어오면 등록이 영영 안 걸렸다.
        if (controller.beginRegistration()) {
          _log.i('방문 등록 시작: ${progress.resolvedCellCodes.length}곳');
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // **`finally`여야 한다.** 순차로 두면 등록이 던졌을 때 플래그가 true로
            // 박혀 재시도조차 막힌다 — `_register`가 예외를 삼키게 됐지만, 그
            // 안에서 또 다른 실패가 나도 여기서는 반드시 풀린다.
            await _register(ref, controller);
          });
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l10n.photoSyncFound(progress.resolvedCellCodes.length),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
            // **갇히지 않게 한다**(2026-08-26). 등록이 어떤 이유로든 끝나지
            // 않으면 이 단계에는 누를 것이 하나도 없어 앱을 껐다 켜는 수밖에
            // 없었다 — 실기기에서 그 상태가 나왔다. 스캔 결과는 남으므로
            // 닫았다 다시 열어 재시도할 수 있다.
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(l10n.commonClose),
            ),
          ],
        );

      case PhotoScanStage.completed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              // 좌표가 하나도 없는 것은 오류가 아니다(R32).
              progress.finishedWithoutCoordinates
                  ? l10n.photoSyncNoCoordinates
                  : l10n.photoSyncDone,
            ),
            // **결과를 수치로 밝힌다**(2026-08-26). "지도를 채웠어요"만 있으면
            // 몇 장을 훑어 몇 곳을 찾았는지 알 수 없어, 스캔이 제대로 돌았는지
            // 사용자가 판단할 수 없다 — 실제로 두 곳만 칠해진 것을 보고 "갤러리가
            // 전부 스캔되지 않은 것 같다"는 의심이 나왔다.
            if (!progress.finishedWithoutCoordinates) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                // **훑은 총 장수와 채운 지역 수만 말한다**(2026-08-26).
                // 좌표가 있던 장수나 이미 있던 지역 수까지 세는 것은 사용자가
                // 궁금해하지 않는 내부 사정이다 — 사용자 지적.
                //
                // 지역 수는 새로 찾은 곳과 이미 있던 곳을 합친다. 사진에서 찾아낸
                // 지역이 곧 "채운" 것이고, 그중 무엇이 이미 있었는지는 구분할
                // 이유가 없다.
                l10n.photoSyncSummary(
                  progress.total,
                  progress.resolvedCellCodes.length + progress.alreadyOnMapCount,
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            // **"일부만 허용"이면 그 사실을 밝힌다**(2026-08-26). 이 상태에서는
            // 사진첩 전체가 아니라 사용자가 고른 몇 장만 훑는데, 말해 주지 않으면
            // "왜 3장만 훑었지"에서 멈춘다 — 실기기에서 그 질문이 나왔다.
            if (progress.limitedAccess) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                // **설정 경로는 플랫폼마다 다르다**(사용자 지적 2026-08-26).
                // "설정 > 앱 > K-Trip Spot > 사진 > 전체 접근"은 iOS 경로인데
                // 안드로이드에도 그대로 나왔다.
                //
                // 안드로이드 경로는 **삼성 갤럭시(One UI) 기준이다**(사용자 결정
                // 2026-08-26) — 주 사용자층이 갤럭시다. 다른 제조사는 메뉴 이름이
                // 조금씩 다르지만, 아래 "설정에서 전체 허용" 버튼이 설정 화면을
                // 직접 열어 주므로 길을 잃지는 않는다.
                Platform.isIOS
                    ? l10n.photoSyncLimitedNotice
                    : l10n.photoSyncLimitedNoticeAndroid,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: controller.reselectPhotos,
                child: Text(l10n.photoSyncSelectMore),
              ),
              // **재선택만으로는 "일부만 허용"을 벗어날 수 없다**(2026-08-26).
              // `presentLimited`는 고른 사진 목록을 바꿀 뿐 권한 등급은 그대로다
              // — 전체 허용으로 올리는 길은 시스템 설정뿐이다.
              //
              // `PermissionBlockedNotice`는 쓸 수 없다: `needsSettings`가
              // `PermissionController`를 지난 상태에서만 서는데, 사진 스캔은
              // `photo_manager`를 직접 부르는 별도 경로라 그 상태가 비어 있다.
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () =>
                    ref.read(photoLibraryServiceProvider).openSettings(),
                child: Text(l10n.photoSyncAllowAll),
              ),
            ],
            const SizedBox(height: 16),
            // **다시 채울 수 있어야 한다**(2026-08-26). 완료 뒤에 시트를 다시 열면
            // 결과 문구만 남아 이 기능을 두 번째로 쓸 방법이 없었다 — 사진을 더
            // 찍은 사용자가 매번 다시 돌릴 수 있어야 한다(사용자 지적).
            //
            // 언제 보여 줄지는 [PhotoScanProgress.canRescan]이 정한다.
            if (progress.canRescan) ...<Widget>[
              FilledButton(
                onPressed: controller.start,
                child: Text(l10n.photoSyncRescan),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(l10n.commonClose),
            ),
          ],
        );
    }
  }

  Future<void> _register(WidgetRef ref, PhotoScanController controller) async {
    final List<String> codes = progress.resolvedCellCodes;
    try {
      // 사진이 몇 장이든 요청은 1회다 — 판정 결과가 시군구 코드로 축약돼 있다.
      await ref.read(visitControllerProvider.notifier).record(codes);
    } on Object catch (error, stackTrace) {
      // **던지게 두면 스피너가 영원히 돈다**(실기기 확인 2026-08-26).
      // `record`가 던지면 아래 `confirmed()`에 닿지 못해 단계가
      // `awaitingConfirmation`에 머물고, "N곳을 찾았어요" 아래 스피너만 계속
      // 돌면서 재시도 수단도 없다.
      //
      // 스캔 결과는 그대로 두고 실패 단계로 보낸다 — 다시 찾을 필요 없이 등록만
      // 다시 누르면 된다.
      //
      // **타입과 스택을 남긴다.** 조용히 삼키면 서버 응답이 성공인데 화면만
      // 실패인 상황에서 원인을 찾을 길이 없다 — 실제로 그랬다(2026-08-26).
      // 서버 message는 PII를 담을 수 있어 넘기지 않는다(POL-013).
      _log.w('방문 등록 실패: ${error.runtimeType}', stackTrace: stackTrace);
      // **컨트롤러를 부르는 것까지 실패할 수 있다.** `photoScanController`는
      // keepAlive라 살아 있지만, 여기서 또 던지면 단계가 `awaitingConfirmation`에
      // 박혀 스피너가 영원히 돈다 — 원래 고치려던 그 증상으로 되돌아간다.
      try {
        controller.registrationFailed();
      } on Object catch (e) {
        _log.e('실패 단계 전환마저 실패: ${e.runtimeType}');
      }
      return;
    }
    // **호출부에 심는다.** `VisitController.record`는 사진 경로와 현재 위치 경로가
    // 합류하는 자리라, 거기 심으면 둘을 구분할 수 없다.
    AppAnalytics.logEvent(
      AnalyticsEvents.nationalMapRegionAdd,
      <String, Object>{AnalyticsParams.from: 'photo'},
    );
    // 시트를 닫지 않는다 — 완료 문구를 보고 사용자가 닫는다.
    _log.i('방문 등록 성공: ${codes.length}곳');
    controller.confirmed();
  }
}
