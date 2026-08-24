
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/log/app_log.dart';
import '../../../common/pagination/page.dart';
import '../model/spot_answer.dart';
import '../repository/spot_qa_repository.dart';
import 'spot_qa_providers.dart';

part 'spot_answers_providers.g.dart';

/// 답변 한 페이지 크기.
const int _pageSize = 20;

/// 답변 목록의 누적 상태.
///
/// **[items]는 답변만 담는다** — 답글은 각 [SpotAnswer.replies] 안에 있다. 그래서
/// 목록 길이는 답글을 세지 않으며, 질문의 `answerCount`와 다를 수 있다(숨김 규칙이
/// 서로 다르게 반영된다).
class SpotAnswersState {
  const SpotAnswersState({
    required this.items,
    required this.hasMore,
    this.endCursor,
    this.isLoadingMore = false,
  });

  final List<SpotAnswer> items;
  final bool hasMore;
  final String? endCursor;
  final bool isLoadingMore;

  bool get isEmpty => items.isEmpty && !hasMore;

  SpotAnswersState copyWith({
    List<SpotAnswer>? items,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
  }) => SpotAnswersState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// 질문 하나의 답변 목록(R7). [questionId]별 패밀리.
///
/// 답변은 커서 페이지네이션이고 **답글은 답변에 딸려 한 번에 내려온다** — 깊이가
/// 2단계라 화면을 넘길 만큼 커지지 않기 때문이다(계약 §SpotAnswer.replies).
///
/// 질문 조회와 분리된 provider인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
/// 답변 조회가 실패해도 질문 본문은 그대로 뜬다.
@Riverpod(retry: spotQaRetryPolicy)
class SpotAnswersController extends _$SpotAnswersController {
  static const AppLog _log = AppLog('SpotAnswersController');

  SpotQaRepository get _repository => ref.read(spotQaRepositoryProvider);

  @override
  Future<SpotAnswersState> build(String questionId) async {
    final CursorPage<SpotAnswer> page = await _repository.fetchAnswers(
      questionId: questionId,
      first: _pageSize,
    );
    return SpotAnswersState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
  }

  Future<void> loadMore() async {
    final SpotAnswersState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData<SpotAnswersState>(current.copyWith(isLoadingMore: true));
    try {
      final CursorPage<SpotAnswer> next = await _repository.fetchAnswers(
        questionId: questionId,
        first: _pageSize,
        after: current.endCursor,
      );
      state = AsyncData<SpotAnswersState>(
        SpotAnswersState(
          items: <SpotAnswer>[...current.items, ...next.items],
          hasMore: next.hasNextPage,
          endCursor: next.endCursor,
        ),
      );
    } on Object catch (error) {
      _log.warn('spotAnswers loadMore failed: ${error.runtimeType}');
      state = AsyncData<SpotAnswersState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }

  /// 답변·답글 작성이나 삭제 뒤 다시 받는다. **작성을 낙관적으로 넣지 않으므로**
  /// 서버 응답을 기다린 뒤 이 갱신으로 반영한다(설계 §상태 관리).
  Future<void> refresh() async {
    state = await AsyncValue.guard(() => build(questionId));
  }
}
