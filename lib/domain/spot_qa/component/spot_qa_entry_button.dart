import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/spot_qa_eligibility.dart';
import '../provider/spot_questions_providers.dart';

/// 장소 상세의 「지금 여기 어때?」 진입점(설계 §진입점).
///
/// **자격도 없고 질문도 없으면 아무것도 그리지 않는다**(2026-08-18 사용자 결정).
/// 좋아요하지 않은 사용자에게까지 노출할 필요가 없다는 판단이며, 그때 이 버튼은
/// 작성 화면으로만 이어져 눌러 봐야 막힌다.
///
/// 반대로 **질문이 이미 있으면 자격과 무관하게 보인다** — 읽기는 비로그인을 포함해
/// 누구에게나 열려 있다(AC-1.4).
///
/// 목록 조회가 아직/실패면 그리지 않는다. 질문 유무를 모르는 상태에서 버튼을 띄우면
/// 눌렀을 때 어디로 갈지 정할 수 없고, 조회 실패를 상세 화면의 오류로 승격시키는 것도
/// 과하다 — 상세 본문은 그대로 보여야 한다.
class SpotQaEntryButton extends ConsumerWidget {
  const SpotQaEntryButton({
    super.key,
    required this.catalogId,
    required this.viewerLikedSpot,
    required this.onOpenList,
    required this.onCompose,
  });

  final String catalogId;

  /// 내가 이 장소를 좋아요했는지(`SpotDetail.likedByViewer`). 작성 자격의 근거다.
  final bool viewerLikedSpot;

  /// 질문이 있을 때 — 목록으로.
  final VoidCallback onOpenList;

  /// 질문이 없을 때 — **빈 목록을 거치지 않고 바로 작성으로**(설계 §진입점).
  /// 빈 화면을 보여주고 다시 누르게 하면 진입 장벽만 높아진다.
  final VoidCallback onCompose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 항목 전체가 아니라 "질문이 있는가"만 구독한다(§5) — 목록이 갱신돼도 이 버튼은
    // 유무가 바뀔 때만 다시 그린다.
    final bool? resolved = ref.watch(
      spotQuestionsControllerProvider(catalogId).select(
        (AsyncValue<SpotQuestionsState> s) => s.value?.items.isNotEmpty,
      ),
    );
    if (resolved == null) return const SizedBox.shrink();

    if (!showSpotQaEntry(
      viewerLikedSpot: viewerLikedSpot,
      hasQuestions: resolved,
    )) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: resolved ? onOpenList : onCompose,
        icon: const Icon(Icons.forum_outlined),
        label: Text(AppLocalizations.of(context).spotQaEntryAction),
      ),
    );
  }
}
