import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/permission/component/permission_blocked_notice.dart';
import '../../../common/permission/model/permission_kind.dart';
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
              onPressed: () => controller.start(),
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
        // 확인 없이 자동 등록하지 않는다(R30).
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l10n.photoSyncFound(progress.resolvedCellCodes.length),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.photoSyncConfirmBody,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.reset();
                      Navigator.of(context).maybePop();
                    },
                    child: Text(l10n.commonCancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _register(context, ref, controller),
                    child: Text(l10n.photoSyncRegister),
                  ),
                ),
              ],
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
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(l10n.commonClose),
            ),
          ],
        );
    }
  }

  Future<void> _register(
    BuildContext context,
    WidgetRef ref,
    PhotoScanController controller,
  ) async {
    final List<String> codes = progress.resolvedCellCodes;
    // 사진이 몇 장이든 요청은 1회다 — 판정 결과가 시군구 코드로 축약돼 있다.
    await ref.read(visitControllerProvider.notifier).record(codes);
    controller.confirmed();
    if (context.mounted) Navigator.of(context).maybePop();
  }
}
