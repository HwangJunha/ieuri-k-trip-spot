import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 홈의 검색 진입점(R10). 검색 필드처럼 보이는 둥근 컨테이너이며, 여기서 직접
/// 입력받지 않고 **누르면 검색 페이지로 보낸다**.
///
/// 입력을 여기서 받지 않는 이유는 검색이 전체 화면 흐름이기 때문이다 — 홈에
/// 머문 채로 결과를 뿌리면 세 섹션과 결과가 한 스크롤에 섞인다(설계 §1).
///
/// 이동은 [onTap]으로 화면에 맡긴다 — `component`는 `view`를 import하지 않는다
/// (CLAUDE.md §3).
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.homeSearchHint,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
