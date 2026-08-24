import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../provider/spot_questions_providers.dart';

/// 장소 상세의 「지금 여기 어때?」 진입점.
///
/// **한 줄짜리 행이다** — 아이콘 · 제목 · 질문 수 · 화살표. 예전에는 큰 버튼과 텍스트
/// 버튼이 세로로 쌓여 있었는데, 상세 화면 맨 아래에서 두 칸을 먹는 것치고 전달하는
/// 정보가 없었다. 질문 수를 함께 보이면 **줄 자체가 들어갈 이유**가 된다 — "3개나
/// 있네"와 "아직 없네"는 다음 행동이 다르다.
///
/// 아이콘은 **겹친 말풍선**(`forum`)이다. 말풍선 개수가 의미를 가른다 — 겹친 2개는
/// 여러 사람이 오가는 스레드, 단일 버블은 1:1 대화로 읽힌다. 이 앱에는 이미 DM이
/// 있어(`domain/dm`) 단일 버블 계열을 쓰면 그쪽과 헷갈린다.
///
/// **누구에게나 보인다** — 좋아요 여부로 가리지 않는다. 서버가 2026-08-18에 좋아요
/// 게이팅을 걷어냈고, 그 전부터도 진입점은 열어 두고 있었다.
///
/// 질문이 있으면 목록으로, 없으면 **빈 목록을 거치지 않고 바로 작성으로** 보낸다.
/// 아직 모르는 동안에도 줄을 그리되 목록으로 보낸다 — 상세 화면이 늦게 흔들리는 것이
/// 더 나쁘고, 빈 목록에도 작성 버튼이 있어 막다른 길이 아니다.
class SpotQaEntryButton extends ConsumerWidget {
  const SpotQaEntryButton({
    super.key,
    required this.catalogId,
    required this.onOpenList,
    required this.onCompose,
  });

  final String catalogId;

  /// 질문이 있을 때(또는 아직 모를 때) — 목록으로.
  final VoidCallback onOpenList;

  /// 질문이 하나도 없을 때 — 바로 작성으로.
  final VoidCallback onCompose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    // 항목 전체가 아니라 개수만 구독한다(§5) — 목록이 갱신돼도 이 줄은 수가 바뀔
    // 때만 다시 그린다. 아직 모르면 null이다.
    final int? count = ref.watch(
      spotQuestionsControllerProvider(
        catalogId,
      ).select((AsyncValue<SpotQuestionsState> s) => s.value?.items.length),
    );

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: count == 0 ? onCompose : onOpenList,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.forum_outlined,
                size: 22,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      l10n.spotQaEntryAction,
                      style: theme.textTheme.titleSmall,
                    ),
                    // 조회 전에는 둘째 줄을 비운다 — "질문 0개"라고 단정했다가
                    // 곧바로 뒤집히면 잘못 알려준 것이 된다.
                    if (count != null)
                      Text(
                        l10n.spotQaEntryQuestionCount(count),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
