/// 신고 사유(서버 `ReportReason`, 가이드 §9). 안정 식별자이며 **표시 문자열은
/// 클라이언트가 l10n으로 매핑한다** — `PostTopic`과 같은 방식(POL-023).
///
/// [other]를 고르면 `detail`이 **필수**다. 비면 서버가 `REPORT_DETAIL_REQUIRED`로
/// 거부하므로 입력 폼에서 미리 막는다(가이드 §9).
enum ReportReason { spam, abuse, inappropriateContent, other }

/// 신고 대상 종류(서버 `ReportTargetType`).
///
/// **`member` 신고는 기록만 된다** — 5명이 신고해도 그 사람의 글이 사라지지 않는다.
/// 자동 조치는 [post]·[comment]에만 있으므로 "접수되었다" 이상을 약속하지 않는다
/// (가이드 §9).
///
/// [spotQuestion]·[spotAnswer]·[spotAnswerReply]는 SPEC-0026에서 서버가 더한 값이다
/// (가산적 변경). 장소 질문/답변도 **새 신고 뮤테이션 없이 `reportContent`를 그대로
/// 쓴다**(R11) — 신고 사유·중복 규칙이 커뮤니티와 같기 때문이다.
enum ReportTargetType {
  post,
  comment,
  member,
  spotQuestion,
  spotAnswer,
  spotAnswerReply,
}
