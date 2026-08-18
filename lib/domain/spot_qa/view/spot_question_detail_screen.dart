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
import '../provider/my_questions_providers.dart';
import '../provider/spot_answers_providers.dart';
import '../provider/spot_qa_composer_providers.dart';
import '../provider/spot_question_by_id_providers.dart';
import '../provider/spot_questions_providers.dart';
import 'spot_qa_actions.dart';
import '../component/spot_qa_resolution_badge.dart';
import '../component/spot_qa_photos.dart';

/// 질문 상세(R7, 디자인 §2).
///
/// ```
/// AppBar        제목 · 우측 ⋮(해결 토글 / 신고)
/// 질문 블록      작성자 · 본문 전문 · 해결 배지
/// "답변 · N"
/// SpotAnswerTile × N (답글 포함, 커서 페이지네이션)
/// 하단 고정      답변 컴포저
/// ```
///
/// **질문 본문의 출처가 둘이다.** 목록에서 들어온 보통의 경우에는 목록 provider가
/// 이미 받아 둔 항목을 쓰고 — 해결 표시의 낙관적 갱신을 그 컨트롤러가 쥐고 있어 즉시
/// 반영된다 — 목록에 없으면 `ids` 필터로 직접 조회한다(딥링크·알림 진입, 아직 못 받은
/// 페이지). 예전에는 후자가 그냥 "불러오지 못했습니다"로 끝났다.
///
/// **질문과 답변이 서로 다른 provider다** — 답변 조회가 실패해도 질문 본문은 그대로
/// 뜬다(디자인 §2 상태 표).
///
/// 읽기는 로그인 여부와 무관하다(AC-1.4).
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

  /// 이 화면에서 마지막으로 "본 것"으로 기록한 답변 수. 같은 값을 두 번 쓰지 않기
  /// 위한 것이며, 컨트롤러도 변화가 없으면 저장하지 않는다.
  int? _markedAnswerCount;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<SpotQuestionsState> questions = ref.watch(
      spotQuestionsControllerProvider(widget.catalogId),
    );
    // 목록이 이미 받아 둔 항목을 먼저 본다 — 목록에서 들어온 보통의 경우이며,
    // 해결 표시의 낙관적 갱신도 그 컨트롤러가 쥐고 있어 즉시 반영된다.
    final SpotQuestion? fromList = questions.value?.items
        .where((SpotQuestion q) => q.id == widget.questionId)
        .firstOrNull;

    // 목록에 없으면 id로 직접 조회한다(딥링크·알림 진입, 아직 못 받은 페이지).
    // **목록에 있으면 이 provider를 깨우지 않는다** — 같은 질문을 두 번 받을 이유가
    // 없다.
    final AsyncValue<SpotQuestion?> byId = fromList == null
        ? ref.watch(spotQuestionByIdProvider(widget.questionId))
        : const AsyncValue<SpotQuestion?>.data(null);

    final SpotQuestion? question = fromList ?? byId.value;

    // **열어 본 시점의 답변 수를 기록해 「내 질문」의 새 답변 배지를 끈다.** 알림이
    // 없어 그 배지가 유일한 신호라, 읽은 뒤에도 남아 있으면 신호가 무의미해진다.
    //
    // 빌드 중이 아니라 프레임 뒤에 부른다 — 기록이 provider 상태를 바꾸므로
    // 빌드 도중 호출하면 같은 프레임에서 다시 그리게 된다.
    if (question != null &&
        question.ownedByViewer &&
        _markedAnswerCount != question.answerCount) {
      final int seen = question.answerCount;
      _markedAnswerCount = seen;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _markSeen(seen);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.spotQaQuestionsTitle),
        actions: <Widget>[
          // 「이 질문에 대한 조치」를 한군데 모은다 — 해결 토글과 신고는 서로 배타적
          // (내 질문이냐 아니냐)이라 각각 아이콘을 두면 자리만 차지한다.
          //
          // **해결 토글을 본문 옆이 아니라 여기 두는 이유**: 본문 아래 왼쪽에
          // 두었더니 바로 위 「해결됨」 배지와 자리·아이콘이 같아 **버튼이 아니라
          // 상태 표시로 읽혔다.**
          if (question != null)
            PopupMenuButton<_QuestionAction>(
              onSelected: (_QuestionAction action) => switch (action) {
                _QuestionAction.resolve => _toggleResolved(question),
                _QuestionAction.report => runSpotQaReport(
                  context,
                  ref,
                  targetType: ReportTargetType.spotQuestion,
                  targetId: question.id,
                ),
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<_QuestionAction>>[
                    // **되돌릴 수 있다**(2026-08-18 서버가 토글을 열었다) — 해결된
                    // 질문에는 「미해결로 되돌리기」가 나온다.
                    if (question.ownedByViewer)
                      PopupMenuItem<_QuestionAction>(
                        value: _QuestionAction.resolve,
                        child: Text(
                          question.resolved
                              ? l10n.spotQaUnresolveAction
                              : l10n.spotQaResolveAction,
                        ),
                      ),
                    // 내 질문에는 신고를 두지 않는다 — 자기 글 신고는 의미가 없다.
                    if (!question.ownedByViewer)
                      PopupMenuItem<_QuestionAction>(
                        value: _QuestionAction.report,
                        child: Text(l10n.communityReportAction),
                      ),
                  ],
            ),
        ],
      ),
      // **값이 있으면 그것을 그린다.** 재조회 중(`isLoading`이면서 이전 값이 있는
      // 상태)에도 스피너로 덮지 않는다 — 답변을 하나 달 때마다 질문 본문이 깜빡이면
      // 읽던 자리를 잃는다.
      body: SafeArea(
        child: switch ((question, byId)) {
          (final SpotQuestion found, _) => _Body(
            catalogId: widget.catalogId,
            question: found,
            replyTargetId: _replyTargetId,
            onReplyTarget: (String? id) => setState(() => _replyTargetId = id),
          ),
          // 목록에도 없고 id 조회도 아직인 상태.
          (null, AsyncLoading<SpotQuestion?>()) =>
            const Center(child: CircularProgressIndicator()),
          // id 조회가 전송 실패한 것이라 재시도가 의미 있다.
          (null, AsyncError<SpotQuestion?>()) => _Notice(
            message: l10n.spotQaQuestionsUnavailable,
            onRetry: () =>
                ref.invalidate(spotQuestionByIdProvider(widget.questionId)),
          ),
          // 서버가 "그런 질문 없음"으로 답했다 — 삭제됐거나 차단·숨김으로 가려진
          // 경우이며, 다시 물어도 같은 답이 온다. 재시도를 권하지 않는다.
          (null, _) => _Notice(message: l10n.spotQaQuestionsUnavailable),
        },
      ),
    );
  }

  /// 해결 여부를 뒤집는다.
  ///
  /// **확인을 묻지 않는다** — 되돌릴 수 있게 되어(서버가 `resolved` 인자를 열었다)
  /// 잘못 눌러도 한 번 더 누르면 그만이다. 되돌릴 수 없던 시절에는 다이얼로그로 한 번
  /// 막았지만, 지금은 그 물음이 사용자를 붙잡을 뿐이다.
  ///
  /// 낙관적으로 먼저 반영되고(컨트롤러가 즉시 상태를 바꾼다) 실패하면 되돌아온다.
  Future<void> _toggleResolved(SpotQuestion question) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final bool next = !question.resolved;
    // 실패 문구가 방향에 따라 다르다 — "표시하지 못함"과 "되돌리지 못함"은 다른 말이다.
    final String failedText = next
        ? l10n.spotQaResolveFailed
        : l10n.spotQaUnresolveFailed;

    try {
      final SpotQaMutationResult<void> result = await ref
          .read(spotQuestionsControllerProvider(widget.catalogId).notifier)
          .resolve(question.id, resolved: next);
      if (!mounted || result.succeeded) return;
      messenger.showSnackBar(SnackBar(content: Text(failedText)));
    } on Object {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(failedText)));
    }
  }

  /// 이 질문을 "본 것"으로 기록해 「새 답변」 배지를 끈다.
  ///
  /// **내 질문일 때만 부른다.** 남의 질문을 열었을 뿐인데 「내 질문」 컨트롤러를
  /// 깨우면 서버 조회가 한 번 더 나간다. 판정 근거는 서버가 준 `ownedByViewer`다 —
  /// 예전에는 로컬 기록에 있는지로 갈랐는데, 그 방식은 기기를 바꾸면 내 질문인데도
  /// 아니라고 답했다.
  Future<void> _markSeen(int answerCount) async {
    try {
      await ref
          .read(myQuestionsControllerProvider.notifier)
          .markSeen(widget.questionId, answerCount);
    } on Object {
      // 저장 실패는 배지가 안 꺼지는 것으로 끝난다 — 읽던 화면을 방해하지 않는다.
    }
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
            // 당겨서 새로고침 — **질문과 답변을 함께 다시 받는다.** 답변이 달렸는지
            // 보러 다시 들어오는 화면이라 갱신 수단이 있어야 하고, 답변만 받으면
            // 해결 여부·답변 수 같은 질문 쪽 값이 낡은 채로 남는다.
            //
            // 질문의 출처는 둘이라(목록 캐시 또는 id 조회) 양쪽을 다 무효화한다 —
            // 어느 쪽에서 왔든 눌렀을 때 새 값이 와야 한다.
            onRefresh: () async {
              ref.invalidate(spotAnswersControllerProvider(question.id));
              ref.invalidate(spotQuestionByIdProvider(question.id));
              await ref
                  .read(spotQuestionsControllerProvider(catalogId).notifier)
                  .refresh();
            },
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
/// 상단바 ⋮ 메뉴의 항목. 내 질문이면 해결 토글이, 남의 질문이면 신고가 나온다.
enum _QuestionAction { resolve, report }

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
          // 첨부 사진(R9). 서버가 처음부터 키를 주고 있었는데 그리지 않고 있었다.
          SpotQaPhotos(photoKeys: question.photoKeys),
          if (question.hidden) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              l10n.communityHiddenBadge,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          // 해결 여부는 **오른쪽 끝**에 붙인다. 본문 아래 왼쪽은 읽는 눈이 먼저
          // 닿는 자리라, 거기 두면 본문의 일부처럼 읽힌다.
          //
          // 미해결은 강조색으로 끌어올린다 — 답을 기다리는 질문이 눈에 띄어야
          // 이 기능이 돈다(`SpotQaResolutionBadge` 참고).
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: SpotQaResolutionBadge(resolved: question.resolved),
          ),
          // 해결 토글 버튼은 여기 없다 — 상단바 ⋮ 메뉴로 옮겼다. 본문 아래 왼쪽에
          // 두었더니 바로 위 배지와 자리·아이콘이 같아 **버튼이 아니라 상태 표시로
          // 읽혔다.**
        ],
      ),
    );
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
