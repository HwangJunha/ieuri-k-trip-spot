import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 스와이프 카드의 액션 바 — 패스와 좋아요(2026-08-27).
///
/// **카드 밖에 둔다.** 처음에는 카드 안 제목 옆에 하트를 붙였는데, 뒤에 깔린
/// 카드에는 버튼이 없어 제목이 쓸 수 있는 폭이 달랐다 — 카드가 넘어가는 순간
/// 글자 크기가 변하는 것처럼 보였다(사용자 지적). 버튼이 카드 밖에 있으면 어떤
/// 카드가 올라와도 흔들리지 않는다.
///
/// 자리는 카드 위에 겹친다(R14와 같은 판단) — 자리를 차지하면 사진이 그만큼
/// 줄어 전체화면화의 뜻이 사라진다. 대신 [barHeight]만큼 카드의 하단 여백을
/// 늘려 제목·주소가 버튼 뒤로 들어가지 않게 한다.
///
/// **패스 버튼도 함께 둔다.** 스와이프를 모르는 사용자에게 카드를 넘길 다른 길이
/// 없었다 — 좋아요만 버튼으로 두면 "미는 것"을 아는 사람만 다음 카드를 볼 수 있다.
class SwipeActionBar extends StatelessWidget {
  const SwipeActionBar({super.key, required this.onPass, required this.onLike});

  /// 버튼 하나의 지름. 바 전체 높이는 여기에 상하 여백을 더한 [barHeight]다.
  static const double buttonSize = 60;

  /// 버튼 위아래 여백.
  static const double _verticalPadding = 12;

  /// 바가 차지하는 전체 높이. 카드 하단 여백을 이만큼 늘려야 글자가 가리지 않는다.
  static const double barHeight = buttonSize + _verticalPadding * 2;

  final VoidCallback onPass;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _ActionButton(
            onPressed: onPass,
            icon: Icons.close,
            label: l10n.spotDetailDislikeAction,
            // 패스는 물러서는 동작이라 배경을 채우지 않는다 — 좋아요와 무게를
            // 같게 두면 어느 쪽이 기본인지 알 수 없다.
            background: scheme.surface,
            foreground: scheme.onSurfaceVariant,
            border: scheme.outlineVariant,
          ),
          const SizedBox(width: 28),
          _ActionButton(
            onPressed: onLike,
            icon: Icons.favorite,
            label: l10n.spotDetailLikeAction,
            background: scheme.primary,
            foreground: scheme.onPrimary,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    this.border,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: background,
        shape: border == null
            ? const CircleBorder()
            : CircleBorder(side: BorderSide(color: border!)),
        // 사진 위에 떠 있으므로 그림자로 띄운다 — 밝은 사진에서 흰 버튼이
        // 배경에 묻힌다.
        elevation: 3,
        shadowColor: Colors.black38,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: SwipeActionBar.buttonSize,
            height: SwipeActionBar.buttonSize,
            child: Icon(icon, color: foreground, size: 28),
          ),
        ),
      ),
    );
  }
}
