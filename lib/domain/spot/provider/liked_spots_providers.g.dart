// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_spots_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 좋아요 목록에서 선택된 카테고리(null=전체).
///
/// Discover의 `selectedSpotCategory`와 **일부러 분리한다.** 같은 provider를 쓰면
/// 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치워, 탭을 옮겼을 때 보고 있던
/// 카드가 사라진다. 두 화면의 필터는 서로 독립이다.
///
/// keepAlive인 이유는 Discover의 것과 같다 — 사용자가 고른 필터는 화면이 아니라
/// 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로 되돌아간다.

@ProviderFor(SelectedLikedCategory)
const selectedLikedCategoryProvider = SelectedLikedCategoryProvider._();

/// 좋아요 목록에서 선택된 카테고리(null=전체).
///
/// Discover의 `selectedSpotCategory`와 **일부러 분리한다.** 같은 provider를 쓰면
/// 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치워, 탭을 옮겼을 때 보고 있던
/// 카드가 사라진다. 두 화면의 필터는 서로 독립이다.
///
/// keepAlive인 이유는 Discover의 것과 같다 — 사용자가 고른 필터는 화면이 아니라
/// 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로 되돌아간다.
final class SelectedLikedCategoryProvider
    extends $NotifierProvider<SelectedLikedCategory, SpotCategory?> {
  /// 좋아요 목록에서 선택된 카테고리(null=전체).
  ///
  /// Discover의 `selectedSpotCategory`와 **일부러 분리한다.** 같은 provider를 쓰면
  /// 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치워, 탭을 옮겼을 때 보고 있던
  /// 카드가 사라진다. 두 화면의 필터는 서로 독립이다.
  ///
  /// keepAlive인 이유는 Discover의 것과 같다 — 사용자가 고른 필터는 화면이 아니라
  /// 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로 되돌아간다.
  const SelectedLikedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedLikedCategoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedLikedCategoryHash();

  @$internal
  @override
  SelectedLikedCategory create() => SelectedLikedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotCategory? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotCategory?>(value),
    );
  }
}

String _$selectedLikedCategoryHash() =>
    r'60b12582e14ef02c56ac148ecbcf6e143a24f295';

/// 좋아요 목록에서 선택된 카테고리(null=전체).
///
/// Discover의 `selectedSpotCategory`와 **일부러 분리한다.** 같은 provider를 쓰면
/// 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치워, 탭을 옮겼을 때 보고 있던
/// 카드가 사라진다. 두 화면의 필터는 서로 독립이다.
///
/// keepAlive인 이유는 Discover의 것과 같다 — 사용자가 고른 필터는 화면이 아니라
/// 세션에 속한다. autoDispose면 상세에 다녀오는 것만으로 "전체"로 되돌아간다.

