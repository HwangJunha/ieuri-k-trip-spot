// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_users_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 내가 차단한 사람 목록(가이드 §6).
///
/// **나를 차단한 사람은 여기 없다** — 남이 건 차단은 내가 풀 수 없기 때문이다.
/// "글이 안 보이는데 목록에 없다"는 정상이며, 화면이 그 사실을 안내한다.

@ProviderFor(BlockedUsersController)
const blockedUsersControllerProvider = BlockedUsersControllerProvider._();

/// 내가 차단한 사람 목록(가이드 §6).
///
/// **나를 차단한 사람은 여기 없다** — 남이 건 차단은 내가 풀 수 없기 때문이다.
/// "글이 안 보이는데 목록에 없다"는 정상이며, 화면이 그 사실을 안내한다.
final class BlockedUsersControllerProvider
    extends $AsyncNotifierProvider<BlockedUsersController, BlockedUsersState> {
  /// 내가 차단한 사람 목록(가이드 §6).
  ///
  /// **나를 차단한 사람은 여기 없다** — 남이 건 차단은 내가 풀 수 없기 때문이다.
  /// "글이 안 보이는데 목록에 없다"는 정상이며, 화면이 그 사실을 안내한다.
  const BlockedUsersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: communityRetryPolicy,
        name: r'blockedUsersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blockedUsersControllerHash();

  @$internal
  @override
  BlockedUsersController create() => BlockedUsersController();
}

String _$blockedUsersControllerHash() =>
    r'60abfaaa49e505bc37b3825729894cc9c3c2f38b';

/// 내가 차단한 사람 목록(가이드 §6).
///
/// **나를 차단한 사람은 여기 없다** — 남이 건 차단은 내가 풀 수 없기 때문이다.
/// "글이 안 보이는데 목록에 없다"는 정상이며, 화면이 그 사실을 안내한다.

abstract class _$BlockedUsersController
    extends $AsyncNotifier<BlockedUsersState> {
  FutureOr<BlockedUsersState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<BlockedUsersState>, BlockedUsersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BlockedUsersState>, BlockedUsersState>,
              AsyncValue<BlockedUsersState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
