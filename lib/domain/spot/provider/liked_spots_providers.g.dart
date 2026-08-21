// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_spots_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 좋아요 목록의 카테고리 선택(SPEC-0020 R2). **비어 있을 수 없는 집합이다** —
/// "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현 자체가 없다.
///
/// Discover의 `selectedSpotCategory`와 **일부러 분리한다**(R12). 같은 provider를 쓰면
/// 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치워, 탭을 옮겼을 때 보고 있던
/// 카드가 사라진다. 두 화면의 필터는 서로 독립이다.
///
/// keepAlive인 이유는 Discover의 것과 같다 — 사용자가 고른 필터는 화면이 아니라
/// 세션에 속한다(AC12.3). autoDispose면 상세에 다녀오는 것만으로 초기화된다.

@ProviderFor(SelectedLikedCategory)
const selectedLikedCategoryProvider = SelectedLikedCategoryProvider._();

/// 좋아요 목록의 카테고리 선택(SPEC-0020 R2). **비어 있을 수 없는 집합이다** —
/// "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현 자체가 없다.
///
/// Discover의 `selectedSpotCategory`와 **일부러 분리한다**(R12). 같은 provider를 쓰면
/// 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치워, 탭을 옮겼을 때 보고 있던
/// 카드가 사라진다. 두 화면의 필터는 서로 독립이다.
///
/// keepAlive인 이유는 Discover의 것과 같다 — 사용자가 고른 필터는 화면이 아니라
/// 세션에 속한다(AC12.3). autoDispose면 상세에 다녀오는 것만으로 초기화된다.
final class SelectedLikedCategoryProvider
    extends $NotifierProvider<SelectedLikedCategory, Set<SpotCategory>> {
  /// 좋아요 목록의 카테고리 선택(SPEC-0020 R2). **비어 있을 수 없는 집합이다** —
  /// "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현 자체가 없다.
  ///
  /// Discover의 `selectedSpotCategory`와 **일부러 분리한다**(R12). 같은 provider를 쓰면
  /// 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치워, 탭을 옮겼을 때 보고 있던
  /// 카드가 사라진다. 두 화면의 필터는 서로 독립이다.
  ///
  /// keepAlive인 이유는 Discover의 것과 같다 — 사용자가 고른 필터는 화면이 아니라
  /// 세션에 속한다(AC12.3). autoDispose면 상세에 다녀오는 것만으로 초기화된다.
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
  Override overrideWithValue(Set<SpotCategory> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<SpotCategory>>(value),
    );
  }
}

String _$selectedLikedCategoryHash() =>
    r'e8f7c41f74f7804b0016a12edacb4946a6456500';

/// 좋아요 목록의 카테고리 선택(SPEC-0020 R2). **비어 있을 수 없는 집합이다** —
/// "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현 자체가 없다.
///
/// Discover의 `selectedSpotCategory`와 **일부러 분리한다**(R12). 같은 provider를 쓰면
/// 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치워, 탭을 옮겼을 때 보고 있던
/// 카드가 사라진다. 두 화면의 필터는 서로 독립이다.
///
/// keepAlive인 이유는 Discover의 것과 같다 — 사용자가 고른 필터는 화면이 아니라
/// 세션에 속한다(AC12.3). autoDispose면 상세에 다녀오는 것만으로 초기화된다.

abstract class _$SelectedLikedCategory extends $Notifier<Set<SpotCategory>> {
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

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [selection]별 패밀리 — 선택을 바꾸면
/// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
/// 않는다).
///
/// family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유는 스와이프 컨트롤러와
/// 같다 — `Set`은 값 동등성이 없어 family 키로 쓸 수 없다.
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

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [selection]별 패밀리 — 선택을 바꾸면
/// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
/// 않는다).
///
/// family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유는 스와이프 컨트롤러와
/// 같다 — `Set`은 값 동등성이 없어 family 키로 쓸 수 없다.
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
  /// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [selection]별 패밀리 — 선택을 바꾸면
  /// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
  /// 않는다).
  ///
  /// family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유는 스와이프 컨트롤러와
  /// 같다 — `Set`은 값 동등성이 없어 family 키로 쓸 수 없다.
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
    required SpotCategorySelection super.argument,
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
    r'70aee27f25629fb98f647fd3f8bbd57a1b95f544';

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [selection]별 패밀리 — 선택을 바꾸면
/// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
/// 않는다).
///
/// family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유는 스와이프 컨트롤러와
/// 같다 — `Set`은 값 동등성이 없어 family 키로 쓸 수 없다.
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
          SpotCategorySelection
        > {
  const LikedSpotsControllerFamily._()
    : super(
        retry: spotRetryPolicy,
        name: r'likedSpotsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [selection]별 패밀리 — 선택을 바꾸면
  /// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
  /// 않는다).
  ///
  /// family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유는 스와이프 컨트롤러와
  /// 같다 — `Set`은 값 동등성이 없어 family 키로 쓸 수 없다.
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

  LikedSpotsControllerProvider call(SpotCategorySelection selection) =>
      LikedSpotsControllerProvider._(argument: selection, from: this);

  @override
  String toString() => r'likedSpotsControllerProvider';
}

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [selection]별 패밀리 — 선택을 바꾸면
/// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
/// 않는다).
///
/// family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유는 스와이프 컨트롤러와
/// 같다 — `Set`은 값 동등성이 없어 family 키로 쓸 수 없다.
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
  late final _$args = ref.$arg as SpotCategorySelection;
  SpotCategorySelection get selection => _$args;

  FutureOr<LikedSpotsState> build(SpotCategorySelection selection);
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
