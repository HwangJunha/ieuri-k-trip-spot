import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/spot_suggestion.dart';
import '../provider/spot_search_providers.dart';

/// 검색어 자동완성 목록(R9). 입력 중인 [query]로 시작하는 spot 제목을 보여준다.
///
/// **로딩·실패를 화면에 드러내지 않는다.** 입력 보조 수단이라 타이핑 중에 스피너나
/// 오류 문구가 뜨면 방해가 된다 — 제안이 없으면 그냥 아무것도 그리지 않고, 사용자는
/// 그대로 검색을 제출하면 된다.
class SearchSuggestionList extends ConsumerWidget {
  const SearchSuggestionList({
    super.key,
    required this.query,
    required this.onSelect,
  });

  final String query;

  /// 제안을 누르면 그 제목으로 검색한다.
  final void Function(String title) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 로딩·실패는 빈 목록과 같게 다룬다 — 입력 보조라 방해하지 않는 것이 우선이다.
    final List<SpotSuggestion> suggestions =
        ref.watch(spotSearchSuggestionsProvider(query)).value ??
        const <SpotSuggestion>[];

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        for (final SpotSuggestion s in suggestions)
          ListTile(
            dense: true,
            leading: const Icon(Icons.search),
            title: Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => onSelect(s.title),
          ),
      ],
    );
  }
}
