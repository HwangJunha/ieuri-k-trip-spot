import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 지도 확대·축소 버튼(디자인 §1).
///
/// **버튼을 두는 이유는 카카오 지도의 축소 제스처가 알기 어렵기 때문이다.** 확대는
/// 한 손가락 더블탭이지만 축소는 **두 손가락 한 번 탭**이라(SDK `GestureType`),
/// 더블탭으로 축소를 시도한 사용자에게는 확대만 되는 것으로 보인다. 구글·애플 지도에
/// 익숙한 외국인 방문객이 주 사용자라 이 차이가 그대로 "지도가 고장 났다"로 읽힌다.
///
/// 세로 알약 하나에 ＋/− 를 담고 가운데를 선으로 나눈다 — 두 버튼이 한 기능(줌)의
/// 양방향이라 시각적으로 묶는다. 현재 위치 버튼은 별개 액션이라 떨어뜨린다.
class MapZoomControls extends StatelessWidget {
  const MapZoomControls({
    required this.onZoomIn,
    required this.onZoomOut,
    super.key,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  /// 터치 타깃 한 변. Material 최소 권장(48dp)을 지킨다.
  static const double _buttonSize = 48;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      elevation: 2,
      borderRadius: BorderRadius.circular(_buttonSize / 2),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ZoomButton(
            icon: Icons.add,
            tooltip: l10n.mapZoomIn,
            onPressed: onZoomIn,
          ),
          // 두 버튼의 경계. 알약 안에서 어디까지가 확대인지 보이게 한다.
          Divider(
            height: 1,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: theme.colorScheme.outlineVariant,
          ),
          _ZoomButton(
            icon: Icons.remove,
            tooltip: l10n.mapZoomOut,
            onPressed: onZoomOut,
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: MapZoomControls._buttonSize,
          height: MapZoomControls._buttonSize,
          child: Icon(icon, size: 22, color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}
