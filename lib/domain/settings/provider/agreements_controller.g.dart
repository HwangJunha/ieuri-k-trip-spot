// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 설정 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지 않는다).
/// 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.

@ProviderFor(settingsRepository)
const settingsRepositoryProvider = SettingsRepositoryProvider._();

/// 설정 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지 않는다).
/// 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  /// 설정 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지 않는다).
  /// 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
  const SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'73732d37e76a753351724edcfd839d0f704b587e';

/// 약관 동의 상태(SPEC-0011 R9~R12).
///
/// **`keepAlive`인 이유는 게이트다.** 라우터 리다이렉트가 매 내비게이션마다 이 값을
/// `ref.read`로 읽는데(R11), autoDispose면 화면이 없는 순간 폐기됐다가 다음 리다이렉트에
/// 다시 조회가 시작되고 그 사이 상태가 `loading`이 된다 — 게이트가 사용자를 스플래시에
/// 묶어 화면 전환이 네트워크에 묶인다(설계 §3). 조회는 앱 수명 동안 한 번이면 족하다.
///
/// 토글은 **낙관적으로 반영하고 실패하면 되돌린다**(R10). 서버 왕복을 기다리면 스위치가
/// 손가락을 따라오지 않아 먹통처럼 보인다.

@ProviderFor(AgreementsController)
const agreementsControllerProvider = AgreementsControllerProvider._();

/// 약관 동의 상태(SPEC-0011 R9~R12).
///
/// **`keepAlive`인 이유는 게이트다.** 라우터 리다이렉트가 매 내비게이션마다 이 값을
/// `ref.read`로 읽는데(R11), autoDispose면 화면이 없는 순간 폐기됐다가 다음 리다이렉트에
/// 다시 조회가 시작되고 그 사이 상태가 `loading`이 된다 — 게이트가 사용자를 스플래시에
/// 묶어 화면 전환이 네트워크에 묶인다(설계 §3). 조회는 앱 수명 동안 한 번이면 족하다.
///
/// 토글은 **낙관적으로 반영하고 실패하면 되돌린다**(R10). 서버 왕복을 기다리면 스위치가
/// 손가락을 따라오지 않아 먹통처럼 보인다.
final class AgreementsControllerProvider
    extends
        $AsyncNotifierProvider<AgreementsController, List<AgreementStatus>> {
  /// 약관 동의 상태(SPEC-0011 R9~R12).
  ///
  /// **`keepAlive`인 이유는 게이트다.** 라우터 리다이렉트가 매 내비게이션마다 이 값을
  /// `ref.read`로 읽는데(R11), autoDispose면 화면이 없는 순간 폐기됐다가 다음 리다이렉트에
  /// 다시 조회가 시작되고 그 사이 상태가 `loading`이 된다 — 게이트가 사용자를 스플래시에
  /// 묶어 화면 전환이 네트워크에 묶인다(설계 §3). 조회는 앱 수명 동안 한 번이면 족하다.
  ///
  /// 토글은 **낙관적으로 반영하고 실패하면 되돌린다**(R10). 서버 왕복을 기다리면 스위치가
  /// 손가락을 따라오지 않아 먹통처럼 보인다.
  const AgreementsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: settingsRetryPolicy,
        name: r'agreementsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agreementsControllerHash();

  @$internal
  @override
  AgreementsController create() => AgreementsController();
}

String _$agreementsControllerHash() =>
    r'9181e009554e26a3dda0ce174c871d40164f6c6e';

/// 약관 동의 상태(SPEC-0011 R9~R12).
///
/// **`keepAlive`인 이유는 게이트다.** 라우터 리다이렉트가 매 내비게이션마다 이 값을
/// `ref.read`로 읽는데(R11), autoDispose면 화면이 없는 순간 폐기됐다가 다음 리다이렉트에
/// 다시 조회가 시작되고 그 사이 상태가 `loading`이 된다 — 게이트가 사용자를 스플래시에
/// 묶어 화면 전환이 네트워크에 묶인다(설계 §3). 조회는 앱 수명 동안 한 번이면 족하다.
///
/// 토글은 **낙관적으로 반영하고 실패하면 되돌린다**(R10). 서버 왕복을 기다리면 스위치가
/// 손가락을 따라오지 않아 먹통처럼 보인다.

abstract class _$AgreementsController
    extends $AsyncNotifier<List<AgreementStatus>> {
  FutureOr<List<AgreementStatus>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<AgreementStatus>>, List<AgreementStatus>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AgreementStatus>>,
                List<AgreementStatus>
              >,
              AsyncValue<List<AgreementStatus>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
