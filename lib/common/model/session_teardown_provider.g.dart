// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_teardown_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 세션 정리 훅의 단일 출처(SPEC-0028 §3.2).
///
/// `TokenRefreshBridge`가 네트워크 계층과 auth의 순환을 콜백으로 끊은 것과 같은
/// 방식이다 — 등록하는 쪽(alarm)과 부르는 쪽(auth)이 서로를 import하지 않는다.

@ProviderFor(sessionTeardown)
const sessionTeardownProvider = SessionTeardownProvider._();

/// 세션 정리 훅의 단일 출처(SPEC-0028 §3.2).
///
/// `TokenRefreshBridge`가 네트워크 계층과 auth의 순환을 콜백으로 끊은 것과 같은
/// 방식이다 — 등록하는 쪽(alarm)과 부르는 쪽(auth)이 서로를 import하지 않는다.

final class SessionTeardownProvider
    extends
        $FunctionalProvider<SessionTeardown, SessionTeardown, SessionTeardown>
    with $Provider<SessionTeardown> {
  /// 세션 정리 훅의 단일 출처(SPEC-0028 §3.2).
  ///
  /// `TokenRefreshBridge`가 네트워크 계층과 auth의 순환을 콜백으로 끊은 것과 같은
  /// 방식이다 — 등록하는 쪽(alarm)과 부르는 쪽(auth)이 서로를 import하지 않는다.
  const SessionTeardownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionTeardownProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionTeardownHash();

  @$internal
  @override
  $ProviderElement<SessionTeardown> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionTeardown create(Ref ref) {
    return sessionTeardown(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionTeardown value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionTeardown>(value),
    );
  }
}

String _$sessionTeardownHash() => r'233677937dbf5684bd631d44fc3faad06506406a';
