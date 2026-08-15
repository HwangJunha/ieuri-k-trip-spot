import '../../community/model/report_reason.dart';

/// 신고 사유를 **서버 열거값 이름**으로 옮긴다.
///
/// **`ReportReason.name`을 그대로 쓰면 안 된다.** Dart 식별자는 camelCase
/// (`inappropriateContent`)인데 서버 enum은 SCREAMING_SNAKE
/// (`INAPPROPRIATE_CONTENT`)라, 이름을 그대로 보내면 repository의 매핑이 모르는
/// 값으로 보고 조용히 `OTHER`로 접는다 — 사유가 통째로 바뀌는데 오류는 나지 않는다.
///
/// **사유 시트는 커뮤니티 것을 재사용하라는 것이 스펙의 지시다**(설계 §8) — 그래서
/// 커뮤니티의 `ReportReason`이 이 경계를 넘어온다. 여기서 하는 일은 그 값을 피드
/// repository가 받는 문자열 규약으로 옮기는 것뿐이다.
String reportReasonCode(ReportReason reason) => switch (reason) {
  ReportReason.spam => 'SPAM',
  ReportReason.abuse => 'ABUSE',
  ReportReason.inappropriateContent => 'INAPPROPRIATE_CONTENT',
  ReportReason.other => 'OTHER',
};
