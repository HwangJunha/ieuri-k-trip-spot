/// 이메일 변경 요청 1단계의 결과(SPEC-0011 R7). 서버가 새 주소로 코드를 보내고
/// 그 검증 건의 손잡이를 돌려준다 — **이 시점에 프로필 이메일은 아직 옛 값이다**.
///
/// 순수 도메인이다. 생성 타입(`*.graphql.dart`)은 repository를 넘지 않는다
/// (CLAUDE.md §3).
class EmailChangeRequest {
  const EmailChangeRequest({required this.verificationId, this.expiresAt});

  /// 2단계(`confirmEmailChange`)와 재발송(`resendEmailChange`)에 그대로 넘긴다.
  final String verificationId;

  /// 코드 만료 시각(서버가 준 ISO-8601 원문). **파싱하지 않고 보관만 한다** —
  /// 화면이 쓰는 것은 60초 재발송 쿨다운이지 이 값이 아니고, 형식이 어긋났다고
  /// 흐름을 실패시킬 이유가 없다.
  final String? expiresAt;
}
