import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/spot_qa_failure.dart';
import '../provider/spot_qa_composer_providers.dart';
import 'spot_qa_eligibility_banner.dart';

/// 답변·답글 인라인 컴포저(디자인 §4).
///
/// ```
/// (자격 거부 시) 배너
/// [ 둥근 입력칸 ................. ] [전송]
/// ```
///
/// **낙관적 갱신이 없다**(설계 §상태 관리) — 서버 응답을 기다린 뒤 [onSubmitted]로
/// 목록 갱신을 호출부에 맡긴다. 서버가 자격을 판정하므로 낙관적으로 넣으면 거부 시
/// 롤백해야 하고, 그 사이 사용자가 자기 글을 이미 본 상태가 된다.
///
/// **거부돼도 입력을 지우지 않는다.** 자격 없음이면 배너만 띄우고 컴포저를 접지
/// 않는다 — 사용자가 쓴 글을 자격 문제로 날리는 것은 과하다(설계 §작성 자격 표시).
///
/// **사진 첨부가 없다.** 서버에 업로드 뮤테이션이 없어 이번 범위에서 빠졌다(설계
/// §사진 첨부) — 카메라·갤러리 아이콘을 그리지 않는다.
class SpotQaInlineComposer extends ConsumerStatefulWidget {
  const SpotQaInlineComposer({
    super.key,
    required this.target,
    required this.targetId,
    required this.onSubmitted,
    this.autofocus = false,
  });

  /// 답변이면 [SpotQaComposerTarget.answer], 답글이면 [SpotQaComposerTarget.reply].
  final SpotQaComposerTarget target;

  /// 답변이면 questionId, 답글이면 parentAnswerId.
  final String targetId;

  /// 서버가 성공을 확인한 뒤 불린다 — 호출부가 목록을 다시 받는다.
  final VoidCallback onSubmitted;

  final bool autofocus;

  @override
  ConsumerState<SpotQaInlineComposer> createState() =>
      _SpotQaInlineComposerState();
}

class _SpotQaInlineComposerState extends ConsumerState<SpotQaInlineComposer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  SpotQaComposerProvider get _provider =>
      spotQaComposerProvider(widget.target, widget.targetId);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SpotQaComposerState state = ref.watch(_provider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // 자격 거부는 컴포저를 접지 않고 여기 안내만 얹는다(디자인 §4).
        if (state.notEligible) SpotQaEligibilityBanner(target: widget.target),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: widget.autofocus,
                minLines: 1,
                maxLines: 4,
                // **maxLength를 두지 않는다** — 두면 입력이 잘려 초과분이 사라진다.
                decoration: InputDecoration(
                  // 답글에도 같은 안내를 쓴다 — "아는 것을 알려주세요"는 답변과
                  // 답글에 똑같이 맞는 말이라 키를 새로 파지 않는다.
                  hintText: l10n.spotQaAnswerBodyHint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (String value) =>
                    ref.read(_provider.notifier).updateBody(value),
              ),
            ),
            if (state.isSubmitting)
              const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              IconButton(
                onPressed: state.canSubmit ? _submit : null,
                tooltip: l10n.spotQaSubmitAction,
                icon: const Icon(Icons.send),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    SpotQaMutationResult<String> result;
    try {
      result = await ref.read(_provider.notifier).submit();
    } on Object {
      // 전송·인증 실패는 예외로 온다. 입력은 provider가 지키므로 안내만 띄운다.
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.spotQaSubmitFailed)));
      return;
    }
    if (!mounted) return;

    if (!result.succeeded) {
      // 자격 없음은 배너가 이미 말한다 — 스낵바를 겹치면 같은 말을 두 번 한다.
      if (!result.notEligible) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.spotQaSubmitFailed)),
        );
      }
      return;
    }

    // 성공하면 provider가 폼을 비웠으므로 입력칸도 함께 비운다.
    _controller.clear();
    widget.onSubmitted();
  }
}
