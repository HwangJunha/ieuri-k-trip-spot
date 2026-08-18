/// DM이 어느 장소의 어느 질문/답변에서 시작됐는지의 스냅샷(SPEC-0026 R14).
///
/// **왜 `common/model/`인가.** `Conversation`(dm 소유)이 이 값을 필드로 갖고,
/// 만드는 쪽은 spot_qa다. 어느 한 기능에 두면 다른 기능이 그 기능의 내부를 import하게
/// 되므로(§3) 둘 이상이 쓰는 값은 공용 자리에 둔다(§4).
///
/// **원본을 가리키는 링크가 아니라 값을 복사해 둔 것이다.** 원본 질문·답변이 삭제돼도
/// 맥락이 남아야 하기 때문이다 — 맥락을 남기는 것이 이 타입의 존재 이유라서, 링크만
/// 걸면 원본이 사라지는 순간 목적을 잃는다.
///
/// 따라서 [questionId]·[answerId]는 삭제 후에도 값이 있지만 그 id로 다시 조회하면
/// 없을 수 있다. **참고용 식별자이지 살아있는 참조가 아니다.**
///
/// [catalogId]는 예외로 항상 유효하다(장소는 삭제되지 않는다) — 맥락 카드를 눌러
/// 장소 상세로 보내는 근거가 이것이다.
///
/// 순수 도메인 모델.
class SpotQaOrigin {
  const SpotQaOrigin({
    required this.catalogId,
    required this.spotTitle,
    required this.questionId,
    required this.questionBodySnapshot,
    required this.answerId,
    required this.answerBodySnapshot,
  });

  /// 장소 식별자. 언어 무관하며 `/spot/:id` 상세에 그대로 넘길 수 있다.
  final String catalogId;

  /// 스냅샷 시점의 장소명. 이후 장소명이 바뀌어도 이 값은 고정이다 — 그래서 화면은
  /// 이 값을 그대로 쓰고 장소를 다시 조회하지 않는다.
  final String spotTitle;

  final String questionId;

  /// 질문 본문 앞부분(최대 100자). 맥락 카드 한 줄 표시용이다.
  final String questionBodySnapshot;

  /// DM을 시작시킨 답변.
  final String answerId;

  /// 답변 본문 앞부분(최대 100자).
  final String answerBodySnapshot;

  @override
  bool operator ==(Object other) =>
      other is SpotQaOrigin &&
      other.catalogId == catalogId &&
      other.spotTitle == spotTitle &&
      other.questionId == questionId &&
      other.questionBodySnapshot == questionBodySnapshot &&
      other.answerId == answerId &&
      other.answerBodySnapshot == answerBodySnapshot;

  @override
  int get hashCode => Object.hash(
    catalogId,
    spotTitle,
    questionId,
    questionBodySnapshot,
    answerId,
    answerBodySnapshot,
  );
}
