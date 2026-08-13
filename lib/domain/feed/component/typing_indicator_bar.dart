import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// "○○님이 입력 중" 표시(R10).
///
/// **이 위젯은 보이거나 안 보이거나만 그린다.** 타임아웃 판정은 notifier가 진다
/// (설계 §5) — 타이핑 이벤트는 유실될 수 있어 이벤트로만 켜고 끄면 마지막 이벤트가
/// 유실되는 순간 화면이 영원히 "입력 중"에 갇힌다. 그 판단을 위젯에 두면 화면마다
/// 규칙이 흩어진다.
///
/// **높이를 항상 예약한다** — 나타났다 사라질 때 메시지 리스트가 튀지 않게 빈
/// 상태에서도 같은 자리를 차지하고 투명하게 둔다.
class TypingIndicatorBar extends StatelessWidget {
  const TypingIndicatorBar({super.key, this.nickname});

  /// 입력 중인 상대의 닉네임. null이면 아무도 입력 중이 아니다.
  final String? nickname;

  /// 예약 높이. 문구 한 줄이 들어가는 최소 높이다.
  static const double height = 22;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return SizedBox(
      height: height,
      child: nickname == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.dmTypingIndicator(nickname!),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
    );
  }
}
