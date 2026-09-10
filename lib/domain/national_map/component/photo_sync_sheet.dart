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

    // **제목과 본문을 stage에서 파생시킨다**(SPEC-0034 R9). 예전에는 stage와
    // 무관하게 늘 같은 키를 그려, 스캔을 마치고 다시 열어도 "찾아요"라는 예고가
    // 남았다.
    final bool done = progress.stage == PhotoScanStage.completed;
    final String? body = _bodyOf(progress, l10n);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          done ? l10n.photoSyncTitleDone : l10n.photoSyncTitle,
          style: theme.textTheme.titleLarge,
        ),
        // **제목 바로 아래, 모든 단계에서**(사용자 결정 2026-09-10). 본문 속 한
        // 문장으로 두면 읽히지 않는다 — "사진으로 채우기"를 보는 순간 사진이
        // 나가지 않는다는 것이 같이 보여야 한다.
        const SizedBox(height: 12),
        _NoUploadNotice(l10n: l10n),
        if (body != null) ...<Widget>[
          const SizedBox(height: 12),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 20),
        _Content(progress: progress, l10n: l10n),
      ],
    );
  }

  /// stage별 본문. null이면 본문을 그리지 않는다.
  ///
  /// **스캔 중에는 본문이 없다** — 진행 표시가 그 자리를 차지하므로 예고 문구를
  /// 겹쳐 두면 시트만 길어진다.
  static String? _bodyOf(PhotoScanProgress progress, AppLocalizations l10n) =>
      switch (progress.stage) {
        PhotoScanStage.completed => l10n.photoSyncBodyDone,
        PhotoScanStage.scanning ||
        PhotoScanStage.requestingPermission ||
        PhotoScanStage.awaitingConfirmation => null,
        // 이어하기가 가능하면 중단 지점부터 간다는 것을 먼저 말한다.
        PhotoScanStage.idle || PhotoScanStage.failed =>
          progress.isResumable ? l10n.photoSyncBodyResume : l10n.photoSyncBody,
        PhotoScanStage.permissionDenied => l10n.photoSyncBody,
      };
}

/// "사진은 서버에 전송하지 않아요"(SPEC-0034 R8).
///
/// 시트의 다른 어떤 문구보다 먼저 눈에 들어와야 한다 — 사용자가 걱정하는 것이
/// 바로 이것이고, 본문 안에 섞여 있던 동안은 와닿지 않았다(사용자 지적
/// 2026-09-10). 그래서 본문과 같은 회색 글자가 아니라 색 있는 상자에 아이콘을
/// 붙여 따로 둔다.
///
/// **채운 빨강은 쓰지 않는다.** `primaryContainer`로 칠했더니 아래 "시작하기"
/// 버튼과 같은 색이라 버튼이 둘로 보였다(사용자 지적, 같은 날). 연한 틴트
/// (`secondaryContainer`)에 짙은 글자로 두면 시트 바탕과 어우러지면서도 글자는
/// 여전히 도드라진다.
class _NoUploadNotice extends StatelessWidget {
  const _NoUploadNotice({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.cloud_off_outlined,
            size: 20,
            color: colors.onSecondaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.photoSyncNoUploadNotice,
              style: text.titleSmall?.copyWith(
                color: colors.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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
            // **칸 단위로 센다**(SPEC-0034 R5). 시군구 코드 수를 세면 서울
            // 3개 구가 "3곳"이 되는데 칠해지는 칸은 하나다. 잠정값임은 "지금까지"가
            // 드러낸다(R7).
            if (progress.newCellCount > 0) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                l10n.photoSyncFoundSoFar(progress.newCellCount),
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
          _log.i('방문 등록 시작: 시군구 ${progress.resolvedDistrictCodes.length}개');
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
              // 등록 중이라 아직 응답이 없다 — 로컬 추정을 쓴다(R5).
              l10n.photoSyncFound(progress.newCellCount),
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
            // **수의 근거는 등록 응답이다**(SPEC-0034 R7). 서버가 실제로 갱신한
            // 칸이라 지도에 칠해진 것과 정의상 일치한다.
            //
            // **등록이 실패했으면 수를 아예 말하지 않는다** — 실패했는데
            // "N곳을 확인했어요"가 뜨면 거짓이다. 그래서 0이 아니라 null이다.
            if (!progress.finishedWithoutCoordinates &&
                progress.registeredCellCount != null) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                // **훑은 총 장수와 확인한 칸 수만 말한다**(2026-08-26).
                // 좌표가 있던 장수나 이미 있던 지역 수까지 세는 것은 사용자가
                // 궁금해하지 않는 내부 사정이다 — 사용자 지적.
                l10n.photoSyncSummary(
                  progress.total,
                  progress.registeredCellCount!,
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
    // 등록 요청은 **시군구 코드**를 보낸다 — 서버가 시군구 단위로 저장한다.
    final List<String> codes = progress.resolvedDistrictCodes;
    final List<String> updatedCellIds;
    try {
      // 사진이 몇 장이든 요청은 1회다 — 판정 결과가 시군구 코드로 축약돼 있다.
      updatedCellIds = await ref
          .read(visitControllerProvider.notifier)
          .record(codes);
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
    //
    // **응답이 알려준 갱신 칸을 넘긴다**(SPEC-0034 R7). 완료 문구의 수가
    // 여기서 나온다 — 로컬 추정이 아니라 서버가 실제로 칠한 칸이다.
    _log.i('방문 등록 성공: 시군구 ${codes.length}개 → 칸 ${updatedCellIds.length}곳');
    controller.confirmed(updatedCellIds);
  }
}
