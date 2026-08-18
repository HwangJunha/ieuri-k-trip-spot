import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/navigation/spot_qa_routes.dart';
import '../../../common/pagination/pagination_list_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../community/model/report_reason.dart';
import '../component/spot_answer_tile.dart';
import '../component/spot_qa_author_line.dart';
import '../component/spot_qa_inline_composer.dart';
import '../model/spot_answer.dart';
import '../model/spot_answer_reply.dart';
import '../model/spot_qa_failure.dart';
import '../model/spot_question.dart';
import '../provider/spot_answers_providers.dart';
import '../provider/spot_qa_composer_providers.dart';
import '../provider/spot_questions_providers.dart';
import 'spot_qa_actions.dart';

/// 질문 상세(R7, 디자인 §2).
///
/// ```
/// AppBar        "질문 작성" 아닌 질문 보기 · 우측 신고
/// 질문 블록      작성자 · 본문 전문 · 해결 배지 · [해결됨으로 표시]
/// "답변 · N"
/// SpotAnswerTile × N (답글 포함, 커서 페이지네이션)
/// 하단 고정      답변 컴포저
/// ```
///
/// **질문 본문은 목록 provider에서 온다.** 서버에 `spotQuestion(id:)` 단건 조회가
/// 없어(스키마 §Query) 목록이 유일한 출처다 — 목록 화면에서 들어오므로 그 provider가
/// 살아 있고, 해결 표시도 같은 컨트롤러가 낙관적으로 갱신한다. 아직 받지 못한 페이지의
/// 질문(딥링크 등)이면 안내를 띄운다.
///
/// **질문과 답변이 서로 다른 provider다** — 답변 조회가 실패해도 질문 본문은 그대로
/// 뜬다(디자인 §2 상태 표).
///
/// 읽기는 로그인 여부와 무관하다(AC-1.4). 쓰기만 서버가 자격을 판정한다.
class SpotQuestionDetailScreen extends ConsumerStatefulWidget {
  const SpotQuestionDetailScreen({
    super.key,
    required this.catalogId,
    required this.questionId,
  });

  static String get routeName => spotQuestionDetailRouteName;

  final String catalogId;
  final String questionId;

  @override
  ConsumerState<SpotQuestionDetailScreen> createState() =>
      _SpotQuestionDetailScreenState();
}

