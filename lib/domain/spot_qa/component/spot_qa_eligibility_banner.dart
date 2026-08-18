import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../provider/spot_qa_composer_providers.dart';

/// 자격 없음 인라인 안내(디자인 §3 자격 거부 처리).
///
/// **오류 코드를 그대로 보여주지 않는다** — 다음 행동("이 장소를 좋아요하면 질문할
/// 수 있습니다")을 알려주는 문구여야 한다(설계 §i18n).
///
/// 질문과 답변의 문구가 다르므로 [target]으로 고른다. 답글은 답변과 같은 자격을
/// 요구하니 같은 문구를 쓴다.
class SpotQaEligibilityBanner extends StatelessWidget {
  const SpotQaEligibilityBanner({super.key, required this.target});

  final SpotQaComposerTarget target;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String message = switch (target) {
      SpotQaComposerTarget.question => l10n.spotQaNotEligibleToAsk,
      // 답글은 답변과 같은 자격을 요구한다(우회 참여를 막기 위해서다).
      SpotQaComposerTarget.answer ||
      SpotQaComposerTarget.reply => l10n.spotQaNotEligibleToAnswer,
    };

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.favorite_border,
            size: 18,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
