
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';

import '../../../common/log/app_log.dart';
import '../../../common/pagination/page.dart';
import '../model/spot_qa_failure.dart';
import '../model/spot_question.dart';
import '../repository/spot_qa_repository.dart';
import 'spot_qa_providers.dart';

part 'spot_questions_providers.g.dart';

/// 질문 한 페이지 크기(설계 §질문 목록 화면).
const int _pageSize = 20;

/// 질문 목록의 누적 상태. 커뮤니티 댓글·피드와 같은 커서 페이징이다.
class SpotQuestionsState {
  const SpotQuestionsState({
    required this.items,
    required this.hasMore,
    this.endCursor,
    this.isLoadingMore = false,
  });

  final List<SpotQuestion> items;
  final bool hasMore;
  final String? endCursor;
  final bool isLoadingMore;

  /// 더 받을 것도 없이 비었는지. **첫 페이지가 비었어도 [hasMore]가 참이면 빈 것이
  /// 아니다** — 진입점이 "질문 있음/없음"으로 갈리므로 이 구분이 화면 흐름을 바꾼다.
  bool get isEmpty => items.isEmpty && !hasMore;

  SpotQuestionsState copyWith({
    List<SpotQuestion>? items,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
  }) => SpotQuestionsState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// 장소 하나의 질문 목록(R1·R2·R16). [catalogId]별 패밀리 — id를 인자로 두면
/// codegen이 family를 만든다(CLAUDE.md §5).
///
/// **정렬을 클라이언트가 하지 않는다.** 미해결 우선·최신순은 서버가 고정하며 정렬을
/// 바꾸는 인자가 계약에 없다. 받은 순서를 그대로 쌓는다.
///
/// **차단·숨김도 클라이언트가 거르지 않는다**(R12). 서버가 이미 뺀 것을 다시 거르면
/// 서버 규칙이 바뀔 때 어긋난다.
///
/// **로그인하지 않아도 조회된다**(AC-1.4) — 읽기 화면에서 인증을 요구하지 않는다.
@Riverpod(retry: spotQaRetryPolicy)
class SpotQuestionsController extends _$SpotQuestionsController {
  static final Logger _log = appLogger('SpotQuestionsController');

  SpotQaRepository get _repository => ref.read(spotQaRepositoryProvider);

  @override
  Future<SpotQuestionsState> build(String catalogId) async {
    final CursorPage<SpotQuestion> page = await _repository.fetchQuestions(
      catalogId: catalogId,
      first: _pageSize,
    );
    return SpotQuestionsState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
  }

  Future<void> loadMore() async {
    final SpotQuestionsState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData<SpotQuestionsState>(current.copyWith(isLoadingMore: true));
    try {
      final CursorPage<SpotQuestion> next = await _repository.fetchQuestions(
        catalogId: catalogId,
        first: _pageSize,
        after: current.endCursor,
      );
      state = AsyncData<SpotQuestionsState>(
        SpotQuestionsState(
          items: <SpotQuestion>[...current.items, ...next.items],
          hasMore: next.hasNextPage,
          endCursor: next.endCursor,
        ),
      );
    } on Object catch (error) {
      // 추가 로딩 실패는 보고 있는 목록을 지우지 않는다 — 인디케이터만 걷는다.
      _log.w('spotQuestions loadMore failed: ${error.runtimeType}');
      state = AsyncData<SpotQuestionsState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }

  /// 질문의 해결 여부를 바꾼다(R8).
  ///
  /// **여기만 낙관적으로 갱신한다**(설계 §상태 관리) — 결과가 눈에 바로 보여야 하고,
  /// 실패하면 그대로 되돌리면 된다. 작성은 낙관적으로 처리하지 않는다: 서버가 거부하면
  /// 롤백해야 하는데 그 사이 사용자가 자기 글을 이미 본 상태가 되기 때문이다.
  ///
  /// [resolved]가 false면 미해결로 되돌린다(2026-08-18 서버가 토글을 열었다).
  Future<SpotQaMutationResult<void>> resolve(
    String questionId, {
    required bool resolved,
  }) async {
    final SpotQuestionsState? current = state.value;
    if (current == null) {
      return const SpotQaMutationResult<void>.failure(null);
    }

    state = AsyncData<SpotQuestionsState>(
      current.copyWith(
        items: current.items
            .map(
              (SpotQuestion q) =>
                  q.id == questionId ? q.copyWith(resolved: resolved) : q,
            )
            .toList(growable: false),
      ),
    );

    late final SpotQaMutationResult<void> result;
    try {
      result = await _repository.resolveQuestion(
        questionId,
        resolved: resolved,
      );
    } on Object {
      // 전송·인증 실패는 예외로 온다. 목록을 지우지 않고 표시만 되돌린다.
      state = AsyncData<SpotQuestionsState>(current);
      rethrow;
    }

    if (!result.succeeded) state = AsyncData<SpotQuestionsState>(current);
    return result;
  }

  /// 작성·삭제 뒤 목록을 다시 받는다. **작성은 낙관적으로 넣지 않으므로**(설계
  /// §상태 관리) 서버 응답을 기다린 뒤 이 갱신으로 반영한다.
  Future<void> refresh() async {
    state = await AsyncValue.guard(() => build(catalogId));
  }
}
