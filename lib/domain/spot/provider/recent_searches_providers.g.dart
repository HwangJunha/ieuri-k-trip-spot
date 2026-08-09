// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_searches_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 저장소를 provider 뒤에 둔다 — 테스트는 이 provider 하나만 override 한다.
/// 다른 repository와 같은 자리에서 노출한다(CLAUDE.md §3).

@ProviderFor(recentSearchesStore)
const recentSearchesStoreProvider = RecentSearchesStoreProvider._();

/// 저장소를 provider 뒤에 둔다 — 테스트는 이 provider 하나만 override 한다.
/// 다른 repository와 같은 자리에서 노출한다(CLAUDE.md §3).

final class RecentSearchesStoreProvider
    extends
        $FunctionalProvider<
          RecentSearchesStore,
          RecentSearchesStore,
          RecentSearchesStore
        >
    with $Provider<RecentSearchesStore> {
  /// 저장소를 provider 뒤에 둔다 — 테스트는 이 provider 하나만 override 한다.
  /// 다른 repository와 같은 자리에서 노출한다(CLAUDE.md §3).
  const RecentSearchesStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchesStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchesStoreHash();

  @$internal
  @override
  $ProviderElement<RecentSearchesStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecentSearchesStore create(Ref ref) {
    return recentSearchesStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecentSearchesStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecentSearchesStore>(value),
    );
  }
}

String _$recentSearchesStoreHash() =>
    r'8deacad561f7042198613d4aa61b3456d68d0bb7';

/// 최근 검색어 목록(R12). 최신 검색이 앞에 온다.
///
/// `keepAlive`인 이유는 저장소가 아니라 **화면 전환 때문**이다 — 검색 페이지를
/// 나갔다 들어올 때마다 다시 읽어도 값은 같지만, 목록을 들고 있으면 재진입이
/// 즉시다. 값의 영속은 provider가 아니라 [RecentSearchesStore]가 책임진다.

@ProviderFor(RecentSearches)
const recentSearchesProvider = RecentSearchesProvider._();

/// 최근 검색어 목록(R12). 최신 검색이 앞에 온다.
///
/// `keepAlive`인 이유는 저장소가 아니라 **화면 전환 때문**이다 — 검색 페이지를
/// 나갔다 들어올 때마다 다시 읽어도 값은 같지만, 목록을 들고 있으면 재진입이
/// 즉시다. 값의 영속은 provider가 아니라 [RecentSearchesStore]가 책임진다.
final class RecentSearchesProvider
    extends $NotifierProvider<RecentSearches, List<String>> {
  /// 최근 검색어 목록(R12). 최신 검색이 앞에 온다.
  ///
  /// `keepAlive`인 이유는 저장소가 아니라 **화면 전환 때문**이다 — 검색 페이지를
  /// 나갔다 들어올 때마다 다시 읽어도 값은 같지만, 목록을 들고 있으면 재진입이
  /// 즉시다. 값의 영속은 provider가 아니라 [RecentSearchesStore]가 책임진다.
  const RecentSearchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchesHash();

  @$internal
  @override
  RecentSearches create() => RecentSearches();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$recentSearchesHash() => r'23be3f444866964cf30a432a53c7c964794e2b4e';

/// 최근 검색어 목록(R12). 최신 검색이 앞에 온다.
///
/// `keepAlive`인 이유는 저장소가 아니라 **화면 전환 때문**이다 — 검색 페이지를
/// 나갔다 들어올 때마다 다시 읽어도 값은 같지만, 목록을 들고 있으면 재진입이
/// 즉시다. 값의 영속은 provider가 아니라 [RecentSearchesStore]가 책임진다.

abstract class _$RecentSearches extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
