import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/agreement_row.dart';
import '../model/agreement_status.dart';
import '../provider/agreements_controller.dart';

/// 필수 약관 동의 안내(SPEC-0011 R11·R12). 게이트가 막았을 때 사용자가 착지하는 곳이다.
///
/// **필수 항목만 보여준다** — 선택 항목까지 두면 게이트를 통과하려면 무엇에 동의해야
/// 하는지가 흐려진다. 선택은 게이트를 지난 뒤 `TermsScreen`에서 언제든 바꾼다.
///
/// 동의가 성공하면 라우터 게이트가 그 자리에서 풀리고(재조회 없음, R12 첫 기준)
/// 리다이렉트가 `pendingDestination`에 보관해 둔 원래 목적지로 돌려보낸다 — **이 화면은
/// 직접 이동하지 않는다.** 복귀를 여기서 하지 않는 이유는 게이트를 푸는 주체가 라우터라
/// 이동도 같은 자리에서 일어나야 순서가 어긋나지 않기 때문이다.
class RequiredTermsScreen extends ConsumerWidget {
  const RequiredTermsScreen({super.key});

  static const String routeName = 'required-terms';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<AgreementStatus>> agreements = ref.watch(
      agreementsControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.requiredTermsTitle)),
      body: SafeArea(
        child: agreements.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(l10n.termsLoadFailed, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        ref.invalidate(agreementsControllerProvider),
                    child: Text(l10n.termsRetry),
                  ),
                ],
              ),
            ),
          ),
          data: (List<AgreementStatus> items) => Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        l10n.requiredTermsIntro,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    for (final AgreementStatus status in items.requiredItems)
                      RequiredAgreementRow(status: status),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _agree(context, ref),
                    child: Text(l10n.requiredTermsAgree),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _agree(BuildContext context, WidgetRef ref) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String failedMessage = AppLocalizations.of(
      context,
    ).requiredTermsFailed;

    await ref.read(agreementsControllerProvider.notifier).agreeToRequired();

    // 실패는 provider의 error 상태로 남는다 — 화면을 오류로 갈아엎지 않고 안내만
    // 띄운다. 여기서 재조회하면 게이트가 다시 loading으로 떨어져 사용자가 스플래시로
    // 튕긴다.
    if (ref.read(agreementsControllerProvider).hasError) {
      messenger.showSnackBar(SnackBar(content: Text(failedMessage)));
    }
  }
}
