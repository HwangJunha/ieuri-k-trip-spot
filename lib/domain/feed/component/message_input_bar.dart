import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 대화 입력창 — 텍스트 + 전송 버튼.
///
/// **사진·파일 첨부 버튼은 없다**(범위 밖, 설계 §5). 모델은 `photoKey`를 받지만
/// 이 화면에서 사진을 고르는 수단은 이번 스펙에 없다.
///
/// [maxLength]는 서버 상한과 같은 1000자다. 카운터는 **한계에 가까워졌을 때만**
/// 드러난다 — 짧은 메시지가 대부분인 화면에서 상시 카운터는 잡음이다(디자인 §5).
class MessageInputBar extends StatefulWidget {
  const MessageInputBar({
    super.key,
    required this.onSend,
    required this.onChanged,
  });

  /// 보낼 본문. 공백만 남은 입력은 이 위젯이 먼저 거른다.
  final ValueChanged<String> onSend;

  /// 입력이 바뀔 때마다 불린다 — 호출부가 `notifyTyping`을 보낸다. **스로틀은
  /// provider가 한다**(설계 §5) — 키 입력마다 뮤테이션을 보내면 유실 허용 기능
  /// 하나가 대역폭을 독차지한다.
  final VoidCallback onChanged;

  static const int maxLength = 1000;

  /// 카운터가 드러나는 지점(한계의 90%). 커뮤니티 컴포저와 같은 관례다.
  static const int _counterThreshold = (maxLength * 9) ~/ 10;

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _controller = TextEditingController();
  int _length = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSend => _controller.text.trim().isNotEmpty;

  void _handleChanged(String value) {
    // 글자 수는 **코드포인트 단위로** 센다 — 이모지가 두 글자로 세어지면 사용자가
    // 보는 것과 카운터가 어긋난다.
    setState(() => _length = value.characters.length);
    widget.onChanged();
  }

  void _send() {
    final String body = _controller.text.trim();
    if (body.isEmpty) return;
    _controller.clear();
    setState(() => _length = 0);
    widget.onSend(body);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool showCounter = _length >= MessageInputBar._counterThreshold;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                // 입력을 자르는 것이 아니라 상한에서 멈춘다 — 서버가 같은 규칙을
                // 다시 판정하므로 이 판정은 UX 미러링이다.
                maxLength: MessageInputBar.maxLength,
                textInputAction: TextInputAction.newline,
                onChanged: _handleChanged,
                decoration: InputDecoration(
                  hintText: l10n.dmMessageInputHint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                  // 한계에 가까워지기 전에는 카운터를 감춘다.
                  counterText: showCounter
                      ? '$_length / ${MessageInputBar.maxLength}'
                      : '',
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              tooltip: l10n.dmSendAction,
              onPressed: _canSend ? _send : null,
              color: theme.colorScheme.primary,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
