import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/storage/app_preferences.dart';
import '../repository/recent_searches_store.dart';

part 'recent_searches_providers.g.dart';

/// 저장소를 provider 뒤에 둔다 — 테스트는 이 provider 하나만 override 한다.
/// 다른 repository와 같은 자리에서 노출한다(CLAUDE.md §3).
@Riverpod(keepAlive: true)
RecentSearchesStore recentSearchesStore(Ref ref) =>
    SharedPreferencesRecentSearchesStore(ref.watch(sharedPreferencesProvider));

/// 최근 검색어 목록(R12). 최신 검색이 앞에 온다.
///
/// `keepAlive`인 이유는 저장소가 아니라 **화면 전환 때문**이다 — 검색 페이지를
/// 나갔다 들어올 때마다 다시 읽어도 값은 같지만, 목록을 들고 있으면 재진입이
/// 즉시다. 값의 영속은 provider가 아니라 [RecentSearchesStore]가 책임진다.
@Riverpod(keepAlive: true)
class RecentSearches extends _$RecentSearches {
  RecentSearchesStore get _store => ref.read(recentSearchesStoreProvider);

  @override
  List<String> build() => _store.read();

  /// 검색을 실행했을 때 질의를 기록한다(AC-12.1).
  ///
  /// 같은 질의를 다시 검색하면 **중복으로 쌓지 않고 맨 앞으로 올린다** — 목록의
  /// 뜻이 "최근에 무엇을 찾았는가"이므로 같은 항목이 여러 줄을 차지할 이유가 없다.
  /// 공백만인 질의는 기록하지 않는다(서버가 `EMPTY_QUERY`로 거절하는 입력이라
  /// 기록해 두면 다시 눌러도 실패한다).
  Future<void> record(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final List<String> next = <String>[
      trimmed,
      ...state.where((String q) => q != trimmed),
    ];
    if (next.length > recentSearchesLimit) {
      next.removeRange(recentSearchesLimit, next.length);
    }

    state = next;
    await _store.write(next);
  }

  /// 항목 하나만 지운다(AC-12.3).
  Future<void> remove(String query) async {
    final List<String> next = state
        .where((String q) => q != query)
        .toList(growable: false);
    if (next.length == state.length) return;

    state = next;
    await _store.write(next);
  }

  /// 전체를 지운다(AC-12.4).
  Future<void> clear() async {
    if (state.isEmpty) return;
    state = const <String>[];
    await _store.write(const <String>[]);
  }
}
