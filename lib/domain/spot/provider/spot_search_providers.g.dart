// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 검색에 걸린 카테고리 필터(SPEC-0013 R5 · SPEC-0020 R2). **비어 있을 수 없는
/// 집합이다** — "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현이 없다.
///
/// **Discover의 [SelectedSpotCategory]와 별개다**(R12) — 같은 provider를 쓰면
/// Discover에서 고른 필터가 검색 결과까지 갈아치운다.
///
/// `keepAlive`인 이유는 검색 상태와 같다 — 상세를 다녀와도 고른 필터가 남아야
/// 결과와 어긋나지 않는다(AC-13.2·AC12.3).
///
/// **결과를 다시 받는 것은 호출부(화면)가 한다** — 이 provider는 조회 조건만 들고
/// 있고, 무엇을 언제 다시 조회할지는 검색 notifier가 정한다.

@ProviderFor(SpotSearchCategory)
const spotSearchCategoryProvider = SpotSearchCategoryProvider._();

/// 검색에 걸린 카테고리 필터(SPEC-0013 R5 · SPEC-0020 R2). **비어 있을 수 없는
/// 집합이다** — "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현이 없다.
///
/// **Discover의 [SelectedSpotCategory]와 별개다**(R12) — 같은 provider를 쓰면
/// Discover에서 고른 필터가 검색 결과까지 갈아치운다.
///
/// `keepAlive`인 이유는 검색 상태와 같다 — 상세를 다녀와도 고른 필터가 남아야
/// 결과와 어긋나지 않는다(AC-13.2·AC12.3).
///
/// **결과를 다시 받는 것은 호출부(화면)가 한다** — 이 provider는 조회 조건만 들고
/// 있고, 무엇을 언제 다시 조회할지는 검색 notifier가 정한다.
final class SpotSearchCategoryProvider
    extends $NotifierProvider<SpotSearchCategory, Set<SpotCategory>> {
  /// 검색에 걸린 카테고리 필터(SPEC-0013 R5 · SPEC-0020 R2). **비어 있을 수 없는
  /// 집합이다** — "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현이 없다.
  ///
  /// **Discover의 [SelectedSpotCategory]와 별개다**(R12) — 같은 provider를 쓰면
  /// Discover에서 고른 필터가 검색 결과까지 갈아치운다.
  ///
  /// `keepAlive`인 이유는 검색 상태와 같다 — 상세를 다녀와도 고른 필터가 남아야
  /// 결과와 어긋나지 않는다(AC-13.2·AC12.3).
  ///
  /// **결과를 다시 받는 것은 호출부(화면)가 한다** — 이 provider는 조회 조건만 들고
  /// 있고, 무엇을 언제 다시 조회할지는 검색 notifier가 정한다.
  const SpotSearchCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotSearchCategoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotSearchCategoryHash();

  @$internal
  @override
  SpotSearchCategory create() => SpotSearchCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<SpotCategory> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<SpotCategory>>(value),
    );
  }
}

String _$spotSearchCategoryHash() =>
    r'ffa5c0f303112de79f92a9e5c7956ae247122c57';

/// 검색에 걸린 카테고리 필터(SPEC-0013 R5 · SPEC-0020 R2). **비어 있을 수 없는
/// 집합이다** — "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현이 없다.
///
/// **Discover의 [SelectedSpotCategory]와 별개다**(R12) — 같은 provider를 쓰면
/// Discover에서 고른 필터가 검색 결과까지 갈아치운다.
///
/// `keepAlive`인 이유는 검색 상태와 같다 — 상세를 다녀와도 고른 필터가 남아야
/// 결과와 어긋나지 않는다(AC-13.2·AC12.3).
///
/// **결과를 다시 받는 것은 호출부(화면)가 한다** — 이 provider는 조회 조건만 들고
/// 있고, 무엇을 언제 다시 조회할지는 검색 notifier가 정한다.

abstract class _$SpotSearchCategory extends $Notifier<Set<SpotCategory>> {
  Set<SpotCategory> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<SpotCategory>, Set<SpotCategory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<SpotCategory>, Set<SpotCategory>>,
              Set<SpotCategory>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 검색 결과 상태 기계(R11).
///
/// **자동완성과 분리되어 있다**(설계 §2) — 자동완성은 입력할 때마다 갱신되므로 이
/// 상태에 섞으면 타이핑 중에 로딩 표시가 요동친다.
///
/// `keepAlive`인 이유는 AC-13.2다 — 결과에서 상세로 갔다 돌아왔을 때 질의와 결과가
/// 그대로 있어야 한다. autoDispose면 상세로 이동하는 동안 화면이 트리에서 빠지면서
/// 상태가 버려지고, 돌아오면 빈 검색 페이지가 된다.

@ProviderFor(SpotSearch)
const spotSearchProvider = SpotSearchProvider._();

/// 검색 결과 상태 기계(R11).
///
/// **자동완성과 분리되어 있다**(설계 §2) — 자동완성은 입력할 때마다 갱신되므로 이
/// 상태에 섞으면 타이핑 중에 로딩 표시가 요동친다.
///
/// `keepAlive`인 이유는 AC-13.2다 — 결과에서 상세로 갔다 돌아왔을 때 질의와 결과가
/// 그대로 있어야 한다. autoDispose면 상세로 이동하는 동안 화면이 트리에서 빠지면서
/// 상태가 버려지고, 돌아오면 빈 검색 페이지가 된다.
final class SpotSearchProvider
    extends $NotifierProvider<SpotSearch, SpotSearchState> {
  /// 검색 결과 상태 기계(R11).
  ///
  /// **자동완성과 분리되어 있다**(설계 §2) — 자동완성은 입력할 때마다 갱신되므로 이
  /// 상태에 섞으면 타이핑 중에 로딩 표시가 요동친다.
  ///
  /// `keepAlive`인 이유는 AC-13.2다 — 결과에서 상세로 갔다 돌아왔을 때 질의와 결과가
  /// 그대로 있어야 한다. autoDispose면 상세로 이동하는 동안 화면이 트리에서 빠지면서
  /// 상태가 버려지고, 돌아오면 빈 검색 페이지가 된다.
  const SpotSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotSearchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotSearchHash();

  @$internal
  @override
  SpotSearch create() => SpotSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotSearchState>(value),
    );
  }
}

