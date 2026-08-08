/// 이메일 형식 검사. 순수 값 로직이라 flutter도 riverpod도 들어오지 않는다.
///
/// **왜 `common/`에 있는가.** 가입·로그인·비밀번호 재설정(`domain/auth`)과 이메일
/// 변경(`domain/settings`)이 함께 쓴다 — 둘 이상이 쓰면 공용이다(CLAUDE.md §4).
/// 예전에는 `auth/model/password_policy.dart` 안에 있었는데, 이메일 형식 검사가
/// "비밀번호 정책" 파일에 사는 것도 맞지 않았다.
///
/// 세션 상태가 아니라 **문자열 검사기**라는 점이 `AuthController`와 다르다. 그쪽은
/// auth가 소유하는 것이 옳지만 이건 소유자가 없다.
class EmailFormat {
  const EmailFormat._();

  static final RegExp _pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValid(String email) => _pattern.hasMatch(email.trim());
}
