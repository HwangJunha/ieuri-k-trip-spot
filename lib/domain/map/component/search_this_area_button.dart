import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 지도를 옮긴 뒤 그 지역을 다시 검색하는 버튼.
///
/// **지도를 멈출 때마다 자동으로 조회하지 않는다.** 자동 조회는 지도를 조금만
/// 움직여도 마커가 바뀌어, 보고 있던 장소가 사라지고 화면이 계속 흔들린다. 언제
/// 새로 받을지를 사용자가 정하게 두면 그 흔들림이 없어진다 — 카카오맵·구글맵이 같은
/// 방식을 쓰는 이유다.
///
/// **글자 없이 새로고침 아이콘만 쓴다**(사용자 요청, 2026-08-10). "이 지역 재검색"을
/// 알약 버튼으로 띄웠더니 상단에서는 범례와 겹치고 하단에서는 시선을 뺏었다 —
/// 새로고침은 널리 통하는 기호라 아이콘만으로 뜻이 전해진다. 문구는 툴팁에 남긴다.
class SearchThisAreaButton extends StatelessWidget {
  const SearchThisAreaButton({
    required this.onPressed,
    this.isSearching = false,
    super.key,
  });

  final VoidCallback onPressed;

  /// 조회 중인가. 참이면 진행 표시로 바뀌고 입력을 받지 않는다 — 연타로 요청이
  /// 겹치면 나중 응답이 먼저 온 것을 덮어 마커가 튄다.
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 3,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Tooltip(
        message: l10n.mapSearchThisArea,
        child: InkWell(
          onTap: isSearching ? null : onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: isSearching
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
                    Icons.refresh,
                    size: 22,
                    color: theme.colorScheme.primary,
                  ),
          ),
        ),
      ),
    );
  }
}
