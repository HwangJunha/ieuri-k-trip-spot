// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 커뮤니티 탭에서 선택된 주제 태그(null=전체).
///
/// **상태는 이것 하나뿐이다** — 정렬 선택도, 추가 필터도, 검색도 없다(설계 §3).
/// 타일에서 진입해도 같은 상태에 반영되어 상단 칩이 그 태그로 선택된 것처럼 보인다
/// (R11-3) — 타일 진입과 칩 선택이 서로 다른 화면 상태를 만들지 않는다.
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.

@ProviderFor(SelectedPostTopic)
const selectedPostTopicProvider = SelectedPostTopicProvider._();

/// 커뮤니티 탭에서 선택된 주제 태그(null=전체).
///
/// **상태는 이것 하나뿐이다** — 정렬 선택도, 추가 필터도, 검색도 없다(설계 §3).
/// 타일에서 진입해도 같은 상태에 반영되어 상단 칩이 그 태그로 선택된 것처럼 보인다
/// (R11-3) — 타일 진입과 칩 선택이 서로 다른 화면 상태를 만들지 않는다.
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.
final class SelectedPostTopicProvider
    extends $NotifierProvider<SelectedPostTopic, PostTopic?> {
  /// 커뮤니티 탭에서 선택된 주제 태그(null=전체).
  ///
  /// **상태는 이것 하나뿐이다** — 정렬 선택도, 추가 필터도, 검색도 없다(설계 §3).
  /// 타일에서 진입해도 같은 상태에 반영되어 상단 칩이 그 태그로 선택된 것처럼 보인다
  /// (R11-3) — 타일 진입과 칩 선택이 서로 다른 화면 상태를 만들지 않는다.
  ///
  /// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
  /// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
  /// 되돌아간다.
  const SelectedPostTopicProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedPostTopicProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedPostTopicHash();

  @$internal
  @override
  SelectedPostTopic create() => SelectedPostTopic();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostTopic? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostTopic?>(value),
    );
  }
}

String _$selectedPostTopicHash() => r'bb8d8d5cc9cec8b2ecdd8ca652639a0291712dce';

/// 커뮤니티 탭에서 선택된 주제 태그(null=전체).
///
/// **상태는 이것 하나뿐이다** — 정렬 선택도, 추가 필터도, 검색도 없다(설계 §3).
/// 타일에서 진입해도 같은 상태에 반영되어 상단 칩이 그 태그로 선택된 것처럼 보인다
/// (R11-3) — 타일 진입과 칩 선택이 서로 다른 화면 상태를 만들지 않는다.
///
/// keepAlive인 이유는 좋아요 목록의 카테고리 필터와 같다 — 사용자가 고른 필터는
/// 화면이 아니라 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로
/// 되돌아간다.

