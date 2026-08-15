// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 커뮤니티 탭에서 선택된 카테고리(null=전체).
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.

@ProviderFor(SelectedCategory)
const selectedCategoryProvider = SelectedCategoryProvider._();

/// 커뮤니티 탭에서 선택된 카테고리(null=전체).
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.
final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, TargetCategory?> {
  /// 커뮤니티 탭에서 선택된 카테고리(null=전체).
  ///
  /// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
  /// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
  /// 되돌아간다.
  const SelectedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TargetCategory? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TargetCategory?>(value),
    );
  }
}

String _$selectedCategoryHash() => r'ac186e8b1b949485b0b82f79888f6065283290ed';

/// 커뮤니티 탭에서 선택된 카테고리(null=전체).
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.

abstract class _$SelectedCategory extends $Notifier<TargetCategory?> {
  TargetCategory? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TargetCategory?, TargetCategory?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TargetCategory?, TargetCategory?>,
              TargetCategory?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 커뮤니티 탭에서 선택된 정렬(2차 가이드 §3). 기본은 [PostSortOrder.latest]다.
///
/// [SelectedCategory]와 같은 이유로 keepAlive다 — 사용자가 고른 정렬은 화면이
/// 아니라 세션에 속한다.
///
/// **정렬은 피드 provider의 family 인자이기도 하다.** 여기서 값을 바꾸면 화면이
/// 다른 family 인스턴스를 watch하게 되고, 그 인스턴스는 커서 없이 처음부터
/// 로딩된다 — 두 정렬의 커서 형식이 달라 이전 커서를 넘기면 `INVALID_INPUT`이므로
/// 이 구조가 곧 "정렬을 바꾸면 커서를 버린다"는 규약의 구현이다.

@ProviderFor(SelectedSort)
const selectedSortProvider = SelectedSortProvider._();

/// 커뮤니티 탭에서 선택된 정렬(2차 가이드 §3). 기본은 [PostSortOrder.latest]다.
///
/// [SelectedCategory]와 같은 이유로 keepAlive다 — 사용자가 고른 정렬은 화면이
/// 아니라 세션에 속한다.
///
/// **정렬은 피드 provider의 family 인자이기도 하다.** 여기서 값을 바꾸면 화면이
/// 다른 family 인스턴스를 watch하게 되고, 그 인스턴스는 커서 없이 처음부터
/// 로딩된다 — 두 정렬의 커서 형식이 달라 이전 커서를 넘기면 `INVALID_INPUT`이므로
/// 이 구조가 곧 "정렬을 바꾸면 커서를 버린다"는 규약의 구현이다.
final class SelectedSortProvider
    extends $NotifierProvider<SelectedSort, PostSortOrder> {
  /// 커뮤니티 탭에서 선택된 정렬(2차 가이드 §3). 기본은 [PostSortOrder.latest]다.
  ///
  /// [SelectedCategory]와 같은 이유로 keepAlive다 — 사용자가 고른 정렬은 화면이
  /// 아니라 세션에 속한다.
  ///
  /// **정렬은 피드 provider의 family 인자이기도 하다.** 여기서 값을 바꾸면 화면이
  /// 다른 family 인스턴스를 watch하게 되고, 그 인스턴스는 커서 없이 처음부터
  /// 로딩된다 — 두 정렬의 커서 형식이 달라 이전 커서를 넘기면 `INVALID_INPUT`이므로
  /// 이 구조가 곧 "정렬을 바꾸면 커서를 버린다"는 규약의 구현이다.
  const SelectedSortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedSortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedSortHash();

  @$internal
  @override
  SelectedSort create() => SelectedSort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostSortOrder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostSortOrder>(value),
    );
  }
}

String _$selectedSortHash() => r'72133e7a627f386495b6c6cf0b6ca5d9acaed6e0';

/// 커뮤니티 탭에서 선택된 정렬(2차 가이드 §3). 기본은 [PostSortOrder.latest]다.
///
/// [SelectedCategory]와 같은 이유로 keepAlive다 — 사용자가 고른 정렬은 화면이
/// 아니라 세션에 속한다.
///
/// **정렬은 피드 provider의 family 인자이기도 하다.** 여기서 값을 바꾸면 화면이
/// 다른 family 인스턴스를 watch하게 되고, 그 인스턴스는 커서 없이 처음부터
/// 로딩된다 — 두 정렬의 커서 형식이 달라 이전 커서를 넘기면 `INVALID_INPUT`이므로
/// 이 구조가 곧 "정렬을 바꾸면 커서를 버린다"는 규약의 구현이다.

