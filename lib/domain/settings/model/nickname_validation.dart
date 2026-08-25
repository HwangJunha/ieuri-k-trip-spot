/// 닉네임 형식 검사 결과(SPEC-0011 R5).
///
/// **중복은 여기 없다.** 중복은 허용되므로(2026-08-25 서버 변경) 검사할 것이
/// 없고, 클라이언트도 서버도 형식만 본다.
enum NicknameValidation {
  ok,

  /// 공백을 제외하면 비어 있다.
  empty,

  /// [nicknameMaxLength] 코드포인트를 넘었다.
  tooLong,
}

/// 닉네임 최대 길이(코드포인트). 디자인 §3의 "7/20" 카운터가 이 값을 쓴다.
///
/// **코드 단위가 아니라 코드포인트로 센다** — 이모지·한글이 UTF-16에서 2단위를
/// 차지해, `String.length`로 세면 사용자가 보는 글자 수와 카운터가 어긋난다.
const int nicknameMaxLength = 20;

/// 앞뒤 공백을 제거한 닉네임. 제출도 표시도 이 값을 쓴다 — 공백만 다른 닉네임은
/// 사용자에게 같은 값으로 보인다.
String normalizeNickname(String raw) => raw.trim();

/// 형식 검사(R5). 서버에 보내기 전 이 검사를 통과해야 한다.
NicknameValidation validateNickname(String raw) {
  final String value = normalizeNickname(raw);
  if (value.isEmpty) return NicknameValidation.empty;
  if (nicknameLength(value) > nicknameMaxLength) {
    return NicknameValidation.tooLong;
  }
  return NicknameValidation.ok;
}

/// 카운터에 그릴 글자 수. [nicknameMaxLength]와 같은 기준(코드포인트)으로 센다.
int nicknameLength(String raw) => raw.runes.length;
