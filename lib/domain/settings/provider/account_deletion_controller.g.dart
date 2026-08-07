// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_deletion_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 회원 탈퇴(SPEC-0011 R16).
///
/// 상태는 "아직 실행 안 함(data) / 진행 중(loading) / 실패(error)" 세 갈래다.
/// **성공 상태가 따로 없다** — 성공하면 세션이 지워져 라우터가 로그인 화면으로
/// 보내므로 이 화면이 남아 성공을 그릴 일이 없다.

@ProviderFor(AccountDeletionController)
const accountDeletionControllerProvider = AccountDeletionControllerProvider._();

/// 회원 탈퇴(SPEC-0011 R16).
///
/// 상태는 "아직 실행 안 함(data) / 진행 중(loading) / 실패(error)" 세 갈래다.
/// **성공 상태가 따로 없다** — 성공하면 세션이 지워져 라우터가 로그인 화면으로
/// 보내므로 이 화면이 남아 성공을 그릴 일이 없다.
final class AccountDeletionControllerProvider
    extends $AsyncNotifierProvider<AccountDeletionController, void> {
  /// 회원 탈퇴(SPEC-0011 R16).
  ///
  /// 상태는 "아직 실행 안 함(data) / 진행 중(loading) / 실패(error)" 세 갈래다.
  /// **성공 상태가 따로 없다** — 성공하면 세션이 지워져 라우터가 로그인 화면으로
  /// 보내므로 이 화면이 남아 성공을 그릴 일이 없다.
  const AccountDeletionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountDeletionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountDeletionControllerHash();

  @$internal
  @override
  AccountDeletionController create() => AccountDeletionController();
}

String _$accountDeletionControllerHash() =>
    r'5db2ec4dcefa2458db2029688de441a11e93f212';

/// 회원 탈퇴(SPEC-0011 R16).
///
/// 상태는 "아직 실행 안 함(data) / 진행 중(loading) / 실패(error)" 세 갈래다.
/// **성공 상태가 따로 없다** — 성공하면 세션이 지워져 라우터가 로그인 화면으로
/// 보내므로 이 화면이 남아 성공을 그릴 일이 없다.

abstract class _$AccountDeletionController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