abstract class _$SelectedLikedCategory extends $Notifier<SpotCategory?> {
  SpotCategory? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SpotCategory?, SpotCategory?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SpotCategory?, SpotCategory?>,
              SpotCategory?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [category]별 패밀리 — 카테고리를 바꾸면
/// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
/// 않는다).
///
/// 미인증이면 repository가 `UNAUTHENTICATED`를 [SpotFailure]로 던지고, 그것이
/// `AsyncValue.error`로 UI에 노출되어 SPEC-0005의 세션 갱신 경로를 탄다 — 이 스펙이
/// 별도 처리를 더하지 않는다(§5.2).
///
/// autoDispose(codegen 기본값)를 그대로 쓴다. 스와이프 큐와 달리 이 목록은 화면에
/// 속하고 서버가 정렬을 보장하므로, 탭을 떠났다 오면 다시 받는 것이 오히려 맞다 —
/// 상세에서 좋아요를 해제하고 돌아왔을 때 최신 목록을 보게 된다.
///
/// [spotRetryPolicy]로 자동 재시도를 묶는다(SPEC-0006 R1). Riverpod 기본값은 실패한
/// provider를 최대 10회 지수 백오프로 재조회하는데, 미인증 실패는 여기서 다시 조회해
/// 봐야 같은 실패가 날 뿐이고 그 폭주가 세션 갱신 경로와 겹친다 — 인증 실패에는
/// 재시도하지 않는 이 정책이 그것을 끊는다(R5).

@ProviderFor(LikedSpotsController)
const likedSpotsControllerProvider = LikedSpotsControllerFamily._();

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [category]별 패밀리 — 카테고리를 바꾸면
/// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
/// 않는다).
///
/// 미인증이면 repository가 `UNAUTHENTICATED`를 [SpotFailure]로 던지고, 그것이
/// `AsyncValue.error`로 UI에 노출되어 SPEC-0005의 세션 갱신 경로를 탄다 — 이 스펙이
/// 별도 처리를 더하지 않는다(§5.2).
///
/// autoDispose(codegen 기본값)를 그대로 쓴다. 스와이프 큐와 달리 이 목록은 화면에
/// 속하고 서버가 정렬을 보장하므로, 탭을 떠났다 오면 다시 받는 것이 오히려 맞다 —
/// 상세에서 좋아요를 해제하고 돌아왔을 때 최신 목록을 보게 된다.
///
/// [spotRetryPolicy]로 자동 재시도를 묶는다(SPEC-0006 R1). Riverpod 기본값은 실패한
/// provider를 최대 10회 지수 백오프로 재조회하는데, 미인증 실패는 여기서 다시 조회해
/// 봐야 같은 실패가 날 뿐이고 그 폭주가 세션 갱신 경로와 겹친다 — 인증 실패에는
/// 재시도하지 않는 이 정책이 그것을 끊는다(R5).
final class LikedSpotsControllerProvider
    extends $AsyncNotifierProvider<LikedSpotsController, LikedSpotsState> {
  /// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [category]별 패밀리 — 카테고리를 바꾸면
  /// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
  /// 않는다).
  ///
  /// 미인증이면 repository가 `UNAUTHENTICATED`를 [SpotFailure]로 던지고, 그것이
  /// `AsyncValue.error`로 UI에 노출되어 SPEC-0005의 세션 갱신 경로를 탄다 — 이 스펙이
  /// 별도 처리를 더하지 않는다(§5.2).
  ///
  /// autoDispose(codegen 기본값)를 그대로 쓴다. 스와이프 큐와 달리 이 목록은 화면에
  /// 속하고 서버가 정렬을 보장하므로, 탭을 떠났다 오면 다시 받는 것이 오히려 맞다 —
  /// 상세에서 좋아요를 해제하고 돌아왔을 때 최신 목록을 보게 된다.
  ///
  /// [spotRetryPolicy]로 자동 재시도를 묶는다(SPEC-0006 R1). Riverpod 기본값은 실패한
  /// provider를 최대 10회 지수 백오프로 재조회하는데, 미인증 실패는 여기서 다시 조회해
  /// 봐야 같은 실패가 날 뿐이고 그 폭주가 세션 갱신 경로와 겹친다 — 인증 실패에는
  /// 재시도하지 않는 이 정책이 그것을 끊는다(R5).
  const LikedSpotsControllerProvider._({
    required LikedSpotsControllerFamily super.from,
    required SpotCategory? super.argument,
  }) : super(
         retry: spotRetryPolicy,
         name: r'likedSpotsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$likedSpotsControllerHash();

  @override
  String toString() {
    return r'likedSpotsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LikedSpotsController create() => LikedSpotsController();

  @override
  bool operator ==(Object other) {
    return other is LikedSpotsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$likedSpotsControllerHash() =>
    r'2c13f26e4473cb537727426b13e2a138535eabdd';

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [category]별 패밀리 — 카테고리를 바꾸면
/// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
/// 않는다).
///
/// 미인증이면 repository가 `UNAUTHENTICATED`를 [SpotFailure]로 던지고, 그것이
/// `AsyncValue.error`로 UI에 노출되어 SPEC-0005의 세션 갱신 경로를 탄다 — 이 스펙이
/// 별도 처리를 더하지 않는다(§5.2).
///
/// autoDispose(codegen 기본값)를 그대로 쓴다. 스와이프 큐와 달리 이 목록은 화면에
/// 속하고 서버가 정렬을 보장하므로, 탭을 떠났다 오면 다시 받는 것이 오히려 맞다 —
/// 상세에서 좋아요를 해제하고 돌아왔을 때 최신 목록을 보게 된다.
///
/// [spotRetryPolicy]로 자동 재시도를 묶는다(SPEC-0006 R1). Riverpod 기본값은 실패한
/// provider를 최대 10회 지수 백오프로 재조회하는데, 미인증 실패는 여기서 다시 조회해
/// 봐야 같은 실패가 날 뿐이고 그 폭주가 세션 갱신 경로와 겹친다 — 인증 실패에는
/// 재시도하지 않는 이 정책이 그것을 끊는다(R5).

final class LikedSpotsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          LikedSpotsController,
          AsyncValue<LikedSpotsState>,
          LikedSpotsState,
          FutureOr<LikedSpotsState>,
          SpotCategory?
        > {
  const LikedSpotsControllerFamily._()
    : super(
        retry: spotRetryPolicy,
        name: r'likedSpotsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [category]별 패밀리 — 카테고리를 바꾸면
  /// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
  /// 않는다).
  ///
  /// 미인증이면 repository가 `UNAUTHENTICATED`를 [SpotFailure]로 던지고, 그것이
  /// `AsyncValue.error`로 UI에 노출되어 SPEC-0005의 세션 갱신 경로를 탄다 — 이 스펙이
  /// 별도 처리를 더하지 않는다(§5.2).
  ///
  /// autoDispose(codegen 기본값)를 그대로 쓴다. 스와이프 큐와 달리 이 목록은 화면에
  /// 속하고 서버가 정렬을 보장하므로, 탭을 떠났다 오면 다시 받는 것이 오히려 맞다 —
  /// 상세에서 좋아요를 해제하고 돌아왔을 때 최신 목록을 보게 된다.
  ///
  /// [spotRetryPolicy]로 자동 재시도를 묶는다(SPEC-0006 R1). Riverpod 기본값은 실패한
  /// provider를 최대 10회 지수 백오프로 재조회하는데, 미인증 실패는 여기서 다시 조회해
  /// 봐야 같은 실패가 날 뿐이고 그 폭주가 세션 갱신 경로와 겹친다 — 인증 실패에는
  /// 재시도하지 않는 이 정책이 그것을 끊는다(R5).

  LikedSpotsControllerProvider call(SpotCategory? category) =>
      LikedSpotsControllerProvider._(argument: category, from: this);

  @override
  String toString() => r'likedSpotsControllerProvider';
}

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [category]별 패밀리 — 카테고리를 바꾸면
/// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
/// 않는다).
///
/// 미인증이면 repository가 `UNAUTHENTICATED`를 [SpotFailure]로 던지고, 그것이
/// `AsyncValue.error`로 UI에 노출되어 SPEC-0005의 세션 갱신 경로를 탄다 — 이 스펙이
/// 별도 처리를 더하지 않는다(§5.2).
///
/// autoDispose(codegen 기본값)를 그대로 쓴다. 스와이프 큐와 달리 이 목록은 화면에
/// 속하고 서버가 정렬을 보장하므로, 탭을 떠났다 오면 다시 받는 것이 오히려 맞다 —
/// 상세에서 좋아요를 해제하고 돌아왔을 때 최신 목록을 보게 된다.
///
/// [spotRetryPolicy]로 자동 재시도를 묶는다(SPEC-0006 R1). Riverpod 기본값은 실패한
/// provider를 최대 10회 지수 백오프로 재조회하는데, 미인증 실패는 여기서 다시 조회해
/// 봐야 같은 실패가 날 뿐이고 그 폭주가 세션 갱신 경로와 겹친다 — 인증 실패에는
/// 재시도하지 않는 이 정책이 그것을 끊는다(R5).

abstract class _$LikedSpotsController extends $AsyncNotifier<LikedSpotsState> {
  late final _$args = ref.$arg as SpotCategory?;
  SpotCategory? get category => _$args;

  FutureOr<LikedSpotsState> build(SpotCategory? category);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<LikedSpotsState>, LikedSpotsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LikedSpotsState>, LikedSpotsState>,
              AsyncValue<LikedSpotsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
