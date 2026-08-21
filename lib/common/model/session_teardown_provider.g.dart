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
///
/// **기기에 남는 사용자 데이터 삭제도 여기 건다.** `keepAlive` provider는 인증을
/// watch해 스스로 비워지지만(`SessionScope`), 디스크에 쓴 것은 그렇지 않아 앱을
/// 다시 켜면 되살아난다 — 다음 사용자에게 이전 사람의 검색어와 글 초안이 보인다.
///
/// 등록을 이 provider 안에서 하는 이유는 **부를 자리가 마땅치 않아서**다. alarm은
/// 화면 게이트가 있어 거기서 걸지만, 이쪽은 화면이 없다. `keepAlive`라 한 번만
/// 만들어지므로 중복 등록되지 않는다.

@ProviderFor(sessionTeardown)
const sessionTeardownProvider = SessionTeardownProvider._();

/// 세션 정리 훅의 단일 출처(SPEC-0028 §3.2).
///
/// `TokenRefreshBridge`가 네트워크 계층과 auth의 순환을 콜백으로 끊은 것과 같은
/// 방식이다 — 등록하는 쪽(alarm)과 부르는 쪽(auth)이 서로를 import하지 않는다.
///
/// **기기에 남는 사용자 데이터 삭제도 여기 건다.** `keepAlive` provider는 인증을
/// watch해 스스로 비워지지만(`SessionScope`), 디스크에 쓴 것은 그렇지 않아 앱을
/// 다시 켜면 되살아난다 — 다음 사용자에게 이전 사람의 검색어와 글 초안이 보인다.
///
/// 등록을 이 provider 안에서 하는 이유는 **부를 자리가 마땅치 않아서**다. alarm은
/// 화면 게이트가 있어 거기서 걸지만, 이쪽은 화면이 없다. `keepAlive`라 한 번만
/// 만들어지므로 중복 등록되지 않는다.

final class SessionTeardownProvider
    extends
        $FunctionalProvider<SessionTeardown, SessionTeardown, SessionTeardown>
    with $Provider<SessionTeardown> {
  /// 세션 정리 훅의 단일 출처(SPEC-0028 §3.2).
  ///
  /// `TokenRefreshBridge`가 네트워크 계층과 auth의 순환을 콜백으로 끊은 것과 같은
  /// 방식이다 — 등록하는 쪽(alarm)과 부르는 쪽(auth)이 서로를 import하지 않는다.
  ///
  /// **기기에 남는 사용자 데이터 삭제도 여기 건다.** `keepAlive` provider는 인증을
  /// watch해 스스로 비워지지만(`SessionScope`), 디스크에 쓴 것은 그렇지 않아 앱을
  /// 다시 켜면 되살아난다 — 다음 사용자에게 이전 사람의 검색어와 글 초안이 보인다.
  ///
  /// 등록을 이 provider 안에서 하는 이유는 **부를 자리가 마땅치 않아서**다. alarm은
  /// 화면 게이트가 있어 거기서 걸지만, 이쪽은 화면이 없다. `keepAlive`라 한 번만
  /// 만들어지므로 중복 등록되지 않는다.
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

String _$sessionTeardownHash() => r'b593f0a25691d35ecbd8041b929b4b87835b379f';
