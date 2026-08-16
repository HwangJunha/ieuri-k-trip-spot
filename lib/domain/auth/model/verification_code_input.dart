/// 6칸 인증 코드 입력의 **순수 로직**(SPEC-0024 R11).
///
/// **왜 모델인가.** 칸 사이의 포커스 이동과 붙여넣기 분배는 위젯을 세우지 않으면
/// 확인할 수 없어 보이지만, 실제로 틀리기 쉬운 부분은 "다음에 어느 칸이 활성인가"와
/// "값이 어떻게 합쳐지는가"뿐이다. 그 둘을 값 계산으로 떼어 두면 표처럼 검증할 수
/// 있고, 위젯은 결과를 실제 `FocusNode`에 옮기는 일만 한다(설계 §7).
///
/// **코드는 끝까지 문자열이다.** 여섯 자리 중 앞자리 0이 의미를 가지므로(R11-5,
/// POL-004) `int`로 바꾸는 순간 `012345`가 `12345`가 된다. 이 파일에는 수치 변환이
/// 없고, 있어서도 안 된다.
library;

/// 코드의 자릿수. 서버가 6자리를 발급한다(POL-004).
const int verificationCodeLength = 6;

/// 한 칸에 들어갈 수 있는 문자인지. 숫자 한 글자만 허용한다.
bool _isDigit(String character) =>
    character.length == 1 &&
    character.codeUnitAt(0) >= 0x30 &&
    character.codeUnitAt(0) <= 0x39;

/// 여섯 칸의 값과 그로부터 파생되는 계산을 담는 불변 값.
///
/// 각 칸은 빈 문자열이거나 숫자 한 글자다. 칸 수는 항상
/// [verificationCodeLength]로 고정된다 — 길이가 변하는 경우는 없다.
class VerificationCodeInput {
  const VerificationCodeInput._(this.digits);

  /// 모든 칸이 빈 초기 상태.
  factory VerificationCodeInput.empty() => VerificationCodeInput._(
    List<String>.filled(verificationCodeLength, '', growable: false),
  );

  /// 임의의 칸 값으로 만든다. 테스트와 복원 경로에서 쓴다. 숫자가 아닌 값과
  /// 넘치는 칸은 버려서 불변식을 지킨다.
  factory VerificationCodeInput.of(List<String> digits) {
    final List<String> normalized = List<String>.filled(
      verificationCodeLength,
      '',
      growable: false,
    );
    for (int i = 0; i < verificationCodeLength && i < digits.length; i++) {
      final String value = digits[i];
      if (_isDigit(value)) normalized[i] = value;
    }
    return VerificationCodeInput._(normalized);
  }

  /// 칸별 값. 빈 문자열은 미입력이다.
  final List<String> digits;

  /// 전송용 코드 문자열. 칸을 **문자열 그대로** 이어 붙인다 — 앞자리 0이 살아남는
  /// 유일한 방법이다(R11-5).
  String get code => digits.join();

  /// 여섯 칸이 모두 찼는지. 제출 버튼의 활성 조건이다.
  bool get isComplete => digits.every((String d) => d.isNotEmpty);

  /// [index] 칸에 [character]를 입력한 결과.
  ///
  /// 숫자가 아니면 상태를 바꾸지 않는다 — 키보드를 숫자 전용으로 띄워도 하드웨어
  /// 키보드나 IME로 다른 문자가 들어올 수 있다.
  ///
  /// 사용자가 한 칸에 여러 글자를 한꺼번에 넣은 경우(붙여넣기, 자동완성)는
  /// [paste]로 넘긴다 — 그쪽이 칸 분배 규칙을 안다.
  VerificationCodeInput enter(int index, String character) {
    if (character.length > 1) return paste(character, from: index);
    if (!_isDigit(character)) return this;
    if (index < 0 || index >= verificationCodeLength) return this;
    final List<String> next = List<String>.of(digits);
    next[index] = character;
    return VerificationCodeInput._(List<String>.unmodifiable(next));
  }

