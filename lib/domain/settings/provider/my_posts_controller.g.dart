// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_posts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 내가 쓴 글(R3).
///
/// **페이지네이션은 `common/pagination/`을 쓴다**(CLAUDE.md §4) — 화면은
/// `PaginationListView`가 그리고, 여기서는 누적·커서·중복 호출 억제만 한다.

@ProviderFor(MyPostsController)
const myPostsControllerProvider = MyPostsControllerProvider._();

/// 내가 쓴 글(R3).
///
/// **페이지네이션은 `common/pagination/`을 쓴다**(CLAUDE.md §4) — 화면은
/// `PaginationListView`가 그리고, 여기서는 누적·커서·중복 호출 억제만 한다.
final class MyPostsControllerProvider
    extends $AsyncNotifierProvider<MyPostsController, MyPostsState> {
  /// 내가 쓴 글(R3).
  ///
  /// **페이지네이션은 `common/pagination/`을 쓴다**(CLAUDE.md §4) — 화면은
  /// `PaginationListView`가 그리고, 여기서는 누적·커서·중복 호출 억제만 한다.
  const MyPostsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: settingsRetryPolicy,
        name: r'myPostsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPostsControllerHash();

  @$internal
  @override
  MyPostsController create() => MyPostsController();
}

String _$myPostsControllerHash() => r'e50461fbe454019a8b97ae5032145cdc915ccd59';

/// 내가 쓴 글(R3).
///
/// **페이지네이션은 `common/pagination/`을 쓴다**(CLAUDE.md §4) — 화면은
/// `PaginationListView`가 그리고, 여기서는 누적·커서·중복 호출 억제만 한다.

abstract class _$MyPostsController extends $AsyncNotifier<MyPostsState> {
  FutureOr<MyPostsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<MyPostsState>, MyPostsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MyPostsState>, MyPostsState>,
              AsyncValue<MyPostsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
