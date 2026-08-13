// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 피드 목록(R4). 최신순 고정이라 정렬 인자가 없다.
///
/// **이 provider의 실패는 추천 화면을 막지 않는다**(AC5-3) — 두 화면이 서로 다른
/// provider를 보기 때문이며, 세그먼트 토글은 어느 쪽을 그릴지만 정한다.

@ProviderFor(FeedListController)
const feedListControllerProvider = FeedListControllerProvider._();

/// 피드 목록(R4). 최신순 고정이라 정렬 인자가 없다.
///
/// **이 provider의 실패는 추천 화면을 막지 않는다**(AC5-3) — 두 화면이 서로 다른
/// provider를 보기 때문이며, 세그먼트 토글은 어느 쪽을 그릴지만 정한다.
final class FeedListControllerProvider
    extends $AsyncNotifierProvider<FeedListController, FeedListState> {
  /// 피드 목록(R4). 최신순 고정이라 정렬 인자가 없다.
  ///
  /// **이 provider의 실패는 추천 화면을 막지 않는다**(AC5-3) — 두 화면이 서로 다른
  /// provider를 보기 때문이며, 세그먼트 토글은 어느 쪽을 그릴지만 정한다.
  const FeedListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: feedRetryPolicy,
        name: r'feedListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedListControllerHash();

  @$internal
  @override
  FeedListController create() => FeedListController();
}

String _$feedListControllerHash() =>
    r'27e73558c2689a0c5674168ff83ce4578ed218f1';

/// 피드 목록(R4). 최신순 고정이라 정렬 인자가 없다.
///
/// **이 provider의 실패는 추천 화면을 막지 않는다**(AC5-3) — 두 화면이 서로 다른
/// provider를 보기 때문이며, 세그먼트 토글은 어느 쪽을 그릴지만 정한다.

abstract class _$FeedListController extends $AsyncNotifier<FeedListState> {
  FutureOr<FeedListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<FeedListState>, FeedListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FeedListState>, FeedListState>,
              AsyncValue<FeedListState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