  /// [index] 칸만 비운 결과.
  ///
  /// [deleteAt]과 다르다 — 이쪽은 이미 빈 칸이어도 이전 칸을 건드리지 않는다.
  /// 텍스트 필드가 "값이 지워졌다"고 알려 온 경우가 여기다. 그 시점엔 지워진 칸이
  /// 확정돼 있어서, 이전 칸까지 비우면 사용자가 지우지 않은 자리가 사라진다.
  VerificationCodeInput enterEmpty(int index) {
    if (index < 0 || index >= verificationCodeLength) return this;
    if (digits[index].isEmpty) return this;
    final List<String> next = List<String>.of(digits);
    next[index] = '';
    return VerificationCodeInput._(List<String>.unmodifiable(next));
  }

  /// [index] 칸에서 삭제한 결과.
  ///
  /// 칸에 값이 있으면 그 칸을 비우고, 이미 비어 있으면 **이전 칸을 비운다**(R11-3).
  /// 빈 칸에서의 삭제가 아무 일도 하지 않으면 사용자는 앞 칸을 고치려고 두 번
  /// 눌러야 한다 — 포커스만 옮기고 값을 남기면 다음 입력이 덮어써 헷갈린다.
  VerificationCodeInput deleteAt(int index) {
    if (index < 0 || index >= verificationCodeLength) return this;
    final List<String> next = List<String>.of(digits);
    if (next[index].isNotEmpty) {
      next[index] = '';
    } else if (index > 0) {
      next[index - 1] = '';
    }
    return VerificationCodeInput._(List<String>.unmodifiable(next));
  }

  /// [text]를 [from] 칸부터 순서대로 분배한 결과(R11-4).
  ///
  /// 숫자가 아닌 문자는 걸러 낸다 — 메일에서 복사하면 공백이나 줄바꿈이 딸려 오는
  /// 일이 흔하고, 그걸 이유로 붙여넣기를 통째로 버리면 사용자가 손으로 다시 친다.
  /// 칸 수를 넘치는 만큼은 버린다.
  VerificationCodeInput paste(String text, {int from = 0}) {
    final String cleaned = text.split('').where(_isDigit).join();
    if (cleaned.isEmpty) return this;
    final int start = from.clamp(0, verificationCodeLength - 1);
    final List<String> next = List<String>.of(digits);
    for (
      int i = 0;
      i < cleaned.length && start + i < verificationCodeLength;
      i++
    ) {
      next[start + i] = cleaned[i];
    }
    return VerificationCodeInput._(List<String>.unmodifiable(next));
  }

  @override
  bool operator ==(Object other) =>
      other is VerificationCodeInput && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'VerificationCodeInput($code)';
}

/// 입력 뒤 포커스가 갈 칸(R11-2).
///
/// 한 칸을 채우면 다음 칸으로 전진하고, 마지막 칸이면 그 자리에 머문다 — 여섯 번째
/// 입력 뒤 포커스가 사라지면 사용자가 마지막 자리를 고칠 수 없다.
///
/// 붙여넣기처럼 여러 칸이 한 번에 찬 경우에도 맞아야 하므로, "입력한 칸 + 1"이
/// 아니라 **채워진 상태를 보고** 정한다.
int focusAfterEntry(VerificationCodeInput input, int index) {
  if (index < 0) return 0;
  final int next = index + 1;
  if (next >= verificationCodeLength) return verificationCodeLength - 1;
  return next;
}

/// 붙여넣기 뒤 포커스가 갈 칸(R11-4).
///
/// 첫 번째 빈 칸으로 보낸다. 다 찼으면 마지막 칸에 둔다 — 제출 직전이므로 사용자가
/// 마지막 자리를 확인·수정할 수 있는 자리가 자연스럽다.
int focusAfterPaste(VerificationCodeInput input) {
  final int firstEmpty = input.digits.indexWhere((String d) => d.isEmpty);
  return firstEmpty == -1 ? verificationCodeLength - 1 : firstEmpty;
}

/// 삭제 뒤 포커스가 갈 칸(R11-3).
///
/// 값이 있던 칸을 지웠으면 그 자리에 머물고, 빈 칸에서 지웠으면 이전 칸으로
/// 후퇴한다. 판정 근거는 **삭제 이전** 상태다 — 삭제 후만 보면 두 경우가 구분되지
/// 않는다.
int focusAfterDelete(VerificationCodeInput before, int index) {
  if (index <= 0) return 0;
  if (index >= verificationCodeLength) return verificationCodeLength - 1;
  return before.digits[index].isNotEmpty ? index : index - 1;
}