String _$spotSearchHash() => r'd352ebbed6acf10310aa1724e8e4cfa310ba8f6f';

/// 검색 결과 상태 기계(R11).
///
/// **자동완성과 분리되어 있다**(설계 §2) — 자동완성은 입력할 때마다 갱신되므로 이
/// 상태에 섞으면 타이핑 중에 로딩 표시가 요동친다.
///
/// `keepAlive`인 이유는 AC-13.2다 — 결과에서 상세로 갔다 돌아왔을 때 질의와 결과가
/// 그대로 있어야 한다. autoDispose면 상세로 이동하는 동안 화면이 트리에서 빠지면서
/// 상태가 버려지고, 돌아오면 빈 검색 페이지가 된다.

abstract class _$SpotSearch extends $Notifier<SpotSearchState> {
  SpotSearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SpotSearchState, SpotSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SpotSearchState, SpotSearchState>,
              SpotSearchState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 검색어 자동완성(R9).
///
/// **결과 상태 기계와 별개의 provider다**(설계 §2) — 입력 중 계속 갱신되므로 결과
/// 상태에 섞으면 타이핑할 때마다 로딩 표시가 요동친다.
///
/// `autoDispose`(codegen 기본)라 질의가 바뀌면 이전 provider가 폐기된다. 디바운스가
/// 그 폐기를 이용한다 — 대기 중에 버려지면 조회를 내보내지 않는다.

@ProviderFor(spotSearchSuggestions)
const spotSearchSuggestionsProvider = SpotSearchSuggestionsFamily._();

/// 검색어 자동완성(R9).
///
/// **결과 상태 기계와 별개의 provider다**(설계 §2) — 입력 중 계속 갱신되므로 결과
/// 상태에 섞으면 타이핑할 때마다 로딩 표시가 요동친다.
///
/// `autoDispose`(codegen 기본)라 질의가 바뀌면 이전 provider가 폐기된다. 디바운스가
/// 그 폐기를 이용한다 — 대기 중에 버려지면 조회를 내보내지 않는다.

final class SpotSearchSuggestionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SpotSuggestion>>,
          List<SpotSuggestion>,
          FutureOr<List<SpotSuggestion>>
        >
    with
        $FutureModifier<List<SpotSuggestion>>,
        $FutureProvider<List<SpotSuggestion>> {
  /// 검색어 자동완성(R9).
  ///
  /// **결과 상태 기계와 별개의 provider다**(설계 §2) — 입력 중 계속 갱신되므로 결과
  /// 상태에 섞으면 타이핑할 때마다 로딩 표시가 요동친다.
  ///
  /// `autoDispose`(codegen 기본)라 질의가 바뀌면 이전 provider가 폐기된다. 디바운스가
  /// 그 폐기를 이용한다 — 대기 중에 버려지면 조회를 내보내지 않는다.
  const SpotSearchSuggestionsProvider._({
    required SpotSearchSuggestionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spotSearchSuggestionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spotSearchSuggestionsHash();

  @override
  String toString() {
    return r'spotSearchSuggestionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SpotSuggestion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SpotSuggestion>> create(Ref ref) {
    final argument = this.argument as String;
    return spotSearchSuggestions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpotSearchSuggestionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spotSearchSuggestionsHash() =>
    r'f24cb45047d7440462ecca66ecb082b24286a093';

/// 검색어 자동완성(R9).
///
/// **결과 상태 기계와 별개의 provider다**(설계 §2) — 입력 중 계속 갱신되므로 결과
/// 상태에 섞으면 타이핑할 때마다 로딩 표시가 요동친다.
///
/// `autoDispose`(codegen 기본)라 질의가 바뀌면 이전 provider가 폐기된다. 디바운스가
/// 그 폐기를 이용한다 — 대기 중에 버려지면 조회를 내보내지 않는다.

final class SpotSearchSuggestionsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SpotSuggestion>>, String> {
  const SpotSearchSuggestionsFamily._()
    : super(
        retry: null,
        name: r'spotSearchSuggestionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 검색어 자동완성(R9).
  ///
  /// **결과 상태 기계와 별개의 provider다**(설계 §2) — 입력 중 계속 갱신되므로 결과
  /// 상태에 섞으면 타이핑할 때마다 로딩 표시가 요동친다.
  ///
  /// `autoDispose`(codegen 기본)라 질의가 바뀌면 이전 provider가 폐기된다. 디바운스가
  /// 그 폐기를 이용한다 — 대기 중에 버려지면 조회를 내보내지 않는다.

  SpotSearchSuggestionsProvider call(String query) =>
      SpotSearchSuggestionsProvider._(argument: query, from: this);

  @override
  String toString() => r'spotSearchSuggestionsProvider';
}
