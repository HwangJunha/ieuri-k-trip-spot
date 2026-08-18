import '../../../common/pagination/page.dart';
import '../model/spot_answer.dart';
import '../model/spot_qa_failure.dart';
import '../model/spot_question.dart';

/// 장소 질문/답변 데이터 접근 경계(SPEC-0026).
///
/// 생성 타입은 이 경계 밖으로 나가지 않는다 — 구현체가 도메인 모델로 매핑한다
/// (CLAUDE.md §3, POL-020).
///
/// 실패는 두 갈래다(계약 §오류 코드):
/// - 최상위 `errors[]` — 세션 신호(`UNAUTHENTICATED`). 구현체가 [SpotQaFailure]로 던진다
/// - `userErrors[]` — 도메인 규칙 위반. 폼 상태를 유지한 채 분기해야 하므로
///   **예외가 아니라 값으로 돌려준다**([SpotQaMutationResult])
///
/// **사진 업로드가 없다.** 계약 초안의 `createSpotQaImageUploadUrls` 3종이 서버에
/// 구현되지 않아 이번 범위에서 빠졌다(설계 §사진 첨부). 작성 메서드는 서버가 실제로
/// 받는 `photoKeys`를 인자로 두되 지금은 호출부가 빈 목록을 넘긴다 — 서버가 업로드를
/// 구현하면 이 경계를 바꾸지 않고 값만 채우면 된다.
abstract interface class SpotQaRepository {
  /// 이 장소의 질문 목록.
  ///
  /// **정렬 인자가 없다** — 미해결 우선·최신순은 서버가 고정하며(R2), 계약에 없는
  /// 인자를 요구하지 않기 위해 클라이언트도 정렬 UI를 두지 않는다.
  ///
  /// **인증 없이 호출된다**(AC-1.4). 읽기에 세션을 요구하지 않는다.
  Future<CursorPage<SpotQuestion>> fetchQuestions({
    required String catalogId,
    int? first,
    String? after,
  });

  /// 질문 하나의 답변 목록. 답글은 [SpotAnswer.replies]로 함께 온다.
  Future<CursorPage<SpotAnswer>> fetchAnswers({
    required String questionId,
    int? first,
    String? after,
  });

  /// 질문을 작성하고 새 질문 id를 돌려준다.
  ///
  /// 자격이 없으면 `NOT_ELIGIBLE_TO_ASK`가 **값으로** 온다 — 서버가 커맨드 시점에
  /// 다시 판정하므로(R5) 화면에서 버튼을 숨겼더라도 이 분기를 생략하면 안 된다.
  /// 좋아요 상태가 다른 기기에서 바뀐 사용자가 원인 모를 실패를 겪는다.
  Future<SpotQaMutationResult<String>> createQuestion({
    required String catalogId,
    required String body,
    List<String> photoKeys,
  });

  /// 본인 질문 삭제. 타인 질문은 `NOT_QUESTION_OWNER`. 딸린 답변·답글도 함께 삭제된다.
  Future<SpotQaMutationResult<void>> deleteQuestion(String questionId);

  /// 질문을 해결됨으로 표시한다. **멱등이며 되돌리는 수단이 없다**(서버에 뮤테이션이
  /// 없다) — 그래서 낙관적 갱신을 적용해도 되돌리기 UI를 만들 필요가 없다.
  Future<SpotQaMutationResult<void>> resolveQuestion(String questionId);

  /// 답변을 작성하고 새 답변 id를 돌려준다. 자격 없으면 `NOT_ELIGIBLE_TO_ANSWER`.
  /// **해결됨으로 표시된 질문에도 답변할 수 있다.**
  Future<SpotQaMutationResult<String>> createAnswer({
    required String questionId,
    required String body,
    List<String> photoKeys,
  });

  Future<SpotQaMutationResult<void>> deleteAnswer(String answerId);

  /// 답변에 답글을 단다. **1단계뿐이라** 대상이 이미 답글이면
  /// `REPLY_TO_REPLY_NOT_ALLOWED`가 온다 — 다만 UI가 답글에 답글 액션을 노출하지
  /// 않으므로 정상 흐름에서는 도달하지 않는다.
  Future<SpotQaMutationResult<String>> createReply({
    required String parentAnswerId,
    required String body,
    List<String> photoKeys,
  });

  Future<SpotQaMutationResult<void>> deleteReply(String replyId);
}