abstract class _$SelectedPostTopic extends $Notifier<PostTopic?> {
  PostTopic? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PostTopic?, PostTopic?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostTopic?, PostTopic?>,
              PostTopic?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 좌표 기반 지역 피드(R7·R8). [topic]별 패밀리 — 태그를 바꾸면 다른 인스턴스가
/// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다 — 이 스펙이
/// 새로 수집하는 항목은 없다(설계 §3). 위치를 얻지 못하면 그 실패가 `AsyncValue.error`로
/// 올라와 화면이 **빈 피드와 구분되는 사유**를 보여준다.
///
/// 조회는 미인증으로도 되므로(가이드 §13) 로그인 여부로 분기하지 않는다.
/// `likedByViewer`·`ownedByViewer`가 false로 올 뿐이다.

@ProviderFor(NearbyFeedController)
const nearbyFeedControllerProvider = NearbyFeedControllerFamily._();

/// 좌표 기반 지역 피드(R7·R8). [topic]별 패밀리 — 태그를 바꾸면 다른 인스턴스가
/// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다 — 이 스펙이
/// 새로 수집하는 항목은 없다(설계 §3). 위치를 얻지 못하면 그 실패가 `AsyncValue.error`로
/// 올라와 화면이 **빈 피드와 구분되는 사유**를 보여준다.
///
/// 조회는 미인증으로도 되므로(가이드 §13) 로그인 여부로 분기하지 않는다.
/// `likedByViewer`·`ownedByViewer`가 false로 올 뿐이다.
final class NearbyFeedControllerProvider
    extends $AsyncNotifierProvider<NearbyFeedController, NearbyFeedState> {
  /// 좌표 기반 지역 피드(R7·R8). [topic]별 패밀리 — 태그를 바꾸면 다른 인스턴스가
  /// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
  ///
  /// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다 — 이 스펙이
  /// 새로 수집하는 항목은 없다(설계 §3). 위치를 얻지 못하면 그 실패가 `AsyncValue.error`로
  /// 올라와 화면이 **빈 피드와 구분되는 사유**를 보여준다.
  ///
  /// 조회는 미인증으로도 되므로(가이드 §13) 로그인 여부로 분기하지 않는다.
  /// `likedByViewer`·`ownedByViewer`가 false로 올 뿐이다.
  const NearbyFeedControllerProvider._({
    required NearbyFeedControllerFamily super.from,
    required PostTopic? super.argument,
  }) : super(
         retry: communityRetryPolicy,
         name: r'nearbyFeedControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$nearbyFeedControllerHash();

  @override
  String toString() {
    return r'nearbyFeedControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NearbyFeedController create() => NearbyFeedController();

  @override
  bool operator ==(Object other) {
    return other is NearbyFeedControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nearbyFeedControllerHash() =>
    r'735988389ffe05e18798b8e4809ee8e17ecdcdbc';

/// 좌표 기반 지역 피드(R7·R8). [topic]별 패밀리 — 태그를 바꾸면 다른 인스턴스가
/// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다 — 이 스펙이
/// 새로 수집하는 항목은 없다(설계 §3). 위치를 얻지 못하면 그 실패가 `AsyncValue.error`로
/// 올라와 화면이 **빈 피드와 구분되는 사유**를 보여준다.
///
/// 조회는 미인증으로도 되므로(가이드 §13) 로그인 여부로 분기하지 않는다.
/// `likedByViewer`·`ownedByViewer`가 false로 올 뿐이다.

final class NearbyFeedControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          NearbyFeedController,
          AsyncValue<NearbyFeedState>,
          NearbyFeedState,
          FutureOr<NearbyFeedState>,
          PostTopic?
        > {
  const NearbyFeedControllerFamily._()
    : super(
        retry: communityRetryPolicy,
        name: r'nearbyFeedControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 좌표 기반 지역 피드(R7·R8). [topic]별 패밀리 — 태그를 바꾸면 다른 인스턴스가
  /// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
  ///
  /// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다 — 이 스펙이
  /// 새로 수집하는 항목은 없다(설계 §3). 위치를 얻지 못하면 그 실패가 `AsyncValue.error`로
  /// 올라와 화면이 **빈 피드와 구분되는 사유**를 보여준다.
  ///
  /// 조회는 미인증으로도 되므로(가이드 §13) 로그인 여부로 분기하지 않는다.
  /// `likedByViewer`·`ownedByViewer`가 false로 올 뿐이다.

  NearbyFeedControllerProvider call(PostTopic? topic) =>
      NearbyFeedControllerProvider._(argument: topic, from: this);

  @override
  String toString() => r'nearbyFeedControllerProvider';
}

/// 좌표 기반 지역 피드(R7·R8). [topic]별 패밀리 — 태그를 바꾸면 다른 인스턴스가
/// 로딩되고 **필터링은 서버가 한다**(클라이언트가 받은 목록을 거르지 않는다).
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다 — 이 스펙이
/// 새로 수집하는 항목은 없다(설계 §3). 위치를 얻지 못하면 그 실패가 `AsyncValue.error`로
/// 올라와 화면이 **빈 피드와 구분되는 사유**를 보여준다.
///
/// 조회는 미인증으로도 되므로(가이드 §13) 로그인 여부로 분기하지 않는다.
/// `likedByViewer`·`ownedByViewer`가 false로 올 뿐이다.

abstract class _$NearbyFeedController extends $AsyncNotifier<NearbyFeedState> {
  late final _$args = ref.$arg as PostTopic?;
  PostTopic? get topic => _$args;

  FutureOr<NearbyFeedState> build(PostTopic? topic);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<NearbyFeedState>, NearbyFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NearbyFeedState>, NearbyFeedState>,
              AsyncValue<NearbyFeedState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
