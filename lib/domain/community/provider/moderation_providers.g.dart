// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 차단·신고·삭제·수정을 실행하는 컨트롤러.
///
/// 상태를 들고 있지 않고 **동작만 노출한다** — 이 기능들은 결과가 피드 재조회로
/// 나타나지 자체 화면 상태를 만들지 않기 때문이다. 그래서 `build()`는 void를
/// 돌려주고, 각 메서드가 [ModerationOutcome]을 반환해 호출한 화면이 안내를 고른다.
///
/// **전부 인증 필수 뮤테이션이다.** 미인증이면 서버가 최상위 `errors[]`로
/// `UNAUTHENTICATED`를 주고 repository가 [CommunityFailureKind.unauthenticated]로
/// 번역한다 — 그때 [ModerationOutcome.unauthenticated]가 나와 화면이 로그인으로
/// 보낸다.

@ProviderFor(ModerationController)
const moderationControllerProvider = ModerationControllerProvider._();

/// 차단·신고·삭제·수정을 실행하는 컨트롤러.
///
/// 상태를 들고 있지 않고 **동작만 노출한다** — 이 기능들은 결과가 피드 재조회로
/// 나타나지 자체 화면 상태를 만들지 않기 때문이다. 그래서 `build()`는 void를
/// 돌려주고, 각 메서드가 [ModerationOutcome]을 반환해 호출한 화면이 안내를 고른다.
///
/// **전부 인증 필수 뮤테이션이다.** 미인증이면 서버가 최상위 `errors[]`로
/// `UNAUTHENTICATED`를 주고 repository가 [CommunityFailureKind.unauthenticated]로
/// 번역한다 — 그때 [ModerationOutcome.unauthenticated]가 나와 화면이 로그인으로
/// 보낸다.
final class ModerationControllerProvider
    extends $NotifierProvider<ModerationController, void> {
  /// 차단·신고·삭제·수정을 실행하는 컨트롤러.
  ///
  /// 상태를 들고 있지 않고 **동작만 노출한다** — 이 기능들은 결과가 피드 재조회로
  /// 나타나지 자체 화면 상태를 만들지 않기 때문이다. 그래서 `build()`는 void를
  /// 돌려주고, 각 메서드가 [ModerationOutcome]을 반환해 호출한 화면이 안내를 고른다.
  ///
  /// **전부 인증 필수 뮤테이션이다.** 미인증이면 서버가 최상위 `errors[]`로
  /// `UNAUTHENTICATED`를 주고 repository가 [CommunityFailureKind.unauthenticated]로
  /// 번역한다 — 그때 [ModerationOutcome.unauthenticated]가 나와 화면이 로그인으로
  /// 보낸다.
  const ModerationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moderationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moderationControllerHash();

  @$internal
  @override
  ModerationController create() => ModerationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$moderationControllerHash() =>
    r'a4bbbb5b8efe28b94683fb315e36c28c54f258c0';

/// 차단·신고·삭제·수정을 실행하는 컨트롤러.
///
/// 상태를 들고 있지 않고 **동작만 노출한다** — 이 기능들은 결과가 피드 재조회로
/// 나타나지 자체 화면 상태를 만들지 않기 때문이다. 그래서 `build()`는 void를
/// 돌려주고, 각 메서드가 [ModerationOutcome]을 반환해 호출한 화면이 안내를 고른다.
///
/// **전부 인증 필수 뮤테이션이다.** 미인증이면 서버가 최상위 `errors[]`로
/// `UNAUTHENTICATED`를 주고 repository가 [CommunityFailureKind.unauthenticated]로
/// 번역한다 — 그때 [ModerationOutcome.unauthenticated]가 나와 화면이 로그인으로
/// 보낸다.

abstract class _$ModerationController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
