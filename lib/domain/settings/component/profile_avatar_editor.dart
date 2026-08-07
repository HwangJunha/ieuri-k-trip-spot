import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/profile_image_upload.dart';
import '../provider/profile_image_controller.dart';
import '../provider/profile_photo_picker.dart';

/// 아바타 + 카메라 배지 + "사진 변경"·"사진 삭제"(SPEC-0011 R6, 디자인 §3).
///
/// **교체와 제거를 나란히, 그러나 다르게 보여준다** — 제거는 별도 서버 동작
/// (`removeProfileImage`)이고 되돌릴 수 없으므로 error 색 텍스트 버튼이다.
///
/// **이미지가 없으면 제거를 그리지 않는다** — 지울 것이 없는데 버튼이 있으면 눌러
/// 보게 되고, 서버는 그때 실패로 답한다.
class ProfileAvatarEditor extends ConsumerWidget {
  const ProfileAvatarEditor({super.key, required this.profileImageUrl});

  /// 현재 프로필 이미지 URL. null이면 기본 아바타를 그린다.
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ProfileImageState image = ref.watch(profileImageControllerProvider);

    // 성공·실패는 스낵바로만 알린다 — 화면에 남기면 다시 들어왔을 때 지난 결과가
    // 붙어 있다.
    ref.listen<ProfileImageState>(profileImageControllerProvider, (
      ProfileImageState? previous,
      ProfileImageState next,
    ) {
      final String? message = switch (next) {
        ProfileImageState(confirmedKey: final String _) =>
          l10n.profilePhotoUpdated,
        ProfileImageState(removed: true) => l10n.profilePhotoRemoved,
        ProfileImageState(failure: final Object _) => l10n.profilePhotoFailed,
        _ => null,
      };
      if (message == null) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    });

    return Column(
      children: <Widget>[
        _Avatar(imageUrl: profileImageUrl, busy: image.isBusy),
        const SizedBox(height: 12),
        if (image.isBusy)
          Text(
            l10n.profilePhotoUploading,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () => _pickAndReplace(context, ref, l10n),
                child: Text(l10n.profilePhotoChange),
              ),
              if (profileImageUrl != null)
                TextButton(
                  onPressed: ref
                      .read(profileImageControllerProvider.notifier)
                      .remove,
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  child: Text(l10n.profilePhotoRemove),
                ),
            ],
          ),
      ],
    );
  }

  /// 사진을 고른 뒤 3단계 교체를 시작한다.
  ///
  /// **고르는 일과 올리는 일을 나눠 둔다** — 컨트롤러가 바이트만 받으므로 picker 없이
  /// 테스트되고(설계 §9), 여기서는 취소·미지원 형식만 걸러 낸다.
  Future<void> _pickAndReplace(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final ProfileImageBytes? picked = await ref.read(
      profilePhotoPickerProvider,
    )();
    if (picked == null) {
      // 취소했거나 지원하지 않는 형식이다. 취소를 오류로 알리지 않도록 화면이
      // 살아 있을 때만, 그리고 조용히 안내한다.
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.profilePhotoUnavailable)));
      }
      return;
    }
    await ref.read(profileImageControllerProvider.notifier).replace(picked);
  }
}

/// 원형 아바타와 카메라 배지. 진행 중이면 배지 자리에 스피너를 둔다 — 버튼이 사라진
/// 동안 아무 반응이 없으면 멈춘 것처럼 보인다.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl, required this.busy});

  final String? imageUrl;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 104,
      height: 104,
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 48,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            // `foregroundImage`는 실패 시 child로 떨어져 기본 아이콘이 남는다 —
            // 개발 환경에서 404가 정상이라 레이아웃이 흔들리면 안 된다.
            foregroundImage: imageUrl == null ? null : NetworkImage(imageUrl!),
            child: Icon(
              Icons.person,
              size: 44,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: busy
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : Icon(
                      Icons.photo_camera,
                      size: 16,
                      color: theme.colorScheme.onPrimary,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