abstract class _$SelectedSort extends $Notifier<PostSortOrder> {
  PostSortOrder build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PostSortOrder, PostSortOrder>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostSortOrder, PostSortOrder>,
              PostSortOrder,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 커뮤니티 탭의 지역 피드. [category]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
/// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
/// 다시 정렬하지 않는다).
///
/// **[sort]가 family 인자인 것이 "정렬을 바꾸면 커서를 버린다"는 규약의 구현이다**
/// (2차 가이드 §3). 두 정렬의 커서 형식이 달라 이전 커서를 넘기면 서버가
/// `INVALID_INPUT`을 주는데, 정렬마다 인스턴스가 갈리면 새 인스턴스는 `after` 없이
/// 첫 페이지부터 받으므로 커서가 섞일 길이 없다.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
/// 사유**를 보여준다.
///
/// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
/// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.

@ProviderFor(FeedController)
const feedControllerProvider = FeedControllerFamily._();

/// 커뮤니티 탭의 지역 피드. [category]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
/// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
/// 다시 정렬하지 않는다).
///
/// **[sort]가 family 인자인 것이 "정렬을 바꾸면 커서를 버린다"는 규약의 구현이다**
/// (2차 가이드 §3). 두 정렬의 커서 형식이 달라 이전 커서를 넘기면 서버가
/// `INVALID_INPUT`을 주는데, 정렬마다 인스턴스가 갈리면 새 인스턴스는 `after` 없이
/// 첫 페이지부터 받으므로 커서가 섞일 길이 없다.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
/// 사유**를 보여준다.
///
/// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
/// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.
final class FeedControllerProvider
    extends $AsyncNotifierProvider<FeedController, FeedState> {
  /// 커뮤니티 탭의 지역 피드. [category]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
  /// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
  /// 다시 정렬하지 않는다).
  ///
  /// **[sort]가 family 인자인 것이 "정렬을 바꾸면 커서를 버린다"는 규약의 구현이다**
  /// (2차 가이드 §3). 두 정렬의 커서 형식이 달라 이전 커서를 넘기면 서버가
  /// `INVALID_INPUT`을 주는데, 정렬마다 인스턴스가 갈리면 새 인스턴스는 `after` 없이
  /// 첫 페이지부터 받으므로 커서가 섞일 길이 없다.
  ///
  /// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
  /// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
  /// 사유**를 보여준다.
  ///
  /// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
  /// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.
  const FeedControllerProvider._({
    required FeedControllerFamily super.from,
    required (TargetCategory?, PostSortOrder) super.argument,
  }) : super(
         retry: communityRetryPolicy,
         name: r'feedControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$feedControllerHash();

  @override
  String toString() {
    return r'feedControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  FeedController create() => FeedController();

  @override
  bool operator ==(Object other) {
    return other is FeedControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$feedControllerHash() => r'45dd47ea76dda825625a68d2b6510358ffbe4950';

/// 커뮤니티 탭의 지역 피드. [category]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
/// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
/// 다시 정렬하지 않는다).
///
/// **[sort]가 family 인자인 것이 "정렬을 바꾸면 커서를 버린다"는 규약의 구현이다**
/// (2차 가이드 §3). 두 정렬의 커서 형식이 달라 이전 커서를 넘기면 서버가
/// `INVALID_INPUT`을 주는데, 정렬마다 인스턴스가 갈리면 새 인스턴스는 `after` 없이
/// 첫 페이지부터 받으므로 커서가 섞일 길이 없다.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
/// 사유**를 보여준다.
///
/// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
/// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.

final class FeedControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          FeedController,
          AsyncValue<FeedState>,
          FeedState,
          FutureOr<FeedState>,
          (TargetCategory?, PostSortOrder)
        > {
  const FeedControllerFamily._()
    : super(
        retry: communityRetryPolicy,
        name: r'feedControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 커뮤니티 탭의 지역 피드. [category]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
  /// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
  /// 다시 정렬하지 않는다).
  ///
  /// **[sort]가 family 인자인 것이 "정렬을 바꾸면 커서를 버린다"는 규약의 구현이다**
  /// (2차 가이드 §3). 두 정렬의 커서 형식이 달라 이전 커서를 넘기면 서버가
  /// `INVALID_INPUT`을 주는데, 정렬마다 인스턴스가 갈리면 새 인스턴스는 `after` 없이
  /// 첫 페이지부터 받으므로 커서가 섞일 길이 없다.
  ///
  /// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
  /// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
  /// 사유**를 보여준다.
  ///
  /// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
  /// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.

  FeedControllerProvider call(TargetCategory? category, PostSortOrder sort) =>
      FeedControllerProvider._(argument: (category, sort), from: this);

  @override
  String toString() => r'feedControllerProvider';
}

/// 커뮤니티 탭의 지역 피드. [category]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
/// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
/// 다시 정렬하지 않는다).
///
/// **[sort]가 family 인자인 것이 "정렬을 바꾸면 커서를 버린다"는 규약의 구현이다**
/// (2차 가이드 §3). 두 정렬의 커서 형식이 달라 이전 커서를 넘기면 서버가
/// `INVALID_INPUT`을 주는데, 정렬마다 인스턴스가 갈리면 새 인스턴스는 `after` 없이
/// 첫 페이지부터 받으므로 커서가 섞일 길이 없다.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
/// 사유**를 보여준다.
///
/// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
/// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.

abstract class _$FeedController extends $AsyncNotifier<FeedState> {
  late final _$args = ref.$arg as (TargetCategory?, PostSortOrder);
  TargetCategory? get category => _$args.$1;
  PostSortOrder get sort => _$args.$2;

  FutureOr<FeedState> build(TargetCategory? category, PostSortOrder sort);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<FeedState>, FeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FeedState>, FeedState>,
              AsyncValue<FeedState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 한 장소에 달린 글 피드(장소 상세에 끼워 넣는 섹션용).
///
/// 좌표 피드와 **같은 쿼리를 인자만 달리해** 부른다 — `catalogId`를 주면 좌표는
/// 무시되므로(가이드 §2) 좌표를 아예 넘기지 않는다. 위치 권한이 없어도 도는 것이
/// 이 피드의 성질이다.
///
/// [catalogId]는 `Spot.id`를 그대로 넘기면 된다 — SPEC-0019에서 언어 무관
/// 식별자로 바뀌었고 두 값은 호환된다.

@ProviderFor(spotPosts)
const spotPostsProvider = SpotPostsFamily._();

/// 한 장소에 달린 글 피드(장소 상세에 끼워 넣는 섹션용).
///
/// 좌표 피드와 **같은 쿼리를 인자만 달리해** 부른다 — `catalogId`를 주면 좌표는
/// 무시되므로(가이드 §2) 좌표를 아예 넘기지 않는다. 위치 권한이 없어도 도는 것이
/// 이 피드의 성질이다.
///
/// [catalogId]는 `Spot.id`를 그대로 넘기면 된다 — SPEC-0019에서 언어 무관
/// 식별자로 바뀌었고 두 값은 호환된다.

final class SpotPostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<CursorPage<Post>>,
          CursorPage<Post>,
          FutureOr<CursorPage<Post>>
        >
    with $FutureModifier<CursorPage<Post>>, $FutureProvider<CursorPage<Post>> {
  /// 한 장소에 달린 글 피드(장소 상세에 끼워 넣는 섹션용).
  ///
  /// 좌표 피드와 **같은 쿼리를 인자만 달리해** 부른다 — `catalogId`를 주면 좌표는
  /// 무시되므로(가이드 §2) 좌표를 아예 넘기지 않는다. 위치 권한이 없어도 도는 것이
  /// 이 피드의 성질이다.
  ///
  /// [catalogId]는 `Spot.id`를 그대로 넘기면 된다 — SPEC-0019에서 언어 무관
  /// 식별자로 바뀌었고 두 값은 호환된다.
  const SpotPostsProvider._({
    required SpotPostsFamily super.from,
    required String super.argument,
  }) : super(
         retry: communityRetryPolicy,
         name: r'spotPostsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spotPostsHash();

  @override
  String toString() {
    return r'spotPostsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CursorPage<Post>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CursorPage<Post>> create(Ref ref) {
    final argument = this.argument as String;
    return spotPosts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpotPostsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spotPostsHash() => r'192d7b733b4d068d011cd818f7aaa4fe44191e38';

/// 한 장소에 달린 글 피드(장소 상세에 끼워 넣는 섹션용).
///
/// 좌표 피드와 **같은 쿼리를 인자만 달리해** 부른다 — `catalogId`를 주면 좌표는
/// 무시되므로(가이드 §2) 좌표를 아예 넘기지 않는다. 위치 권한이 없어도 도는 것이
/// 이 피드의 성질이다.
///
/// [catalogId]는 `Spot.id`를 그대로 넘기면 된다 — SPEC-0019에서 언어 무관
/// 식별자로 바뀌었고 두 값은 호환된다.

final class SpotPostsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CursorPage<Post>>, String> {
  const SpotPostsFamily._()
    : super(
        retry: communityRetryPolicy,
        name: r'spotPostsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 한 장소에 달린 글 피드(장소 상세에 끼워 넣는 섹션용).
  ///
  /// 좌표 피드와 **같은 쿼리를 인자만 달리해** 부른다 — `catalogId`를 주면 좌표는
  /// 무시되므로(가이드 §2) 좌표를 아예 넘기지 않는다. 위치 권한이 없어도 도는 것이
  /// 이 피드의 성질이다.
  ///
  /// [catalogId]는 `Spot.id`를 그대로 넘기면 된다 — SPEC-0019에서 언어 무관
  /// 식별자로 바뀌었고 두 값은 호환된다.

  SpotPostsProvider call(String catalogId) =>
      SpotPostsProvider._(argument: catalogId, from: this);

  @override
  String toString() => r'spotPostsProvider';
}
