import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/spot_qa_routes.dart';
import '../../../common/pagination/pagination_list_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/spot_question_card.dart';
import '../model/spot_question.dart';
import '../provider/spot_questions_providers.dart';
import 'spot_qa_composer_screen.dart';
import 'spot_question_detail_screen.dart';

/// 장소 질문 목록(R1·R2·R16, 디자인 §1).
///
/// ```
/// AppBar  "장소 질문"
/// 목록    SpotQuestionCard × N (얇은 구분선, 커서 페이지네이션)
/// FAB     질문하기
/// ```
///
/// **정렬 UI가 없다.** 미해결 우선·최신순은 서버가 고정하며 정렬을 바꾸는 인자가
/// 계약에 없다(설계 §질문 목록 화면) — 토글을 두면 계약에 없는 인자를 요구하게 된다.
///
/// **로그인 게이트가 없다**(AC-1.4). 읽기는 비로그인을 포함해 누구에게나 열려 있다.
/// 쓰기(FAB → 작성 화면)만 서버가 자격을 판정한다.
///
/// 페이지네이션은 공용 [PaginationListView]다 — 기능이 자기 것을 만들지 않는다
/// (CLAUDE.md §4).
class SpotQuestionsScreen extends ConsumerWidget {
  const SpotQuestionsScreen({super.key, required this.catalogId});

  static String get routeName => spotQuestionsRouteName;

  /// 장소 식별자(`/spot/:spotId/qa`의 경로 파라미터).
  final String catalogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<SpotQuestionsState> state = ref.watch(
      spotQuestionsControllerProvider(catalogId),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.spotQaQuestionsTitle)),
      // 셸 밖의 최상위 라우트라 하단 내비 바가 없다 — 바 높이 보정이 필요 없다.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _compose(context, ref),
        icon: const Icon(Icons.edit_outlined),
        label: Text(l10n.spotQaAskAction),
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _Notice(
            message: l10n.spotQaQuestionsUnavailable,
            actionLabel: l10n.communityRetry,
            onAction: () =>
                ref.invalidate(spotQuestionsControllerProvider(catalogId)),
          ),
          data: (SpotQuestionsState data) => data.items.isEmpty
              ? _Notice(
                  message: l10n.spotQaQuestionsEmptyTitle,
                  detail: l10n.spotQaQuestionsEmptyBody,
                  actionLabel: l10n.spotQaAskAction,
                  onAction: () => _compose(context, ref),
                )
              : _List(catalogId: catalogId, state: data),
        ),
      ),
    );
  }

  /// 작성 화면을 연다. **성공하면 목록을 다시 받는다** — 작성은 낙관적으로 넣지
  /// 않으므로(설계 §상태 관리) 서버 응답 뒤의 재조회가 유일한 반영 경로다.
  Future<void> _compose(BuildContext context, WidgetRef ref) async {
    // 장소명은 「내 질문」 목록에 적어 둘 **표시용 힌트**다. 이미 받아 둔 질문이
    // 있으면 거기 실린 장소명을 쓰고, 없으면 빈 값으로 둔다 — 이 값 때문에 작성이
    // 막히지 않는다(목록이 나중에 서버 조회로 채운다).
    final String spotTitle =
        ref
            .read(spotQuestionsControllerProvider(catalogId))
            .value
            ?.items
            .firstOrNull
            ?.spot
            .title ??
        '';
    final bool? created = await context.pushNamed<bool>(
      SpotQaComposerScreen.routeName,
      pathParameters: <String, String>{'spotId': catalogId},
      queryParameters: <String, String>{'spot': spotTitle},
    );
    if (created ?? false) {
      await ref
          .read(spotQuestionsControllerProvider(catalogId).notifier)
          .refresh();
    }
  }
}

class _List extends ConsumerWidget {
  const _List({required this.catalogId, required this.state});

  final String catalogId;
  final SpotQuestionsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 목록 전체가 같은 기준으로 상대시각을 계산하도록 빌드 1회당 한 번만 읽는다.
    final DateTime now = DateTime.now().toUtc();
    final List<SpotQuestion> items = state.items;

    return PaginationListView(
      itemCount: items.length,
      hasMore: state.hasMore,
      isLoadingMore: state.isLoadingMore,
      onLoadMore: () => ref
          .read(spotQuestionsControllerProvider(catalogId).notifier)
          .loadMore(),
      onRefresh: () => ref
          .read(spotQuestionsControllerProvider(catalogId).notifier)
          .refresh(),
      itemBuilder: (BuildContext context, int index) {
        final SpotQuestion question = items[index];
        return Column(
          children: <Widget>[
            SpotQuestionCard(
              question: question,
              now: now,
              onTap: () => context.pushNamed(
                SpotQuestionDetailScreen.routeName,
                pathParameters: <String, String>{
                  'spotId': catalogId,
                  'questionId': question.id,
                },
              ),
            ),
            if (index < items.length - 1) const Divider(height: 1),
          ],
        );
      },
    );
  }
}

/// 빈 목록·조회 실패 안내. 둘 다 행동 버튼을 하나 갖는다(질문하기 / 다시 시도).
class _Notice extends StatelessWidget {
  const _Notice({
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.detail,
  });

  final String message;
  final String? detail;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall,
            ),
            if (detail != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                detail!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
