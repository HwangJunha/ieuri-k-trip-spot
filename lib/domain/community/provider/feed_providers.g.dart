// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 커뮤니티 탭에서 선택된 카테고리(null=전체).
///
/// **상태는 이것 하나뿐이다** — 정렬 선택도, 추가 필터도, 검색도 없다(디자인 §1).
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.

@ProviderFor(SelectedCategory)
const selectedCategoryProvider = SelectedCategoryProvider._();

/// 커뮤니티 탭에서 선택된 카테고리(null=전체).
///
/// **상태는 이것 하나뿐이다** — 정렬 선택도, 추가 필터도, 검색도 없다(디자인 §1).
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.
final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, TargetCategory?> {
  /// 커뮤니티 탭에서 선택된 카테고리(null=전체).
  ///
  /// **상태는 이것 하나뿐이다** — 정렬 선택도, 추가 필터도, 검색도 없다(디자인 §1).
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
/// **상태는 이것 하나뿐이다** — 정렬 선택도, 추가 필터도, 검색도 없다(디자인 §1).
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

/// 커뮤니티 탭의 지역 피드. [category]별 패밀리 — 칩을 바꾸면 다른 인스턴스가
/// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
/// 사유**를 보여준다.
///
/// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
/// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.

@ProviderFor(FeedController)
const feedControllerProvider = FeedControllerFamily._();

/// 커뮤니티 탭의 지역 피드. [category]별 패밀리 — 칩을 바꾸면 다른 인스턴스가
/// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
/// 사유**를 보여준다.
///
/// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
/// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.
final class FeedControllerProvider
    extends $AsyncNotifierProvider<FeedController, FeedState> {
  /// 커뮤니티 탭의 지역 피드. [category]별 패밀리 — 칩을 바꾸면 다른 인스턴스가
  /// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
  ///
  /// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
  /// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
  /// 사유**를 보여준다.
  ///
  /// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
  /// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.
  const FeedControllerProvider._({
    required FeedControllerFamily super.from,
    required TargetCategory? super.argument,
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
        '($argument)';
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

String _$feedControllerHash() => r'441d70cbe156cb2d8cf78d975c4f042d79cc65fb';

/// 커뮤니티 탭의 지역 피드. [category]별 패밀리 — 칩을 바꾸면 다른 인스턴스가
/// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
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
          TargetCategory?
        > {
  const FeedControllerFamily._()
    : super(
        retry: communityRetryPolicy,
        name: r'feedControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 커뮤니티 탭의 지역 피드. [category]별 패밀리 — 칩을 바꾸면 다른 인스턴스가
  /// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
  ///
  /// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
  /// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
  /// 사유**를 보여준다.
  ///
  /// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
  /// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.

  FeedControllerProvider call(TargetCategory? category) =>
      FeedControllerProvider._(argument: category, from: this);

  @override
  String toString() => r'feedControllerProvider';
}

/// 커뮤니티 탭의 지역 피드. [category]별 패밀리 — 칩을 바꾸면 다른 인스턴스가
/// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라와 화면이 **빈 피드와 구분되는
/// 사유**를 보여준다.
///
/// **좌표와 카테고리는 서로 독립이다**(가이드 §2) — 카테고리는 범위와 무관하게
/// 걸리므로 좌표가 있든 없든 같은 인자로 넘어간다.

abstract class _$FeedController extends $AsyncNotifier<FeedState> {
  late final _$args = ref.$arg as TargetCategory?;
  TargetCategory? get category => _$args;

  FutureOr<FeedState> build(TargetCategory? category);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
/// 좌표 피드와 **같은 쿼리를 인자만 달리해** 부른다 — `spotId`를 주면 좌표는
/// 무시되므로(가이드 §2) 좌표를 아예 넘기지 않는다. 위치 권한이 없어도 도는 것이
/// 이 피드의 성질이다.

@ProviderFor(spotPosts)
const spotPostsProvider = SpotPostsFamily._();

/// 한 장소에 달린 글 피드(장소 상세에 끼워 넣는 섹션용).
///
/// 좌표 피드와 **같은 쿼리를 인자만 달리해** 부른다 — `spotId`를 주면 좌표는
/// 무시되므로(가이드 §2) 좌표를 아예 넘기지 않는다. 위치 권한이 없어도 도는 것이
/// 이 피드의 성질이다.

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
  /// 좌표 피드와 **같은 쿼리를 인자만 달리해** 부른다 — `spotId`를 주면 좌표는
  /// 무시되므로(가이드 §2) 좌표를 아예 넘기지 않는다. 위치 권한이 없어도 도는 것이
  /// 이 피드의 성질이다.
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

String _$spotPostsHash() => r'd9c790b04bf9b0d0de5f4546c4c15e918388002a';

/// 한 장소에 달린 글 피드(장소 상세에 끼워 넣는 섹션용).
///
/// 좌표 피드와 **같은 쿼리를 인자만 달리해** 부른다 — `spotId`를 주면 좌표는
/// 무시되므로(가이드 §2) 좌표를 아예 넘기지 않는다. 위치 권한이 없어도 도는 것이
/// 이 피드의 성질이다.

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
  /// 좌표 피드와 **같은 쿼리를 인자만 달리해** 부른다 — `spotId`를 주면 좌표는
  /// 무시되므로(가이드 §2) 좌표를 아예 넘기지 않는다. 위치 권한이 없어도 도는 것이
  /// 이 피드의 성질이다.

  SpotPostsProvider call(String spotId) =>
      SpotPostsProvider._(argument: spotId, from: this);

  @override
  String toString() => r'spotPostsProvider';
}
