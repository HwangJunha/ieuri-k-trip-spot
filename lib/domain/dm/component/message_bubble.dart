import 'package:flutter/material.dart';

import '../../../common/network/media_cdn.dart';
import '../../../common/widget/author_avatar.dart';
import '../../../common/widget/image_placeholder.dart';
import '../../../common/widget/network_photo.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/message.dart';
import 'message_quote_card.dart';

/// 메시지 말풍선 하나.
///
/// 정렬과 색은 [Message.ownedByViewer]가 가른다(DESIGN.md §6 — 발신 `primary`,
/// 수신 `surfaceContainer`).
///
/// 세 가지를 절대 하지 않는다:
/// - **본문이 비었다고 말풍선을 접지 않는다** — 사진만 보낸 메시지가 화면에서
///   사라진다
/// - **본문도 사진도 없어도 말풍선을 숨기지 않는다** — 피드 인용만 있던 과거
///   메시지가 그렇고(SPEC-0021 R4), 숨기면 대화 기록에 구멍이 난다. 빈 말풍선
///   대신 "내용 없음" 표시를 그린다
/// - **전송 실패한 말풍선을 지우지 않는다** — 실패 표시와 재시도 수단을 남긴다(R9)
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.onRetry,
    this.selectionMode = false,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.retryExhausted = false,
  });

  final Message message;

  /// 재전송. 실패 상태에서만 노출된다.
  final VoidCallback onRetry;

  /// 다중 선택 신고 모드인지(R15). true면 선택 인디케이터가 붙는다.
  final bool selectionMode;
  final bool selected;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// 재시도 상한(POL-040)에 도달했는지. true면 재시도 버튼 대신 종료 문구를 그린다 —
  /// 계속 누를 수 있게 두면 같은 실패를 반복할 뿐이다.
  final bool retryExhausted;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool mine = message.ownedByViewer;
    final bool failed = message.status == MessageDeliveryStatus.failed;
    final bool sending = message.status == MessageDeliveryStatus.sending;

    final Color background = failed
        ? theme.colorScheme.errorContainer
        : mine
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHigh;
    final Color foreground = failed
        ? theme.colorScheme.onErrorContainer
        : mine
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    final Widget bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.72,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // 인용은 **맨 위**다. 이 메시지가 무엇에 대한 말인지 먼저 읽혀야 한다 —
          // 인스타 스토리 답장이 같은 구조다.
          //
          // 대화당 하나였던 상단 고정 카드를 대체한다(2026-08-18). 카드 하나로는
          // 두 번째 인용을 표현할 수 없었고, 갈아끼우면 첫 인용이 사라졌다.
          if (message.spotQaOrigin != null)
            MessageQuoteCard(
              origin: message.spotQaOrigin!,
              onMine: message.ownedByViewer,
            ),
          if (message.photoKey != null)
            _MessagePhoto(photoKey: message.photoKey!),
          // 본문이 비면 이 줄만 생략한다 — 말풍선 자체는 남는다.
          if (message.hasBody)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                message.body,
                style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
              ),
            ),
          // **그릴 것이 하나도 없으면 안내 문구를 넣는다**(SPEC-0021 R4) — 피드
          // 인용만 있던 과거 메시지가 여기 온다. 이 분기가 없으면 높이 0의 빈
          // 말풍선이 그려진다.
          if (message.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                l10n.dmEmptyMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foreground.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Row(
        mainAxisAlignment: mine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // **자기 메시지는 선택 대상이 아니다**(AC15-5) — 체크박스 자체를
          // 그리지 않는다. 자리도 비우지 않아 정렬이 흔들리지 않는다.
          if (selectionMode && message.reportable) ...<Widget>[
            // **동그라미 자체가 탭 대상이어야 한다.** 예전에는 순수 Icon이라
            // 말풍선을 눌러야만 선택됐고, 체크박스처럼 생긴 것을 눌렀는데 아무
            // 반응이 없어 선택 모드가 고장 난 것처럼 보였다. 손가락이 닿는
            // 48dp를 확보한다(Material 최소 터치 영역).
            InkResponse(
              onTap: onTap,
              radius: 24,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          // **받은 메시지에는 상대 프로필을 붙인다.** 채팅에서 말풍선만 있으면
          // 누가 한 말인지 앱바를 봐야 알 수 있다. 보낸 메시지(오른쪽)는 내
          // 것이 자명하므로 달지 않는다 — 양쪽에 다 붙이면 폭만 좁아진다.
          if (!mine) ...<Widget>[
            // 아바타는 말풍선 아래쪽에 맞춘다 — 여러 줄 메시지에서 가운데 정렬은
            // 아바타가 공중에 뜬 것처럼 보인다.
            Align(
              alignment: Alignment.bottomCenter,
              child: AuthorAvatar(author: message.sender, radius: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: mine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: onTap,
                  onLongPress: onLongPress,
                  borderRadius: BorderRadius.circular(18),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      // 선택된 말풍선은 배경 강조로 알린다.
                      color: selected
                          ? theme.colorScheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      // 전송 중은 반투명 — 아직 서버가 받았다는 보장이 없다.
                      child: Opacity(opacity: sending ? 0.6 : 1, child: bubble),
                    ),
                  ),
                ),
                if (sending) _StatusLine(label: l10n.dmSendingLabel),
                if (failed)
                  _FailedLine(onRetry: onRetry, exhausted: retryExhausted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 말풍선 아래 작은 상태 줄(전송 중 등).
class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 6, right: 6),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// 전송 실패 줄 — 오류 아이콘 + 재시도.
///
/// **재시도 상한에 도달하면 버튼을 비활성화하고 문구를 바꾼다**(POL-040) — 같은
/// 실패를 계속 반복하게 두지 않는다.
class _FailedLine extends StatelessWidget {
  const _FailedLine({required this.onRetry, required this.exhausted});

  final VoidCallback onRetry;
  final bool exhausted;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 6, right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.error_outline, size: 14, color: theme.colorScheme.error),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              exhausted ? l10n.dmRetryExhausted : l10n.dmSendFailed,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          if (!exhausted) ...<Widget>[
            const SizedBox(width: 4),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 28),
                // 시각 높이는 28로 좁게 두되 터치 영역은 48dp를
                // 확보한다 — shrinkWrap이면 손가락이 닿는 상자까지
                // 28px로 줄어 접근성 최소 크기에 못 미친다.
                tapTargetSize: MaterialTapTargetSize.padded,
              ),
              child: Text(l10n.dmRetryAction),
            ),
          ],
        ],
      ),
    );
  }
}

/// 첨부 사진. 키는 URL이 아니라 [MediaCdn]이 조합하고, 404여도 플레이스홀더가 남는다.
class _MessagePhoto extends StatelessWidget {
  const _MessagePhoto({required this.photoKey});

  final String photoKey;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ImagePlaceholder(imageRef: photoKey),
        NetworkPhoto(
          url: MediaCdn.urlFor(photoKey),
          fit: BoxFit.cover,
          // 대화 버블 안이라 화면 폭의 일부만 차지한다. 대화를 위로 훑으면 사진
          // 버블이 계속 쌓이므로 여기서 줄이는 효과가 크다.
          decodeWidth: 400,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ],
    ),
  );
}
