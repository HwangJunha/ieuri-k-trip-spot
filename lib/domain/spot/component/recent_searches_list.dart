import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../provider/recent_searches_providers.dart';

/// 최근 검색어 목록(R12). 검색 페이지의 초기 상태가 보여준다.
///
/// 개별 삭제(AC-12.3)와 전체 삭제(AC-12.4)를 모두 제공한다. 목록이 비어 있으면
/// 아무것도 그리지 않는다 — 첫 진입에서 "최근 검색어 없음"을 띄우는 것은 빈
/// 검색창 아래에 의미 없는 문구를 하나 더 얹는 일이다.
class RecentSearchesList extends ConsumerWidget {
  const RecentSearchesList({super.key, required this.onSelect, this.onClose});

  /// 항목을 누르면 그 질의로 검색한다.
  final void Function(String query) onSelect;

  /// 닫기 수단. **패널로 띄울 때만 준다** — 초기 상태(검색 전)에서는 이 목록이
  /// 화면 본문이라 닫을 대상이 없다.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<String> queries = ref.watch(recentSearchesProvider);

    if (queries.isEmpty) return const SizedBox.shrink();

    return ListView(
      // 패널로 띄울 때 내용만큼만 차지하도록. 본문으로 쓸 때는 부모가 높이를
      // 주므로 어느 쪽이든 같은 위젯으로 족하다.
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  l10n.searchRecentTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(recentSearchesProvider.notifier).clear(),
                child: Text(l10n.searchRecentClearAll),
              ),
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: l10n.searchRecentClose,
                  onPressed: onClose,
                ),
            ],
          ),
        ),
        for (final String query in queries)
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(query, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              tooltip: l10n.searchRecentRemove,
              onPressed: () =>
                  ref.read(recentSearchesProvider.notifier).remove(query),
            ),
            onTap: () => onSelect(query),
          ),
      ],
    );
  }
}
