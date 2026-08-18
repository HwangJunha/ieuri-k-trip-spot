import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../provider/spot_questions_providers.dart';

/// 장소 상세의 「지금 여기 어때?」 진입점.
///
/// **누구에게나 보인다** — 좋아요 여부로 가리지 않는다(2026-08-18 결정, 게이팅 폐지의
/// 근거는 `spot_qa_eligibility.dart`). 읽기는 원래부터 비로그인에게도 열려 있었고
/// (AC-1.4), 쓰기 게이팅이 사라지면서 숨길 이유가 남지 않았다.
///
/// 질문이 있으면 목록으로, 없으면 **빈 목록을 거치지 않고 바로 작성으로** 보낸다 —
/// 빈 화면을 보여주고 다시 누르게 하면 진입 장벽만 높아진다.
///
/// 목록 조회가 아직 끝나지 않았으면 버튼을 그리되 목록으로 보낸다. 질문 유무를 모르는
/// 동안 버튼을 감추면 상세 화면이 늦게 흔들리고, 목록은 비어 있어도 작성으로 가는
/// 버튼을 제 안에 갖고 있어 막다른 길이 아니다.
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
    // 항목 전체가 아니라 "질문이 있는가"만 구독한다(§5) — 목록이 갱신돼도 이 버튼은
    // 유무가 바뀔 때만 다시 그린다.
    final bool? hasQuestions = ref.watch(
      spotQuestionsControllerProvider(
        catalogId,
      ).select((AsyncValue<SpotQuestionsState> s) => s.value?.items.isNotEmpty),
    );

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        // 아직 모르면(null) 목록으로 보낸다 — 빈 목록에도 작성 버튼이 있다.
        onPressed: hasQuestions == false ? onCompose : onOpenList,
        icon: const Icon(Icons.forum_outlined),
        label: Text(AppLocalizations.of(context).spotQaEntryAction),
      ),
    );
  }
}
