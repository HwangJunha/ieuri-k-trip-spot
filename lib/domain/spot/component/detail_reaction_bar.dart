import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/spot_reaction.dart';

/// 상세 화면의 좋아요/싫어요 반응 바(SPEC-0003 §4). 두 버튼을 노출하고 탭 시
/// [onReaction]으로 알린다 — 낙관적 갱신·롤백은 provider 몫이라 이 위젯은 상태를
/// 갖지 않는다(표시·입력만).
class DetailReactionBar extends StatelessWidget {
  const DetailReactionBar({super.key, required this.onReaction});

  final ValueChanged<SpotReaction> onReaction;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onReaction(SpotReaction.dislike),
            icon: const Icon(Icons.close),
            label: Text(l10n.spotDetailDislikeAction),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => onReaction(SpotReaction.like),
            icon: const Icon(Icons.favorite),
            label: Text(l10n.spotDetailLikeAction),
          ),
        ),
      ],
    );
  }
}
