import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/model/terms_code.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/agreement_row.dart';
import '../component/settings_tile.dart';
import '../model/agreement_status.dart';
import '../provider/agreements_controller.dart';

/// 약관 동의 관리(SPEC-0011 R9·R10). 필수와 선택을 **한 화면에서** 함께 보여준다.
///
/// 필수 항목은 읽기 전용이다 — 철회 경로가 없어 토글을 두면 누를 수 있는 것처럼
/// 보인다(디자인 참조 §5). 선택 항목만 토글하고, 토글은 낙관적으로 반영한 뒤 실패하면
/// provider가 되돌린다.
class TermsScreen extends ConsumerWidget {
  const TermsScreen({super.key});

  static String get routeName => 'settings-terms';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<AgreementStatus>> agreements = ref.watch(
      agreementsControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.termsTitle)),
      body: SafeArea(
        child: agreements.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _TermsError(
            message: l10n.termsLoadFailed,
            retryLabel: l10n.termsRetry,
            onRetry: () => ref.invalidate(agreementsControllerProvider),
          ),
          data: (List<AgreementStatus> items) => ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  l10n.termsIntro,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (items.requiredItems.isNotEmpty) ...<Widget>[
                SettingsSectionHeader(l10n.termsSectionRequired),
                for (final AgreementStatus status in items.requiredItems)
                  RequiredAgreementRow(status: status),
              ],
              if (items.optionalItems.isNotEmpty) ...<Widget>[
                SettingsSectionHeader(l10n.termsSectionOptional),
                for (final AgreementStatus status in items.optionalItems)
                  OptionalAgreementRow(
                    status: status,
                    onChanged: (bool agreed) =>
                        _toggle(context, ref, status.termsCode, agreed),
                  ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// 토글 실패를 스낵바로만 알린다 — 스위치는 provider가 이미 제자리로 되돌렸고,
  /// 그 움직임이 주된 피드백이다(R10). 화면 전체를 오류로 바꾸면 나머지 항목까지
  /// 사라진다.
  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    TermsCode code,
    bool agreed,
  ) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String failedMessage = AppLocalizations.of(context).termsUpdateFailed;
    try {
      await ref
          .read(agreementsControllerProvider.notifier)
          .toggleOptional(code, agreed);
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(failedMessage)));
    }
  }
}

/// 조회 실패 상태. 재시도 하나만 둔다.
class _TermsError extends StatelessWidget {
  const _TermsError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}
