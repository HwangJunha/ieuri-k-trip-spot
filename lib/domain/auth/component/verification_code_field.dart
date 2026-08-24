import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/verification_code_input.dart';

/// 6칸 인증 코드 입력(SPEC-0024 R11).
///
/// 인증 화면과 이메일 변경 확인 두 곳에서 쓰므로 component에 둔다(설계 §8).
///
/// **값 계산은 여기에 없다.** 칸 분배·포커스 규칙은 전부
/// [VerificationCodeInput]과 `focusAfter*` 함수가 정하고, 이 위젯은 그 결과를
/// `TextEditingController`와 `FocusNode`에 옮기기만 한다. 규칙을 위젯에 넣으면
/// 위젯 테스트 없이는 확인할 수 없어진다(설계 §7).
class VerificationCodeField extends StatefulWidget {
  const VerificationCodeField({
    super.key,
    required this.onChanged,
    this.onCompleted,
    this.enabled = true,
    this.errorText,
    this.autofocus = true,
  });

  /// 칸이 하나라도 바뀔 때마다 현재 코드 문자열을 넘긴다. 여섯 자리가 안 되면
  /// 그만큼 짧은 문자열이다 — 완성 여부는 [onCompleted]로 판단한다.
  final ValueChanged<String> onChanged;

  /// 여섯 칸이 모두 찼을 때 한 번 불린다. 자동 제출에 쓴다.
  final ValueChanged<String>? onCompleted;

  final bool enabled;
  final String? errorText;
  final bool autofocus;

  @override
  State<VerificationCodeField> createState() => _VerificationCodeFieldState();
}

class _VerificationCodeFieldState extends State<VerificationCodeField> {
  /// 칸별 컨트롤러/포커스. 길이는 [verificationCodeLength]로 고정이다.
  late final List<TextEditingController> _controllers =
      List<TextEditingController>.generate(
        verificationCodeLength,
        (_) => TextEditingController(),
        growable: false,
      );
  late final List<FocusNode> _focusNodes = List<FocusNode>.generate(
    verificationCodeLength,
    (_) => FocusNode(),
    growable: false,
  );

  VerificationCodeInput _input = VerificationCodeInput.empty();

  /// [onCompleted]를 코드 하나당 한 번만 부르기 위한 표시. 완성된 상태에서 칸을
  /// 고치면 다시 열린다.
  bool _completionReported = false;

  @override
  void dispose() {
    for (final TextEditingController c in _controllers) {
      c.dispose();
    }
    for (final FocusNode f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  /// 계산된 [next] 상태를 칸에 반영하고 [focus] 칸으로 포커스를 옮긴다.
  void _apply(VerificationCodeInput next, int focus) {
    setState(() => _input = next);
    for (int i = 0; i < verificationCodeLength; i++) {
      final String value = next.digits[i];
      if (_controllers[i].text != value) {
        // 커서를 값 뒤에 둔다. 그러지 않으면 다음 입력이 앞에 끼어든다.
        _controllers[i].value = TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
      }
    }
    if (widget.enabled) _focusNodes[focus].requestFocus();

    widget.onChanged(next.code);
    if (next.isComplete) {
      if (!_completionReported) {
        _completionReported = true;
        widget.onCompleted?.call(next.code);
      }
    } else {
      _completionReported = false;
    }
  }

  /// 칸의 텍스트가 바뀌었을 때. 붙여넣기는 한 칸에 여러 글자가 들어오는 형태로
  /// 도착하므로 [VerificationCodeInput.enter]가 [VerificationCodeInput.paste]로
  /// 넘겨 준다 — 여기서 갈래를 나누지 않는다.
  void _onChanged(int index, String value) {
    if (value.isEmpty) {
      // 값이 지워진 경우다. 백스페이스 키 처리(_onKey)가 이미 다룬 뒤라면 상태가
      // 같아 아무 일도 일어나지 않는다.
      final VerificationCodeInput next = _input.enterEmpty(index);
      if (next == _input) return;
      _apply(next, index);
      return;
    }
    final VerificationCodeInput next = _input.enter(index, value);
    if (next == _input) {
      // 거부된 입력(숫자 아님) — 칸을 원래 값으로 되돌린다.
      _controllers[index].value = TextEditingValue(
        text: _input.digits[index],
        selection: TextSelection.collapsed(
          offset: _input.digits[index].length,
        ),
      );
      return;
    }
    final int focus = value.length > 1
        ? focusAfterPaste(next)
        : focusAfterEntry(next, index);
    _apply(next, focus);
  }

  /// 빈 칸에서의 백스페이스(R11-3).
  ///
  /// 칸이 이미 비어 있으면 `onChanged`가 오지 않으므로 키 이벤트로 잡아야 한다.
  KeyEventResult _onKey(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.backspace) {
      return KeyEventResult.ignored;
    }
    if (_input.digits[index].isNotEmpty) return KeyEventResult.ignored;

    final int focus = focusAfterDelete(_input, index);
    _apply(_input.deleteAt(index), focus);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (int i = 0; i < verificationCodeLength; i++)
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: i == verificationCodeLength - 1 ? 0 : 8,
                  ),
                  child: _box(theme, i, hasError),
                ),
              ),
          ],
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              widget.errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _box(ThemeData theme, int index, bool hasError) {
    return Focus(
      onKeyEvent: (FocusNode _, KeyEvent event) => _onKey(index, event),
      child: TextField(
        key: Key('verification-code-box-$index'),
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        enabled: widget.enabled,
        autofocus: widget.autofocus && index == 0,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        textInputAction: index == verificationCodeLength - 1
            ? TextInputAction.done
            : TextInputAction.next,
        style: theme.textTheme.headlineSmall,
        // 길이를 제한하지 않는다. 붙여넣기가 한 칸에 여섯 글자로 도착해야
        // [VerificationCodeInput.paste]가 칸을 나눌 수 있다(R11-4) — maxLength: 1을
        // 걸면 붙여넣기가 첫 글자만 남기고 잘린다.
        //
        // 숫자만 통과시키는 것도 모델이 한다. 여기서 한 번 더 거르면 규칙이 두
        // 군데로 갈라진다.
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: const OutlineInputBorder(),
          errorText: hasError ? '' : null,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
        ),
        onChanged: (String value) => _onChanged(index, value),
      ),
    );
  }
}