class _SpotQuestionDetailScreenState
    extends ConsumerState<SpotQuestionDetailScreen> {
  /// 지금 답글을 달고 있는 답변의 id. null이면 열린 답글 입력이 없다.
  ///
  /// **화면 상태이지 서버 상태가 아니라서 provider로 올리지 않는다** — 다른 화면이
  /// 알 필요가 없고, 상세를 떠나면 사라지는 것이 맞다.
  String? _replyTargetId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<SpotQuestionsState> questions = ref.watch(
      spotQuestionsControllerProvider(widget.catalogId),
    );
    final SpotQuestion? question = questions.value?.items
        .where((SpotQuestion q) => q.id == widget.questionId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.spotQaQuestionsTitle),
        actions: <Widget>[
          // 내 질문에는 신고를 두지 않는다 — 자기 글 신고는 의미가 없다.
          if (question != null && !question.ownedByViewer)
            IconButton(
              icon: const Icon(Icons.flag_outlined),
              tooltip: l10n.communityReportAction,
              onPressed: () => runSpotQaReport(
                context,
                ref,
                targetType: ReportTargetType.spotQuestion,
                targetId: question.id,
              ),
            ),
        ],
      ),
      // **값이 있으면 그것을 그린다.** 재조회 중(`isLoading`이면서 이전 값이 있는
      // 상태)에도 스피너로 덮지 않는다 — 답변을 하나 달 때마다 질문 본문이 깜빡이면
      // 읽던 자리를 잃는다.
      body: SafeArea(
        child: switch ((question, questions)) {
          (final SpotQuestion found, _) => _Body(
            catalogId: widget.catalogId,
            question: found,
            replyTargetId: _replyTargetId,
            onReplyTarget: (String? id) => setState(() => _replyTargetId = id),
          ),
          (null, AsyncError<SpotQuestionsState>()) => _Notice(
            message: l10n.spotQaQuestionsUnavailable,
            onRetry: () => ref.invalidate(
              spotQuestionsControllerProvider(widget.catalogId),
            ),
          ),
          (null, AsyncValue<SpotQuestionsState>(hasValue: false)) =>
            const Center(child: CircularProgressIndicator()),
          // 받아 둔 페이지에 없는 질문 — 다시 조회해도 같은 페이지가 오므로 재시도를
          // 권하지 않는다(딥링크로 뒤쪽 페이지의 질문에 들어온 경우다).
          (null, _) => _Notice(message: l10n.spotQaQuestionsUnavailable),
        },
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.catalogId,
    required this.question,
    required this.replyTargetId,
    required this.onReplyTarget,
  });

  /// 질문 블록과 "답변 · N" 헤더가 목록 앞에 차지하는 칸 수.
  static const int _headerCount = 2;

  final String catalogId;
  final SpotQuestion question;
  final String? replyTargetId;
  final ValueChanged<String?> onReplyTarget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 화면 전체가 같은 기준으로 상대시각을 계산하도록 빌드 1회당 한 번만 읽는다.
    final DateTime now = DateTime.now().toUtc();
    final AsyncValue<SpotAnswersState> answers = ref.watch(
      spotAnswersControllerProvider(question.id),
    );
    final SpotAnswersState? data = answers.value;
    final List<SpotAnswer> items = data?.items ?? const <SpotAnswer>[];

    return Column(
      children: <Widget>[
        Expanded(
          // 질문 블록·헤더·답변을 **한 목록**으로 엮어 공용 [PaginationListView]에
          // 넘긴다(CLAUDE.md §4 — 기능이 자기 페이지네이션을 만들지 않는다).
          // 목록 안에 목록을 넣으면 스크롤이 중첩돼 어느 쪽이 움직이는지 알 수 없다.
          child: PaginationListView(
            itemCount: _headerCount + (items.isEmpty ? 1 : items.length),
            hasMore: data?.hasMore ?? false,
            isLoadingMore: data?.isLoadingMore ?? false,
            onLoadMore: () => ref
                .read(spotAnswersControllerProvider(question.id).notifier)
                .loadMore(),
            itemBuilder: (BuildContext context, int index) => switch (index) {
              0 => _QuestionBlock(
                catalogId: catalogId,
                question: question,
                now: now,
              ),
              1 => _AnswersHeader(count: question.answerCount),
              // 답변이 하나도 없으면 헤더 뒤 한 칸이 상태 표시 자리다 —
              // 로딩·실패·"답변 없음"이 서로 다른 문구로 그 자리에 뜬다.
              _ when items.isEmpty => _AnswersStatus(
                state: answers,
                questionId: question.id,
              ),
              _ => _AnswerRow(
                questionId: question.id,
                answer: items[index - _headerCount],
                now: now,
                replyTargetId: replyTargetId,
                onReplyTarget: onReplyTarget,
              ),
            },
          ),
        ),
        // 하단 고정 답변 컴포저. **답변이 없어도 그대로 노출한다** — 첫 답변을
        // 유도하는 자리다(디자인 §2 상태 표).
        Material(
          color: Theme.of(context).colorScheme.surface,
          elevation: 2,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
              child: SpotQaInlineComposer(
                target: SpotQaComposerTarget.answer,
                targetId: question.id,
                onSubmitted: () {
                  // 작성은 낙관적으로 넣지 않으므로 서버 응답 뒤 다시 받는다.
                  // 답변 수는 질문에 있으므로 목록도 함께 갱신한다.
                  ref
                      .read(spotAnswersControllerProvider(question.id).notifier)
                      .refresh();
                  ref
                      .read(spotQuestionsControllerProvider(catalogId).notifier)
                      .refresh();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// "답변 · N" 섹션 헤더. **서버가 준 answerCount 그대로다** — 목록 길이로 세지
/// 않는다(숨김 규칙이 서로 달라 두 수가 어긋날 수 있다).
class _AnswersHeader extends StatelessWidget {
  const _AnswersHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            l10n.spotQaAnswerCount(count),
            style: theme.textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

/// 답변 한 칸 — 타일에 DM·신고·답글 흐름을 물린다.
///
/// **내 답변·내 답글에는 DM·신고를 두지 않는다**(`ownedByViewer`): 자기 자신과
/// 대화하거나 자기 글을 신고할 이유가 없다.
class _AnswerRow extends ConsumerWidget {
  const _AnswerRow({
    required this.questionId,
    required this.answer,
    required this.now,
    required this.replyTargetId,
    required this.onReplyTarget,
  });

  final String questionId;
  final SpotAnswer answer;
  final DateTime now;
  final String? replyTargetId;
  final ValueChanged<String?> onReplyTarget;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SpotAnswerTile(
    answer: answer,
    now: now,
    onMessage: answer.ownedByViewer
        ? null
        : () => runSpotQaDirectMessage(
            context,
            ref,
            counterpartMemberId: answer.author.id,
            sourceAnswerId: answer.id,
          ),
    onReport: answer.ownedByViewer
        ? null
        : () => runSpotQaReport(
            context,
            ref,
            targetType: ReportTargetType.spotAnswer,
            targetId: answer.id,
          ),
    // 다시 누르면 접힌다 — 답글 모드에 갇히면 답변을 달 수 없다.
    onReply: () => onReplyTarget(replyTargetId == answer.id ? null : answer.id),
    replyComposer: replyTargetId == answer.id
        ? SpotQaInlineComposer(
            target: SpotQaComposerTarget.reply,
            targetId: answer.id,
            autofocus: true,
            onSubmitted: () {
              onReplyTarget(null);
              // 작성은 낙관적으로 넣지 않으므로 서버 응답 뒤 다시 받는다.
              ref
                  .read(spotAnswersControllerProvider(questionId).notifier)
                  .refresh();
            },
          )
        : null,
    // 답글의 DM 출처는 **그 답글이 달린 답변**이다 — 계약이 답변만 출처로 받는다.
    onReplyMessage: (SpotAnswerReply reply) => reply.ownedByViewer
        ? null
        : () => runSpotQaDirectMessage(
            context,
            ref,
            counterpartMemberId: reply.author.id,
            sourceAnswerId: answer.id,
          ),
    onReplyReport: (SpotAnswerReply reply) => reply.ownedByViewer
        ? null
        : () => runSpotQaReport(
            context,
            ref,
            targetType: ReportTargetType.spotAnswerReply,
            targetId: reply.id,
          ),
  );
}

/// 질문 본문 블록. 해결 표시 버튼은 **내 질문이고 아직 미해결일 때만** 보인다.
class _QuestionBlock extends ConsumerWidget {
  const _QuestionBlock({
    required this.catalogId,
    required this.question,
    required this.now,
  });

  final String catalogId;
  final SpotQuestion question;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SpotQaAuthorLine(
            author: question.author,
            createdAt: question.createdAt,
            now: now,
          ),
          const SizedBox(height: 8),
          // 상세에서는 **자르지 않는다**(디자인 §2).
          Text(question.body, style: theme.textTheme.bodyLarge),
          if (question.hidden) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              l10n.communityHiddenBadge,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          if (question.resolved) ...<Widget>[
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.spotQaResolvedLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
          // **되돌릴 수단이 없다**(서버에 뮤테이션 자체가 없다) — 성공하면 버튼이
          // 사라지고 다시 나타나지 않는다.
          if (question.ownedByViewer && !question.resolved)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => _resolve(context, ref),
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: Text(l10n.spotQaResolveAction),
              ),
            ),
        ],
      ),
    );
  }

  /// 해결 표시. **낙관적으로 반영된다**(컨트롤러가 즉시 상태를 바꾼다) — 실패하면
  /// 컨트롤러가 되돌리고 화면은 안내만 띄운다.
  Future<void> _resolve(BuildContext context, WidgetRef ref) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    SpotQaMutationResult<void> result;
    try {
      result = await ref
          .read(spotQuestionsControllerProvider(catalogId).notifier)
          .resolve(question.id);
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l10n.spotQaResolveFailed)));
      return;
    }
    if (!result.succeeded) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.spotQaResolveFailed)));
    }
  }
}

/// 답변 목록의 로딩·실패·빈 상태 한 칸.
///
/// **질문 본문과 분리돼 있다** — 답변 조회가 실패해도 위의 질문은 그대로 보인다.
class _AnswersStatus extends ConsumerWidget {
  const _AnswersStatus({required this.state, required this.questionId});

  final AsyncValue<SpotAnswersState> state;
  final String questionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final bool failed = state.hasError;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              failed ? l10n.spotQaAnswersUnavailable : l10n.spotQaAnswersEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (failed) ...<Widget>[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(spotAnswersControllerProvider(questionId)),
                child: Text(l10n.communityRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 질문 조회 실패·볼 수 없는 질문 안내. [onRetry]가 null이면 재시도 버튼을 두지
/// 않는다 — 다시 조회해도 같은 페이지가 온다.
class _Notice extends StatelessWidget {
  const _Notice({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
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
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                child: Text(l10n.communityRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
