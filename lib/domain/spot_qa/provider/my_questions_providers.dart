import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/pagination/page.dart';
import '../model/spot_question.dart';
import '../repository/seen_answer_counts_store.dart';
import '../repository/spot_qa_repository.dart';
import 'seen_answer_counts_providers.dart';
import 'spot_qa_providers.dart';

part 'my_questions_providers.g.dart';

/// 한 페이지 크기.
const int _pageSize = 20;

/// 내 질문 하나와 "못 본 답변이 있는지".
class MyQuestionItem {
  const MyQuestionItem({required this.question, required this.seenAnswerCount});

  final SpotQuestion question;

  /// 마지막으로 이 질문을 열어 봤을 때의 답변 수. 한 번도 안 열었으면 0이다.
  final int seenAnswerCount;

  /// 마지막으로 본 뒤로 답변이 늘었는지.
  ///
  /// **서버에 읽음 지점이 없어 이렇게 센다.** `answerCount`는 누적값이라 내가 어디까지
  /// 봤는지를 서버가 모른다 — 마지막으로 본 수를 로컬에 두고 비교하는 근사치이며,
  /// 서버가 질문별 읽음 지점을 갖게 되면 그때 이 계산을 걷어낸다.
  bool get hasNewAnswers => question.answerCount > seenAnswerCount;

  /// 새로 달린 답변 수. 배지 숫자다.
  int get newAnswerCount => question.answerCount - seenAnswerCount;
}

/// 내가 올린 질문 목록.
///
/// **출처는 서버다**(2026-08-18). 서버가 `spotQuestions`에 `mine` 필터를 더하면서,
/// 질문 목록을 로컬에 쌓던 임시 저장소를 걷어냈다 — 서버가 정답을 주는데 클라이언트가
/// 따로 기록을 쥐면 어긋날 때 판단 근거가 없다.
///
/// 그래서 **기기를 바꿔도, 앱을 지웠다 깔아도 내 질문이 그대로 보인다.** 예전 로컬
/// 방식의 가장 큰 구멍이 그것이었다.
///
/// 로컬에 남은 것은 「마지막에 본 답변 수」 하나뿐이다. 서버에 읽음 지점이 없어
/// 새 답변 배지를 그것 없이는 만들 수 없다. 이 값이 비어도 목록은 정상이고 배지만
/// 안 뜬다 — **목록의 정확성을 로컬 상태에 걸지 않는다.**
///
/// **인증이 필요하다.** 비로그인이면 repository가 실패를 던지고 화면이 그대로
/// 오류/로그인 안내로 분기한다 — 빈 목록으로 접으면 "쓴 적 없음"으로 오해된다.
@riverpod
class MyQuestionsController extends _$MyQuestionsController {
  SpotQaRepository get _repository => ref.read(spotQaRepositoryProvider);
  SeenAnswerCountsStore get _seen => ref.read(seenAnswerCountsStoreProvider);

  @override
  Future<List<MyQuestionItem>> build() async {
    final CursorPage<SpotQuestion> page = await _repository.fetchMyQuestions(
      first: _pageSize,
    );
    final Map<String, int> seen = _seen.read();
    return page.items
        .map(
          (SpotQuestion q) =>
              MyQuestionItem(question: q, seenAnswerCount: seen[q.id] ?? 0),
        )
        .toList(growable: false);
  }

  /// 질문을 열어 봤을 때 부른다 — 지금 답변 수를 "본 것"으로 적어 배지를 끈다.
  Future<void> markSeen(String questionId, int answerCount) async {
    final Map<String, int> current = _seen.read();
    if (current[questionId] == answerCount) return;

    await _seen.write(<String, int>{...current, questionId: answerCount});
    ref.invalidateSelf();
  }

  /// 목록을 다시 받는다. 질문을 새로 올린 뒤 호출부가 부른다.
  Future<void> reload() async {
    state = await AsyncValue.guard(build);
  }
}

/// 못 본 답변이 있는 질문 수. 진입점 배지가 이것만 구독한다.
///
/// **이 provider는 조회를 시작시키지 않는다.** [myQuestionsControllerProvider]가 이미
/// 살아 있을 때만 그 값을 읽고, 아니면 0이다 — 설정 화면에 배지 하나 그리려고 들어가는
/// 순간 질문 목록을 서버에서 받아 오는 것은 과하고, 비로그인이면 매번 실패한다.
///
/// 그래서 배지는 **「내 질문」을 한 번 열어 본 뒤부터** 뜬다. 부가 정보라 그 정도면
/// 충분하고, 못 본 답변의 진짜 확인 지점은 그 화면 자체다.
///
/// 조회 실패·비로그인이면 0이다 — 배지가 오류를 끌고 다니지 않는다.
@riverpod
int myQuestionsUnseenCount(Ref ref) {
  // `exists`로 먼저 거른다 — 없는 provider를 watch하면 그 자리에서 조회가 시작된다.
  if (!ref.exists(myQuestionsControllerProvider)) return 0;
  return ref
          .watch(myQuestionsControllerProvider)
          .value
          ?.where((MyQuestionItem i) => i.hasNewAnswers)
          .length ??
      0;
}
