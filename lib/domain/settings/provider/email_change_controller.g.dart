// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_change_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 이메일 변경 repository 하나의 출처(CLAUDE.md §5). 테스트는 이 provider만
/// 오버라이드한다.

@ProviderFor(emailChangeRepository)
const emailChangeRepositoryProvider = EmailChangeRepositoryProvider._();

/// 이메일 변경 repository 하나의 출처(CLAUDE.md §5). 테스트는 이 provider만
/// 오버라이드한다.

final class EmailChangeRepositoryProvider
    extends
        $FunctionalProvider<
          EmailChangeRepository,
          EmailChangeRepository,
          EmailChangeRepository
        >
    with $Provider<EmailChangeRepository> {
  /// 이메일 변경 repository 하나의 출처(CLAUDE.md §5). 테스트는 이 provider만
  /// 오버라이드한다.
  const EmailChangeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailChangeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailChangeRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmailChangeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmailChangeRepository create(Ref ref) {
    return emailChangeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmailChangeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmailChangeRepository>(value),
    );
  }
}

String _$emailChangeRepositoryHash() =>
    r'9b5f812173098d8c4723b59af6dc76564189d0e2';

/// 이메일 변경 2단계 흐름(SPEC-0011 R7·R8).
///
/// **가입 검증(`verifyEmail`)을 돌려 쓰지 않는다**(디자인 §4) — 한 뮤테이션에 두
/// 의미를 얹으면 가입 흐름의 상태 기계가 여기 끌려온다. 화면 형태는 닮았지만
/// 호출부가 다르다.
///
/// 검증에 성공하면 세션의 `Me`를 다시 조회한다 — 설정 홈과 프로필 화면이 그리는
/// 이메일이 그 값이라, 갱신하지 않으면 바꿨는데 옛 주소가 남는다.

@ProviderFor(EmailChangeController)
const emailChangeControllerProvider = EmailChangeControllerProvider._();

/// 이메일 변경 2단계 흐름(SPEC-0011 R7·R8).
///
/// **가입 검증(`verifyEmail`)을 돌려 쓰지 않는다**(디자인 §4) — 한 뮤테이션에 두
/// 의미를 얹으면 가입 흐름의 상태 기계가 여기 끌려온다. 화면 형태는 닮았지만
/// 호출부가 다르다.
///
/// 검증에 성공하면 세션의 `Me`를 다시 조회한다 — 설정 홈과 프로필 화면이 그리는
/// 이메일이 그 값이라, 갱신하지 않으면 바꿨는데 옛 주소가 남는다.
final class EmailChangeControllerProvider
    extends $NotifierProvider<EmailChangeController, EmailChangeState> {
  /// 이메일 변경 2단계 흐름(SPEC-0011 R7·R8).
  ///
  /// **가입 검증(`verifyEmail`)을 돌려 쓰지 않는다**(디자인 §4) — 한 뮤테이션에 두
  /// 의미를 얹으면 가입 흐름의 상태 기계가 여기 끌려온다. 화면 형태는 닮았지만
  /// 호출부가 다르다.
  ///
  /// 검증에 성공하면 세션의 `Me`를 다시 조회한다 — 설정 홈과 프로필 화면이 그리는
  /// 이메일이 그 값이라, 갱신하지 않으면 바꿨는데 옛 주소가 남는다.
  const EmailChangeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailChangeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailChangeControllerHash();

  @$internal
  @override
  EmailChangeController create() => EmailChangeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmailChangeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmailChangeState>(value),
    );
  }
}

String _$emailChangeControllerHash() =>
    r'7ca8e02e33fa6cbfded1e222ed2eb2b6376bab40';

/// 이메일 변경 2단계 흐름(SPEC-0011 R7·R8).
///
/// **가입 검증(`verifyEmail`)을 돌려 쓰지 않는다**(디자인 §4) — 한 뮤테이션에 두
/// 의미를 얹으면 가입 흐름의 상태 기계가 여기 끌려온다. 화면 형태는 닮았지만
/// 호출부가 다르다.
///
/// 검증에 성공하면 세션의 `Me`를 다시 조회한다 — 설정 홈과 프로필 화면이 그리는
/// 이메일이 그 값이라, 갱신하지 않으면 바꿨는데 옛 주소가 남는다.

abstract class _$EmailChangeController extends $Notifier<EmailChangeState> {
  EmailChangeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<EmailChangeState, EmailChangeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EmailChangeState, EmailChangeState>,
              EmailChangeState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
