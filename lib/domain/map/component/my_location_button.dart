import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 현재 위치로 지도를 옮기는 버튼(디자인 §1).
///
/// 줌 컨트롤과 **떨어뜨려 둔다** — 줌은 지도 조작이고 위치 이동은 별개 액션이라,
/// 붙여 놓으면 하나의 그룹으로 읽힌다.
///
/// 위치 조회는 즉시 끝나지 않는다(권한 확인·GPS 픽스). [isLocating]이 참인 동안
/// 진행 표시로 바꿔, 눌렀는데 아무 일도 없는 것처럼 보이지 않게 한다.
class MyLocationButton extends StatelessWidget {
  const MyLocationButton({
    required this.onPressed,
    this.isLocating = false,
    super.key,
  });

  final VoidCallback onPressed;

  /// 위치를 얻는 중인가. 참이면 진행 표시로 바뀌고 입력을 받지 않는다.
  final bool isLocating;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      elevation: 2,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Tooltip(
        message: l10n.mapMyLocation,
        child: InkWell(
          // 조회 중에는 다시 눌러도 무시한다 — 연타로 요청이 겹치면 나중 응답이
          // 먼저 온 것을 덮어 지도가 튄다.
          onTap: isLocating ? null : onPressed,
          child: SizedBox(
            width: _size,
            height: _size,
            child: isLocating
                ? Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Icon(
                    Icons.my_location,
                    size: 22,
                    color: theme.colorScheme.primary,
                  ),
          ),
        ),
      ),
    );
  }
}
