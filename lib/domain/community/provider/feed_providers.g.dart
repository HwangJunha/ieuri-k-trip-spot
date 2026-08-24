// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 커뮤니티 탭에서 선택된 카테고리 집합(**빈 집합 = 전체**).
///
/// 서버가 복수 인자를 받게 되면서(#77, 2026-08-16) spot 쪽과 같은 다중 선택이 됐다.
/// 빈 집합이 "전체"인 것도 앱 전체 규약을 따른다 — 바 맨 앞의 "전체" 칩이 켜지고,
/// 서버에는 `categories` 인자를 **보내지 않는다**(빈 배열은 거절된다).
/// 예전의 "마지막 하나는 해제 불가" 규칙은 없다.
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.
///
/// **토글 규칙이 위젯이 아니라 여기 있는 이유**: 위젯 없이 테스트가 성립해야 한다.

@ProviderFor(SelectedCategory)
const selectedCategoryProvider = SelectedCategoryProvider._();

/// 커뮤니티 탭에서 선택된 카테고리 집합(**빈 집합 = 전체**).
///
/// 서버가 복수 인자를 받게 되면서(#77, 2026-08-16) spot 쪽과 같은 다중 선택이 됐다.
/// 빈 집합이 "전체"인 것도 앱 전체 규약을 따른다 — 바 맨 앞의 "전체" 칩이 켜지고,
/// 서버에는 `categories` 인자를 **보내지 않는다**(빈 배열은 거절된다).
/// 예전의 "마지막 하나는 해제 불가" 규칙은 없다.
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.
///
/// **토글 규칙이 위젯이 아니라 여기 있는 이유**: 위젯 없이 테스트가 성립해야 한다.
final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, Set<TargetCategory>> {
  /// 커뮤니티 탭에서 선택된 카테고리 집합(**빈 집합 = 전체**).
  ///
  /// 서버가 복수 인자를 받게 되면서(#77, 2026-08-16) spot 쪽과 같은 다중 선택이 됐다.
  /// 빈 집합이 "전체"인 것도 앱 전체 규약을 따른다 — 바 맨 앞의 "전체" 칩이 켜지고,
  /// 서버에는 `categories` 인자를 **보내지 않는다**(빈 배열은 거절된다).
  /// 예전의 "마지막 하나는 해제 불가" 규칙은 없다.
  ///
  /// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
  /// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
  /// 되돌아간다.
  ///
  /// **토글 규칙이 위젯이 아니라 여기 있는 이유**: 위젯 없이 테스트가 성립해야 한다.
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
  Override overrideWithValue(Set<TargetCategory> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<TargetCategory>>(value),
    );
  }
}

String _$selectedCategoryHash() => r'9c17df82338cee35ea29de54bf306b8043277401';

/// 커뮤니티 탭에서 선택된 카테고리 집합(**빈 집합 = 전체**).
///
/// 서버가 복수 인자를 받게 되면서(#77, 2026-08-16) spot 쪽과 같은 다중 선택이 됐다.
/// 빈 집합이 "전체"인 것도 앱 전체 규약을 따른다 — 바 맨 앞의 "전체" 칩이 켜지고,
/// 서버에는 `categories` 인자를 **보내지 않는다**(빈 배열은 거절된다).
/// 예전의 "마지막 하나는 해제 불가" 규칙은 없다.
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.
///
/// **토글 규칙이 위젯이 아니라 여기 있는 이유**: 위젯 없이 테스트가 성립해야 한다.

abstract class _$SelectedCategory extends $Notifier<Set<TargetCategory>> {
  Set<TargetCategory> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<TargetCategory>, Set<TargetCategory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<TargetCategory>, Set<TargetCategory>>,
              Set<TargetCategory>,
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

String _$selectedSortHash() => r'd855cb4366d61ac3ff05978f62a3d4f994396cf2';

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

/// 커뮤니티 탭의 지역 피드. [selection]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
/// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
/// 다시 정렬하지 않는다).
///
/// **family 인자가 `Set`이 아니라 [TargetCategorySelection]인 이유**: `Set`은 값
/// 동등성이 없어 선택이 그대로여도 매 빌드마다 새 인스턴스가 만들어지고, keepAlive라
/// 버려지지도 않아 피드를 처음부터 다시 받는다.
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

/// 커뮤니티 탭의 지역 피드. [selection]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
/// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
/// 다시 정렬하지 않는다).
///
/// **family 인자가 `Set`이 아니라 [TargetCategorySelection]인 이유**: `Set`은 값
/// 동등성이 없어 선택이 그대로여도 매 빌드마다 새 인스턴스가 만들어지고, keepAlive라
/// 버려지지도 않아 피드를 처음부터 다시 받는다.
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
  /// 커뮤니티 탭의 지역 피드. [selection]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
  /// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
  /// 다시 정렬하지 않는다).
  ///
  /// **family 인자가 `Set`이 아니라 [TargetCategorySelection]인 이유**: `Set`은 값
  /// 동등성이 없어 선택이 그대로여도 매 빌드마다 새 인스턴스가 만들어지고, keepAlive라
  /// 버려지지도 않아 피드를 처음부터 다시 받는다.
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
    required (TargetCategorySelection, PostSortOrder) super.argument,
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

String _$feedControllerHash() => r'cedd70fceb549f5ca25c3fb86c3bd8994bb2af8a';

/// 커뮤니티 탭의 지역 피드. [selection]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
/// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
/// 다시 정렬하지 않는다).
///
/// **family 인자가 `Set`이 아니라 [TargetCategorySelection]인 이유**: `Set`은 값
/// 동등성이 없어 선택이 그대로여도 매 빌드마다 새 인스턴스가 만들어지고, keepAlive라
/// 버려지지도 않아 피드를 처음부터 다시 받는다.
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
          (TargetCategorySelection, PostSortOrder)
        > {
  const FeedControllerFamily._()
    : super(
        retry: communityRetryPolicy,
        name: r'feedControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 커뮤니티 탭의 지역 피드. [selection]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
  /// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
  /// 다시 정렬하지 않는다).
  ///
  /// **family 인자가 `Set`이 아니라 [TargetCategorySelection]인 이유**: `Set`은 값
  /// 동등성이 없어 선택이 그대로여도 매 빌드마다 새 인스턴스가 만들어지고, keepAlive라
  /// 버려지지도 않아 피드를 처음부터 다시 받는다.
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

  FeedControllerProvider call(
    TargetCategorySelection selection,
    PostSortOrder sort,
  ) => FeedControllerProvider._(argument: (selection, sort), from: this);

  @override
  String toString() => r'feedControllerProvider';
}

/// 커뮤니티 탭의 지역 피드. [selection]·[sort]별 패밀리 — 둘 중 하나를 바꾸면 다른
/// 인스턴스가 로딩되고 **필터링·정렬은 서버가 한다**(클라이언트가 받은 목록을 거르거나
/// 다시 정렬하지 않는다).
///
/// **family 인자가 `Set`이 아니라 [TargetCategorySelection]인 이유**: `Set`은 값
/// 동등성이 없어 선택이 그대로여도 매 빌드마다 새 인스턴스가 만들어지고, keepAlive라
/// 버려지지도 않아 피드를 처음부터 다시 받는다.
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
  late final _$args = ref.$arg as (TargetCategorySelection, PostSortOrder);
  TargetCategorySelection get selection => _$args.$1;
  PostSortOrder get sort => _$args.$2;

  FutureOr<FeedState> build(
    TargetCategorySelection selection,
    PostSortOrder sort,
  );
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
