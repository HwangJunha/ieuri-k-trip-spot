// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hidden_posts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 내가 숨긴 글 목록(2차 가이드 §2) — 해제 화면이 쓴다.
///
/// **별도 쿼리가 아니라 `posts(hiddenByViewer: true)`다.** 서버가 그렇게 만든 이유는
/// 이 목록에도 카테고리·태그 필터와 정렬이 그대로 걸려야 하기 때문이다. 다만 해제
/// 화면은 필터를 두지 않으므로 여기서는 인자 없이 부른다.
///
/// **숨긴 글은 그 밖의 모든 조회에서 빠진다** — 피드도, `post(id:)` 단건도 null이다.
/// 그래서 이 목록이 유일한 해제 경로다.
///
/// 좌표를 넘기지 않는 이유: 이 화면은 "내가 숨긴 것"의 전체 목록이지 지역 피드가
/// 아니다. 좌표를 걸면 다른 도시에서 숨긴 글을 풀 수 없게 된다.

@ProviderFor(HiddenPostsController)
const hiddenPostsControllerProvider = HiddenPostsControllerProvider._();

/// 내가 숨긴 글 목록(2차 가이드 §2) — 해제 화면이 쓴다.
///
/// **별도 쿼리가 아니라 `posts(hiddenByViewer: true)`다.** 서버가 그렇게 만든 이유는
/// 이 목록에도 카테고리·태그 필터와 정렬이 그대로 걸려야 하기 때문이다. 다만 해제
/// 화면은 필터를 두지 않으므로 여기서는 인자 없이 부른다.
///
/// **숨긴 글은 그 밖의 모든 조회에서 빠진다** — 피드도, `post(id:)` 단건도 null이다.
/// 그래서 이 목록이 유일한 해제 경로다.
///
/// 좌표를 넘기지 않는 이유: 이 화면은 "내가 숨긴 것"의 전체 목록이지 지역 피드가
/// 아니다. 좌표를 걸면 다른 도시에서 숨긴 글을 풀 수 없게 된다.
final class HiddenPostsControllerProvider
    extends $AsyncNotifierProvider<HiddenPostsController, HiddenPostsState> {
  /// 내가 숨긴 글 목록(2차 가이드 §2) — 해제 화면이 쓴다.
  ///
  /// **별도 쿼리가 아니라 `posts(hiddenByViewer: true)`다.** 서버가 그렇게 만든 이유는
  /// 이 목록에도 카테고리·태그 필터와 정렬이 그대로 걸려야 하기 때문이다. 다만 해제
  /// 화면은 필터를 두지 않으므로 여기서는 인자 없이 부른다.
  ///
  /// **숨긴 글은 그 밖의 모든 조회에서 빠진다** — 피드도, `post(id:)` 단건도 null이다.
  /// 그래서 이 목록이 유일한 해제 경로다.
  ///
  /// 좌표를 넘기지 않는 이유: 이 화면은 "내가 숨긴 것"의 전체 목록이지 지역 피드가
  /// 아니다. 좌표를 걸면 다른 도시에서 숨긴 글을 풀 수 없게 된다.
  const HiddenPostsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: communityRetryPolicy,
        name: r'hiddenPostsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiddenPostsControllerHash();

  @$internal
  @override
  HiddenPostsController create() => HiddenPostsController();
}

String _$hiddenPostsControllerHash() =>
    r'cbc1df70394a2e30bce82eba60d33b774d06ca33';

/// 내가 숨긴 글 목록(2차 가이드 §2) — 해제 화면이 쓴다.
///
/// **별도 쿼리가 아니라 `posts(hiddenByViewer: true)`다.** 서버가 그렇게 만든 이유는
/// 이 목록에도 카테고리·태그 필터와 정렬이 그대로 걸려야 하기 때문이다. 다만 해제
/// 화면은 필터를 두지 않으므로 여기서는 인자 없이 부른다.
///
/// **숨긴 글은 그 밖의 모든 조회에서 빠진다** — 피드도, `post(id:)` 단건도 null이다.
/// 그래서 이 목록이 유일한 해제 경로다.
///
/// 좌표를 넘기지 않는 이유: 이 화면은 "내가 숨긴 것"의 전체 목록이지 지역 피드가
/// 아니다. 좌표를 걸면 다른 도시에서 숨긴 글을 풀 수 없게 된다.

abstract class _$HiddenPostsController
    extends $AsyncNotifier<HiddenPostsState> {
  FutureOr<HiddenPostsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<HiddenPostsState>, HiddenPostsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HiddenPostsState>, HiddenPostsState>,
              AsyncValue<HiddenPostsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
