import '../../../common/model/composer_photo.dart';
import '../../../common/model/post_image_upload.dart';
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
  /// 사진 업로드 URL 발급. **커뮤니티와 같은 오퍼레이션을 쓴다**(POL-042) —
  /// spot_qa 전용 업로드 뮤테이션은 서버에 없다.
  ///
  /// 오브젝트 키가 `{상태}/community/{memberId}/{uuid}` 형식이고 검증이 회원 소유
  /// 기준이라, 질문/답변 사진도 이 흐름을 그대로 통과한다. 전용 경로를 만들면 같은
  /// 로직의 복사본이 되고 고를 이유 없는 선택지만 늘어난다.
  ///
  /// **전부 아니면 전무다** — 한 장이라도 형식·크기가 어긋나면 빈 목록이 온다.
  Future<List<PostImageUploadUrl>> createImageUploadUrls(
    List<PostImageUploadRequest> images,
  );

  /// 발급받은 URL로 직접 PUT한다. **GraphQL이 아니다.** 인증 헤더를 붙이지 않으며
  /// (서명이 URL에 있다) 바이트 수가 1이라도 다르면 스토리지가 403으로 거부한다.
  Future<void> uploadImage({
    required String uploadUrl,
    required LocalPhoto photo,
  });

  /// 업로드 확정. **장별로 성패가 갈리며 실패는 값으로 돌아온다** — 5장 중 3장째
  /// 실패를 "업로드 실패"로 뭉뚱그리지 않는다. 성공한 것은 유지하고 실패한 것만
  /// 다시 올릴 수 있어야 한다(설계 §사진 첨부).
  ///
  /// 확정되지 않은 키(`pending/...`)를 작성에 넘기면 서버가 `PHOTO_NOT_UPLOADED`로
  /// 거부한다 — 커뮤니티 글과 같은 코드다.
  Future<PostImageConfirmation> confirmImageUploads(List<String> objectKeys);

  /// 업로드한 사진을 지운다(작성 취소 시 정리). 멱등이다.
  Future<void> deleteImage(String objectKey);

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

  /// 내가 쓴 질문 목록(2026-08-18 서버가 `spotQuestions`에 `mine` 필터를 더했다).
  ///
  /// **인증이 필요하다.** 비로그인이면 최상위 `errors`로 실패하며 [SpotQaFailure]가
  /// 던져진다 — 빈 목록으로 접지 않는 것이 중요하다. 조용히 비우면 "쓴 적 없음"으로
  /// 오해되는데, 실제로는 "로그인하면 보인다"이기 때문이다.
  ///
  /// 회원 id를 넘기지 않는다 — 인자가 없고 호출자는 서버가 토큰에서 정한다.
  Future<CursorPage<SpotQuestion>> fetchMyQuestions({int? first, String? after});

  /// id로 질문을 집어 온다(딥링크·알림 진입). 단건 루트가 없어 `ids` 필터를 쓴다.
  ///
  /// **가려진 id는 빠진다** — 차단·숨김·삭제면 결과에 없다. 요청한 수보다 적게 오거나
  /// 비어 오는 것이 정상이며 오류가 아니다.
  ///
  /// [ids]가 비면 **서버를 부르지 않고 빈 목록을 돌려준다** — 빈 배열을 그대로
  /// 넘기면 서버가 "결과 없음"으로 답해 같은 값이 오지만, 부를 이유가 없는 왕복이다.
  Future<CursorPage<SpotQuestion>> fetchQuestionsByIds(
    List<String> ids, {
    int? first,
  });

  /// 질문 하나의 답변 목록. 답글은 [SpotAnswer.replies]로 함께 온다.
  Future<CursorPage<SpotAnswer>> fetchAnswers({
    required String questionId,
    int? first,
    String? after,
  });

  /// 질문을 작성하고 새 질문 id를 돌려준다.
  ///
  /// **좋아요 자격을 요구하지 않는다**(2026-08-18 서버가 게이팅을 걷어냈다). 반응
  /// 없음·싫어요를 포함해 로그인한 회원이면 쓸 수 있다.
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

  /// 답변을 작성하고 새 답변 id를 돌려준다.
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
