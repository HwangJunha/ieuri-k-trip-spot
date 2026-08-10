import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 지도 상단의 검색창.
///
/// **입력을 받지 않는다.** 누르면 기존 검색 화면(`/search`)으로 보내는 버튼이며,
/// 모양만 검색창이다 — 지도 위에서 키보드를 띄우면 화면 절반이 가려지고, 검색 결과
/// 목록을 놓을 자리도 없다.
///
/// 카카오 장소 검색(REST)을 새로 붙이지 않는 이유는 앱에 이미 `searchSpots`가 있기
/// 때문이다(SPEC-0013). 두 검색이 서로 다른 결과를 주면 사용자가 혼란스럽고, REST 키
/// 관리와 일일 쿼터가 새로 생긴다.
class MapSearchBar extends StatelessWidget {
  const MapSearchBar({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 3,
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.search,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.homeSearchHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
