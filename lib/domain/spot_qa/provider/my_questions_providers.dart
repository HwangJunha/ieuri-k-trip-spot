import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/pagination/page.dart';
import '../../../common/storage/app_preferences.dart';
import '../model/my_question_ref.dart';
import '../model/spot_question.dart';
import '../repository/my_questions_store.dart';
import '../repository/spot_qa_repository.dart';
import 'spot_qa_providers.dart';

part 'my_questions_providers.g.dart';

@riverpod
MyQuestionsStore myQuestionsStore(Ref ref) =>
    SharedPreferencesMyQuestionsStore(ref.watch(sharedPreferencesProvider));

/// 내 질문 하나와, 서버에서 되짚어 온 최신 상태.
///
/// [question]이 null이면 서버에서 찾지 못한 것이다 — 삭제됐거나, 신고 누적으로
/// 가려졌거나, 그 장소의 질문이 많아 첫 페이지 밖으로 밀려난 경우다. **그래도 목록에서
/// 지우지 않는다**: 내가 질문했다는 사실은 로컬 기록이 알고 있고, 조회 실패를 삭제로
/// 해석하면 일시적인 네트워크 오류에 내 기록이 사라진다.
class MyQuestionItem {
  const MyQuestionItem({required this.ref, this.question});

  final MyQuestionRef ref;

  /// 서버가 준 최신 질문. 못 찾았으면 null이다.
  final SpotQuestion? question;

  /// 마지막으로 본 뒤로 답변이 늘었는지. **알림이 없는 상태에서 "답이 달렸다"를
  /// 알리는 유일한 신호다.**
  bool get hasNewAnswers =>
      question != null && question!.answerCount > ref.seenAnswerCount;

  /// 새로 달린 답변 수. 배지에 숫자를 띄울 때 쓴다.
  int get newAnswerCount =>
      question == null ? 0 : question!.answerCount - ref.seenAnswerCount;
}

/// 내가 올린 질문 목록(로컬 기록 + 서버 되짚기).
///
/// **서버에 `myQuestions`가 없어서 이런 모양이다.** 로컬에 적어 둔 `catalogId`로 각
/// 장소의 질문 목록을 조회해 내 질문을 찾는다. 계약이 생기면 이 컨트롤러는 그 조회
/// 하나로 대체되고 로컬 저장소는 삭제된다(`MyQuestionRef` 주석 참고).
///
/// **장소당 한 번씩 조회한다.** 여러 질문이 같은 장소에 있으면 묶어서 한 번만 부른다 —
/// 질문 수가 아니라 장소 수만큼 왕복한다.
///
/// 일부 장소 조회가 실패해도 **나머지는 보여준다.** 전체를 오류로 만들면 장소 하나가
/// 죽었을 때 내 질문이 전부 안 보인다.
@riverpod
class MyQuestionsController extends _$MyQuestionsController {
  MyQuestionsStore get _store => ref.read(myQuestionsStoreProvider);
  SpotQaRepository get _repository => ref.read(spotQaRepositoryProvider);

  @override
  Future<List<MyQuestionItem>> build() async {
    final List<MyQuestionRef> refs = _store.read();
    if (refs.isEmpty) return const <MyQuestionItem>[];

    // 같은 장소의 질문은 한 번의 조회로 함께 찾는다.
    final Map<String, List<MyQuestionRef>> byCatalog =
        <String, List<MyQuestionRef>>{};
    for (final MyQuestionRef r in refs) {
      byCatalog.putIfAbsent(r.catalogId, () => <MyQuestionRef>[]).add(r);
    }

    final Map<String, SpotQuestion> found = <String, SpotQuestion>{};
    for (final MapEntry<String, List<MyQuestionRef>> entry
        in byCatalog.entries) {
      try {
        final CursorPage<SpotQuestion> page = await _repository.fetchQuestions(
          catalogId: entry.key,
          first: 50,
        );
        for (final SpotQuestion q in page.items) {
          found[q.id] = q;
        }
      } on Object catch (error) {
        // 이 장소만 접는다. 나머지 장소의 질문은 그대로 보여준다.
        developer.log(
          'myQuestions lookup failed for ${entry.key}: ${error.runtimeType}',
          name: 'MyQuestionsController',
        );
      }
    }

    return refs
        .map(
          (MyQuestionRef r) =>
              MyQuestionItem(ref: r, question: found[r.questionId]),
        )
        .toList(growable: false);
  }

  /// 질문을 새로 올렸을 때 기록한다. 목록 맨 앞에 놓고 상한을 넘으면 오래된 것을 버린다.
  Future<void> remember({
    required String catalogId,
    required String questionId,
    required String spotTitle,
    required DateTime askedAt,
  }) async {
    final List<MyQuestionRef> current = _store.read();
    // 같은 질문이 두 번 들어오지 않게 한다(재시도·중복 제출).
    final List<MyQuestionRef> next = <MyQuestionRef>[
      MyQuestionRef(
        catalogId: catalogId,
        questionId: questionId,
        spotTitle: spotTitle,
        askedAt: askedAt,
      ),
      ...current.where((MyQuestionRef r) => r.questionId != questionId),
    ];
    await _store.write(
      next.length > myQuestionsLimit ? next.sublist(0, myQuestionsLimit) : next,
    );
    ref.invalidateSelf();
  }

  /// 질문을 열어 봤을 때 호출한다 — 지금 답변 수를 "본 것"으로 기록해 배지를 끈다.
  Future<void> markSeen(String questionId, int answerCount) async {
    final List<MyQuestionRef> current = _store.read();
    bool changed = false;
    final List<MyQuestionRef> next = current
        .map((MyQuestionRef r) {
          if (r.questionId != questionId || r.seenAnswerCount == answerCount) {
            return r;
          }
          changed = true;
          return r.copyWith(seenAnswerCount: answerCount);
        })
        .toList(growable: false);

    // 바뀐 게 없으면 쓰지도, 다시 그리지도 않는다.
    if (!changed) return;
    await _store.write(next);
    ref.invalidateSelf();
  }
}

/// 못 본 답변이 있는 질문 수. 진입점 배지가 이것만 구독한다.
@riverpod
int myQuestionsUnseenCount(Ref ref) =>
    ref
        .watch(myQuestionsControllerProvider)
        .value
        ?.where((MyQuestionItem i) => i.hasNewAnswers)
        .length ??
    0;
