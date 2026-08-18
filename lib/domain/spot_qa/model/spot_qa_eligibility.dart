/// 질문·답변 작성 자격(R3·R4).
///
/// **좋아요한 회원만 쓸 수 있다.** 반응 없음과 DISLIKE는 **둘 다** 자격 없음이며 둘을
/// 구분하지 않는다 — 서버가 그렇게 판정하기 때문이다.
///
/// 입력이 `SpotReaction?`이 아니라 불리언인 이유: 이 판정에 필요한 정보는 "좋아요인가"
/// 하나뿐이라 열거형을 받으면 `domain/spot`에 의존만 생기고 얻는 것이 없다(§3).
/// 호출부(장소 상세)가 `viewerReaction == SpotReaction.like`를 넘긴다.
///
/// 이것은 **UX이지 방어가 아니다.** 서버가 뮤테이션 시점에 다시 판정하며(R5),
/// 클라이언트는 `NOT_ELIGIBLE_TO_ASK`/`NOT_ELIGIBLE_TO_ANSWER`를 반드시 처리해야 한다.
/// 화면에서 버튼을 숨겼다는 이유로 그 분기를 생략하면, 좋아요 상태가 다른 기기에서
/// 바뀐 사용자가 원인 모를 실패를 겪는다.
///
/// 순수 함수 — 위젯·GraphQL·Riverpod 의존 없음.
bool canWriteSpotQa({required bool viewerLikedSpot}) => viewerLikedSpot;

/// 「지금 여기 어때?」 진입점을 장소 상세에 노출할지(2026-08-18 사용자 결정).
///
/// **자격이 없으면 숨긴다.** 비활성 + 안내로 좋아요를 유도하는 대안도 검토했으나,
/// 좋아요하지 않은 사용자에게까지 노출할 필요가 없다는 판단이다.
///
/// 단, 질문이 이미 있으면 자격과 무관하게 보인다 — **읽기는 누구에게나 열려 있다**
/// (AC-1.4). 숨기는 것은 "질문도 없고 쓸 자격도 없는" 경우뿐이며, 그때 진입점은
/// 작성 화면으로만 이어져 눌러 봐야 막힌다.
bool showSpotQaEntry({
  required bool viewerLikedSpot,
  required bool hasQuestions,
}) => hasQuestions || canWriteSpotQa(viewerLikedSpot: viewerLikedSpot);
