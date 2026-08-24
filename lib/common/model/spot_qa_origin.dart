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
/// **[catalogId]도 예외가 아니다**(SPEC-0029). 예전에는 "장소는 삭제되지 않으므로
/// 항상 유효하다"고 적혀 있었고 맥락 카드를 눌러 상세로 보내는 근거가 그것이었으나,
/// 언어별 분리 이후 거짓이다 — 자세한 것은 [catalogId] 참조. 서버 스키마도 같은
/// 주장을 철회했다(`ConversationSpotQaOrigin.catalogId`).
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

  /// 장소 식별자. **id 자체는 언어와 무관하지만 열람 가능 여부는 아니다**(SPEC-0029).
  ///
  /// **이 값은 목록 필터를 거치지 않는다.** 인용 시점에 굳은 스냅샷이라, 작성자의
  /// 언어에서 해소되던 것이 수신자의 언어에서는 해소되지 않을 수 있고, 시간이 지나
  /// 작성자 본인의 언어에서도 그럴 수 있다. `spotDetail(id:)`에 넘기면
  /// `SPOT_NOT_FOUND_IN_LOCALE`로 실패한다.
  ///
  /// **그래서 이 id로 상세를 열지 않는다**(AC-27.2). 목록에서 받은 `PostSpot.id`와
  /// 결론이 반대라는 점이 요점이다 — 그쪽은 서버가 걸러 주지만 이쪽은 아니다.
  final String catalogId;

  /// 스냅샷 시점의 장소명. 이후 장소명이 바뀌어도 이 값은 고정이다 — 그래서 화면은
  /// 이 값을 그대로 쓰고 장소를 다시 조회하지 않는다.
  ///
  /// **제목이 보인다고 열리는 것은 아니다**(SPEC-0029). 이 값은 인용 시점에 발신자
  /// 언어로 굳은 스냅샷이라 항상 있지만, [catalogId]는 지금 언어에서 해소되지 않을
  /// 수 있다.
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
