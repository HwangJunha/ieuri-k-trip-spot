// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_spots_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 좋아요 목록 컨트롤러(SPEC-0008 R-18).
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
const likedSpotsControllerProvider = LikedSpotsControllerProvider._();

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18).
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
  /// 좋아요 목록 컨트롤러(SPEC-0008 R-18).
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
  const LikedSpotsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: spotRetryPolicy,
        name: r'likedSpotsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likedSpotsControllerHash();

  @$internal
  @override
  LikedSpotsController create() => LikedSpotsController();
}

String _$likedSpotsControllerHash() =>
    r'63d7fd3a382ee7e13af041aeaca2dcb2d0a7e69a';

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18).
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
  FutureOr<LikedSpotsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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
