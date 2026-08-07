import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../provider/account_deletion_controller.dart';

/// 탈퇴 확인 화면(SPEC-0011 R16).
///
/// **확인 단계를 반드시 거친다.** 되돌릴 수 없다는 것과 삭제되는 대상을 명시하고,
/// **취소가 기본 동작이 되도록** 배치한다 — 취소를 위에 채워진 버튼으로, 파괴적
/// 동작은 아래에 약한 텍스트 버튼으로 둔다(디자인 참조 §8).
///
/// 성공 후 정리는 [AccountDeletionController]가 한다 — 로그아웃과 같은 정리를
/// 거쳐 토큰 갱신 시도가 남지 않게 한다. 로그인 화면으로의 이동은 라우터
/// 리다이렉트가 하므로 여기서 직접 내비게이션하지 않는다.
class AccountDeletionScreen extends ConsumerWidget {
  const AccountDeletionScreen({super.key});

  static String get routeName => 'settings-delete-account';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<void> deletion = ref.watch(
      accountDeletionControllerProvider,
    );
    final bool busy = deletion.isLoading;

    ref.listen(accountDeletionControllerProvider, (
      AsyncValue<void>? previous,
      AsyncValue<void> next,
    ) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.deleteAccountFailed)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.deleteAccountTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const SizedBox(height: 16),
            Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.deleteAccountHeadline,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.deleteAccountIntro,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _DeletionItem(
              icon: Icons.forum_outlined,
              label: l10n.deleteAccountItemPosts,
            ),
            _DeletionItem(
              icon: Icons.favorite_border,
              label: l10n.deleteAccountItemLikes,
            ),
            _DeletionItem(
              icon: Icons.person_outline,
              label: l10n.deleteAccountItemProfile,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.deleteAccountCaution,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // 취소가 시각적으로 우세하다(R16) — 기본 동작이 안전한 쪽이어야 한다.
            FilledButton(
              onPressed: busy ? null : () => context.pop(),
              child: Text(l10n.deleteAccountCancel),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: busy
                  ? null
                  : () => ref
                        .read(accountDeletionControllerProvider.notifier)
                        .deleteAccount(),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.deleteAccountConfirm),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeletionItem extends StatelessWidget {
  const _DeletionItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
