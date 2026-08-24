/// 닉네임 형식 검사 결과(SPEC-0011 R5).
///
/// **중복은 여기 없다.** 클라이언트는 형식만 보고, 중복은 서버 판정을
/// `NICKNAME_ALREADY_TAKEN`으로 받아 입력란 오류로 표시한다 — 미리 조회해도 조회와
/// 제출 사이에 선점당할 수 있어 어차피 서버 오류를 처리해야 한다(설계 §4).
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
